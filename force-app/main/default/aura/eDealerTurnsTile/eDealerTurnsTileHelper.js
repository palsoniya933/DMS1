({
    updateUI : function(component, event, helper) {
        var turnsData = component.get("v.turnsData");
        var selectedOption = component.get("v.selectedoption");
        var total = 0;
        
        if(!$A.util.isUndefinedOrNull(turnsData)){
            if( selectedOption == 'monthly' && !$A.util.isUndefinedOrNull(turnsData.monthly_turns)){
                total = turnsData.monthly_turns;
            }
            if( selectedOption == 'yearly' && !$A.util.isUndefinedOrNull(turnsData.yearly_turns)){
                total = turnsData.yearly_turns;
            }
        }
        component.set("v.totalDays", total);        
    },
    
	fetchDaysOnHandDetail : function(component, event, helper) {
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
        
        var action = component.get("c.fetchAWSTurnsData");
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "division" : component.get("v.currentDealerDivision")             
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
                }else if(!$A.util.isEmpty(resultData.response) && resultData.response.length > 0){
                    component.set("v.turnsData", resultData.response[0]);
                }
                //update U.I.
                helper.updateUI(component, event, helper);
            }
            else {
                console.log("Failed with state: " + state);
            }            
        });
        $A.enqueueAction(action);
	},
    
    defaultSelectedOption : function(component) {
        component.set("v.turnsData", undefined);
        component.set("v.selectedoption", "monthly");
        component.set("v.totalDays", 0);
    },
})