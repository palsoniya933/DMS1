({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Master Inventory');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Master Inventory',component.get('v.loadTime'));
        });
    },
    
    searchByKeyword : function(component, event, helper) {
        component.set("v.partsList", undefined);
        component.set("v.totalOrderSelected", 0);
        component.set("v.offset_value", 0);
        component.set("v.lastRefreshDate", undefined);
        component.set("v.totalInventroyLines", 0);
        var searchKeyword = component.get("v.searchKeyword");
        component.set("v.responseReceived",false);
        helper.fetchMasterInventoryPartsDetails(component, event, helper, searchKeyword, false);
    },
    
    partClicked : function(component, event, helper) {
        component.set("v.partNumber",event.getParam("partNumber"));  
        component.set("v.displayParts",true);
    },
    
    closePartModel : function(component, event, helper) {                  
        component.set("v.displayParts",false);
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Master Inventory',component.get('v.loadTime'));
    }
})