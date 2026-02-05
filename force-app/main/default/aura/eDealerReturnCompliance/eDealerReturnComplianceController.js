({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper); 
        helper.getMonthTranslations(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'MDI Returns Compliance Report Center');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Returns Compliance Report Center',component.get('v.loadTime'));
        });
    },
    
    reset : function(component, event, helper) {
        component.set("v.renderFilters",false);
        component.set("v.month",'');
        component.set("v.quarter",'');
        component.set("v.year",'');
        
        component.set("v.renderFilters",true);
        
        helper.handleToFilterChangeHelper(component, event, helper); 
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    
    
    fetchInternalReportData : function(component, event, helper) {
        component.set("v.returnComplinceReportData", []);
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
        helper.handleToFilterChangeHelper(component, event, helper); 
    },
    
    monthChange : function(component, event, helper) {
        component.set("v.month", event.getSource().get("v.value"));
        helper.handleToFilterChangeHelper(component, event, helper);
    },
    
    quarterChange : function(component, event, helper) {
        component.set("v.quarter", event.getSource().get("v.value"));
        helper.handleToFilterChangeHelper(component, event, helper);
    },
    
    yearChange : function(component, event, helper) {
        component.set("v.year", event.getSource().get("v.value"));
        helper.handleToFilterChangeHelper(component, event, helper);
    },
       handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Returns Compliance Report Center',component.get('v.loadTime'));
    }
})