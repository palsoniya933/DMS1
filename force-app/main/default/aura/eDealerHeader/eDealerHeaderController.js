({
    gotoCartPage : function(component, event, helper) {
        // fire event
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({ "menuName" : "cartpage" });
        menuEvent.fire();
    },
    handleMenuChange:function(component, event, helper){
        var menuName = event.getParam("menuName");
        var selectedPicklistItems = component.get("v.selectedPicklistItem");
      
        component.set("v.selectedMenu",menuName);
        var selectedPicklistValueCSR=['CSR','CSR Part #'];
        var allowedMenus = ['partnumberdetail', 'csrdetail', 'createCSR', 'csrandvolumnsales'];
        if (!allowedMenus.includes(menuName) && selectedPicklistValueCSR.includes(selectedPicklistItems) ) {
            component.set("v.enteredTxt", '');
        }
       var selectedPicklistValue=['Dealer PO','Order Tracking','Part Availability'];
        if (allowedMenus.includes(menuName) && selectedPicklistValue.includes(selectedPicklistItems) ) {
            component.set("v.enteredTxt", '');
        }        
        
    },
    doInit : function(component, event, helper) {
        helper.FetchCartItems(component, event, helper);
        helper.getCsrToggle(component, event, helper);
    },

    handleSelection : function(component, event, helper) {
        
    },
    
    handleClick: function(component, event, helper) {
        var mainDiv = component.find('myDropdown');
        $A.util.addClass(mainDiv, 'show');
    },
    
    
    handleMouseOutButton : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var mainDiv = component.find('myDropdown');
                $A.util.removeClass(mainDiv, 'show');
            }), 200
        );
        
    },
    
    handlePicklist : function(component, event, helper) {
        component.set("v.selectedPicklistItem", event.currentTarget.value);
    },
    
    handleEntered : function(component, event, helper) {
        component.set("v.enteredTxt", event.currentTarget.value);
        if (event.keyCode === 13){
            helper.handleSearch(component, event, helper);
        }
    },
    
    handleEnteredValue : function(component, event, helper) {
        helper.handleSearch(component, event, helper);
        
    }
})