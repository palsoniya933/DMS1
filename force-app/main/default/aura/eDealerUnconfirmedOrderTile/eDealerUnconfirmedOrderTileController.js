({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component, event, helper);

        component.set("v.unConfirmOrders", 0);
        component.set("v.unConfirmOrdersData", undefined);
        component.set("v.selectedUnConfirmedOrder",'All');
        component.set("v.selectedoption", "All");;

        //fetch data
        helper.fetchUnConfirmedOrdersMultipleData(component, event, helper);
    },
    
    listdealerLocChange : function(component, event, helper) {
        component.set("v.unConfirmOrders", 0);
        component.set("v.unConfirmOrdersData", undefined);
        component.set("v.selectedUnConfirmedOrder",'All');
        component.set("v.selectedoption", "All");;

        //Fetch data
        helper.fetchUnConfirmedOrdersMultipleData(component, event, helper);
    },
    
    handleSubTypeUpdate : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Unconfirmed Order');
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Unconfirmed Order');
        var option = component.get("v.selectedoption");
        var dealerLoc = component.get("v.listDealerLoc")[0];
        var ordertype = component.get("v.selectedUnConfirmedOrder");
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=unconfirmedorders&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
 
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Unconfirmed Order');
        var orderType = component.get("v.selectedUnConfirmedOrder");       
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
            component.set("v.selectedUnConfirmedOrder", "truckdownorders");
        }
        else if(orderType == 'Emergency'){
            component.set("v.selectedUnConfirmedOrder", "emergencyorders");
        }
            else if(orderType == 'Stock'){
                component.set("v.selectedUnConfirmedOrder", "stockorders");
            }
                else{
                    component.set("v.selectedUnConfirmedOrder", "total");
                }
         let selecedDivision = component.get("v.currentDealerDivision")
        component.set("v.selectedMenu", "unconfirmedorders");                
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "unconfirmedorders" ,
                            "division":selecedDivision});

        menuEvent.fire();
        
    },
     updateTileDetails : function(component, event, helper) {
      helper.updateTrackingDetails(component, event, helper,'Unconfirmed Order');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        
        //update U.I.
        helper.updateUI(component, event, helper);
    }
    
})