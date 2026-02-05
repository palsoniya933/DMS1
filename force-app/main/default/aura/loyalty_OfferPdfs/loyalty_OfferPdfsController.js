({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Loyalty - Offer Pdfs');
         component.set(
            'v.loadTime',
            Date.now()
        );
          window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Loyalty - Offer Pdfs',component.get('v.loadTime'));
        });
    },
    
    handleDealerCodeChange : function(component, event, helper) {
        const currentLoggedInUserInfo = component.get('v.loggedInUserInfo');
        if(!currentLoggedInUserInfo.isDealerUser){
            helper.setFilterOnDatasets(component, event, helper);
        }
    },
    
    handleDashboardLoaded : function(component, event, helper){
        const isLoaded = component.get('v.isLoaded');
        if(isLoaded){
            helper.publishData(component);
            component.set('v.isLoaded',false);
        }
    },
       handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Loyalty - Offer Pdfs',component.get('v.loadTime'));
    }
})