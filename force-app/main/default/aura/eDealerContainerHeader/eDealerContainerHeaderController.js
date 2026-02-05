({
    // this method will run on load of the component
    onload : function(component, event, helper) {
       // getting the current date time
        var today = new Date();
        var todayDate = today.getYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var currentDate = $A.localizationService.formatDate(today);
        component.set('v.currentDate', currentDate);  
        helper.updateLstOfDealerCodesHelper(component, event, helper);
         
    },
    
    resetValues : function(component, event, helper) {        
        location.reload();
    },
    
    handleMenuChange : function(component, event, helper){
        var headingName = event.getParam("headingName"); 
        if(headingName){
            component.set("v.submenu",headingName); 
        }        
    },
    
    handleSubMenuChange : function(component, event, helper){
        var mainHeading = event.getParam("menuName"); 
        var subMenu = event.getParam("submenu"); 
        component.set("v.selectedmenu",mainHeading);
                

        if(mainHeading == 'dashboardDemo' || mainHeading == "dashboardDivV2"|| mainHeading=='eDealerInvHealth'){       
            component.set("v.changeAccessibleDealersLocs",component.get("v.allAccessibleDealersLocs")); 
        }
        component.set("v.submenu",subMenu);
        if(!$A.util.isUndefinedOrNull(subMenu) 
           	&& !$A.util.isEmpty(subMenu) 
           	&& subMenu!=''){
                component.set("v.isOrderScreenPageOpen",true);
        }
        
    },
    
    // this method will run on change of the location picklist
    handleLocationChange : function(component, event, helper) {
        // getting selected location
        var selectecLoc = event.getSource().get("v.value");
        component.set("v.selectedLocation",selectecLoc);
        var selectedLocs = [];
        selectedLocs.push(selectecLoc);
        // fire event
        var menuEvent = $A.get("e.c:eDealerLocationEvent");    
        menuEvent.setParams({ "selectedLoc" : selectecLoc, "listSelectedLoc" : selectedLocs});
        menuEvent.fire(); 
    },
    
    updateSelectedDealerCode : function(component, event, helper) {
        var obj = component.get("v.selectedRecord");
        var selectecLoc = obj.Dealer_Code__c;
        var selectedLocs = [];
        selectedLocs.push(selectecLoc);
        // fire event
        var menuEvent = $A.get("e.c:eDealerLocationEvent");    
        menuEvent.setParams({ "selectedLoc" : selectecLoc, "listSelectedLoc" : selectedLocs});
        menuEvent.fire();
    },
    
    selectedLocations : function(component, event, helper) {
        var allAccessibleDealersLocs = component.get("v.allAccessibleDealersLocs");
        var selectedLocs = [];
        
        for(let count=0;count<allAccessibleDealersLocs.length;count++){
            if(allAccessibleDealersLocs[count].selected){
                selectedLocs.push((allAccessibleDealersLocs[count].Name).split(" ")[0]);
            }
        }
        var menuEvent = $A.get("e.c:eDealerLocationEvent");  
        menuEvent.setParams({ "listSelectedLoc" : selectedLocs});
        
        if(selectedLocs.length >= 1){
            menuEvent.setParams({ "listSelectedLoc" : selectedLocs});
        }else{
           menuEvent.setParams({ "selectedLoc" : null}); 
        }
        
        menuEvent.fire(); 
    }  ,
    handleNavFromHeader: function(component,event,helper){
        
        if( component.get("v.selectedmenu") == 'csrlisting'
         || component.get("v.selectedmenu") == 'csrandvolumnsales' 
         || component.get("v.selectedmenu") == 'createCSR'){
            console.log('if: '+component.get("v.selectedmenu"));
            component.set("v.selectedmenu",'csrandvolumnsales'); 
            
            // fires event for menu navigation
            var menuEvent = $A.get("e.c:eDealerMenuClickedEvent"); 
            menuEvent.setParams({ "menuName" : component.get("v.selectedmenu") });
            menuEvent.fire();        
            
            
        }
        else if(   component.get("v.selectedmenu") == 'activeorders' 
                || component.get("v.selectedmenu") == 'pendingorders' 
                || component.get("v.selectedmenu") == 'confirmedorders'
                || component.get("v.selectedmenu") == 'unconfirmedorders'
                || component.get("v.selectedmenu") == 'intransitorders'
                || component.get("v.selectedmenu") == 'shippedorders'
                || component.get("v.selectedmenu") == 'ordersummary'
                || component.get("v.selectedmenu") == 'deliveredorders'
                || component.get("v.selectedmenu") == 'dashboardDemo'
                || component.get("v.selectedmenu") == 'freightcharges'
            ){
                    console.log('elseif: '+component.get("v.selectedmenu"));

                   component.set("v.selectedmenu",'dashboardDemo'); 
                    

            // fires event for menu navigation
            var menuEvent = $A.get("e.c:eDealerMenuClickedEvent"); 
            menuEvent.setParams({ "menuName" : component.get("v.selectedmenu")
                                });
            menuEvent.fire();        
            
        }
        else if( component.get("v.selectedmenu") == 'manuallockdownparts' 
                || component.get("v.selectedmenu") == 'cnrorderlisting'
                || component.get("v.selectedmenu") == 'returncompliance' 
                || component.get("v.selectedmenu") == 'eDealerInvHealth'
                || component.get("v.selectedmenu") == 'emergencyorderlisting' 
                || component.get("v.selectedmenu") == 'dashboardDivV2'  ){
                    component.set("v.selectedmenu",'dashboardDivV2'); 
                    component.set("v.submenu",''); 

                    var menuEvent = $A.get("e.c:eDealerMenuClickedEvent"); 
                    menuEvent.setParams({ "menuName" : component.get("v.selectedmenu"), 
                                         });
                    menuEvent.fire();   
        }
       
        //clears URL attributes
        var currentUrl = window.location.href;
        var createCsrBaseURL = currentUrl.split('?')[0];
        if (currentUrl !== createCsrBaseURL) {
            history.replaceState(null, null, createCsrBaseURL);             
        }
    }
})