({
    doInit : function(component, event, helper) {
        console.log('Inside Listing');
        //default slected column
        component.set("v.activeColumnName", "All");
        component.set("v.displayLoading",true);
        var orderType = component.get('v.orderType');
        if(orderType == 'all'){
            orderType = '';
        }
        if(!orderType
           && helper.getParams('ordertype')){
            component.set("v.orderType",helper.getParams('ordertype'))
        } 
       
        
        helper.fetchOrdersData(component, event, helper);
        
        
    },
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },
    
    openOrder : function(component, event, helper) {
        // fire event
        var orderNum = event.currentTarget.name;
        console.log('orderNum'+orderNum);
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({
            "menuName" : "activeordersdetail",
            "orderNumber" : orderNum
        });
        menuEvent.fire();
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
})