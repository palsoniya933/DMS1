({
    doInit : function(component, event, helper) {
        //set default total days
        component.set("v.totalDays", 0);
        component.set("v.daysOnHandDisplaydata", undefined);
        //set default 
        helper.defaultSelectedOption(component);        
        //Check data in cache or fetch data
        helper.checkDataInCacheOtherWiseFatchData(component, event, helper);
    },
    
    engineUpdateTileDetails : function(component, event, helper) {
        helper.updateTileUIData(component, event, helper);
        
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        var index = event.target.name;
        //var currentEl = event.currentTarget.name;
        component.set("v.selectedoption",index);
        
        helper.updateUI(component, event, helper);
        
    },
    
})