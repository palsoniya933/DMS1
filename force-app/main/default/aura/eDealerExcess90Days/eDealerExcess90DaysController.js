({
    doInit : function(component, event, helper) {
           component.set("v.displayLoading",true);

          
            // Access the new attributes
            var dealerCode = component.get("v.dealerCode");
            var division = component.get("v.division");
            var selectedLocation = component.get("v.selectedLocation");
            
            // Use these attributes as needed
            console.log("Dealer Code: " + dealerCode);
            console.log("Division: " + division);
            console.log("Selected Location: " + JSON.stringify(selectedLocation));   
           
           // Fetch inventory data
           helper.fetchInventoryData(component);
       },

       handleRefresh : function(component, event, helper) {
           helper.fetchInventoryData(component);
       }
})