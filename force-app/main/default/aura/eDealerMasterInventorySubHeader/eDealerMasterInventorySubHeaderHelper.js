({
    
    showErrorToast : function(component, event, helper, ErrorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": ErrorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
})