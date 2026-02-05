({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Loyalty - Dashboard');
        component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Loyalty - Dashboard',component.get('v.loadTime'));
        });
    },
    
    handleDealerCodeChange : function(component, event, helper) {
        helper.setFilterOnDatasets(component, event, helper);
    },

    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Loyalty - Dashboard',component.get('v.loadTime'));
    }
})