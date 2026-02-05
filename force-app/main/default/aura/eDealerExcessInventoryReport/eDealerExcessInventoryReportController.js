({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);  
         component.set(
            'v.loadTime',
            Date.now()
        ); 
        helper.updateTrackingDetails(component, event, helper,'MDI Excess Report');
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Excess Report',component.get('v.loadTime'));
        });
    },
    
    fetchInternalReportData : function(component, event, helper) {
        component.set("v.reportData", []);
        helper.getReportData(component, event, helper); 
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
        
        // this will be used to save if the any from location is selected
        var isFromLocSelected = false;
        
        // checking if we ahve any selected from location
        for(var ele in fromLoc){            
            if(fromLoc[ele].selected){
                isFromLocSelected = true;
            }
        }        
        
        // checking we all of them have values
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
    
    updateTableData : function(cmp, event, helper) {
        var paginationDataList = cmp.get("v.PaginationList");
        cmp.set("v.data", paginationDataList);
        helper.handleSort(cmp, event);
    },
    
    handleHeaderAction: function (cmp, event, helper) {
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        //console.log("colDef ==>> "+JSON.stringify(colDef));
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
            var actions = columns[idx].actions;
            if (actions) {
                actions.forEach(function (action) {
                    action.checked = action.name === actionName;
                });
                cmp.set('v.activeFilter', actionName);
                //console.log('colDef.fieldName ==>> '+colDef.fieldName);
                helper.updateBooks(cmp, colDef.fieldName);
                cmp.set('v.columns', columns);
            }
        }
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Excess Report',component.get('v.loadTime'));
    },
})