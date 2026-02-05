({
	calculateTotals : function(component, event, helper, suggestedOrdersList) {
        
        var totalSuggestedParts = suggestedOrdersList.length;
        var totalSuggestedPartsQty = 0;
        var totalQtyAddedInCart = 0;
        var totalQtyOrderedToday = 0;
        
        for(var i=0;i<suggestedOrdersList.length;i++){
            totalSuggestedPartsQty += parseInt(suggestedOrdersList[i].Suggested_Qty);
            if(suggestedOrdersList[i].qtyInTodayCart != undefined && Number.isInteger(suggestedOrdersList[i].qtyInTodayCart)){
                totalQtyAddedInCart += suggestedOrdersList[i].qtyInTodayCart;
                totalQtyOrderedToday += suggestedOrdersList[i].qtyOrdered;
            }
        }
        
        component.set("v.totalSuggestedParts", totalSuggestedParts);
        component.set("v.totalSuggestedPartsQty", totalSuggestedPartsQty);
        component.set("v.totalQtyAddedInCart", totalQtyAddedInCart);
        component.set("v.totalQtyOrderedToday", totalQtyOrderedToday);
		
	}
})