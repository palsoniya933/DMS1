({
    doInitHelper : function(component, event, helper) {
        component.set("v.displayLoading", true);
        component.set("v.invData", undefined);
        component.set("v.totalOrderSelected", 0);
        helper.fetchPDCSuggestedOrders(component, event, helper);
    },
    
    
    fetchPDCSuggestedOrders : function(component, event, helper) {
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchDealerPDCSuggestedOrdersDetails");
        action.setParams({
            "dealerCode" : locCode,
            "isSpecialSOF" : component.get("v.isSpecialOrdersSOF")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.invData", response.getReturnValue());
                // update sub-header details
                helper.callSubHeaderToUpdate(component, event, helper);
                
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
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    
    addItemsInEmergencyCart : function(component, event, helper, selectedOrderType) {
        var action = component.get("c.upsertItemsInEmergencyCart");
        action.setParams({
            "suggestedOrders"  : JSON.stringify(component.get("v.invData"))
        });
        
        action.setCallback(this, function(response) {
            //hide spinner
            component.set("v.displayLoading",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //Show Modal for Selected items now in cart
                component.set("v.showEmergencyOrderAddCartModal", true);
                
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
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
        });
        $A.enqueueAction(action);
    },
    
    addItemsInStockCart : function(component, event, helper, selectedOrderType) {
        var action = component.get("c.upsertItemsInStockCart");
        action.setParams({
            "suggestedOrders"  : JSON.stringify(component.get("v.invData"))
        });
        
        action.setCallback(this, function(response) {
            //hide spinner
            component.set("v.displayLoading",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //Show Modal for Selected items now in cart
                component.set("v.showStockOrderAddCartModal", true);
                
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
                
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
        });
        $A.enqueueAction(action);
    },
    
	calculateSelectedRowsHelper  : function(component, event, helper) {
        var invData = component.get("v.PaginationList");
        var selectedRows = 0;
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked == true){
                selectedRows++;
            }
        }
        component.set("v.totalOrderSelected", selectedRows);
    },
    
    callSubHeaderToUpdate : function(component, event, helper) {
        var SubHeaderComp = component.find('SubHeaderComp');
        SubHeaderComp.callChild();
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