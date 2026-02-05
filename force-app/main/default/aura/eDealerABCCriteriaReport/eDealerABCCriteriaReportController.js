({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper); 
        helper.updateTrackingDetails(component, event, helper,'MDI ABC Criteria Report');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI ABC Criteria Report',component.get('v.loadTime'));
        });
	},
    
    fetchReportData : function(component, event, helper) {
        component.set("v.ABCCriteriaReportData", []);
        //Check data in cache or fetch data
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
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
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
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI ABC Criteria Report',component.get('v.loadTime'));
    }
})