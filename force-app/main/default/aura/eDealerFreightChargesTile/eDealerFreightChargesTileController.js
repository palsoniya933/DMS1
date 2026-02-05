({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        helper.getfilters(component, event, helper);
        component.set("v.freightCharges", 0);
        component.set("v.freightChargesData", undefined);
        //fetch data
        helper.fetchFreightChargeMultipleData(component, event, helper);
    },
    
    listdealerLocChange : function(component, event, helper) {
       component.set("v.selectedFreightChargesType","all");
        component.set("v.freightCharges", 0);
        component.set("v.freightChargesData", undefined);
        component.set("v.selectedoption", "Daily");
        //Fetch data
        helper.fetchFreightChargeMultipleData(component, event, helper);
    },
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Freight Charges');
        var option = component.get("v.selectedoption");
        var ordertype = component.get("v.selectedFreightChargesType");
        console.log('option'+option);
        var dealerLoc = component.get("v.listDealerLoc")[0];
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=freightcharges&option="+option+"&ordertype="+ordertype+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
               
        urlEvent.fire();
    }, 
    handleSubTypeUpdate : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Freight Charges');
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Freight Charges');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        console.log('index'+index);
        //update U.I.
        helper.updateUI(component, event, helper);
    },
    
    handleMouseHover: function(component, event, helper) {
        component.set("v.togglehover",true);
    },
    handleMouseOut: function(component, event, helper) {
        component.set("v.togglehover",false);
    },
    openOrdersTile : function(component, event, helper){
        try{
        var orderType = component.get("v.selectedOrder");
        var selectedoption='';
        var option = component.get("v.selectedoption");
        console.log('option'+option);
        if(option == "Daily"){
            selectedoption = 'Day';            
        }else if(option == "Monthly"){
            selectedoption = 'Month';    
        }else if(option == "Quarterly"){
            selectedoption = 'Quarter';             
        }else if(option == "Annually"){
            selectedoption = 'Year';            
        }else if(option == "Weekly"){
            selectedoption = 'Week';              
        }
        
       
        component.set("v.selectedoption", selectedoption);
        component.set("v.selectedMenu", "freightcharges");
        
        //component.set("v.selectedSubMenu", "freightcharges");
        
        var menuEvent = $A.get("e.c:eDealerSubMenu"); 
            
        menuEvent.setParams({ "menuName" : 'dashboardDemo',
                             "submenu" : "freightcharges" });
        menuEvent.fire();
        }
        catch(error){
            console('error'+error);
        }
    },
     
})