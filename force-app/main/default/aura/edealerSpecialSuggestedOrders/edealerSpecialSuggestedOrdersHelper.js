({
    
    getSelectedLocDealerCode : function(component) {
        var locDealerCode;
        //selected loc/dealer code
        var selLocationObj = component.get("v.selectedLocation");
        if(!$A.util.isUndefinedOrNull(selLocationObj)){
            locDealerCode = selLocationObj.selectedLoc;
        }
        
        return locDealerCode;
    },
    
    
    
    getSOFFileCreatedDate : function(component, event, helper) {        
        debugger;
        var selLocationObj = component.get("v.selectedLocation");
        var dealerLoc;
        
        //check selected  location/dealer code
        if(!$A.util.isUndefinedOrNull(selLocationObj) && !$A.util.isUndefinedOrNull(selLocationObj.selectedLoc)){
            dealerLoc = selLocationObj.selectedLoc;
        }
        
        if($A.util.isUndefinedOrNull(dealerLoc)){
            return;
        }
        
        var action = component.get("c.sofDealerLocAdditionDetails");
        action.setParams({
            "dealerCode" : dealerLoc,
            "isPromo" : true
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let sofInfo = response.getReturnValue();
                console.log('sofInfo 1 ==>> '+JSON.stringify(sofInfo));
                component.set("v.sofInfo", sofInfo);             
            }
            else if (state === "ERROR") {
                component.set("v.sofInfo", {}); 
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                        helper.showInfoToast(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
     
    showSucessToast : function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": msg,
            "type": "success"
        });
        toastEvent.fire();
    },
    
    showInfoToast : function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "",
            "message": msg,
            "type": "info",
            "mode":"sticky"
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(ErrorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": ErrorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
})