({
	fetchEmergencyOrderDetail : function(component, event, helper) {
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
        component.set("v.emergencyLoading", true);
        
        var action = component.get("c.fetchAWSEmergencyKPIData"); 
        action.setParams({ "dealerCodes" : listDealerLoc });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.emergencyLoading", false);            
            var state = response.getState();
            if (state === "SUCCESS") { 
                var orderDetail = response.getReturnValue();
                component.set("v.emergencyOrder", orderDetail);
                
                //Default Weekly
                if(!$A.util.isUndefinedOrNull(orderDetail)
                  && !$A.util.isUndefinedOrNull(orderDetail.weekly_order)
                  && !$A.util.isUndefinedOrNull(orderDetail.weekly_order.percent_emr_order)){
                    var emergencyOrderPercentages = orderDetail.weekly_order.percent_emr_order;
                    // if the percentage is null / blank then set the percentage to 0
                    if($A.util.isUndefinedOrNull(emergencyOrderPercentages)){
                        emergencyOrderPercentages = 0;
                    }
                    
                    //Set Emergency Order percentages
                    component.set("v.percentages", Number.parseFloat(emergencyOrderPercentages).toFixed(2));
                }
            }
            else {
                console.log("Failed with state: " + state);
            }            
        });
        $A.enqueueAction(action);
		
	},
    
    defaultSelectedOption : function(component) {
        component.set("v.selectedoption", "weekly");
        component.set("v.percentages", 0.00);
    },
      
})