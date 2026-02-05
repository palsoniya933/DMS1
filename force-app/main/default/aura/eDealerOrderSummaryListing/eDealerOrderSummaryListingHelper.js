({
    fetchOrdersData : function(component, event, helper, isDownload, offset) {
        var action;
        
        var selectedMenu = component.get("v.selectedMenu");
        var dealerCode = component.get("v.dealerCode");
        var dealerCodes = component.get("v.listDealerLoc");
        var listDealerCodes = [];
        var frequency = component.get("v.selectedoption");
        var orderType = component.get("v.orderType");
        console.log("orderType::"+orderType);
        console.log("frequency::"+frequency);
        console.log("selectedMenu::"+selectedMenu);
        console.log("dealerCode::"+dealerCode);
        //check selected  location/dealer code

		if($A.util.isUndefinedOrNull(dealerCode)){
            if($A.util.isUndefinedOrNull(dealerCodes)){
             return;
         }
            else{
                listDealerCodes = dealerCodes;
            }
            
                      
        }
        else{
             listDealerCodes=[dealerCode];
 
        }
        //alert(orderType);
        helper.setFrequency(component, event, helper);
        
        // setting report Limit
        var recordLimit = 2000;
        if(isDownload){
            recordLimit = $A.get("$Label.c.eDealerDownloadSize");
        }
        
        var offsetVal = component.get("v.offset");
        if(offset){
            offsetVal = offset;
        }
        
        action = component.get("c.orderSummaryData");
        action.setParams({ 
            dealerCode : listDealerCodes,                
            orderType : orderType,
            timeFrame : frequency,
            offSet : offsetVal,
            recLimit : recordLimit
        });
        
        action.setBackground();
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                // from the server
                var result = response.getReturnValue();
                console.log("result::"+JSON.stringify(result));
                if(!isDownload){
                    var invoicedOrder = 0;
                    var activeorders = 0;
                    var backorders = 0;
                    var cancelledorders = 0;
                    
                    var orderTypes = [];
                    var orderTypesMap = new Map();
                    
                    for(var i=0; i < result.response.length; i++){
                        if(result.response[i].orderstatus == 'Invoiced'){
                            invoicedOrder++;
                        }else if(result.response[i].orderstatus == 'Active'){
                            activeorders++;
                        }else if(result.response[i].orderstatus == 'Backorder'){
                            backorders++;
                        }else if(result.response[i].orderstatus == 'Cancelled'){
                            cancelledorders++;
                        }
                    }
                    
                    component.set("v.masterData", JSON.stringify(result.response));
                    component.set("v.invData", result.response);
                    console.log("invData length::"+result.response.length);
                    component.set("v.PaginationList", result.response);
                    
                    component.set("v.languageTranslation", result.languageTranslation);
                    console.log('result.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                    
                    component.set("v.totalOrders", totalRecords /*result.response.length*/);
                    component.set("v.invoicedOrder", invoicedOrder);
                    component.set("v.activeorders", activeorders);
                    component.set("v.backorders", backorders);
                    component.set("v.cancelledorders", cancelledorders);
                    
                    helper.setGridColumns(component, event, helper);
                    
                    var totalRecords = result.RowCount[0].rowcount;
                    
                    // setting total values
                    var orderType = component.get("v.orderType");
                    if(orderType == 'Invoiceorder'){
                        component.set("v.invoicedOrder", totalRecords);
                    }                    
                    else if(orderType == 'Backorders'){
                        component.set("v.backorders", totalRecords);
                    }                        
                    
                    //alert(totalRecords);
                    component.set("v.totalOrders", totalRecords /*result.response.length*/);
                    var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                    var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                    
                    // gettin reminder
                    if(totalRecords % downloadSize > 0){
                        totalAPICalls = totalAPICalls+1;
                    }
                    component.set("v.totaldownloadAPIcalls",totalAPICalls);
                }
                else{
                    /*var childComponent = component.find("downloadcmp");
                        var message = childComponent.downloadExcel(result.response);*/
                    debugger;
                    console.log(result);
                    var existingData = component.get("v.downloadData");
                    existingData.push(result.dataJSON);
                    component.set("v.downloadData", existingData);
                    console.log('\n--existingData--'+existingData);
                    console.log('\n--existingData.length--'+existingData.length);
                    if(component.get("v.totaldownloadAPIcalls") == existingData.length){
                        for(var ele in existingData){
                            var childComponent = component.find("downloadcmp");
                            var message = childComponent.downloadExcel(existingData[ele]);
                        }
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    setFrequency : function(component, event, helper){

        var frequency = component.get("v.selectedoption");        

        let selectedFrequencies = component.get("v.selectedFrequencies");         

        if(frequency == "Day"){

            component.set("v.frequency", selectedFrequencies.Daily);

        }else if(frequency == "Week" || frequency == "Weekly"){

            component.set("v.frequency", selectedFrequencies.Weekly);

        }else if(frequency == "Month" || frequency == "Monthly"){

            component.set("v.frequency", selectedFrequencies.Monthly);

        }else if(frequency == "Quarter" || frequency == "Quarterly"){

            component.set("v.frequency", selectedFrequencies.Quarterly);

        }else if(frequency == "Year" || frequency == "Annually"){

            component.set("v.frequency", selectedFrequencies.Annually);

        }else if(frequency == "All"){

            component.set("v.frequency", selectedFrequencies.All);

        }
         
        var orderSummary = $A.get("$Label.c.Order_Summary");
        component.set("v.downloadFileName",orderSummary +'-'+component.get("v.frequency"));
        
    },
    
    getParams : function(name){
        
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    },
    
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        
        const colmunsDownloadData =[];
        
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
        }
        component.set("v.columnLabelByApiName",columns);
        component.set("v.columns",colmunsDownloadData);
    },
    
    fetchColumnDetailsData : function(component, event, helper) {
        var action = component.get("c.getColumnHeaders");
        var reportName='Active Order Listing Table';
        console.log("report Name------>"+reportName);
        action.setParams({ 
            reportName:reportName
        });
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                const columns =[];
                const colmunsDownloadData =[];
                var result = response.getReturnValue(); 
                console.log('--success GOT--'+ JSON.stringify(result));
                component.set("v.MapColumnDetails",result);
                for (let [key, value] of Object.entries(result)) {
                    columns.push({key:key,value:value.label});
                    colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
                }
                component.set("v.columnLabelByApiName",columns);
                component.set("v.columns",colmunsDownloadData);
                console.log('colmunsDownloadData -->> ' + JSON.stringify(colmunsDownloadData));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " , errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    getFrequencyTranslation : function(component, event, helper) { 
        var action = component.get("c.getFrequencyTranslations");        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                var result = response.getReturnValue(); 
                component.set("v.selectedFrequencies",result);
                
                
                var resultData = response.getReturnValue();
                console.log('response >> frequency'+ JSON.stringify(response.getReturnValue()));
                let processedData = {};
                resultData.forEach(option => {
                    if (option.label && option.value) {
                    processedData[option.label] = option.value;
                }
                                   });                
                
                console.log("Processed Frequency Options: ", processedData);
                
                // Set the processed data in the Aura attribute
                component.set("v.selectedFrequencies",processedData); 
                
                helper.fetchOrdersData(component, event, helper);
                //helper.fetchColumnDetailsData(component, event, helper);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " , errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    }
})