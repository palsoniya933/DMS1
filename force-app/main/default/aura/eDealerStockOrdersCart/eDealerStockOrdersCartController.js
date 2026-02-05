({
	doInit : function(component, event, helper) {
        component.set("v.cartStockOrders", undefined);
        component.set("v.displayLoading", true);
		helper.getStockCartItems(component, event, helper);
	},
    
    deleteItem  : function(component, event, helper) {
        var cartID = event.currentTarget.name;
        if(!$A.util.isUndefinedOrNull(cartID)){
            component.set("v.displayLoading", true);
            helper.deleteItemFromCart(component, event, helper, cartID);
        }
	},
})