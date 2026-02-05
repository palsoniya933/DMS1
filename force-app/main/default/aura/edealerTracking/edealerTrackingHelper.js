({
	updateTrackingDetails: function (component, event, helper, trackingDetail) {
        var action = component.get("c.insertTrackingDetails");
         action.setParams({
            "trackingDetail" : trackingDetail
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                console.log("tracking SUCCESS");
                
                var returnResult = response.getReturnValue();                
            } else if (state === "ERROR") {
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
        });
        $A.enqueueAction(action);
    },
    
    updateTrackingTime: function (component, event, helper, trackingDetail, loadTime) {
        const timeDiffInMilSecs = Date.now() - loadTime;
        const timeSpentInSecs = Math.floor(timeDiffInMilSecs / 1000);
        var action = component.get("c.updateTimeSpent");
         action.setParams({
            "trackingDetail" : trackingDetail,
             "timeSpent" : timeSpentInSecs
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                console.log("tracking SUCCESS");
                
                var returnResult = response.getReturnValue();                
            } else if (state === "ERROR") {
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
        });
        $A.enqueueAction(action);
    }
})