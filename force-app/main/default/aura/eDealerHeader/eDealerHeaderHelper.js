({
    FetchCartItems : function(component, event, helper) {
        // getting dealer code
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchCartItemsDetails");
        action.setParams({
            "dealerCode": locCode
        });
        
        action.setBackground();
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // cart detail
                component.set("v.cartSummary",response.getReturnValue());
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
    
    handleSearch : function(component, event, helper) {
        var searchVal = component.get("v.enteredTxt");
        
        if(searchVal != undefined 
           && searchVal.trim() != ''
           && searchVal.length >= 3){
            var selectedPicklistValue = component.get("v.selectedPicklistItem");
            if(selectedPicklistValue == 'Order Tracking'){
                // fire event
                var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
                menuEvent.setParams({
                    "menuName" : "ordersearch",
                    "orderNumber" : searchVal});
                menuEvent.fire();
            }
            else if(selectedPicklistValue == 'Part Availability'){
                
                // fire event
                var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
                menuEvent.setParams({
                    "menuName" : "partavailabledetail",
                    "partNumber" :searchVal
                });
                menuEvent.fire();
            }
            else if(selectedPicklistValue == 'CSR'){
                var selectedLocation=component.get("v.selectedLocation");
                var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
                menuEvent.setParams({
                    "menuName" : "csrdetail",
                    "csrNumber" :searchVal
                });
                menuEvent.fire();
                
            }
             else if(selectedPicklistValue == 'Dealer PO'){
                
                // fire event
                var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
                menuEvent.setParams({
                    "menuName" : "POrderDetails",
                    "poNumber" :searchVal
                });
                menuEvent.fire();
            }
  
            else if(selectedPicklistValue == 'CSR Part #'){
                var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
                menuEvent.setParams({
                    "menuName" : "partnumberdetail",
                    "csrPartNumber" :searchVal
                });
                menuEvent.fire();
            }
        }
        else if(searchVal.length < 3){
            helper.showErrorToast(component, event, helper, $A.get("$Label.c.search_text_should_have_minimum_3_characters"));
        }
    },
    
     getCsrToggle : function(component, event, helper) {
        
        var action = component.get("c.getCsrToggle");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // cart detail
                component.set("v.isCsrEnabled",response.getReturnValue());
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
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
       var toastError = $A.get("$Label.c.eDealer_error");
        toastEvent.setParams({
            "title": toastError,
            "type": "error",
            "message": message
        });
        toastEvent.fire();
	},
})