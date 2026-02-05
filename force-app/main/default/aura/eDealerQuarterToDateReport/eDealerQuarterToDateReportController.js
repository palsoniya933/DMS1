({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'MDI Quarter-to-Date Report');
        // code to arrange the quarter
        var dateNew = new Date();
        var quarters = [];
        for(var i = 0; i < 5; i++) {
            quarters.push('Q' + Math.floor((dateNew.getMonth() + 3) / 3) + ' ' + dateNew.getFullYear());
            dateNew.setMonth(dateNew.getMonth() - 3);
        }        
        component.set("v.quarters", quarters);
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Quarter-to-Date Report',component.get('v.loadTime'));
        });
    },
    
    quarterChange : function(component, event, helper) {
        var selectedValue = component.find("quarterselect").get("v.value");
        
        // split with space
        var quarterYear = selectedValue.split(' ');
        if(quarterYear.length == 2){
            component.set("v.quarter", quarterYear[0].trim().replace('Q',''));
            component.set("v.year", quarterYear[1].trim());
        }
        else{
            component.set("v.quarter", '');
            component.set("v.year", '');
        }
        
        helper.handleToFilterChangeHelper(component, event, helper);
    },
    
    fetchInternalReportData : function(component, event, helper) {
        component.set("v.quarterToDateReportData", []);
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
        helper.updateTrackingTime(component, event, helper, 'MDI Quarter-to-Date Report',component.get('v.loadTime'));
    },
})