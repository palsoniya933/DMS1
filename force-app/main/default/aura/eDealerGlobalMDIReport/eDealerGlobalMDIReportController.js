({
	doInit : function(component, event, helper) {
        debugger;
        component.set("v.reportData", [])
        helper.getReportData(component, event, helper);
         component.set(
            'v.loadTime',
            Date.now()
        );
        helper.updateTrackingDetails(component, event, helper,'MDI Global Report');
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Global Report',component.get('v.loadTime'));
        });
	},    
    
    handleHeaderAction: function (cmp, event, helper) {
        debugger;
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        console.log("colDef ==>> "+JSON.stringify(colDef));
        var columns = cmp.get('v.columns');
		debugger;
        if (actionName !== 'clipText' && actionName !== 'wrapText') {
            var idx = -1;
            columns.some(function(column, i) {
                if (column.fieldName === colDef.fieldName) {
                    idx = i;
                    return true;
                }
            });
        }
    },
    
    downloadReportData : function(component, event, helper) {
        debugger;
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getReportData(component, event, helper, true, offset);
        }
    },
    
    handleMouseHover: function(component, event, helper) {
        component.set("v.togglehover",true);
    },
    
    handleMouseOut: function(component, event, helper) {
        component.set("v.togglehover",false);
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Global Report',component.get('v.loadTime'));
    }
})