({
    doInit : function(component, event, helper) {
        component.set("v.selectoptions",[
            {label: 'monthly', value: $A.get("$Label.c.EDealer_filters_dates_M")},
            {label: 'yearly', value: $A.get("$Label.c.EDealer_filters_dates_Y")}
            ]);
        
        //set default 
        helper.defaultSelectedOption(component);        
        //Check data in cache or fetch data
        helper.fetchDaysOnHandDetail(component, event, helper);
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Turns');
        var index = event.target.name;
        component.set("v.selectedoption",index);
        helper.updateUI(component, event, helper);
    },
})