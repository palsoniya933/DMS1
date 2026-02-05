({
    handleActive : function(component, event, helper) {
        var tab = event.getSource();
        var tabID = tab.get('v.id');        
        component.set("v.PricingInformationActiveTAB", tabID);
    },
    
    doInit : function(component, event, helper) {
            component.set("v.displayLoading",true);
            helper.fetchOnloadDetails(component, event, helper);   
            helper.fetchPartDetail(component, event, helper);
    },
    
})