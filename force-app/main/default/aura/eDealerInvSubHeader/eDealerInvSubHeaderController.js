({
	doInit : function(component, event, helper) {
        var tabName = component.get("v.tabName");
        helper.calculateTotals(component, event, helper, component.get("v.suggestedOrders"));
        console.log("sofInfo::"+ component.get("v.sofInfo"));
	}
})