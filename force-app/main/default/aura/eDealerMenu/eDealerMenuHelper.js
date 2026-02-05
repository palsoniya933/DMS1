({
    myFunctionHelper : function(component, event, helper) {
        var el = component.find('myDIV');
        // Check if the element has the class 'expanded'
        if ($A.util.hasClass(el, 'expanded')) {
            console.log("Element has class 'expanded'");
        } else {
            console.log("Element does not have class 'expanded'");
        }
        
        var isClosed = component.get("v.ismenuClosed");
        if(!($A.util.hasClass(el, 'expanded'))){
            helper.retrieveAndSetPreviousState(component);
          //  helper.storeAndCloseChildNavState(component);
            $A.util.addClass(el, 'expanded'); 
            component.set("v.ismenuClosed", false);

        }else{
           // helper.retrieveAndSetPreviousState(component);
           helper.storeAndCloseChildNavState(component)
            $A.util.removeClass(el, 'expanded');
            component.set("v.ismenuClosed", true);
            component.set("v.clickedBarName", undefined);

        }
    },
    
    
    myFunctionHelper2 : function(component, event, helper) {
        const buttonName = event.currentTarget.name;
        const isMenuClosed = component.get('v.ismenuClosed');
        if(buttonName != 'dashboard'){
            const childNavItemId = buttonName+'ChildNav';
            const childNavState = component.get("v.childNavState");       
            var childNavName = childNavState[childNavItemId];
            if(childNavName && childNavName.isOpen){
                childNavState[childNavItemId].isOpen = false;                
            }else{
                childNavState[childNavItemId].isOpen = true;
                if(isMenuClosed){
                    component.set('v.ismenuClosed',false);
                }
                
            }
            if(helper.areAllClosed(childNavState)){
                component.set('v.ismenuClosed2',true);
            }
            else{
                component.set('v.ismenuClosed2',false);
            }
            localStorage.setItem("eDealerChildNavState", JSON.stringify(childNavState));
            component.set("v.childNavState",childNavState);
        }else{
            const isMenuClosed2 = component.get('v.ismenuClosed2');
            if(isMenuClosed2){
                component.set('v.ismenuClosed2',false);
                helper.retrieveAndSetPreviousState(component);
                component.set("v.ismenuClosed", false);
            }
            else{
                component.set('v.ismenuClosed2',true);
                helper.storeAndCloseChildNavState(component);
                component.set("v.ismenuClosed", true);
                
                
            }
        }
    },
    
    setDefaultStateOfSubNav : function(component){
        window.addEventListener('beforeunload',function(){
           localStorage.removeItem("eDealerChildNavState"); 
        });
        const eDealerChildNavState = localStorage.getItem("eDealerChildNavState");
        if(eDealerChildNavState){
            component.set("v.childNavState",JSON.parse(eDealerChildNavState));
        }else{
	        component.set("v.childNavState",{
            'mdiChildNav' :{'isOpen': true, previousState : true},
            'analyticsChildNav' :{'isOpen': true, previousState : true},
            'pricingChildNav' :{'isOpen': true, previousState : true},
            'csrChildNav' :{'isOpen': true, previousState : true},
            'loyaltyChildNav' :{'isOpen': true, previousState : true}
        });
        }
    },
    
    areAllClosed : function(childNavState){
        return Object.values(childNavState).every(item => item.isOpen === false);
    },
    
    storeAndCloseChildNavState : function(component){
        const childNavState = component.get("v.childNavState");
        if(childNavState){
            Object.keys(childNavState).forEach((childNavName)=>{
                if(childNavState[childNavName]){
                childNavState[childNavName].previousState = childNavState[childNavName].isOpen;
                childNavState[childNavName].isOpen = false
            }
                                               });
        }
        localStorage.setItem("eDealerChildNavState", JSON.stringify(childNavState));
        component.set("v.childNavState",childNavState);
    },
    
    retrieveAndSetPreviousState : function(component){
        const childNavState = component.get("v.childNavState");
        console.log(JSON.stringify(childNavState));
        if(childNavState){
            Object.keys(childNavState).forEach((childNavName)=>{
                if(childNavState[childNavName]){
                childNavState[childNavName].isOpen = childNavState[childNavName].previousState;
                childNavState[childNavName].previousState = true
            }
                                               });
        }
        localStorage.setItem("eDealerChildNavState", JSON.stringify(childNavState));
        component.set("v.childNavState",childNavState);
    },
    
    getPricingToggleStatus : function(component , event, helper) {
        var action = component .get("c.pricingToggle");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.isPricingToogleOn",response.getReturnValue());
                console.log("This user getPricingToggleStatus--------::"+ response.getReturnValue());
            }
            else if(state === "INCOMPLETE")
            {
                //do something 
            }
                else if(state === "ERROR")
                {
                    var error = response.getError();
                    if(error)
                    {
                        console.log("error"+errors);
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getLoggingUserStatus : function(component , event, helper) {
        var action = component .get("c.csrToggle");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.isToggleOnForLoggedInUser",response.getReturnValue());
                console.log("This user Status--------::"+ response.getReturnValue());
            }
            else if(state === "INCOMPLETE")
            {
                //do something 
            }
                else if(state === "ERROR")
                {
                    var error = response.getError();
                    if(error)
                    {
                        console.log("error"+errors);
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getIsLoyaltyMenuVisible : function(component , event, helper) {
        var action = component .get("c.isLoyaltyMenuVisible");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.isLoyaltyMenuVisible",response.getReturnValue());
            }
            else if(state === "INCOMPLETE")
            {
                //do something 
            }
                else if(state === "ERROR")
                {
                    var error = response.getError();
                    if(error)
                    {
                        console.log("error"+errors);
                    }
                }
        });
        $A.enqueueAction(action);
    },

	getRPMScoreCardToggleStatus : function(component , event, helper) {
        var action = component.get("c.isRPMScoreCardMenuVisible");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.isRPMScoreCardToggleOn",response.getReturnValue());
            }
            else if(state === "INCOMPLETE")
            {
                //do something 
            }
                else if(state === "ERROR")
                {
                    var error = response.getError();
                    if(error)
                    {
                        console.log("error"+errors);
                    }
                }
        });
        $A.enqueueAction(action);
    },getTCS365ToggleStatus : function(component , event, helper) {
        var action = component .get("c.tcs365Toggle");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.isTCS365ToogleOn",response.getReturnValue());
                console.log("This user getTCS365ToggleStatus--------::"+ response.getReturnValue());
            }
            else if(state === "INCOMPLETE")
            {
                //do something 
            }
                else if(state === "ERROR")
                {
                    var error = response.getError();
                    if(error)
                    {
                        console.log("error"+errors);
                    }
                }
        });
        $A.enqueueAction(action);

    }
})