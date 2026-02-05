({    
    //Getting multiple Location data
    fetchActiveOrdersMultipleData : function(component, event, helper) {
        //selected loc/dealer code
        var listDealerLoc = component.get("v.listDealerLoc");
        var dealerLoc = component.get("v.dealerLoc");
        var selectedoption = component.get("v.selectedoption");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc)){
            listDealerLoc = [];
            if(!$A.util.isUndefinedOrNull(dealerLoc)){
                listDealerLoc.push(dealerLoc);
                //   component.set("v.listDealerLoc",listDealerLoc);
            }else{
                return;
            }
        }
        //show spinner
        component.set("v.displayLoading", true);
       
        var action = component.get("c.getActiveOrders");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "orderType": selectedoption
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);           
            var state = response.getState();
            console.log('Status of data '+ state);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                console.log('response >> of active order'+ JSON.stringify(response.getReturnValue()));
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.activeOrdersData", resultData.response);
                    console.log('response >> of active order'+JSON.stringify(resultData.response));
                    
                    
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
        var activeOrdersData =  component.get("v.activeOrdersData");
        var selectedoption = component.get("v.selectedoption");
        var selectedType = component.get("v.selectedActiveOrder");
        var activeOrders = 0;
        if(!$A.util.isUndefinedOrNull(activeOrdersData) && activeOrdersData.length > 0 ){
          for(var i=0;i<activeOrdersData.length;i++){
                if(selectedoption == 'Monthly' && activeOrdersData[i].frequency == 'Monthly'){
                    activeOrders = helper.fetchDisplayValue(activeOrdersData[i], selectedType);
                }else if(selectedoption == 'Quarterly' && activeOrdersData[i].frequency == 'Quarterly'){
                    activeOrders = helper.fetchDisplayValue(activeOrdersData[i], selectedType);
                }else if(selectedoption == 'Weekly' && activeOrdersData[i].frequency == 'weekly'){
                    activeOrders = helper.fetchDisplayValue(activeOrdersData[i], selectedType);
                }else if(selectedoption == 'All' && activeOrdersData[i].frequency == 'All'){
                    activeOrders = helper.fetchDisplayValue(activeOrdersData[i], selectedType);
                }            }
         
        }        
        component.set("v.activeOrders", activeOrders);        
    },
    
    fetchDisplayValue : function(currentRec, selectedType) {
        if(selectedType == 'All'){
            return currentRec.total;
        }else if(selectedType == 'Truck'){
            if(currentRec.td == undefined){
                return 0;
            }else{
                return currentRec.td; 
            }
        }else if(selectedType == 'Emergency'){
            if(currentRec.em ==undefined ){
                return 0;
            }else{
                return currentRec.em;
            }
        }else if(selectedType == 'Stock') {
            if(currentRec.st == undefined){
                return 0;
            }else{
                return currentRec.st;
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