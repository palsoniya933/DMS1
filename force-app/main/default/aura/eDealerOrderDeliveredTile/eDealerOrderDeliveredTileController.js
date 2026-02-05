({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        component.set("v.deliveredOrders", 0);
        component.set("v.deliveredOrdersData", undefined);
        //fetch data
        helper.fetchDeliveredOrdersData(component, event, helper);
    },
    
    dealerLocChange : function(component, event, helper) {
        component.set("v.deliveredOrders", 0);
        component.set("v.deliveredOrdersData", undefined);
        component.set("v.selectedoption", "Daily");
        //fetch data
        helper.fetchDeliveredOrdersData(component, event, helper);
    },
    listdealerLocChange : function(component, event, helper) {
        component.set("v.deliveredOrders", 0);
        component.set("v.deliveredOrdersData", undefined);
        component.set("v.selectedoption", "Daily");
        //Fetch data
        helper.fetchDeliveredOrdersMultipleData(component, event, helper);
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        var index = event.target.name;
        component.set("v.selectedoption",index);
        
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    

    
    openOrdersTile : function(component, event, helper){
        var option = component.get("v.selectedoption");
        
        if(option == "Daily"){
            component.set("v.selectedoption", "Day");
        }
        else if(option == "Weekly"){
            component.set("v.selectedoption", "Week");
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
        
        component.set("v.selectedMenu", "deliveredorders");
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "deliveredorders" });
        menuEvent.fire();
        
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var option = component.get("v.selectedoption");
        var dealerLoc = component.get("v.dealerLoc");
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=deliveredorders&option="+option+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
     
})