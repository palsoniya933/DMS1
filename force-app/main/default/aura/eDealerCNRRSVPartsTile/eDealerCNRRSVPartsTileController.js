({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        component.set("v.csrRSVData", undefined);
        helper.fetchTotalInventoryData(component, event, helper);
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var dealerLoc = component.get("v.dealerLoc");         
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": ("?orderlisting=cnrorderlisting&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
            });
            urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'CNR / RSV Parts');
        component.set("v.selectedMenu", "cnrorderlisting");                
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'cnrorderlisting'});
        menuEvent.fire();
        
    }
})