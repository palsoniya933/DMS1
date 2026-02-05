({
    validateInCartParts : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.validateCartParts");
        action.setParams({
            "cartOrders" : JSON.stringify(component.get("v.cartOrders"))          
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } 
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
                
                //Close place order Modal
                helper.closePlaceOrderModalHelper(component, event, helper);  
            }
            
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    getTotalEstimatePrice : function(component) {
        var cartOrders = component.get("v.cartOrders");
        var totalEstPrice=0.00;
        for(var i=0;i<cartOrders.length;i++){
            if(cartOrders[i].cartOrderType == 'DSP' 
               && !$A.util.isUndefinedOrNull(cartOrders[i].PriceDetail)
               && !$A.util.isUndefinedOrNull(cartOrders[i].PriceDetail.DspFinalNet)
               && !$A.util.isEmpty(cartOrders[i].PriceDetail.DspFinalNet)){
                totalEstPrice = totalEstPrice + (cartOrders[i].PriceDetail.DspFinalNet * cartOrders[i].qtyForOrder);
            }
            else if(cartOrders[i].cartOrderType == 'PDC' 
               && !$A.util.isUndefinedOrNull(cartOrders[i].PriceDetail)
               && !$A.util.isUndefinedOrNull(cartOrders[i].PriceDetail.WhsFinalNet)
               && !$A.util.isEmpty(cartOrders[i].PriceDetail.WhsFinalNet)){
                totalEstPrice = totalEstPrice + (cartOrders[i].PriceDetail.WhsFinalNet * cartOrders[i].qtyForOrder);
            }
        }
        component.set("v.totalEstPrice", totalEstPrice.toFixed(2));
    },
   
    getPlaceOrderNumber : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.fetchPlaceOrderNumber");
        action.setParams({
            "dealerCode" : component.get("v.dealerCode")           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //hide Spinner
                component.set("v.displayLoading",false);
                var resultPO = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(resultPO)){
                    if($A.util.isUndefinedOrNull(resultPO.purchaseOrderNumber)){
                        //Show error message
                        helper.showErrorToast(component, event, helper, resultPO.error);
                        //hide Spinner
                        component.set("v.displayLoading",false);
                    }else{
                        //save po number
                        component.set("v.po", resultPO.purchaseOrderNumber);
                        // and call place order (apex)
                        helper.callPlaceOrder(component, event, helper);
                    }
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
                //hide Spinner
            component.set("v.displayLoading",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    
	callPlaceOrder : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        
        var poNum = component.get("v.po");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(poNum)){
            return;
        }
        
        var action = component.get("c.placeOrderToASI");
        action.setParams({
            "dealerCode" : component.get("v.dealerCode"),
            "orderType" : component.get("v.orderType"),
            "poNumber" : component.get("v.po"),
            "carrier" : component.get("v.selectedRecord").Carrier_Code__c,		//component.get("v.selectCarrier"),
            "shipmentDate" : component.get("v.requestedShipDate"),
            "comments" : component.get("v.comments"),
            "cartOrders" : JSON.stringify(component.get("v.cartOrders"))            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.asiOrderCreationRes", result);
                var isChange = false;
                
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isUndefinedOrNull(result.Data) && !$A.util.isUndefinedOrNull(result.Data.OrderNumber) && !$A.util.isEmpty(result.Data.OrderNumber)){
                    //check PO U.I. field disabled or not
                    var callGeneratePONumberAPI = component.get("v.disablePO");
                    //if PO field disabled that means PO number is auto genrated via DSI
                    //after order created update the order details on DSI
                    if(callGeneratePONumberAPI){
                        //call to update purchase oreder details to DSI
                    	helper.callDSItoUpdatePurchaseOrder(component, event, helper);
                    }else{
                        isChange = true;
                    }
                    helper.showSuccessToast(component, event, helper, 'Your Order has created');
                }else{
                    isChange = true;
                    //error message
                    helper.showErrorToast(component, event, helper, 'Your Order has not created');
                }
                //condition true when need to close the place order modal and display Order Detail Modal
                //and update cart details
                if(isChange){
                    //hide Spinner
                    component.set("v.displayLoading",false);
                    //show parent Modal
                    component.set("v.isShowModal", true);
                    
                    //Close place order Modal
                    helper.closePlaceOrderModalHelper(component, event, helper);
                    
                    //event to update cart details (on Header)
                    var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                    menuEvent.fire();
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                //hide Spinner
            component.set("v.displayLoading",false);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    callDSItoUpdatePurchaseOrder : function(component, event, helper) {
        var action = component.get("c.updatePurchaseOrderDetailsOnDSI");
        action.setParams({
            "dealerCode" : component.get("v.dealerCode"),
            "purchasedOrderNumber" : component.get("v.po"),
            "cartOrders" : JSON.stringify(component.get("v.cartOrders"))            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrap = response.getReturnValue();
                component.set("v.dsiOrderUpdateRes", wrap);
                if($A.util.isUndefinedOrNull(wrap.OrderUpdateStatus)){
                    //error message
                    helper.showErrorToast(component, event, helper, wrap.error);
                }else if(!$A.util.isUndefinedOrNull(wrap.OrderUpdateStatus.errorMessage)){
                    //error message
                    helper.showErrorToast(component, event, helper, wrap.OrderUpdateStatus.errorMessage);
                }else{
                    //success message
                    helper.showSuccessToast(component, event, helper, wrap.OrderUpdateStatus.message);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            //event to update cart details (on Header)
            var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
            menuEvent.fire();
            
            //hide Spinner
            component.set("v.displayLoading",false);
            //show parent Modal
            component.set("v.isShowModal", true);
            //Close current Modal
            helper.closePlaceOrderModalHelper(component, event, helper);
            
        });
        $A.enqueueAction(action);
    },
    
    closePlaceOrderModalHelper : function(component, event, helper) {
       component.set("v.showPlaceOrderModal", false);
    },
    
    showSuccessToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Success!",
            "type": "success",
            "message": message
        });
        toastEvent.fire();
	},
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error!",
            "type": "error",
            "message": message
        });
        toastEvent.fire();
	},
})