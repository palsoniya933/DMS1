({
    fetchInventoryData: function (component) {
        component.set("v.displayLoading", true);
        var action = component.get("c.getInventoryData");
        var dealerCodes = component.get("v.selectedLocation");
        var category = "totalinventory";
        
        action.setParams({ dealerCodes: dealerCodes, category: category });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            console.log("state >>> Checking state :: >>>>" + state);
            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                console.log("data >>> Checking data :: >>>>" + JSON.stringify(data));
                
                // Set total inventory dynamically
                component.set("v.totalInventory", {
                    totaldesc: "Total",
                    category: category,
                    inventory: data.total ? data.total.total_inventory : 0,
                    percentage: (data.total ? data.total.total_percentage : 0) + "%",
                    pdc: data.total ? data.total.total_pdc : 0,
                    dsp: data.total ? data.total.total_dsp : 0,
                    mdiSuggested:data.total ? data.total.total_inventory_sugg : 0,
                    mdiSuggestedPercentage: (data.total ? data.total.total_inventory_sugg_percentage : 0) + "%",
                    mdiSuggestedPDC: data.total ? data.total.total_pdc_sugg : 0,
                    mdiSuggestedDSP: data.total ? data.total.total_dsp_sugg : 0,
                    notMdiSuggested: data.total ? data.total.total_inventory_not_sugg : 0,
                    notSuggestedPercentage: (data.total ? data.total.total_inventory_not_sugg_percentage : 0) + "%",
                    notSuggestedPDC: data.total ? data.total.total_pdc_not_sugg : 0,
                    notSuggestedDSP:data.total ? data.total.total_dsp_not_sugg : 0
                    
                });
                console.log("Total Inventory " + JSON.stringify(component.get("v.totalInventory")));
                
                // Set dealer-specific inventory dynamically
                var dealers = data.dealers ? data.dealers.map(function (dealer) {
                    return {
                        dealerCode: dealer.loc,
                        inventory:  dealer.total_inventory,
                        percentage: dealer.total_percentage + "%",
                        pdc:  dealer.total_pdc,
                        dsp:  dealer.total_dsp,
                        mdiSuggested: dealer ? dealer.total_inventory_sugg : 0,
                        mdiSuggestedPercentage: (dealer ? dealer.total_inventory_sugg_percentage : 0) + "%",
                        mdiSuggestedPDC: dealer ? dealer.total_pdc_sugg : 0,
                        mdiSuggestedDSP: dealer ? dealer.total_dsp_sugg : 0,
                        notMdiSuggested: dealer ? dealer.total_inventory_not_sugg : 0,
                        notSuggestedPercentage: (dealer ? dealer.total_inventory_not_sugg_percentage : 0) + "%",
                        notSuggestedPDC: dealer ? dealer.total_pdc_not_sugg : 0,
                        notSuggestedDSP: dealer ? dealer.total_dsp_not_sugg : 0
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
    }
})