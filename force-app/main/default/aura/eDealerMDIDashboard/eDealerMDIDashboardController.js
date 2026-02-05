({
	doInit : function(component, event, helper) {
        var isNonDealer = component.get("v.userDetail.isNonDealer");
        
         if(!isNonDealer){
            var selectedLocation = component.get("v.selectedLocation");
           
            if(!$A.util.isUndefinedOrNull(selectedLocation.selectedLoc)){
                var listDealerLoc = [];
                listDealerLoc.push(selectedLocation.selectedLoc);                
                selectedLocation.listSelectedLoc = listDealerLoc;
                component.set("v.selectedLocation",selectedLocation);
            }
        }
        helper.updateTrackingDetails(component, event, helper,'MDI Dashboard');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Dashboard',component.get('v.loadTime'));
        });
	},
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Dashboard',component.get('v.loadTime'));
    },
})