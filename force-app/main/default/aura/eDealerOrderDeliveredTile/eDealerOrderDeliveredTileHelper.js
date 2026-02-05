({    
	fetchDeliveredOrdersData : function(component, event, helper) {
        //selected loc/dealer code
         var locCode = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.getDeliveredOrdersDetail");
        action.setParams({
            "dealerCode" : locCode
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
                    component.set("v.deliveredOrdersData", resultData.response);
                    //update U.I.
                    helper.updateUI(component, event, helper);
                }
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
    
     //Getting multiple Location data
    fetchDeliveredOrdersMultipleData : function(component, event, helper) {
        //selected loc/dealer code
         var listDealerLoc = component.get("v.listDealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc)){
            return;
        }
        
        //show spinner
        component.set("v.displayLoading", true);

        var action = component.get("c.getDeliveredOrdersDetails");
        action.setParams({
            "dealerCode" : listDealerLoc
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
                    component.set("v.deliveredOrdersData", resultData.response);
                    
                    //update U.I.
                    helper.updateUI(component, event, helper);
                    
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
		
	},
    
    updateUI : function(component, event, helper) {
        var deliveredOrdersData =  component.get("v.deliveredOrdersData");
        var selectedoption = component.get("v.selectedoption");
        var deliveredOrders = 0;
        if(!$A.util.isUndefinedOrNull(deliveredOrdersData) && deliveredOrdersData.length > 0 
          && !$A.util.isUndefinedOrNull(deliveredOrdersData[0].OrdersDeliveredTotal)){
                if(selectedoption == 'Daily' && deliveredOrdersData[0].OrdersDeliveredTotal.dayCount > 0){
                    deliveredOrders = deliveredOrdersData[0].OrdersDeliveredTotal.dayCount;
                }else if(selectedoption == 'Weekly' && deliveredOrdersData[0].OrdersDeliveredTotal.weekCount > 0){
                    deliveredOrders = deliveredOrdersData[0].OrdersDeliveredTotal.weekCount;
                }else if(selectedoption == 'Monthly' && deliveredOrdersData[0].OrdersDeliveredTotal.monthCount > 0){
                    deliveredOrders = deliveredOrdersData[0].OrdersDeliveredTotal.monthCount;
                }else if(selectedoption == 'Quarterly' && deliveredOrdersData[0].OrdersDeliveredTotal.quarterCount > 0){
                    deliveredOrders = deliveredOrdersData[0].OrdersDeliveredTotal.quarterCount;
                }else if(selectedoption == 'Annually' && deliveredOrdersData[0].OrdersDeliveredTotal.yearCount > 0){
                    deliveredOrders = deliveredOrdersData[0].OrdersDeliveredTotal.yearCount;
                }
            
        }
        
        component.set("v.deliveredOrders", deliveredOrders);
        
    },

    
})