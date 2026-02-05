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
        
       var tabname = 'EM';
        
        //Call helper to create Stock cartItems
        var invData = component.get("v.invData");
        var isDSPSelectedPriceParts = false;
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked == true && invData[i].DualPartSelectedPriceType == 'DSP'){
                isDSPSelectedPriceParts = true;
                break;
            }
        }
        if(isDSPSelectedPriceParts){
            tabname = 'DSPEM';
        }
        
       var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ "menuName" : "cartpage",  "tabName" : tabname});
        menuEvent.fire();
    },
    
    checkoutSO : function(component, event, helper){
    	//close modal
    	component.set("v.showEmergencyOrderAddCartModal", false);
        component.set("v.showStockOrderAddCartModal", false);
        
        var tabname = 'SO';
        
        //Call helper to create Stock cartItems
        var invData = component.get("v.invData");
        var isDSPSelectedPriceParts = false;
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked == true && invData[i].DualPartSelectedPriceType == 'DSP'){
                isDSPSelectedPriceParts = true;
                break;
            }
        }
        if(isDSPSelectedPriceParts){
            tabname = 'DSP';
        }
        
       var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ "menuName" : "cartpage",  "tabName" : tabname});
        menuEvent.fire();
    },
    
    addEmergencyOrderInCart : function(component, event, helper){
        //show spinner
        component.set("v.displayLoading", true);
        //Call helper to create EM cartItems
        helper.addItemsInEmergencyCart(component, event, helper);
        
    },
    
    addStockOrderInCart : function(component, event, helper){ 
        //show spinner
        component.set("v.displayLoading", true);
        //Call helper to create PDC Stock OR DSP cartItems
        helper.addItemsInPDC_DSP_StockCart(component, event, helper);
    },
    
    refresh : function(component, event, helper){
        component.set("v.showEmergencyOrderAddCartModal", false);
        component.set("v.showStockOrderAddCartModal", false);
        //get updated suggested orders
        helper.doInitHelper(component, event, helper);
    },


})