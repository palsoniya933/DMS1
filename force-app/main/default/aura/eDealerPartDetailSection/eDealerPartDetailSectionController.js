({
	openBreakPriceDetailModal : function(component, event, helper){
        component.set("v.showBreakPrice", true);
    },
    
    openLoyalityDetailModal : function(component, event, helper){
        component.set("v.showLoyality", true);
    },
    
    openBreakPriceDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        //component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showBreakPrice", true);
    },
    
    openCSRDetailModal : function(component, event, helper){
        component.set("v.showCSR", true);
    },
    
    openCNRDetailModal : function(component, event, helper){
        component.set("v.showCNR", true);
    },
        
    closeModal : function(component, event, helper){
        component.set("v.showBreakPrice", false);
        component.set("v.showLoyality", false);
        component.set("v.showCSR", false);
        component.set("v.showCNR", false);
    },
})