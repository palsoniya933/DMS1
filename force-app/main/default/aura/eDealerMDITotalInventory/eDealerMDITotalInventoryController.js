({
       doInit : function(component, event, helper) {
           // Set the current date in the format you prefer
           var currentDate = new Date().toLocaleString(); // Adjust formatting as needed
           component.set("v.currentDate", currentDate);
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
           //helper.fetchDummyData(component);
       },

       handleRefresh : function(component, event, helper) {
           helper.fetchInventoryData(component);
           //helper.fetchDummyData(component);   
       }
   })