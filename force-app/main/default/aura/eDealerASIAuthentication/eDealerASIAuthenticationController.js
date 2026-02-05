({
    checkUserASIUser : function(component, event, helper) {
        helper.ByPassAuthentication(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Gateway Login');
    },
    
	// hide the place order modal
    closeModal : function(component, event, helper) {        
        component.set("v.displayModal", false);         
    },
    
    validateForm : function(component, event, helper) {  
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
            helper.updateTrackingDetails(component, event, helper,'Gateway Login');
            // call ASI Authentication API
            helper.ASIAuthentication_APEX(component, event, helper); 
        }
    },
    
    showModal :  function(component, event, helper) {
    	component.set("v.displayModal", true);
    },
})