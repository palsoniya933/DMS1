({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        component.set("v.selectoptions",[
            {label: 'weekly', value: $A.get("$Label.c.EDealer_filters_dates_W")},
            {label: 'monthly', value: $A.get("$Label.c.EDealer_filters_dates_M")},
            {label: 'quaterly', value: $A.get("$Label.c.EDealer_filters_dates_Q")},
            {label: 'yearly', value: $A.get("$Label.c.EDealer_filters_dates_1Y")},
            {label: 'twoyear', value: $A.get("$Label.c.EDealer_filters_dates_All")}]);
        

        //set default 
        helper.defaultSelectedOption(component);        
        component.set("v.emergencyOrder",undefined);
        //get emergency details
        helper.fetchEmergencyOrderDetail(component, event, helper);
    },
    
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Emergency Lines');
        var index = event.target.name;
        //var currentEl = event.currentTarget.name;
        var orderDetail = component.get("v.emergencyOrder");
        component.set("v.selectedoption",index);
        var emergencyOrderPercentages;
        if(!$A.util.isUndefinedOrNull(orderDetail)){
            if(index == 'daily'){
                emergencyOrderPercentages = orderDetail.daily_order.percent_emr_order;
            }else if(index == 'weekly'){
                emergencyOrderPercentages = orderDetail.weekly_order.percent_emr_order;
            }else if(index == 'monthly'){
                emergencyOrderPercentages = orderDetail.monthly_order.percent_emr_order;
            }else if(index == 'quaterly'){
                emergencyOrderPercentages = orderDetail.quaterly_order.percent_emr_order;
            }else if(index == 'yearly'){
                emergencyOrderPercentages = orderDetail.yearly_order.percent_emr_order;
            }else if(index == 'twoyear'){
                emergencyOrderPercentages = orderDetail.two_yearly_order.percent_emr_order;
            }
        }
        
        // if the percentage is null / blank then set the percentage to 0
        if($A.util.isUndefinedOrNull(emergencyOrderPercentages)){
            emergencyOrderPercentages = 0;
        }
        
        //Set Emergency Order percentages
        component.set("v.percentages", Number.parseFloat(emergencyOrderPercentages).toFixed(2));
        
    },
    
    //20-10-21 
    handleOpenInNewWindow : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Emergency Lines');
        var option = component.get("v.selectedoption");
        //list of dealer location
        var listDealerLoc;
        //selected loc/dealer code
        var selLocationObj = component.get("v.selectedLocation");
        if(!$A.util.isUndefinedOrNull(selLocationObj)){
            listDealerLoc = selLocationObj.listSelectedLoc;
        }
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc) || $A.util.isEmpty(listDealerLoc)){
            return;
        }
        
        var dealerLoc = listDealerLoc[0];
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderlisting=emergencyorderlisting&option="+option+"&loc="+dealerLoc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'Emergency Lines');
        var selectedoption='';
        var option = component.get("v.selectedoption");
        if(option == "weekly"){
            selectedoption = 'Week';            
        }else if(option == "monthly"){
            selectedoption = 'Month';    
        }else if(option == "quaterly"){
            selectedoption = 'Quarter';             
        }else if(option == "yearly"){
            selectedoption = 'Year';            
        }else if(option == "twoyear"){
            selectedoption = 'all';              
        }
        
        var menuClickEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuClickEvent.setParams({ "selectedoption" : selectedoption,
                                   "menuName" : 'emergencyorderlisting'
        });
        menuClickEvent.fire();
        
        component.set("v.selectedMenu", "emergencyorderlisting");                
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'emergencyorderlisting',
                            "submenu" : null});
        menuEvent.fire();
    }
    
})