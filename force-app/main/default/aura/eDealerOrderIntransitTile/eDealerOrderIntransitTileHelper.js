({
	fetchInTransitOrdersData : function(component, event, helper) {
        //selected loc/dealer code
         var locCode = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.getIntransitOrdersDetail");
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
                    component.set("v.intransitOrdersData", resultData.response);
                    //update U.I.
                    helper.updateUI(component, event, helper);
                }
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
    
    updateUI : function(component, event, helper) {
        var intransitOrdersData =  component.get("v.intransitOrdersData");
        var selectedoption = component.get("v.selectedoption");
        var intransitOrders = 0;
        if(!$A.util.isUndefinedOrNull(intransitOrdersData) && intransitOrdersData.length > 0 
          && !$A.util.isUndefinedOrNull(intransitOrdersData[0].OrdersTransitTotal)){
                if(selectedoption == 'Daily' && intransitOrdersData[0].OrdersTransitTotal.dayCount > 0){
                    intransitOrders = intransitOrdersData[0].OrdersTransitTotal.dayCount;
                }else if(selectedoption == 'Weekly' && intransitOrdersData[0].OrdersTransitTotal.weekCount > 0){
                    intransitOrders = intransitOrdersData[0].OrdersTransitTotal.weekCount;
                }else if(selectedoption == 'Monthly' && intransitOrdersData[0].OrdersTransitTotal.monthCount > 0){
                    intransitOrders = intransitOrdersData[0].OrdersTransitTotal.monthCount;
                }else if(selectedoption == 'Quarterly' && intransitOrdersData[0].OrdersTransitTotal.quarterCount > 0){
                    intransitOrders = intransitOrdersData[0].OrdersTransitTotal.quarterCount;
                }else if(selectedoption == 'Annually' && intransitOrdersData[0].OrdersTransitTotal.yearCount > 0){
                    intransitOrders = intransitOrdersData[0].OrdersTransitTotal.yearCount;
                }
            
        }
        
        component.set("v.intransitOrders", intransitOrders);
        
    },
    
    
})