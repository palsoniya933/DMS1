({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'MDI Planning Breadth Report');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Planning Breadth Report',component.get('v.loadTime'));
        });
    },
    
    fetchPlanningBreadthData : function(component, event, helper) {
        //console.log('fetchPlanningBreadthData...');
        component.set("v.planningBreadthReportData", []);
        helper.getReportData(component, event, helper);
    },
    
    downloadReportData : function(component, event, helper) {
        //debugger;
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getReportData(component, event, helper, true, offset);
        }
    },

    handleToFilterChange : function(component, event, helper) {
        helper.handleToFilterChangeHelper(component, event, helper);
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Planning Breadth Report',component.get('v.loadTime'));
    }
    
})