({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        
        //get today date in PST
        var todayDate = new Date();
        var pstDate = todayDate.toLocaleString("en-US", {timeZone: "America/Los_Angeles"});
        var pstDateString = pstDate.toString().split(",")[0];
        component.set("v.todayPSTDateString",pstDateString);
    },
    
    checkoutEM : function(component, event, helper){
    	//close modal
    	component.set("v.showEmergencyOrderAddCartModal", false);
        component.set("v.showStockOrderAddCartModal", false);
        
       var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ "menuName" : "cartpage",  "tabName" : "DSPEM"});
        menuEvent.fire();
    },
	    
    checkoutDSP : function(component, event, helper){
    	//close modal
        component.set("v.showStockOrderAddCartModal", false);
        
       var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ "menuName" : "cartpage",  "tabName" : "DSP"});
        menuEvent.fire();
    },
    
    addEmergencyOrderInCart : function(component, event, helper){
        //show spinner
        component.set("v.displayLoading", true);
        //Call helper to create EM cartItems
        helper.addItemsInEmergencyCart(component, event, helper);
        
    },
    
    addDSPOrderInCart : function(component, event, helper){   
        //show spinner
         component.set("v.displayLoading", true);
        //Call helper to create DSP Stock cartItems
        helper.addItemsInDSPCart(component, event, helper);
        
    },
    
    refresh : function(component, event, helper){
        component.set("v.showEmergencyOrderAddCartModal", false);
        component.set("v.showStockOrderAddCartModal", false);
        //get updated suggested orders
        helper.doInitHelper(component, event, helper);
    },


})