({
    doInitHelper : function(component, event, helper){
        var context = {};
        var methodName = 'listDatasets';
        var methodParameters = {
            'pageSize' : 200,
            'hasCurrentOnly' : true
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
                                 const queryData = JSON.parse(data);
                                 const dealerInfo = queryData.results.records;
                                 component.set('v.dealersInfo',dealerInfo);
                                 component.set('v.dealersInfoString',JSON.stringify(dealerInfo));
                                 helper.setFilterOnDatasets(component, event, helper);
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
    
    setFilterOnDatasets : function(component, event, helper) {
        component.set("v.showDashboard",false);
        component.set('v.showErrorMessage',false);
        let dealerCode = component.get('v.dealerCode');
        let lstSelectedLocation = component.get('v.lstSelectedLocation');
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
        helper.idetifyRenderingLanguage(component);
        component.set("v.showDashboard",true); 
    },
    
    setFilters : function(component, helper,lstSelectedLocation){
        const dealersInfo = component.get('v.dealersInfo');
        const selectedDealersInfo = helper.getSelectedDealersInfo(dealersInfo,lstSelectedLocation);
        let filter = {
            "datasets": {
                "RedemptionSummaryDataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Loyalty_Dataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Membership_Summary_Dataset": [
                    {
                        "fields": [
                            "PREFERREDDEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "OFFER_SUMMARY_security": helper.getOfferSummaryFilter(selectedDealersInfo),
                "Active_Rewards": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ]
            }
        };
        component.set("v.filters",JSON.stringify(filter));  
    },
    
    isAllSelectedDealerCodeContainsDealerSuffix :  function(lstSelectedLocation) {
        return lstSelectedLocation.every((selectedLocation) =>{
            return selectedLocation.includes('-');
        })
    },
    
    idetifyRenderingLanguage : function(component){
        const currentLanguage = $A.get("$Locale.langLocale");
        if(currentLanguage.toLowerCase() == 'es_mx'){
            component.set('v.showFrenchDashboard',false);
            component.set('v.showSpanishDashboard',true);
            component.set('v.showEnglishDashboard',false);
        }
        else if(currentLanguage.toLowerCase() == 'fr_ca'){
            component.set('v.showFrenchDashboard',true);
            component.set('v.showSpanishDashboard',false);
            component.set('v.showEnglishDashboard',false);
        }
            else{
                component.set('v.showFrenchDashboard',false);
                component.set('v.showSpanishDashboard',false);
                component.set('v.showEnglishDashboard',true);
                
            }
        
    },
    
    removeDealersWithSuffix : function (lstSelectedLocation){
        const dealersWithoutSuffix = lstSelectedLocation.filter((selectedLocation)=>{
            return !selectedLocation.includes('-');
        })
        return dealersWithoutSuffix;
    },
    
    getSelectedDealersInfo : function(dealersInfo,lstSelectedLocation){
        const selectedDealersInfo = dealersInfo.filter((dealerInfo)=>{
            return lstSelectedLocation.includes(dealerInfo.DEALERCODE);
        })
        return selectedDealersInfo;
    },
    
    getOfferSummaryFilter : function(selectedDealersInfo){
        const brands = [];
        const regions = [];
        if(selectedDealersInfo && selectedDealersInfo.length > 0){
            brands.push('TRP');
            for(const dealerInfo of selectedDealersInfo){
                if(!brands.includes(dealerInfo.DIVISION_formula)){
                    brands.push(dealerInfo.DIVISION_formula);
                }
                if(!regions.includes(dealerInfo.LOYALTY_REGION)){
                    regions.push(dealerInfo.LOYALTY_REGION)
                }
            }
        }
        else{
            brands.push('UnknownFilterMatch');
            regions.push('UnknownFilterMatch');
        }
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
    }
    
})