({
    fetchCostOfSalesData : function(component, event, helper) {
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
        
        var dealerDivision = component.get("v.currentDealerDivision");
        var action = component.get("c.fetchCostOfSalesKPIData");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "division" : dealerDivision
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
                    console.log('resultData.response'+JSON.stringify(resultData.response));
                    component.set("v.dealerCostOfSalesData", resultData.response);
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

})