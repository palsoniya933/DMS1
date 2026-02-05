({
    fetchURLLinks: function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading", true);
        var dealerCode = component.get('v.dealerCode');
        var year = component.get('v.year');
        var action = component.get("c.fetchMonthlyPriceFilesURLs");
        component.set("v.APICalled", false);
        
        action.setParams({
            "dealerCode" : dealerCode,
            "year": year
        });
        
        action.setCallback(this, function(response) {
            component.set("v.APICalled", true);
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var resultData = response.getReturnValue();                 
                component.set('v.lstUrlsResponse',resultData);

            } else {
                console.log("Failed with state: " + state);
                console.log(response.getError());
            }
            
            //hide Spinner
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
    }
});