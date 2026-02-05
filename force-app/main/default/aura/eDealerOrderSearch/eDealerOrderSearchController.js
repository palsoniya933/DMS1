({
    doInit : function(component, event, helper) {
        component.set("v.displayLoading",true);
        component.set("v.responseReceived",false);
        //component.set("v.partavailableData",[]);
        helper.fetchSearchOrdersDetail(component, event, helper);
    },
    
    
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderNum="+partNum+'&loc='+dealerCode+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrder : function(component, event, helper) {
    	// fire event
        var orderNum = event.currentTarget.name;
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({
            "menuName" : "activeordersdetail",
            "orderNumber" : orderNum
        });
        menuEvent.fire();
    },
    
})