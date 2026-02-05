({
	doInit : function(component, event, helper) {
        let isShowPartAvailabilitySectionOnPage = component.get("v.isShowPartAvailabilitySectionOnPage");
        if(isShowPartAvailabilitySectionOnPage == true){
            let activeSections = [];
            activeSections.push("PricingInfo1"); 
            component.set("v.activeSections",activeSections);
        }
        
        
		helper.partAvailabilityDetails(component, event, helper);
	},
    
    handleSectionToggle : function(component, event, helper) {
        var openSections = event.getParam('openSections');        
        let isShowPartAvailabilitySectionOnPage = component.get("v.isShowPartAvailabilitySectionOnPage");
        if(isShowPartAvailabilitySectionOnPage != true){
            component.set("v.activeSections",[]);
            var getError = $A.get('$Label.c.You_do_not_have_Parts_availability_Inquiry_permission_contact_your_External_D'); 
            helper.showErrorToast(component, event, helper,getError);
        }
	},
    
    
    
    displaynearstdealer: function (component, event, helper) {
        if($A.util.hasClass(component.find("nearstdealer"), "slds-show")){
            $A.util.addClass(component.find("nearstdealer"), "slds-hide");
            $A.util.removeClass(component.find("nearstdealer"), "slds-show");
        }
        else{
            $A.util.addClass(component.find("nearstdealer"), "slds-show");
            $A.util.removeClass(component.find("nearstdealer"), "slds-hide");
        }
        
    },
   
    
    refresh : function(component, event, helper){
        //get updated suggested orders
        helper.partAvailabilityDetails(component, event, helper);
    },
    
    
    handleOpenInNewWindow : function(component, event, helper) {
        var origin = window.location.origin;
        var pathName = window.location.pathname;
        var partNum = event.currentTarget.name;
        //console.log('*** Part Num ***'+partNum);
        var dealerCode = component.get("v.dealerCode");
        window.open('https://tcs365.paccar.com/s', '_blank');
    },
    
    
})