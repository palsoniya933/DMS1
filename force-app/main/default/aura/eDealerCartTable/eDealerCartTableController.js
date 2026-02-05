({
    deleteItem  : function(component, event, helper) {
        var cartID = event.currentTarget.name;
        if(!$A.util.isUndefinedOrNull(cartID)){
            component.set("v.displayLoading", true);
            helper.deleteItemFromCart(component, event, helper, cartID);
        }
    },
    
    confirmCancelOrders : function(component, event, helper) {
        component.set("v.showCancelOrderModal", true);
    },
    
    /*closeModal : function(component, event, helper) {
        component.set("v.showOrderCreationDetail", false);   
    },*/
    
    closeCartConfirmationModal : function(component, event, helper) {
        component.set("v.showCancelOrderModal", false);   
    },
    
    closeOrderDetailModal : function(component, event, helper) {
        component.set("v.asiOrderCreationRes", {});
        component.set("v.dsiOrderUpdateRes", undefined);
        helper.refreshCartHelper(component, event, helper);
    },
    
    deleteAllItems : function(component, event, helper) {
        component.set("v.showCancelOrderModal", false);
        component.set("v.displayLoading", true);
        helper.deleteAllItemFromCart(component, event, helper);
    },
    
    // update the quantity value in Dealer Cart record
    getupdatedQntRec : function(component, event, helper) {
        //get the updated record Id
        var RecId = event.getSource().get("v.name");
        //get the updated record quantity value
        var qntVal = event.getSource().get("v.value");
        
        if(!$A.util.isUndefinedOrNull(RecId)){
            //Display spinner
            component.set("v.displayLoading", true);
            helper.updateQntyVal(component, event, helper, RecId, qntVal);
        }        
    },
    
    // show the place order modal
    showPlaceOrderModal : function(component, event, helper) {        
        component.set("v.showPlaceOrderModal", true);
           
    },
    
    // hide the place order modal
    closePlaceOrderModal : function(component, event, helper) {
        component.set("v.showPlaceOrderModal", false);
           
    }, 
    
    refreshCart : function(component, event, helper) {        
        helper.refreshCartHelper(component, event, helper);
    },
    
})