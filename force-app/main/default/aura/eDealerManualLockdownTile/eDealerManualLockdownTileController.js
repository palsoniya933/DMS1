({
    doInit : function(component, event, helper) {
        component.set("v.date", new Date());
        component.set("v.manualLockdownData", []);
        //Check data in cache or fetch data
        helper.fetchManualLockDownData(component, event, helper);
    },
    
    /*gotoManualLockDownReport : function(component, event, helper) {
        // fire event
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({
            "menuName" : "reportcenter",
            "reportName" : "Manual Lockdown Report"});
        menuEvent.fire();
	},*/
    
    handleOpenInNewWindow : function(component, event, helper) { 
        var dealerLoc = component.get("v.dealerLoc");
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=manuallockdownparts&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Manual Parameter(s)');
        component.set("v.selectedSubMenu", "manuallockdownparts");
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'manuallockdownparts',
                             "submenu" : null });
        menuEvent.fire();
        var menuClickEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuClickEvent.setParams({ 
                                   "menuName" : 'manuallockdownparts'

        });
        menuClickEvent.fire();
    },
    
})