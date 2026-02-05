({
    displaySelectedReportTile : function(component, event, helper, selectedReportName) {
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.selectedReport", selectedReportName);
            }), 100
        );
    },
      
})