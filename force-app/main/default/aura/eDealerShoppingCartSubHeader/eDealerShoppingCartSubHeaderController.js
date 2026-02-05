({
	doInit : function(component, event, helper) {
		var totalParts = 0;
        var totalQuantity = 0;
        
        var lstOrders = component.get("v.cartOrders");
        
        if(!$A.util.isUndefinedOrNull(lstOrders) && lstOrders.length > 0) {
            totalParts = lstOrders.length;
            for(var i=0;i<lstOrders.length;i++){
                totalQuantity += lstOrders[i].qtyForOrder;
            }
        }
        
        component.set("v.totalPartsAddedonOrder", totalParts);
        component.set("v.totalPartsQuantityAddedonOrder", totalQuantity);
        
	}
})