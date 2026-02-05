({
    //Getting multiple Location data
    fetchUnConfirmedOrdersMultipleData : function(component, event, helper) {
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

        var action = component.get("c.getUnConfirmedOrders");
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
               console.log('response >> of Unconfirmed order'+ JSON.stringify(response.getReturnValue()));

                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.unConfirmOrdersData", resultData.response);
                    
                    //update U.I.
                    helper.updateUI(component, event, helper);
                    
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
    
    updateUI : function(component, event, helper) {
        var unConfirmOrdersData =  component.get("v.unConfirmOrdersData");
          var selectedoption = component.get("v.selectedoption");
        var selectedType = component.get("v.selectedUnConfirmedOrder");
        var unConfirmOrders = 0;
       if(!$A.util.isUndefinedOrNull(unConfirmOrdersData) && unConfirmOrdersData.length > 0 ){
          for(var i=0;i<unConfirmOrdersData.length;i++){
                if(selectedoption == 'Monthly' && unConfirmOrdersData[i].frequency == 'Monthly'){
                    unConfirmOrders = helper.fetchDisplayValue(unConfirmOrdersData[i], selectedType);
                }else if(selectedoption == 'Quarterly' && unConfirmOrdersData[i].frequency == 'Quarterly'){
                    unConfirmOrders = helper.fetchDisplayValue(unConfirmOrdersData[i], selectedType);
                }else if(selectedoption == 'Weekly' && unConfirmOrdersData[i].frequency == 'weekly'){
                    unConfirmOrders = helper.fetchDisplayValue(unConfirmOrdersData[i], selectedType);
                }else if(selectedoption == 'All' && unConfirmOrdersData[i].frequency == 'All'){
                    unConfirmOrders = helper.fetchDisplayValue(unConfirmOrdersData[i], selectedType);
                }            }
         
        }         
        component.set("v.unConfirmOrders", unConfirmOrders);        
    },
    
    fetchDisplayValue : function(currentRec, selectedType) {
        if(selectedType == 'All'){
            return currentRec.total;
        }
        else if(selectedType == 'Truck'){
            if(currentRec.truckdownorders == undefined){
                return 0;
            }else{
                return currentRec.truckdownorders; 
            }
        } else if(selectedType == 'Emergency'){
                if(currentRec.emergencyorders == undefined){
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