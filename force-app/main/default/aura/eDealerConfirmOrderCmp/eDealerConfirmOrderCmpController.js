({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component, event, helper);
        component.set("v.confirmOrders", 0);
        component.set("v.confirmOrdersData", undefined);
        component.set("v.selectedoption", "All");
        component.set("v.selectedOrder",'All');
        //fetch data
        helper.fetchConfirmOrdersMultipleData(component, event, helper);
    },
    
     listdealerLocChange : function(component, event, helper) {
        component.set("v.confirmOrders", 0);
        component.set("v.confirmOrdersData", undefined);
        component.set("v.selectedoption", "All");
        component.set("v.selectedOrder",'All');
        //fetch data
        helper.fetchConfirmOrdersMultipleData(component, event, helper);
    },
    
    handleSubTypeUpdate : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Closed Orders');
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Closed Orders');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Closed Orders');
        var option = component.get("v.selectedoption");
        var dealerLoc = component.get("v.dealerLoc");
        var ordertype = component.get("v.selectedOrder");
        var dealerDivision = component.get("v.currentDealerDivision");
    	let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=confirmedorders&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Closed Orders');
        var orderType = component.get("v.selectedOrder");
        var option = component.get("v.selectedoption");
        
        if(option == "Daily"){
            component.set("v.selectedoption", "Day");
        }
        else if(option == "Monthly"){
            component.set("v.selectedoption", "Month");
        }
        else if(option == "Quarterly"){
            component.set("v.selectedoption", "Quarter");
        }
        else if(option == "Annually"){
            component.set("v.selectedoption", "Year");
        }
        else if(option == "All"){
            component.set("v.selectedoption", "All");
        }
        
        if(orderType == 'invoiceorders'){
            component.set("v.selectedClosedOrder","Invoiceorder");
        }else if(orderType == 'cancelorders'){
            component.set("v.selectedClosedOrder","Cancel");
        }else{
            component.set("v.selectedClosedOrder","All");
        }
       
        component.set("v.selectedMenu", "confirmedorders");
       
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "confirmedorders" });
        menuEvent.fire();
    },
    
    mouseover : function(component, event, helper) {
        var option = event.target.name;
        
        if(option == "Daily"){
            component.set("v.tooltipdata", "Current Date");
        }
        else if(option == "Monthly"){
            component.set("v.tooltipdata", "Current Month to Date");
        }
        else if(option == "Quarterly"){
            component.set("v.tooltipdata", "Current Quarter to Date");
        }
        else if(option == "Annually"){
            component.set("v.tooltipdata", "Current Year to Date");
        }
        else if(option == "All"){
            component.set("v.tooltipdata", "Current Year to Date - Prior 2 Years");
        }
        
        component.set("v.tooltip", true);
    },
    
    mouseout : function(component, event, helper) {
        component.set("v.tooltipdata", '');
        component.set("v.tooltip", false);
    },
})