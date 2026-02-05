({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);  
        helper.updateTrackingDetails(component, event, helper,'MDI Not on File Report');
        
        // initalize filter values
        var filterList=[];
        var filterObject = {};
        filterObject.fieldName = '';
        filterObject.fieldOperator = '';
        filterObject.fieldValue = '';
        filterList.push(filterObject); 
         component.set(
            'v.loadTime',
            Date.now()
        );
        // set the filter
        component.set("v.selectedFilters", filterList);
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Not on File Report',component.get('v.loadTime'));
        });
	},
    
    fetchReportData : function(component, event, helper) {
        debugger;
        component.set("v.notOnFileReportData", []);
        //fatch the data
        helper.getReportData(component, event, helper);
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
    
    handleToFilterChange : function(component, event, helper) {
        debugger;
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
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Not on File Report',component.get('v.loadTime'));
    },
})