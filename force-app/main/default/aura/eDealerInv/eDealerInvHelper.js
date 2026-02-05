({
    checkIsPromoAvailable : function(component, event, helper) {
        component.set("v.displayLoading", true);
        var selLocationObj = component.get("v.selectedLocation");
        var dealerLoc;
        
        //check selected  location/dealer code
        if(!$A.util.isUndefinedOrNull(selLocationObj) && !$A.util.isUndefinedOrNull(selLocationObj.selectedLoc)){
            dealerLoc = selLocationObj.selectedLoc;
        }
        
        if($A.util.isUndefinedOrNull(dealerLoc)){
            return;
        }
        
        
        var action = component.get("c.IsPromoAvailableForDealerLocation");
        action.setParams({
            "dealerCode" : dealerLoc
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let isPromo = response.getReturnValue();
                component.set("v.isSOFPromoAvailable", isPromo);
                //hide spinner
                component.set("v.displayLoading", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                        helper.showErrorToast(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                //hide spinner
                component.set("v.displayLoading", false);
            }            
            
            
        });
        $A.enqueueAction(action);        
    },
    
    
    calltoGenerateSOFonDemand : function(component, event, helper, isPromoSOF) {
        component.set("v.displayLoading", true);
        var selLocationObj = component.get("v.selectedLocation");
        var dealerLoc;
        
        //check selected  location/dealer code
        if(!$A.util.isUndefinedOrNull(selLocationObj) && !$A.util.isUndefinedOrNull(selLocationObj.selectedLoc)){
            dealerLoc = selLocationObj.selectedLoc;
        }
        
        if($A.util.isUndefinedOrNull(dealerLoc)){
            return;
        }
        
        var action = component.get("c.generateSofonDemand");
        action.setParams({
            "dealerCode" : dealerLoc,
            "dealerDivision" : component.get("v.userDetail.division"),
            "isPromo" : isPromoSOF
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let sofCount = response.getReturnValue();
                if(sofCount > 0){
                    helper.showSucessToast('SOF generated successfully.');
                    let isSOFPromoAvailable = component.get('v.isSOFPromoAvailable');
                    if(isSOFPromoAvailable != true && isPromoSOF == true){
                        component.set("v.isSOFPromoAvailable", false);
                        helper.checkIsPromoAvailable(component, event, helper);
                    }
                    helper.updateCart(component, event, helper);
                }else{
                    helper.showInfoToast('SOF data not available to display, please try again after sometime. If the problem persists, please contact your MDI Analyst"');
                }
                //hide spinner
                component.set("v.displayLoading", false);
                
                
                //refresh the component details
                var selectedtabName = component.get("v.selecetdTabID");
                if(selectedtabName == "sofPartsTab"){
                    let sofCmp = component.find('sofPartsCmp');        
                    sofCmp.refreshSOFTabData(); 
                }
                if(selectedtabName == "sofSpecialPartsTab"){
                    //refresh the component details
                    let sofCmp = component.find('sofSpecialPartsCmp');        
                    sofCmp.refreshSOFTabData(); 
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                        helper.showErrorToast(errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                }
                //hide spinner
                component.set("v.displayLoading", false);
                
            }            
            
            //Disable the SOF button
            component.set("v.isEnableSOFGenerateBtn", false);
            component.set("v.isEnableSOFPromoGenerateBtn", false);
        });
        $A.enqueueAction(action);
    },
    
    
    updateCart : function(component, event, helper){
        var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
        menuEvent.fire();
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