({ 
    //Getting multiple Location data
    fetchPendingOrdersMultipleData : function(component, event, helper) {
        //selected loc/dealer code
        var listDealerLoc = component.get("v.listDealerLoc");
        var dealerLoc = component.get("v.dealerLoc");
        var selectedType = component.get("v.selectedPendingOrder");

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

        var action = component.get("c.getPendingOrders");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "orderType": selectedType
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);           
            var state = response.getState();
            console.log('Status of data '+ state);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                console.log('response >> of pending order'+ JSON.stringify(response.getReturnValue()));
                
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.pendingOrdersData", resultData.response);
                    console.log('response >> of pending order'+JSON.stringify(resultData.response));
                    
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
        var pendingOrdersData =  component.get("v.pendingOrdersData");     
        var selectedoption = component.get("v.selectedoption");
        var selectedType = component.get("v.selectedPendingOrder");
        var pendingOrders = 0;
        if(!$A.util.isUndefinedOrNull(pendingOrdersData) && pendingOrdersData.length > 0 ){
           for(var i=0;i<pendingOrdersData.length;i++){
               if(selectedoption == 'Monthly' && pendingOrdersData[i].frequency == 'Monthly'){
                   pendingOrders = helper.fetchDisplayValue(pendingOrdersData[i], selectedType);
                }else if(selectedoption == 'Quarterly' && pendingOrdersData[i].frequency == 'Quarterly'){
                    pendingOrders = helper.fetchDisplayValue(pendingOrdersData[i], selectedType);
               }else if(selectedoption == 'Weekly' && pendingOrdersData[i].frequency == 'weekly'){
                  pendingOrders = helper.fetchDisplayValue(pendingOrdersData[i], selectedType);
               }else if(selectedoption == 'All' && pendingOrdersData[i].frequency == 'All'){
                   pendingOrders = helper.fetchDisplayValue(pendingOrdersData[i], selectedType);
                }            }
        }        
        component.set("v.pendingOrders", pendingOrders);        
    },
    
    fetchDisplayValue : function(currentRec, selectedType) {
        if(selectedType == 'All'){
            return currentRec.ordercount;
        }else if(selectedType == 'Truck'){
            if(currentRec.truckdownorders == undefined){
                return 0;
            }else{
                return currentRec.truckdownorders; 
            }
        }else if(selectedType == 'Emergency'){
            if(currentRec.emergencyorders ==undefined ){
                return 0;
            }else{
                return currentRec.emergencyorders;
            }
        }else if(selectedType == 'Stock') {
            if(currentRec.stockorders == undefined){
                return 0;
            }else{
                return currentRec.stockorders;
            }
        }else{
            return 0;//default
        }
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