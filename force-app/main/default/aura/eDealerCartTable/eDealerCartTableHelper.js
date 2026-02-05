({
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
                //
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
                
                //and
                //refresh EM cart Table
                var vx = component.get("v.method");
                //fire event from child and capture in parent
                $A.enqueueAction(vx);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
    },
    
    
    deleteAllItemFromCart : function(component, event, helper) {
        var action = component.get("c.removeAllCartItem");
        action.setParams({
            "cartItems": JSON.stringify(component.get("v.cartOrders"))
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //show success Message after cart item removed
                //and
                //
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
                
                //and
                //refresh EM cart Table
                var vx = component.get("v.method");
                //fire event from child and capture in parent
                $A.enqueueAction(vx);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
    },
    
    updateQntyVal :  function(component, event, helper,recordId,quantityVal) {
         var action = component.get("c.updateEDealerRec");
        action.setParams({
            "recId": recordId,
            "qntyVal":quantityVal
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                //refresh EM cart Table
                var vx = component.get("v.method");
                //fire event from child and capture in parent
                $A.enqueueAction(vx);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
    },
    
    refreshCartHelper : function(component, event, helper) {        
        var vx = component.get("v.method");
        //fire event from child and capture in parent
        $A.enqueueAction(vx);
        
    },
    
    showErrorToast : function(component, event, helper, ErrorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error",
            "message": ErrorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
    
})