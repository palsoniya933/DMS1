({
    	
    resetStyleClass : function(component, event, helper) {
        component.set('v.TotalInvTabClass','tab-link');
        component.set('v.HealthInventoryTabClass','tab-link');
        component.set('v.NoMoveTabClass','tab-link');
        component.set('v.Exess90Days','tab-link');
    },
    
    setActiveTab : function(component, event, helper) {
        let selectedTab = component.get('v.selectedTab');
        if(selectedTab == 'TotalInventory'){
            component.set('v.TotalInvTabClass','tab-link activetab');
        } else if(selectedTab == 'HealthInventory'){
            component.set('v.HealthInventoryTabClass','tab-link activetab');
        } else if(selectedTab == 'NoMove'){
            component.set('v.NoMoveTabClass','tab-link activetab');
        } else if(selectedTab == 'Excess90Days'){
            component.set('v.Exess90Days','tab-link activetab');
        }
    },
})