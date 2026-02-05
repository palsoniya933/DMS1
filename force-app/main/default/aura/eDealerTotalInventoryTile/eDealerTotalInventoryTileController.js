({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        component.set("v.totalInventoryData", undefined);
        component.set("v.AllInventoryData",undefined);
        
        //Check data in cache or fetch data
        helper.fetchTotalInventoryData(component, event, helper);        
    },
    
    engineUpdateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'Total Inventory');
        helper.updateTileUIData(component, event, helper);
    },

    
    handleSelectedTab: function(component, event, helper) {        
        const selectedTab = event.currentTarget.dataset.tab;
        const selectedTabLabel=event.currentTarget.innerText;
        component.set("v.selectedTab", selectedTab);
        component.set("v.selectedTabLabel",selectedTabLabel);
        component.set("v.selectedSubMenu", "inventoryhealthreport");
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ 
            "menuName" : 'eDealerInvHealth',
            "submenu" : "inventoryhealthreport",
            "tabName":selectedTab,
            "selectedTabLabel":selectedTabLabel,
            "dealercode": component.get("v.dealerLoc")
        });  
        menuEvent.fire();
        
        var subMenuEvent = $A.get("e.c:eDealerSubMenu");    
    	subMenuEvent.setParams({ 
        	"menuName" : 'eDealerInvHealth',
        	"submenu" : "inventoryhealthreport"
    	});
        subMenuEvent.fire();
    }
    
})