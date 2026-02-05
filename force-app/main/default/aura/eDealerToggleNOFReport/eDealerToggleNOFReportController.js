({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Toggle NOF Report');
         component.set(
            'v.loadTime',
            Date.now()
        );
          window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Toggle NOF Report',component.get('v.loadTime'));
        });
        
	},
    
    fetchReportData : function(component, event, helper) {
            component.set("v.toggleNOFReportData", []);
            helper.getReportData(component, event, helper, false);
	},
    
    downloadReportData : function(component, event, helper) {
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getReportData(component, event, helper, true, offset);
        }
    },
    
    handleToFilterChange : function(component, event, helper) {
        var fromLoc = component.get("v.fromLocList");        
 component.set("v.toggleNOFReportData", []);
        component.set("v.APICalled",false);
        var isFromLocSelected = false;

        for(var ele in fromLoc){            
            if(fromLoc[ele].selected){
                isFromLocSelected = true;
            }
        }     
        
        if(isFromLocSelected){
            component.set("v.disabledReportButton",false);
        }
        else{
            component.set("v.disabledReportButton",true);
        }
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
   handleHeaderAction: function (cmp, event, helper) {
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        console.log("colDef ==>> "+JSON.stringify(colDef));
        var columns = cmp.get('v.columns');
        var activeFilter = cmp.get('v.activeFilter');
        if (actionName !== 'clipText' && actionName !== 'wrapText' && actionName !== activeFilter) {
            var idx = -1;
            columns.some(function(column, i) {
                if (column.fieldName === colDef.fieldName) {
                    idx = i;
                    return true;
                }
            });
        }
    },
       handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Toggle NOF Report',component.get('v.loadTime'));
    }
})