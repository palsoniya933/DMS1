({
    doInitHelper : function(component, event, helper){
        var context = {};
        var methodName = 'listDatasets';
        var methodParameters = {
            'pageSize' : 200,
            'hasCurrentOnly' : true,
            'q' : 'Dealer_code_Api'
        }
        component.set('v.isSpinnerVisible',true);
        const sdk = component.find('sdk');
        sdk.invokeMethod(context, methodName, methodParameters,
                         $A.getCallback(function (err, data) {
                             component.set('v.isSpinnerVisible',false);
                             if (err !== null) {
                                 console.error("SDK error", err);
                             } else {
                                 let datasetId = '';
                                 let currentVersionId = '';
                                 for(const dataset of data.datasets){
                                     if(dataset.name =='Dealer_code_Api'){
                                         datasetId = dataset.id;
                                         currentVersionId = dataset.currentVersionId;
                                         break;
                                     }
                                 }
                                 helper.fetchDealerInfoAndApplyFilters(component, event, helper,datasetId,currentVersionId,sdk);
                             }
                         }))  
    },
    
    fetchDealerInfoAndApplyFilters : function(component, event, helper,datasetId,currentVersionId,sdk){
        const query = helper.buildQuery(datasetId,currentVersionId);
        var context = {};
        var methodName = 'executeQuery';
        var methodParameters = {
            'query' : query
        }
        component.set('v.isSpinnerVisible',true);
        sdk.invokeMethod(context, methodName, methodParameters,
                         $A.getCallback(function (err, data) {
                             component.set('v.isSpinnerVisible',false);
                             if (err !== null) {
                                 console.error("SDK error", err);
                             } else {
                                 component.set('v.dealersInfo',JSON.parse(data).results.records);
                                 helper.getLoggedInUserDetails(component, event, helper);
                             }
                         }))  
    },
    
    buildQuery : function(datasetId, currentVersionId){
        let query = '';
        query += 'q = load \"';
        query += datasetId;
        query += '/';
        query += currentVersionId;
        query += "\";q = foreach q generate q.'COUNTRY' as 'COUNTRY', q.'DEALERGROUPNUMBER' as 'DEALERGROUPNUMBER', q.'ABBREVIATEDNAME' as 'ABBREVIATEDNAME', q.'DEALERCODE' as 'DEALERCODE', q.'LOYALTY_REGION' as 'LOYALTY_REGION', q.'DIVISION' as 'DIVISION',q.'DIVISION_formula' as 'DIVISION_formula';q = limit q 2000;"
        return query;
    },
    
    getLoggedInUserDetails : function(component, event, helper){
        var action = component.get("c.getCurrentLoggedInUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.loggedInUserInfo',response.getReturnValue());
                helper.setFilterOnDatasets(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    setFilterOnDatasets : function(component, event, helper) {
        component.set("v.showDashboard",false);
        component.set('v.showErrorMessage',false);
        const currentLoggedInUserInfo = component.get('v.loggedInUserInfo');
        let lstSelectedLocation = currentLoggedInUserInfo.isDealerUser
        ? [currentLoggedInUserInfo.dealerCode]
        : component.get('v.lstSelectedLocation');
        if(helper.isAllSelectedDealerCodeContainsDealerSuffix(lstSelectedLocation)){
            component.set('v.showErrorMessage',true);
            component.set("v.showDashboard",false);
            return;
        }
        const dealersWithoutSuffix = helper.removeDealersWithSuffix(lstSelectedLocation);
        if(dealersWithoutSuffix.length == 0){
            dealersWithoutSuffix =['NullIn'];
        }
        helper.setFilters(component,helper,dealersWithoutSuffix);
        component.set("v.showDashboard",true); 
    },
    
    setFilters : function(component, helper,lstSelectedLocation){
        const dealersInfo = component.get('v.dealersInfo');
        const selectedDealersInfo = helper.getSelectedDealersInfo(dealersInfo,lstSelectedLocation);
        let filter = {
            "datasets":{
                "Future_Part_list": helper.getFuturePartListFilters(component, selectedDealersInfo)
            }
        };
        helper.idetifyRenderingLanguage(component, helper,selectedDealersInfo);
        component.set("v.filters",JSON.stringify(filter));  
    },
    
    isAllSelectedDealerCodeContainsDealerSuffix :  function(lstSelectedLocation) {
        return lstSelectedLocation.every((selectedLocation) =>{
            return selectedLocation.includes('-');
        })
    },
    
    getSelectedDealersInfo : function(dealersInfo,lstSelectedLocation){
        const selectedDealersInfo = dealersInfo.filter((dealerInfo)=>{
            return lstSelectedLocation.includes(dealerInfo.DEALERCODE);
        })
        return selectedDealersInfo;
    },
    
    getFuturePartListFilters : function(component, selectedDealersInfo){
        const brands = [];
        const regions = [];
        let dealerBrandName  = '';
        let dealerRegionName  = '';
        if(selectedDealersInfo && selectedDealersInfo.length > 0){
            brands.push('TRP');
            for(const dealerInfo of selectedDealersInfo){
                if(dealerInfo.ABBREVIATEDNAME.toLowerCase().includes('trp')){
                    dealerBrandName = 'TRP';
                }
                if(!brands.includes(dealerInfo.DIVISION_formula)){
                    brands.push(dealerInfo.DIVISION_formula);
                    dealerBrandName = dealerBrandName ? dealerBrandName : dealerInfo.DIVISION_formula ;
                }
                if(!regions.includes(dealerInfo.LOYALTY_REGION)){
                    regions.push(dealerInfo.LOYALTY_REGION)
                    dealerRegionName = dealerRegionName ? dealerRegionName :dealerInfo.COUNTRY; 
                }
            }
        }
        else{
            brands.push('UnknownFilterMatch');
            regions.push('UnknownFilterMatch');
        }
        component.set("v.brand",dealerBrandName);
        component.set("v.region",dealerRegionName);
        return [
            {
                "fields": [
                    "OFFERBRAND"
                ],
                "filter": {
                    "operator": "in",
                    "values":  brands
                },
            },
            {
                "fields": [
                    "OFFERREGION"
                ],
                "filter": {
                    "operator": "in",
                    "values":  regions
                },
            }
        ];
    },
    
    removeDealersWithSuffix : function (lstSelectedLocation){
        const dealersWithoutSuffix = lstSelectedLocation.filter((selectedLocation)=>{
            return !selectedLocation.includes('-');
        })
        return dealersWithoutSuffix;
    },
    
    idetifyRenderingLanguage: function(component, helper, selectedDealersInfo) {
        let language = '';
        let promises = [];  // Collect all promises
        
        for (const selectedDealer of selectedDealersInfo) {
            if (selectedDealer.LOYALTY_REGION.toLowerCase() == 'mexico' || 
                selectedDealer.LOYALTY_REGION.toLowerCase() == 'latin america') {
                component.set('v.showFrenchDashboard', false);
                component.set('v.showSpanishDashboard', true);
                component.set('v.showEnglishDashboard', false);
                language = 'es_MX';
            } else if (selectedDealer.LOYALTY_REGION.toLowerCase() == 'canada') {
                let promise = helper.isFrenchCanadianDealer(component, helper, selectedDealer).then(function(isFrenchCanadian) {
                    if (isFrenchCanadian) {
                        component.set('v.showFrenchDashboard', true);
                        component.set('v.showSpanishDashboard', false);
                        component.set('v.showEnglishDashboard', false);
                        language = 'fr_CA';
                    } else {
                        component.set('v.showFrenchDashboard', false);
                        component.set('v.showSpanishDashboard', false);
                        component.set('v.showEnglishDashboard', true);
                        language = 'en_US';
                    }
                });
                promises.push(promise);
            } else {
                component.set('v.showFrenchDashboard', false);
                component.set('v.showSpanishDashboard', false);
                component.set('v.showEnglishDashboard', true);
                language = 'en_US';
            }
        }
        Promise.all(promises).then(function() {
            component.set("v.language", language);
        });
    },
    
    isFrenchCanadianDealer: function(component, helper, selectedDealer) {
        return new Promise(function(resolve, reject) {
            const frcaDealers = component.get('v.frcaDealers');
            if (frcaDealers && frcaDealers.length > 0) {
                resolve(frcaDealers.includes(selectedDealer.DEALERCODE));
            } else {
                var context = {};
                var methodName = 'listDatasets';
                var methodParameters = {
                    'pageSize': 200,
                    'hasCurrentOnly': true,
                    'q': 'fr_CA_Dealers'
                };
                component.set('v.isSpinnerVisible', true);
                const sdk = component.find('sdk');
                
                // SDK call to fetch datasets
                sdk.invokeMethod(context, methodName, methodParameters,
                                 $A.getCallback(function (err, data) {
                                     component.set('v.isSpinnerVisible', false);
                                     if (err !== null) {
                                         console.error("SDK error", err);
                                         reject(err); 
                                     } else {
                                         let datasetId = '';
                                         let currentVersionId = '';
                                         for (const dataset of data.datasets) {
                                             if (dataset.name == 'fr_CA_Dealers') {
                                                 datasetId = dataset.id;
                                                 currentVersionId = dataset.currentVersionId;
                                                 break;
                                             }
                                         }
                                         helper.fetchFrCADealersAndIdentifyLanguage(component, helper, datasetId, currentVersionId, sdk, selectedDealer)
                                         .then(result => resolve(result))
                                         .catch(error => reject(error));
                                     }
                                 })
                                );
            }
        });
    },
    
    fetchFrCADealersAndIdentifyLanguage: function(component, helper, datasetId, currentVersionId, sdk, selectedDealer) {
        return new Promise(function(resolve, reject) {
            const query = helper.buildFrCaQuery(datasetId, currentVersionId);
            var context = {};
            var methodName = 'executeQuery';
            var methodParameters = {
                'query': query
            };
            component.set('v.isSpinnerVisible', true);
            sdk.invokeMethod(context, methodName, methodParameters,
                             $A.getCallback(function (err, data) {
                                 component.set('v.isSpinnerVisible', false);
                                 if (err !== null) {
                                     console.error("SDK error", err);
                                     reject(err); 
                                 } else {
                                     const frcaDealers = [];
                                     for (const dealer of JSON.parse(data).results.records) {
                                         frcaDealers.push(dealer.dealerCode);
                                     }
                                     component.set('v.frcaDealers', frcaDealers);
                                     resolve(frcaDealers.includes(selectedDealer.DEALERCODE));
                                 }
                             })
                            );
        });
    },
    
    buildFrCaQuery : function(datasetId, currentVersionId){
        let query = '';
        query += 'q = load \"';
        query += datasetId;
        query += '/';
        query += currentVersionId;
        query += "\";q = foreach q generate q.'CSTNO' as 'dealerCode';q = limit q 2000;"
        return query;
    },
    
})