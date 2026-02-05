({
    doInitHelper : function(component, event, helper) {
        debugger;
        component.set("v.displayLoading", true);
        component.set("v.invData", undefined);
        component.set("v.totalOrderSelected", 0);
        helper.fetchNonPaccarPartsSuggestedOrders(component, event, helper);
    },
    
    
    fetchNonPaccarPartsSuggestedOrders : function(component, event, helper) {
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchDealerNonPaccarSuggestedOrdersDetails");
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
                        console.log("Error message: " + 
                                 errors[0].message);
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
    
    callSubHeaderToUpdate : function(component, event, helper) {
        var SubHeaderComp = component.find('SubHeaderComp');
        SubHeaderComp.callChild();
    },
    
})