({
    getEmergencyCartItems : function(component, event, helper) {   
        // getting dealer code
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchEMCartItemsDetails");
        action.setParams({
            "dealerCode": locCode
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartEmergencyOrders", response.getReturnValue());
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
            
            component.set("v.displayLoading", false);
            
        });
        $A.enqueueAction(action);
    },
    
    
    
})