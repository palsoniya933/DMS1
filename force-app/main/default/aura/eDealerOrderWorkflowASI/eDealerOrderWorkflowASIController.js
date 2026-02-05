({
    myAction : function(component, event, helper) {
	},
    
    openSelectedTab : function(component, event, helper) {
        var tabName = event.target.name;
        //update the selected tab name
        component.set("v.selectedTabName", tabName);
	},
	
})