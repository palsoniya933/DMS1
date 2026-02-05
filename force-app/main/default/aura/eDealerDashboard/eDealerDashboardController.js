({
    doInit : function(component, event, helper) {
        console.log("Dashboard selectedmenu::"+component.get("v.selectedmenu"));
        
        var isNonDealer = component.get("v.isNonDealer");
        console.log("isNonDealer"+isNonDealer);
        if(!isNonDealer){
            var selectedLocation = component.get("v.selectedLocation");
            if(!$A.util.isUndefinedOrNull(selectedLocation.selectedLoc)){
                var listDealerLoc = [];
                listDealerLoc.push(selectedLocation.selectedLoc);                
                selectedLocation.listSelectedLoc = listDealerLoc;
                component.set("v.selectedLocation",selectedLocation);
            }
            console.log("selectedLocation in dashboard"+JSON.stringify(component.get("v.selectedLocation")));    
        }
        
        let accessibleDealersLocs = component.get("v.accessibleDealersLocs");
        if(!$A.util.isUndefinedOrNull(accessibleDealersLocs) 
           && accessibleDealersLocs.length > 0
           && accessibleDealersLocs[0].Order_Inquiry__c == false){ 
            component.set("v.activeSections",[]);
            helper.showErrorToast('You do not have "POL Order Inquiry" permission, contact your External Dealer Admin for requesting access');
        }
        helper.updateTrackingDetails(component, event, helper,'dashboard');
         helper.fetchFrequency(component, event, helper);
          component.set(
            'v.loadTime',
            Date.now()
        );
         window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'dashboard',component.get('v.loadTime'));
        });
    },
    
    handleSectionToggle : function(component, event, helper) {
        var openSections = event.getParam('openSections');        
        let accessibleDealersLocs = component.get("v.accessibleDealersLocs");
        if(!$A.util.isUndefinedOrNull(accessibleDealersLocs) 
           && accessibleDealersLocs.length > 0
           && accessibleDealersLocs[0].Order_Inquiry__c == false
           && openSections.length > 0){ 
            component.set("v.activeSections",[]);
            helper.showErrorToast('You do not have "POL Order Inquiry" permission, contact your External Dealer Admin for requesting access');
        }
    },
    /*receiveCrmaData : function(component, event, helper)
	{
        component.set("v.selectedmenu", "crmaDataListing");
         
        
	},
    crmHandle : function(component, event, helper){
        component.set("v.selectedmenu", "crmaDataListing");
    },
    crmdataHandle: function(component, event, helper){
        component.set("v.selectedmenu", "crmaDataListing");
    },*/
    
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'dashboard',component.get('v.loadTime'));
    },
})