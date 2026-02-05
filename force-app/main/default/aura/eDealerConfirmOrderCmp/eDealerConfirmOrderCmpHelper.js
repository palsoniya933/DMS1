({
    //Getting multiple Location data
    fetchConfirmOrdersMultipleData : function(component, event, helper) {
        //selected loc/dealer code
        var listDealerLoc = component.get("v.listDealerLoc");
        var dealerLoc = component.get("v.dealerLoc");
                var selectedOrder = component.get("v.selectedOrder");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc)){
            listDealerLoc = [];
            if(!$A.util.isUndefinedOrNull(dealerLoc)){
                listDealerLoc.push(dealerLoc);
            }else{
                return;
            }
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.getConfirmOrders");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "ordstatus":selectedOrder
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);           
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.confirmOrdersData", resultData.response);
                    console.log("confirmOrdersData::"+JSON.stringify(resultData.response));
                    //update U.I.
                    helper.updateUI(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    updateUI : function(component, event, helper) {
        var confirmOrdersData =  component.get("v.confirmOrdersData");
        var selectedoption = component.get("v.selectedoption");
        var selectedType = component.get("v.selectedOrder");
        var confrimOrders = 0;
        if(!$A.util.isUndefinedOrNull(confirmOrdersData) && confirmOrdersData.length > 0 ){
            for(var i=0;i<confirmOrdersData.length;i++){
                if(selectedoption == 'Daily' && confirmOrdersData[i].frequency == 'Daily'){
                    confrimOrders = helper.fetchDisplayValue(confirmOrdersData[i], selectedType);
                }else if(selectedoption == 'Monthly' && confirmOrdersData[i].frequency == 'Monthly'){
                    confrimOrders = helper.fetchDisplayValue(confirmOrdersData[i], selectedType);
                }else if(selectedoption == 'Quarterly' && confirmOrdersData[i].frequency == 'Quarterly'){
                    confrimOrders = helper.fetchDisplayValue(confirmOrdersData[i], selectedType);
                }else if(selectedoption == 'Annually' && confirmOrdersData[i].frequency == 'Annually'){
                    confrimOrders = helper.fetchDisplayValue(confirmOrdersData[i], selectedType);
                }else if(selectedoption == 'All' && confirmOrdersData[i].frequency == 'All'){
                    confrimOrders = helper.fetchDisplayValue(confirmOrdersData[i], selectedType);
                }
            }
        }
        
        component.set("v.confirmOrders", confrimOrders);
    },
    
    fetchDisplayValue : function(currentRec, selectedType) {
        if(selectedType == 'All'){
            return currentRec.ordercount;
        }
        else if(selectedType == 'invoiceorders'){
            if(currentRec.invoiceordercount == undefined){
                return 0;
            }else{
                return currentRec.invoiceordercount;
            }
        }
            else if(selectedType == 'cancelorders'){
                if(currentRec.cancleordercount == undefined){
                    return 0;
                }else{
                    return currentRec.cancleordercount;
                }
            }else{
                return 0;//default
            }
    },
    getfilters: function(component, event, helper) {
        var action2 = component.get("c.getFilters");
        
        action2.setCallback(this, function(response2) {
            var resultData = response2.getReturnValue()
            console.log('filters::::::::::::::::::::::::::'+resultData);
            console.log(JSON.stringify(resultData));
            component.set("v.selectoptions", resultData);
        });
        $A.enqueueAction(action2);
    }
})