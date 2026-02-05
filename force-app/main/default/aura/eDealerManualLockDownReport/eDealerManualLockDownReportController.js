({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);
        var todaysDate = new Date();
        var startDate = new Date(todaysDate.getFullYear(), todaysDate.getMonth(), todaysDate.getDate());
        var startDateSTR = helper.getDateWithFormat(component, event, helper, startDate);
        component.set("v.minStartDate", startDateSTR);
        
        startDate.setFullYear(startDate.getFullYear()+1);
        startDate.setDate(startDate.getDate() - 1);
        var endDate = startDate;
        var endDateSTR = helper.getDateWithFormat(component, event, helper, endDate );
        component.set("v.maxStartDate", endDateSTR);
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.startDate",today);
        helper.updateTrackingDetails(component, event, helper,'MDI Manual Parameters Report');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Manual Parameters Report',component.get('v.loadTime'));
        });
        
	},
    
    fetchReportData : function(component, event, helper) {
        // validate inputs when selected dates not correct 
        var valid = helper.validateInputs(component, event, helper);
        
        if(valid){
            component.set("v.manualLockdownReportData", []);
            //Check data in cache or fetch data
            helper.getManualLockDownReportData(component, event, helper, false);
        }
	},
    
    downloadReportData : function(component, event, helper) {
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getManualLockDownReportData(component, event, helper, true, offset);
        }
    },
    
    handleToFilterChange : function(component, event, helper) {
        var fromLoc = component.get("v.fromLocList");        
        component.set("v.manualLockdownReportData", []);
        component.set("v.APICalled",false);
        
        // this will be used to save if the any from location is selected
        var isFromLocSelected = false;
        
        // checking if we ahve any selected from location
        for(var ele in fromLoc){            
            if(fromLoc[ele].selected){
                isFromLocSelected = true;
            }
        }     
        var isStartDate = false;
        var isEndDate = false;
        
        if(!$A.util.isEmpty(component.get("v.startDate"))){
            isStartDate = true;
        }
        if(!$A.util.isEmpty(component.get("v.endDate"))){
            isEndDate = true;
        }
        
        // checking we all of them have values
        if(isFromLocSelected && isStartDate && isEndDate){
            component.set("v.disabledReportButton",false);
            helper.validateInputs(component, event, helper);
        }
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    
    handleHeaderAction: function (cmp, event, helper) {
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
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
        helper.updateTrackingTime(component, event, helper, 'MDI Manual Parameters Report',component.get('v.loadTime'));
    }
})