({    
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component, event, helper);
        component.set("v.activeOrders", undefined);
        component.set("v.totalPartsData", undefined);
         component.set("v.selectedoption", "All");
        component.set("v.selectedOrder","All");        
        // fetch data
        helper.fetchTotalPartsOrdersMultipleData(component, event, helper);
    },
    
    listdealerLocChange : function(component, event, helper) {
        component.set("v.activeOrders", undefined);
        component.set("v.totalPartsData", undefined);        
        component.set("v.parts",0);
        component.set("v.partsValue",0);
        component.set("v.partsPer",0.00);
        component.set("v.partsValuePer",0.00);
        component.set("v.selectedoption", "All");
        component.set("v.selectedOrder","All");
        //Fetch data
        helper.fetchTotalPartsOrdersMultipleData(component, event, helper);
    },
    
    handleSubTypeUpdate : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Order Summary');
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Order Summary');
        var index = event.target.name;
        if(index == "All" || index == "Two Years"){
            index = 'All';
        }
        component.set("v.selectedoption",index);
        console.log('updateTileDetails--'+component.get("v.selectedoption"));
        //update U.I.
        helper.updateUI(component, event, helper);
    },   
    
    handleSelectedOrder : function(component, event, helper) {
        var SelectedOrder =component.get("v.selectedOrder");
        component.set("v.activeOrders", undefined);
        component.set("v.totalPartsData", undefined);     
        component.set("v.parts",0);
        component.set("v.partsValue",0);
        component.set("v.partsPer",0.00);
        component.set("v.partsValuePer",0.00);         
        helper.fetchTotalPartsOrdersMultipleData(component, event, helper);
    },
    //13-10-21 
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Order Summary');
        var origin = window.location.origin;
        var pathName = window.location.pathname;
        var option = component.get("v.selectedoption");
        var dealerLoc = component.get("v.dealerLoc");
        var ordertype = component.get("v.selectedOrder");
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=ordersummary&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Order Summary');
        var orderType = component.get("v.selectedOrder");
        var selectedoption='';
        var option = component.get("v.selectedoption");
        if(option == "Weekly"){
            selectedoption = 'week';            
        }else if(option == "Monthly"){
            selectedoption = 'Month';    
        }else if(option == "Quarterly"){
            selectedoption = 'Quarter';             
        }else if(option == "Annually"){
            selectedoption = 'Year';            
        }else if(option == "All" || option == "Two Years"){
            selectedoption = 'All';  }
                
        component.set("v.selectedoption", selectedoption);
        component.set("v.selectedMenu", "ordersummary");
        
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "ordersummary" });
        menuEvent.fire();
        
    },
})