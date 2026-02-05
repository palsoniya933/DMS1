({
    fetchOrdersData : function(component, event, helper,isDownload, offset) {
        debugger;
        
        var action;
        var selectedMenu = component.get("v.selectedMenu");
        var dealerCode = component.get("v.dealerCode");
        var dealerCodes = component.get("v.listDealerLoc");
        var listDealerCodes = [];
        var frequency = component.get("v.selectedoption");
        var orderType = component.get("v.orderType");

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
        
        helper.setFrequency(component, event, helper);
        
        var recordLimit = 2000;
        if(isDownload){
            recordLimit = $A.get("$Label.c.eDealerDownloadSize");
        }
        
        var offsetVal = component.get("v.offset");
        if(offset){
            offsetVal = offset;
        }
        else
        {
            offsetVal=0;
        }
        
        if(selectedMenu == 'confirmedorders'){
            action = component.get("c.getConfirmedOrders");
            
            
            action.setParams({ 
                dealerCode : listDealerCodes,                
                orderType : orderType,
                timeFrame : frequency,
                offset_value:offsetVal,
                reclimit:recordLimit
            });
        }
        else if(selectedMenu == 'pendingorders'){
            action = component.get("c.getPendingOrders");
            action.setParams({ 
                dealerCode : listDealerCodes,
                orderType : orderType,
                timeFrame : frequency,
                offset_value:offsetVal,
                reclimit:recordLimit
            });
        }
            else if(selectedMenu == 'activeorders'){
                action = component.get("c.getActiveOrders");
                action.setParams({ 
                    dealerCode : listDealerCodes,                
                    orderType : orderType,
                    timeFrame : frequency,
                    offset_value:offsetVal,
                     reclimit:recordLimit
                });
            }
                else if(selectedMenu == 'unconfirmedorders'){
                    action = component.get("c.getUnConfirmedOrders");
                    action.setParams({ 
                        dealerCode : listDealerCodes,                
                        orderType : orderType,
                        timeFrame : frequency,
                        offset_value:offsetVal,
                        reclimit:recordLimit
                    });
                }
        
        if($A.util.isUndefinedOrNull(action)){
            return;
        }
        
        //action.setBackground();
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                // from the server
                var result = response.getReturnValue();               
                var truckDownOrders = 0;
                var emergencyOrders = 0;
                var stockOrders = 0;
                var otherOrders = 0;
                
                var orderTypes = [];
                var orderTypesMap = new Map();
                if(!$A.util.isUndefinedOrNull(result.response)&& result.response.length>0){
                    for(var i=0; i < result.response.length; i++){
                        if(result.response[i].ordertype == 'Emergency Order'){
                            emergencyOrders++;
                        }else if(result.response[i].ordertype == 'Stock Order'){
                            stockOrders++;
                        }else if(result.response[i].ordertype == 'Truck Down'){
                            truckDownOrders++;
                        }else {
                            otherOrders++;
                        }
                    }
                    component.set("v.masterData", JSON.stringify(result.response));
                    
                    var totalData = result.response;
                    for (var i = 0; i < totalData.length; i++) {
                        totalData[i].srno = i + 1; 
                    }
                    component.set("v.invData", totalData);
                    component.set("v.PaginationList", totalData.slice(0, 25));

                    if(result.rowcount)
                    {
                        component.set("v.totalOrders", result.rowcount);   
                    }
                    else
                    {
                        component.set("v.totalOrders", result.response.length); 
                    }
                }
                
                component.set("v.emergencyOrders", emergencyOrders);
                component.set("v.stockOrders", stockOrders);
                component.set("v.truckDownOrders", truckDownOrders);
                component.set("v.otherOrders", otherOrders);
                if(!isDownload){
                    var totalRecords = result.rowcount;
                    //var totalRecords = resultData.RowCount[0].rowcount;
                    var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                    var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                    
                    // calc total API calls we have to do while downloading the report
                    if(totalRecords % downloadSize > 0){
                        totalAPICalls = totalAPICalls+1;
                    }
                    component.set("v.totaldownloadAPIcalls",totalAPICalls);
                }
                else{
                    var existingData = component.get("v.downloadData");
                    existingData.push(result.response);
                    component.set("v.downloadData", existingData);                        
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
        
        let selectedFrequencies = component.get("v.selectedFrequencies"); 
        
        var frequency = component.get("v.selectedoption");
        
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
        if(component.get("v.selectedMenu") == 'pendingorders'){
            var label = $A.get("$Label.c.EDealer_Menu_Back_Orders");
            component.set("v.downloadFileName",label);
        }else if(component.get("v.selectedMenu") == 'confirmedorders'){
            var label = $A.get("$Label.c.EDealer_Menu_Close_Orders");
            component.set("v.downloadFileName",label + component.get("v.frequency"));
        }else if(component.get("v.selectedMenu") == 'unconfirmedorders'){
            var label = $A.get("$Label.c.Edealer_Unconfirmed_Order");
            component.set("v.downloadFileName",label);
        }else{
            var label = $A.get("$Label.c.EDealer_Menu_Active_Orders");
            component.set("v.downloadFileName",label);
        }        
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
                let processedData = {};
                resultData.forEach(option => {
                    if (option.label && option.value) {
                    processedData[option.label] = option.value;
                }
                                   });                
                
                console.log("Processed Frequency Options: ", processedData);
                
                // Set the processed data in the Aura attribute
                component.set("v.selectedFrequencies",processedData); 
                console.log(component.get("v.selectedFrequencies"));
                helper.fetchOrdersData(component, event, helper);
                helper.fetchColumnDetailsData(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                
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