({
	calculateSelectedRowsHelper  : function(component, event, helper) {
        var invData = component.get("v.invData");
        var selectedRows = 0;
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked == true){
                selectedRows++;
            }
        }
        component.set("v.totalOrderSelected", selectedRows);
        
        //Dual Channel Parts Validation
        helper.SelectedDualChannelPartsValidation(component, event, helper);
        
    },
    
    validateSelectedOrdersQTY : function(component) {
        var invData = component.get("v.invData");
        var isValidate = true;
        
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked
               && ($A.util.isUndefinedOrNull(invData[i].qtyForOrder)
                   || $A.util.isEmpty(invData[i].qtyForOrder)
                   || invData[i].qtyForOrder == 0) ){
                isValidate = false;
            }
        }
        
        return isValidate;
        
    },
    
    showErrorToast : function(component, event, helper, ErrorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": ErrorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
    
    
    //Dual Channle Part Validation (based on selected Price)
    SelectedDualChannelPartsValidation : function(component, event, helper) {
        var invData = component.get("v.invData");
        var isDSPPrice = false;
        for(var i=0;i<invData.length;i++){
            if(invData[i].Part_category_Type == 'DUAL' && invData[i].checked == true){
                if(invData[i].DualPartSelectedPriceType == 'DSP'){
                    isDSPPrice = true;
                }
            }
        }
        
        /*//If user selected the dsp price parts 
        //Then user can not order Parts as EM.
        //so Disable the EM Order Button 
        if(isDSPPrice == true){
            component.set("v.disableEMOrderButton", true);
        }else{
            component.set("v.disableEMOrderButton", false);
        }*/
        
    },
    
    getSpecialCommentInDetail : function(component, event, helper, partNum, specialComment) { 
        component.set("v.showCommentBox",true);
        component.set("v.displayLoading", true);
        //debugger;
        var dealerLoc = component.get("v.dealerCode");
        var division = component.get("v.division");
        
        
        
        var action = component.get("c.getSpecialCommentInDetail");
        action.setParams({
            "dealerCode" : dealerLoc,
            "dealerDivision" : division,
            "partNumber" : partNum,
            "sofComment" : specialComment
        });
        
        action.setCallback(this, function(response) {
             //debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                let commentDetailObj = response.getReturnValue();
             //  console.log("commentDetailObj ==>> "+JSON.stringify(commentDetailObj));
                if(!$A.util.isUndefinedOrNull(commentDetailObj) 
                   && !$A.util.isUndefinedOrNull(commentDetailObj.response)
                  ){
                    component.set("v.commentDetailsList", commentDetailObj.response);
                    
                }
                             
            }
            else if (state === "ERROR") {
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
            // hide spinner
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
    },
})