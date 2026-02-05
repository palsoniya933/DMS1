({
    switchTab: function (component, event, helper) {
        // Get the tab name from the data attribute of the clicked tab
        let selectedTab = event.currentTarget.getAttribute('data-tab');
        let selectedTabLabel = event.currentTarget.innerText;
        
        // Set the selected tab and label
        component.set("v.selectedTab", selectedTab);
        component.set("v.selectedTabLabel", selectedTabLabel);
        
        helper.resetStyleClass(component, event, helper);
        helper.setActiveTab(component, event, helper);
    },
    
    doInit: function(component, event, helper) {  
        helper.resetStyleClass(component, event, helper);
        helper.setActiveTab(component, event, helper);
        component.set('v.displayTabs',true);
        
    }
    
    });