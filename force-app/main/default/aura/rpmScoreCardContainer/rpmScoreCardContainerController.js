({
    doInit : function(component, event, helper) { 
        helper.setFilterOnDatasets(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'RPM Score Card');
		component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'RPM Score Card',component.get('v.loadTime'));
        });
    },
    
    handleDealerCodeChange : function(component, event, helper) {
        helper.setFilterOnDatasets(component, event, helper);
    },
    
    handleCheckBoxChange : function(component, event, helper) {
        const isChecked = event.target.checked;
        const value = event.target.value;
        if(isChecked){
            if( value === 'dealer' ){
                component.set("v.showDealerDashboard",true);
                component.set("v.showDealerGroupDashboard",false);
            }
            else{
                component.set("v.showDealerGroupDashboard",true);
                component.set("v.showDealerDashboard",false);
            }
        }
        helper.setDashboardLanguage(component);
    },
    
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'RPM Score Card',component.get('v.loadTime'));
    },
})