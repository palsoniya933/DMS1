({
    fetchHealthInventoryData: function (component) {
        component.set("v.displayLoading", true);
        var action = component.get("c.getHealthInventoryData");
        var dealerCodes = component.get("v.selectedLocation");
        var category = "healthyinventory";
        
        action.setParams({ dealerCodes: dealerCodes, category: category });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            console.log("state >>> Checking state :: >>>>" + state);
            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                console.log("data >>> Checking data :: >>>>" + JSON.stringify(data));
                
                // Set total inventory dynamically
                component.set("v.healthInventory", {
                    totaldesc: "Total",
                    category: category,
                    inventory:data.total ? data.total.total_inventory : 0,
                    percentage: (data.total ? data.total.total_percentage : 0) + "%",
                    pdc: data.total ? data.total.total_pdc : 0,
                    dsp: data.total ? data.total.total_dsp : 0
                    
                });
                console.log("Health Inventory " + JSON.stringify(component.get("v.healthInventory")));
                
                // Set dealer-specific inventory dynamically
                var dealers = data.dealers ? data.dealers.map(function (dealer) {
                    return {
                        dealerCode: dealer.loc,
                        inventory:  dealer.total_inventory,
                        percentage: dealer.total_percentage + "%",
                        pdc:  dealer.total_pdc,
                        dsp:  dealer.total_dsp
                    };
                }) : [];
                component.set("v.dealerInventory", dealers);
                component.set("v.displayLoading", false);
            } else if (state === "ERROR") {
                component.set("v.displayLoading", false);
                var errors = response.getError();
                if (errors && errors.length > 0) {
                    console.error("Error fetching inventory data: " + errors[0].message);
                } else {
                    console.error("Unknown error occurred while fetching inventory data.");
                }
            } else {
                console.error("Unexpected state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    fetchDummyData : function(component) {
        // Dummy data for health inventory
        var healthInventory = {
            inventory: 1000,
            percentage: 50,
            pdc: 200,
            dsp: 300
        };

        // Dummy data for dealer inventory
        var dealerInventory = [
            {
                dealerCode: "D001",
                inventory: 400,
                percentage: 50,
                pdc: 50,
                dsp: 20
            },
            {
                dealerCode: "D002",
                inventory: 600,
                percentage: 50,
                pdc: 50,
                dsp: 20
            }
        ];

        // Set the component attributes with the dummy data
        component.set("v.healthInventory", healthInventory);
        component.set("v.dealerInventory", dealerInventory);
        
        // Set the current date
        var currentDate = new Date().toLocaleDateString(); // Format as needed
        component.set("v.currentDate", currentDate);
    }     
})