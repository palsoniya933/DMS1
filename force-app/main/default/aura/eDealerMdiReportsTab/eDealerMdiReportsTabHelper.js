({
    doInithelper : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);        
        var action = component.get("c.getUserDetail");
        component.set("v.userDetail",undefined);
        component.set("v.selectedLocation",undefined);
        
        action.setParams({            
            "SelectedUser" : component.get("v.selectedUserName")
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var userAccessDetail = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(userAccessDetail) 
                   && !$A.util.isUndefinedOrNull(userAccessDetail.accessibleDealersLocation)
                   && userAccessDetail.accessibleDealersLocation.length > 0){
                    //default selected location 
                    var selectedLoc = (!$A.util.isEmpty(userAccessDetail.accessibleDealersLocation[0].Sub_Code__c)) ? userAccessDetail.accessibleDealersLocation[0].ASI_Dealer_Code__c +'-'+userAccessDetail.accessibleDealersLocation[0].Sub_Code__c : userAccessDetail.accessibleDealersLocation[0].ASI_Dealer_Code__c;
                    component.set("v.selectedLocation", selectedLoc);
                    
                    //Call EVENT
                    var menuEvent = $A.get("e.c:eDealerLocationEvent");    
                    menuEvent.setParams({ "selectedLoc" : selectedLoc});
                    menuEvent.fire();         
                    
                    component.set("v.userDetail",userAccessDetail);
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        //alert(errors[0].message);
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
            
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    getUsers : function(component,event, helper){        
        var action=component.get("c.getUserList");
        action.setCallback(this, function(response) {
            var state=response.getState();
            var values = response.getReturnValue();
            if(state=='SUCCESS'){             
                component.set("v.options", values);
                component.set("v.displayHeader",true);
            }        
        });
        $A.enqueueAction(action); 
    },
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error!",
            "type": "error",
            "message": message
        });
        toastEvent.fire();
    },
})