({    
    fetchTotalInventoryData : function(component, event, helper) {
        //list of dealer location
        var listDealerLoc;
        //selected loc/dealer code
        var selLocationObj = component.get("v.selectedLocation");
        var dealerLoc = component.get("v.dealerLoc");
        if(!$A.util.isUndefinedOrNull(selLocationObj)){
            listDealerLoc = selLocationObj.listSelectedLoc;
        }
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc) || $A.util.isEmpty(listDealerLoc)){
            listDealerLoc = [];
            if(!$A.util.isUndefinedOrNull(dealerLoc)){
                listDealerLoc.push(dealerLoc);
            }else{
                return;
            }
        }
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.fetchDealerTotalInventoryKPIData");
        action.setParams({
            "dealerCodes" : listDealerLoc
           
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);           
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }
                else if(!$A.util.isUndefinedOrNull(resultData.response) 
                        && resultData.response.length > 0){
                    
                    component.set("v.totalInventoryData", resultData.response);
                    helper.updateTileUIData(component, event, helper);
                    
                    //Update cache
                    //helper.updateCostOfSalesCacheDetails(component, event, helper);
                }else{
                    component.set("v.totalInventoryData",'');
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    /*updateCostOfSalesCacheDetails : function(component, event, helper) {
        let cacheMap = component.get("v.totalInventoryDataMapCache");
        if($A.util.isUndefinedOrNull(cacheMap)){
            cacheMap = new Map();        }
        
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        var order = component.get("v.totalInventoryData");
        
        cacheMap.set(locCode, order);
        
        //update cache for manual Lockdown
        component.set("v.totalInventoryDataMapCache", cacheMap);
    },*/
    
    /* updateTileUIData : function(component, event, helper) {
        // var selectedOption = component.get("v.selectedoption");
        var isEngine = component.get("v.isEngine");
        var totalInventoryData = component.get("v.totalInventoryData");
        var uiData;
        
        if(!$A.util.isUndefinedOrNull(totalInventoryData) 
           && totalInventoryData.length > 0){
            for(var i=0;i<totalInventoryData.length;i++){
                if(isEngine == false
                   && totalInventoryData[i].parts_type == 'NON ENGINE'){
                    uiData = totalInventoryData[i]; 
                }
                if(isEngine == true
                   && totalInventoryData[i].parts_type == 'ENGINE'){
                    uiData = totalInventoryData[i];  
                }
            }
        }        
        component.set("v.AllInventoryData", uiData); 
        
    },*/
    updateTileUIData: function(component, event, helper) {
        var totalInventoryData = component.get("v.totalInventoryData");
        var uiData = {};
        
        if(!$A.util.isUndefinedOrNull(totalInventoryData) 
           && totalInventoryData.length > 0)
            totalInventoryData.forEach(function(item) {
              
                  if(item.report === 'Total_Inventory')
                    {
                        uiData.TotalInventory=item.total;
                    }
              else if (item.report === 'Excess_90_Days') {
                    uiData.Excess90Days = item.total;
                } 
                    else if (item.report === 'Total_Healthy_Inventory') {
                        uiData.HealthyInventory = item.total;
                    } 
                        else if (item.report === 'No_Move') {
                            uiData.NoMove = item.total;
                        }
            });
        
        component.set("v.AllInventoryData", uiData);
    },
    
})