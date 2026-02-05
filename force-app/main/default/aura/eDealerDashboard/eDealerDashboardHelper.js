({
    showErrorToast : function(message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error!",
            "type": "error",
            "message": message
        });
        toastEvent.fire();
    },
    fetchFrequency : function(component, event, helper){
        var action = component.get("c.getFrequency");
        action.setCallback(this, function(response) {
            component.set("v.displayLoading", false);           
            var state = response.getState();
            console.log('Status of data '+ state);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                console.log('response >> frequency'+ JSON.stringify(response.getReturnValue()));
                let processedData = {};
                resultData.forEach(option => {
                    if (option.label && option.value) {
                    processedData[option.label] = option.value;
                }
                                   });
                
                
                console.log("Processed Frequency Options: ", processedData);
                
                // Set the processed data in the Aura attribute
                component.set("v.selectedFrequencies", processedData);
                /// conponent.set("v.frequencyOptions",resultData);
                console.log('selectoptions----->'+resultData);
                
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
        });
        $A.enqueueAction(action);
    }
})