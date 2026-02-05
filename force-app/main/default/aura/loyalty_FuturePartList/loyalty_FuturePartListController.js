({
	doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
         component.set(
            'v.loadTime',
            Date.now()
        );
        helper.updateTrackingDetails(component, event, helper,'Loyalty - Future Part List');
          window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Loyalty - Future Part List',component.get('v.loadTime'));
        });
    },
    
    handleDealerCodeChange : function(component, event, helper) {
        const currentLoggedInUserInfo = component.get('v.loggedInUserInfo');
        if(!currentLoggedInUserInfo.isDealerUser){
            helper.setFilterOnDatasets(component, event, helper);
        }
    },
       handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Loyalty - Future Part List',component.get('v.loadTime'));
    }
})