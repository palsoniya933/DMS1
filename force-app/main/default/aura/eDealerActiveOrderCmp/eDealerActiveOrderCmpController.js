({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component,event,helper);
        component.set("v.activeOrders", 0);
        component.set("v.activeOrdersData", undefined);
        component.set("v.selectedActiveOrder",'All');
        component.set("v.selectedoption", "All");;
        //Fetch data
        helper.fetchActiveOrdersMultipleData(component, event, helper);
    },
    
    
    listdealerLocChange : function(component, event, helper) {
        component.set("v.activeOrders", 0);
        component.set("v.activeOrdersData", undefined);
        component.set("v.selectedoption", "All");
        component.set("v.selectedActiveOrder",'All');
        //Fetch data
        helper.fetchActiveOrdersMultipleData(component, event, helper);
    },
    
    handleSubTypeUpdate : function(component, event, helper) {
        //update U.I.
        helper.updateUI(component, event, helper);
    },  
    
    
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Active Order(s)');
        var option = component.get("v.selectedoption");
        var ordertype = component.get("v.selectedActiveOrder");
        var dealerLoc = component.get("v.listDealerLoc")[0];
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=activeorders&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Active Order(s)');
        var orderType = component.get("v.selectedActiveOrder");       
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
            component.set("v.selectedActiveOrder", "td");
        }
        else if(orderType == 'Emergency'){
            component.set("v.selectedActiveOrder", "em");
        }
            else if(orderType == 'Stock'){
                component.set("v.selectedActiveOrder", "st");
            }
                else{
                    component.set("v.selectedActiveOrder", "All");
                }
        let selecedDivision = component.get("v.currentDealerDivision")
        component.set("v.selectedMenu", "activeorders");
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "activeorders" ,
                             "division":selecedDivision});
        menuEvent.fire();
    },
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
      helper.updateTrackingDetails(component, event, helper,'Active Order(s)');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
})