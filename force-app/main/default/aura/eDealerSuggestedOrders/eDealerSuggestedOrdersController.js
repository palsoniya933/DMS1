({
    fetchData : function(component, event, helper) {
        helper.defaultSelectedOption(component);    
    },
    
    defaultSOFTab : function(component, event, helper) {
        component.set("v.selecetdTabID", "ALLPARTS");
        helper.getSOFFileCreatedDate(component, event, helper);    
    },
    
    doinit : function(component, event, helper) {
        helper.getSOFFileCreatedDate(component, event, helper);    
    },
    
    partClicked : function(component, event, helper) {
        component.set("v.partNumber",event.getParam("partNumber"));  
        component.set("v.displayParts",true);
    },
    
    closePartModel : function(component, event, helper) {                  
        component.set("v.displayParts",false);
    },
    
    checkClickedTab : function(component, event, helper) {     
        var selectedTabId = component.find("tabs").get("v.selectedTabId");
        component.set("v.selecetdTabID", selectedTabId);
    },
    
    
})