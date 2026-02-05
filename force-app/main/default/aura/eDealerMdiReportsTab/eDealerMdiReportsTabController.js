({
	doInit : function(component, event, helper) {
       	helper.getUsers(component, event, helper);
		helper.doInithelper(component, event, helper);
	},
    
    handleLocationChange : function(component, event, helper) {
        var locObj = {};
        locObj.selectedLoc = event.getParam('selectedLoc');
        component.set("v.selectedLocation",locObj);
    },
    
    fetchupdateLocations : function(component, event, helper) {       
    	helper.doInithelper(component, event, helper);
    }
})