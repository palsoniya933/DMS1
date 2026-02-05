({
    fetchOrdersData : function(component, event, helper, isDownload, offset) {
        var action;
        var selectedMenu = component.get("v.selectedMenu");
        var dealerCode = component.get("v.dealerCode");
        var frequency = component.get("v.selectedoption");
        var orderType = component.get("v.orderType");
        console.log("orderType::"+orderType);
        console.log("frequency::"+frequency);
        console.log("selectedMenu::"+selectedMenu);
        console.log("dealerCode::"+dealerCode);
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(dealerCode)){
            return;
        }
        //alert(orderType);
        helper.setFrequecy(component, event, helper);
        
        // setting report Limit
        var recordLimit = 2000;
        if(isDownload){
            recordLimit = $A.get("$Label.c.eDealerDownloadSize");
        }
        
        var offsetVal = component.get("v.offset");
        if(offset){
            offsetVal = offset;
        }
        
        action = component.get("c.fetchFreightChargesListingData");
        action.setParams({ 
            dealerCode : dealerCode,                
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
                    var truckDown = 0;
                    var emergency = 0;
                    var dspFreightCharges = 0;
                    var monthlyReturns = 0;
                    var Other =0;                    
                    var orderTypes = [];
                    var orderTypesMap = new Map();
                    
                    /*
                    for(var i=0; i < result.response.length; i++){
                        if(result.response[i].orderstatus == 'Truck Down'){
                            truckDown++;
                        }else if(result.response[i].orderstatus == 'Emergency'){
                            emergency++;
                        }else if(result.response[i].orderstatus == 'DSP Freight Charges'){
                            dspFreightCharges++;
                        }else if(result.response[i].orderstatus == 'Monthly Returns'){
                            monthlyReturns++;
                        }
                            else if(result.response[i].orderstatus == 'Other'){
                                Other++;
                            }
                    }*/
                    
                    component.set("v.masterData", JSON.stringify(result.response));
                    component.set("v.invData", result.response);
                    console.log("invData length::"+JSON.stringify(result.response));
                    
                    try{
                        component.set("v.PaginationList", result.response);    
                    }
                    catch(err){
                        console.log("Error: " + err);
                    }
                    
                    console.log('result.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                    
                    component.set("v.languageTranslation", result.languageTranslation);
                    
                    
                    component.set("v.totalFreightCharges", totalRecords);/*result.response.length*/
                    component.set("v.turckDown", truckDown);
                    component.set("v.Emergency", emergency);
                    component.set("v.dspFreightCharges", dspFreightCharges);
                    component.set("v.monthlyReturns", monthlyReturns);
                    component.set("v.other", Other);
                    
                    
                    helper.setGridColumns(component, event, helper);
                    
                    var totalRecords = result.RowCount[0].rowcount;
                    
                    
                    
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
    
    setFrequecy : function(component, event, helper){
        var frequency = component.get("v.selectedoption");
        if(frequency == "Day"){
            component.set("v.frequency", "Daily");
        }
        else if(frequency == "Week"){
            component.set("v.frequency", "Weekly");
        }
            else if(frequency == "Month"){
                component.set("v.frequency", "Monthly");
            }
                else if(frequency == "Quarter"){
                    component.set("v.frequency", "Quarterly");
                }
                    else if(frequency == "Year"){
                        component.set("v.frequency", "Annually");
                    }
                        else if(frequency == "All"){
                            component.set("v.frequency", "All");
                        }
        
        
         var freightCharge = $A.get("$Label.c.Edealer_Freight_Charges");
        
        component.set("v.downloadFileName",freightCharge +'-'+component.get("v.frequency"));
        
    },
    
    getParams : function(name){
        
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    },
    
    setGridColumns : function(component, event, helper) {
        const colmunsDownloadData =[];
        var languageTranslation = component.get("v.languageTranslation");
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            if(key != "freighttotal"){
                 colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
            }else{
                console.log('Number total');
                colmunsDownloadData.push({label: value.label, fieldName: key, type: 'Number', sortable: false});
            }
           
        }
        component.set("v.columnLabelByApiName",columns);
        component.set("v.columns",colmunsDownloadData);
    }
})