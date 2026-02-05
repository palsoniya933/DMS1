({
    //Getting multiple Location data
    fetchFreightChargeMultipleData : function(component, event, helper) {
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

        var action = component.get("c.getFreightChargeDetails");
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
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.freightChargesData", resultData.response);
                    console.log('resultData.response:'+JSON.stringify(resultData.response));
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
        var freightChargesData =  component.get("v.freightChargesData");
        var selectedType = component.get("v.selectedFreightChargesType");
        var selectedoption = component.get("v.selectedoption");
        var freightCharges = 0;
        if(!$A.util.isUndefinedOrNull(freightChargesData) && freightChargesData.length > 0 ){
            for(var i=0;i<freightChargesData.length;i++){
                if(selectedoption == 'Daily' && freightChargesData[i].frequency == 'Daily'){                    
                    freightCharges = helper.fetchDisplayValue(freightChargesData[i], selectedType);
                }else if(selectedoption == 'Weekly' && freightChargesData[i].frequency == 'Weekly'){
                    freightCharges = helper.fetchDisplayValue(freightChargesData[i], selectedType);
                }else if(selectedoption == 'Monthly' && freightChargesData[i].frequency == 'Monthly'){
                    freightCharges = helper.fetchDisplayValue(freightChargesData[i], selectedType);
                }else if(selectedoption == 'Quarterly' && freightChargesData[i].frequency == 'Quarterly'){
                    freightCharges = helper.fetchDisplayValue(freightChargesData[i], selectedType);
                }else if(selectedoption == 'Annually' && freightChargesData[i].frequency == 'Annually'){
                    freightCharges = helper.fetchDisplayValue(freightChargesData[i], selectedType);
                }
            }
        }
        
        component.set("v.freightCharges", freightCharges);
        
    },
    
    fetchDisplayValue : function(currentRec, selectedType) {
        if(selectedType == 'all'){
            return currentRec.all;
        }
        else if(selectedType == 'truck'){
            return currentRec.td_freightcharges;
        }
            else if(selectedType == 'emergency') {
                return currentRec.em_freightcharges;
            }
                else if(selectedType == 'DSP') {
                    return currentRec.dsp_freightcharges;
                }
                    else if(selectedType == 'monthly') {
                        return currentRec.monthly_returns;
                    }
                        else if(selectedType == 'other') {
                            return currentRec.other_freightcharges;
                        }
                            else
                            {
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