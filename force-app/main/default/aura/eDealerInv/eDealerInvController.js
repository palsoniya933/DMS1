({
    onload : function(component, event, helper) { 
        helper.checkIsPromoAvailable(component, event, helper);
        helper.updateTrackingDetails(component, event, helper,'Suggested Order File(SOF)');
         component.set(
            'v.loadTime',
            Date.now()
        );
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'Suggested Order File(SOF)',component.get('v.loadTime'));
        });
    },
    
	confirmRefreshSOF : function(component, event, helper) {     
        component.set("v.isSofRefreshConfirm",true);
    },
    
    closeSOFConfirmationModel : function(component, event, helper) {     
        component.set("v.isSofRefreshConfirm",false);
    },
    
    confirmRefreshSOFPromo : function(component, event, helper) {     
        component.set("v.isSofPromoRefreshConfirm",true);
    },
    
    closeSOFPromoConfirmationModel : function(component, event, helper) {     
        component.set("v.isSofPromoRefreshConfirm",false);
    },
    
    generatePROMOSOF : function(component, event, helper) {   
        component.set("v.isSofPromoRefreshConfirm",false);
        helper.calltoGenerateSOFonDemand(component, event, helper, true);
    },
    
    callToGenerateSOF : function(component, event, helper) {   
        component.set("v.isSofRefreshConfirm",false);
        helper.calltoGenerateSOFonDemand(component, event, helper, false);
    },
    
    checkClickedTab : function(component, event, helper) {     
        var selectedTabId = component.find("tabs").get("v.selectedTabId");
        component.set("v.selecetdTabID", selectedTabId);
    },
    selectTab : function(component, event, helper){
    	var activeTab = event.currentTarget.id;
        //console.log('activeTab ==>> '+activeTab);
        component.set("v.selecetdTabID", activeTab);
  
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'Suggested Order File(SOF)',component.get('v.loadTime'));
    },
})