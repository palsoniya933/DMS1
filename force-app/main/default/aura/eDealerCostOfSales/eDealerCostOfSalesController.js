({
    // this method will be called onload of the component
   doInit : function(component, event, helper) {
       component.set("v.selectoptions",[
           {label: 'Weekly', value: $A.get("$Label.c.EDealer_filters_dates_W")},
           {label: 'Monthly', value: $A.get("$Label.c.EDealer_filters_dates_M")},
           {label: 'Quarterly', value: $A.get("$Label.c.EDealer_filters_dates_Q")},
           {label: 'Annually', value: $A.get("$Label.c.EDealer_filters_dates_1Y")}]);
       
	   component.set("v.dealerCostOfSalesData", undefined);
       //Set default option
       component.set("v.selectedoption", "Weekly");
      
        //Check data in cache or fetch data
        helper.fetchCostOfSalesData(component, event, helper);
	},
    
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Cost Of Sales');
        var index = event.target.name;
        console.log('index'+index);
        component.set("v.selectedoption",index);
    },
     
})