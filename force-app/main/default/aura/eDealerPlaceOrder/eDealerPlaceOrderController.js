({
    doInit : function(component, event, helper) {
        var dealerCode = component.get("v.dealerCode");
        var orderType = component.get("v.orderType");
        var d = new Date();
        
        var cartOrders = component.get("v.cartOrders");
        component.set("v.disablePO",cartOrders[0].isDBSDSI);
        //validate in cart parts
        helper.validateInCartParts(component, event, helper);
        //calculate total EST. Price
        helper.getTotalEstimatePrice(component);
        
        var todayDateStr = d.getFullYear() + '-' + ('0' + (d.getMonth()+1)).slice(-2)  + '-' + ('0' + d.getDate()).slice(-2);
        component.set("v.todayDate",todayDateStr);
        
        //show selected Location
        var userDetails = component.get("v.userDetail");
        if(!$A.util.isUndefinedOrNull(userDetails) && !$A.util.isUndefinedOrNull(userDetails.accessibleDealersLocation)){
            for(var i=0;i<userDetails.accessibleDealersLocation.length;i++){
                if($A.util.isEmpty(userDetails.accessibleDealersLocation[i].Sub_Code__c) && userDetails.accessibleDealersLocation[i].ASI_Dealer_Code__c == dealerCode){
                    component.set("v.dealerLocionWithCustomerName", (userDetails.accessibleDealersLocation[i].ASI_Dealer_Code__c + ' '+userDetails.accessibleDealersLocation[i].Customer_Name__c));
                    return;
                }
            }
        }     
    },
    
    // hide the place order modal
    closePlaceOrderModal : function(component, event, helper) {        
        helper.closePlaceOrderModalHelper(component, event, helper);           
    },
    
    placeConfirmOrder : function(component, event, helper) {  
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if($A.util.isUndefinedOrNull(component.get("v.selectedRecord")) || 
           $A.util.isUndefinedOrNull(component.get("v.selectedRecord").Id)){
            allValid = false;
            helper.showErrorToast(component, event, helper, 'Please select carrier');
        }
        
        if (allValid) {
            //first check or get PO Number
            var callGeneratePONumberAPI = component.get("v.disablePO");
            //call generate PO number Api
            if(callGeneratePONumberAPI){
                //get po number and call place order apex
                helper.getPlaceOrderNumber(component, event, helper);
            }else{
                //call place order apex (with user typed PO Number)
                helper.callPlaceOrder(component, event, helper);
            }
            
        }
        
    }
})