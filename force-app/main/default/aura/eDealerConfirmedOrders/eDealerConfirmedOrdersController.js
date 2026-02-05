({
	doInit : function(component, event, helper) {
		helper.fetchConfirmedOrders(component, event, helper);
         component.set(
            'v.loadTime',
            Date.now()
        );
        helper.updateTrackingDetails(component, event, helper,'Confirmed Order File');
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Confirmed Order File',component.get('v.loadTime'));
        });
	},
    
    openPart : function(component, event, helper) {
		component.set("v.partNumberDetail",event.currentTarget.name);  
        component.set("v.displayParts",true); 
	},
    
    closePartModel : function(component, event, helper) {
        component.set("v.partNumberDetail",'');  
        component.set("v.displayParts",false); 
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        let dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?partNum="+partNum+'&loc='+dealerCode+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Confirmed Order File',component.get('v.loadTime'));
    }
})