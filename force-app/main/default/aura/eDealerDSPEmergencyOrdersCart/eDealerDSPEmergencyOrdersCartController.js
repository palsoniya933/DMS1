({
	doInit : function(component, event, helper) {
        component.set("v.cartDSPEmergencyOrders", undefined);
        component.set("v.displayLoading", true);
		helper.getDSPEmergencyCartItems(component, event, helper);
	},
    
    deleteItem  : function(component, event, helper) {
        var cartID = event.currentTarget.name;
        if(!$A.util.isUndefinedOrNull(cartID)){
            component.set("v.displayLoading", true);
            helper.deleteItemFromCart(component, event, helper, cartID);
        }
	},
})