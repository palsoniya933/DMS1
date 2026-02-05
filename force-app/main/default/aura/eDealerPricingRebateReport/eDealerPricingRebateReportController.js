/** 
 Name        : eDealerPricingRebateReport
 Description : This is an JS controller for eDealer Pricing category rebate report page.
 Developer: Nikhil Nair
*/

({
    doInit: function(component, event, helper) {
        // Example initialization of dates
        var today = new Date();
        var RebateDaysAgo = new Date();
        RebateDaysAgo.setDate(today.getDate() - 13);

        var todayStr = today.toISOString().slice(0, 10);
        var RebateDaysAgoStr = RebateDaysAgo.toISOString().slice(0, 10);

        component.set("v.currentDate", todayStr);
        component.set("v.RebateDaysAgoDate", RebateDaysAgoStr);

        // Set the download link text
        var downloadLinkText = "Download Rebate Report (" + RebateDaysAgoStr + " to " + todayStr + ")";
        component.set("v.downloadLinkText", downloadLinkText);
    },

    handleDealerCodeChange: function(component, event, helper) {
        // Reset the download URL when the dealer code changes
        component.set("v.downloadUrl", "");
        component.set("v.displayLoading", false);
    },

    downloadReport: function(component, event, helper) {
        var dealerCode = component.get("v.dealerCode");
        if (!dealerCode) {
            console.error("Dealer code is not set.");
            return;
        }

        // Show loading spinner
        component.set("v.displayLoading", true);

        var action = component.get("c.initiateRebateReportDownload");
        action.setParams({ dealerCode: dealerCode });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("State: " + state);
            if (state === "SUCCESS") {
                var csvData = response.getReturnValue();
                helper.triggerDownload(csvData, dealerCode);
                component.set("v.displayLoading", false);
            } else if (state === "INCOMPLETE") {
                console.error("No response from server or client is offline.");
                component.set("v.displayLoading", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.error("Error message: " + errors[0].message);
                } else {
                    console.error("Unknown error");
                }
                component.set("v.displayLoading", false);
            } else {
                console.error("Unexpected state: " + state);
                component.set("v.displayLoading", false);
            }
        });
        $A.enqueueAction(action);
    }
})