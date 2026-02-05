({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component, event, helper);
        component.set("v.pendingOrders", 0);
        component.set("v.pendingOrdersData", undefined);
        component.set("v.selectedPendingOrder",'All');
        component.set("v.selectedoption", "All");
        //fetch data
        helper.fetchPendingOrdersMultipleData(component, event, helper);
    },
    
    listdealerLocChange : function(component, event, helper) {
        component.set("v.pendingOrders", 0);
        component.set("v.pendingOrdersData", undefined);        
        component.set("v.selectedoption", "All");
        component.set("v.selectedPendingOrder",'All');
        //Fetch data
        helper.fetchPendingOrdersMultipleData(component, event, helper);
    },
    
    handleSubTypeUpdate : function(component, event, helper) {
        //update U.I.
        helper.updateUI(component, event, helper);
    },
   handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Back Order(s)');
        var option = component.get("v.selectedoption");
        var ordertype = component.get("v.selectedPendingOrder");
        var dealerDivision = component.get("v.currentDealerDivision");
        var dealerLoc = component.get("v.listDealerLoc")[0];
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=pendingorders&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Back Order(s)');
        
        var orderType = component.get("v.selectedPendingOrder");   
        var option = component.get("v.selectedoption");
        
        if(option == "Monthly"){
            component.set("v.selectedoption", "Month");
        }
        else if(option == "Quarterly"){
            component.set("v.selectedoption", "Quarter");
        }
        else if(option == "Weekly"){
            component.set("v.selectedoption", "Week");
        }
        else if(option == "All"){
            component.set("v.selectedoption", "All");
        }
        
        if(orderType == 'Truck'){
            component.set("v.selectedPendingOrder", "truckdownorders");
        }else if(orderType == 'Emergency'){
            component.set("v.selectedPendingOrder", "emergencyorders");
        }else if(orderType == 'Stock'){
            component.set("v.selectedPendingOrder", "stockorders");
        }else{
            component.set("v.selectedPendingOrder", "ordercount");
        }
        
        let selecedDivision = component.get("v.currentDealerDivision")
        component.set("v.selectedMenu", "pendingorders");
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "pendingorders" ,
                             "division":selecedDivision});
        menuEvent.fire();
        
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Back Order(s)');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        
        //update U.I.
        helper.updateUI(component, event, helper);
    },
})