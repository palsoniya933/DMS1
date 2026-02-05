({
      //Getting multiple Location data
    fetchTotalPartsOrdersMultipleData : function(component, event, helper) {
        //selected loc/dealer code
        var listDealerLoc = component.get("v.listDealerLoc");
        var dealerLoc = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc)){
            listDealerLoc = [];
            if(!$A.util.isUndefinedOrNull(dealerLoc)){
                listDealerLoc.push(dealerLoc);
            }else{
                return;
            }
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        var selectedOrder = component.get("v.selectedOrder");

        var action = component.get("c.getTotalPartsOrderes");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "orderStatus": selectedOrder,
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
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    
                    // Replace the frequency "Two Years" with "All" using a simple for loop
                    for (let i = 0; i < resultData.response.length; i++) {
                        if (resultData.response[i].frequency === "Two Years" || resultData.response[i].frequency === "All") {
                            resultData.response[i].frequency = "All";
                        }
                    }
                    
                    component.set("v.totalPartsData", resultData.response);
                    
                    //update U.I.
                    helper.updateUI(component, event, helper);
                    
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
		
	},
    
    updateUI : function(component, event, helper) {
        var totalPartsData =  component.get("v.totalPartsData");
        var selectedType = component.get("v.selectedOrder");
        var selectedoption = component.get("v.selectedoption"); 
        console.log('selectedoption--'+selectedoption);
        console.log('totalPartsData--'+JSON.stringify(totalPartsData));
        var activeOrders = [];
        if(!$A.util.isUndefinedOrNull(totalPartsData) && totalPartsData.length > 0 ){
            for(var i=0;i<totalPartsData.length;i++){
                if(selectedoption == totalPartsData[i].frequency){                    
                    activeOrders.push(totalPartsData[i]);
                }
            }
        }
        
        component.set("v.activeOrders", activeOrders);
        
        var totalParts = 0;
        var totalPartsValue = 0;
        var totalPartsPer = 0;
        var totalPartsValuePer = 0;
        
        for(var i=0; i < activeOrders.length; i++){
            if(activeOrders[i].part_count)
            	totalParts += activeOrders[i].part_count;            
            
            if(activeOrders[i].doller_value)
            	totalPartsValue += activeOrders[i].doller_value;
            
            if(activeOrders[i].part_count_per)
            	totalPartsPer += activeOrders[i].part_count_per;
            
            if(activeOrders[i].doller_value_per)
            	totalPartsValuePer += activeOrders[i].doller_value_per;
        }
        
        totalParts = totalParts.toFixed(2);
        totalPartsValue = totalPartsValue.toFixed(2);
        totalPartsPer = totalPartsPer.toFixed(2);
        totalPartsValuePer = totalPartsValuePer.toFixed(2);        
        
        component.set("v.parts", totalParts);
        component.set("v.partsValue", totalPartsValue);
        component.set("v.partsPer", totalPartsPer);
        component.set("v.partsValuePer", totalPartsValuePer);
        
    },
    getfilters: function(component, event, helper) {
        var action2 = component.get("c.getFilters");
        
        action2.setCallback(this, function(response2) {
            var resultData = response2.getReturnValue()
            console.log('filters::::::::::::::::::::::::::'+resultData);
            console.log(JSON.stringify(resultData));
            component.set("v.selectoptions", resultData);
        });
        $A.enqueueAction(action2);
    }
})