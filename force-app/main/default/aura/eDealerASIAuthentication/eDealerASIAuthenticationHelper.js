({
    ByPassAuthentication : function(component, event, helper) {
        var action = component.get("c.ASIAuthenticationByPass");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isByPassAuthentication", response.getReturnValue());
                if(response.getReturnValue() == true){
                    //Redirect user to eDealer page
                    helper.gotoEDealerPage(component);
                }else{
                    helper.CheckUserASIUser_APEX(component, event, helper); 
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                
            }
            
        });
        $A.enqueueAction(action);
	},
    
    CheckUserASIUser_APEX : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.checkASIUsername");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var asiUsername = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(asiUsername)){
                    helper.getAndSaveASIDealerCodes_Apex(component, event, helper, asiUsername);
                }else{
                    //Show User Authentication Modal
                    component.set("v.displayModal", true);
                    
                    //hide Spinner
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.Username", undefined);
                            component.set("v.Password", undefined);
                            component.set("v.displayLoading",false);
                        }), 500
                    );
                    
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast(component, event, helper,errors[0].message);
                    }
                }
                
                //hide Spinner
                component.set("v.displayLoading",false);
                
            }
            
        });
        $A.enqueueAction(action);
	},
    
	ASIAuthentication_APEX : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.ASIUserAuthentication");
        action.setParams({
            "name" : component.get("v.Username"),  
            "pwd" : component.get("v.Password")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(res)){
                    if(res.response == "Authenticated"){
                        // Means : username updated on User custom field and
                        //  now get and save the accessible delaer codes in apex
                    	 helper.getAndSaveASIDealerCodes_Apex(component, event, helper, component.get("v.Username"));
                    }else{
                        //error msg
                        helper.showErrorToast(component, event, helper,res.error);
                        //hide Spinner
            			component.set("v.displayLoading",false);
                    }
                }

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast(component, event, helper,errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                //hide Spinner
            component.set("v.displayLoading",false);
            }
            
            
        });
        $A.enqueueAction(action);
	},
    
    
    getAndSaveASIDealerCodes_Apex : function(component, event, helper, asi_username) {
        var action = component.get("c.getAndSaveASIDealersLocations");
        action.setParams({
            "userName" : asi_username,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                let interactive_order_entry = response.getReturnValue();
                if(interactive_order_entry == true){
                    //Redirect user to eDealer page
                    helper.gotoEDealerPage(component);
                }else{
                    helper.showErrorToast(component, event, helper,"Your account is inactive, please contact your External Dealer Admin to get your account activated.");
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast(component, event, helper,errors[0].message);
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
    
    showSuccessToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Success!",
            "type": "success",
            "message": message
        });
        toastEvent.fire();
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
    
    gotoEDealerPage : function(component){
        try{
            var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                 "url": '/edealer'
                });
               urlEvent.fire();
        }
        catch(e){
            //console.log('error ==>> '+e.message);
        }
    },
})