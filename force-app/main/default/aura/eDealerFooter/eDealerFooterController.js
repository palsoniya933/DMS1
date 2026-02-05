({
	doInit : function(component, event, helper) {
    const d = new Date();
    let year = d.getFullYear();
     component.set("v.currentYear",year);
		
	}
})