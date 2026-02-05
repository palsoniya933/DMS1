({
    doInit : function(component, event, helper) {    
        component.set("v.displayLoading",true);
        helper.fetchOrdersData(component, event, helper);    
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var origin = window.location.origin;
        var pathName = window.location.pathname;
        var partNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        var option = component.get("v.selectedoption");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderNum="+partNum+'&loc='+dealerCode+"&timeFrame="+option),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },
})