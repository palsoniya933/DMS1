({
    getDSPEmergencyCartItems : function(component, event, helper) {
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchDSPEmeregencyCartItemsDetails");
        action.setParams({
            "dealerCode": locCode
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartDSPEmergencyOrders", response.getReturnValue());
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
    
    deleteItemFromCart : function(component, event, helper, cartID) {
        var action = component.get("c.removeCartItem");
        action.setParams({
            "cartId": cartID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //show success Message after cart item removed
                //and
                //refresh DSP Emergency cart Table
                helper.getDSPEmergencyCartItems(component, event, helper);
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