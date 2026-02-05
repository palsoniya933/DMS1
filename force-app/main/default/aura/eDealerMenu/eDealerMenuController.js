({
    onload : function(component, event, helper) {
        //debugger;
        component.set("v.fullHeight", 890);
        helper.setDefaultStateOfSubNav(component);
        window.setTimeout(
            $A.getCallback(function() {
                var screenHeight = 890;
                component.set("v.fullHeight", screenHeight);
                var scrollHeight = document.documentElement.scrollHeight;
                var finalHeight;
                if(scrollHeight != undefined && scrollHeight > screenHeight){
                    finalHeight = scrollHeight - ((scrollHeight *5)/100);
                }else {
                    finalHeight = screenHeight - ((screenHeight *5)/100);
                }
                component.set("v.fullHeight", finalHeight);
                component.set("v.ismenuClosed", false);
            }), 2000);
        component.set("v.ismenuClosed", false);
        component.set("v.ismenuClosed2", false);
        helper.getLoggingUserStatus(component, event, helper);
        helper.getIsLoyaltyMenuVisible(component, event, helper);
        helper.getPricingToggleStatus(component, event, helper);
        helper.getTCS365ToggleStatus(component, event, helper);

        helper.getRPMScoreCardToggleStatus(component, event, helper);

    },
    
    handleMenu : function(component, event, helper) {
        var clickedMenu = event.target.name;
        var trackingName = event.target.id;
        var currentUrl = window.location.href;
        var createCsrBaseURL = currentUrl.split('?')[0];
        window.scrollTo({
            top : 0,
            behavior : 'smooth'
        })
        
        var shouldShowCsrAndPartNumber = (clickedMenu == 'createCSR' || clickedMenu == 'csrandvolumnsales');
        component.set('v.showCsrAndPartNumber', shouldShowCsrAndPartNumber);
        
        if (currentUrl !== createCsrBaseURL) {
            history.replaceState(null, null, createCsrBaseURL);
            if(clickedMenu == 'createCSR'){
                var payload = {
                    detail: "createmode"
                };                
                component.find("eDealerCSR").publish(payload);
            }
        }
        if(clickedMenu == 'linkToLoyalty'){
            var url =  $A.get("$Label.c.Link_to_Loyalty_Application");
            var newWindow = window.open(url, '_blank');
            newWindow.focus();
        }
       
        
        // fire event
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent"); 
        
        menuEvent.setParams({ "menuName" : clickedMenu });
        console.log('menuEvent1::'+menuEvent);
        menuEvent.fire();        
        
        var menuEvent2 = $A.get("e.c:eDealerSubMenu");    
        menuEvent2.setParams({ "menuName" : clickedMenu,
                             "submenu" : "" });
        console.log('menuEvent 2'+menuEvent2);
        menuEvent2.fire();
    },

    naviagteToHomePage : function (component, event, helper) {
        console.log('navigateToHomePage called');
        window.open('/','_blank');
    },
    
    myFunction : function (component, event, helper) {
        helper.myFunctionHelper(component, event, helper);
    },
    
     myFunction2 : function (component, event, helper) {
        helper.myFunctionHelper2(component, event, helper);
    },
    
    
    openBar : function(component, event, helper){
        var clickedMenu = event.target.name;
        component.set("v.clickedBarName", clickedMenu);
        helper.myFunctionHelper(component, event, helper);
    }
})