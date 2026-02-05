({

    // when components loaded
    init: function(component, event, helper) {
        console.log('options:::'+JSON.stringify(component.get("v.options")))
        var values = helper.getSelectedValues(component);
        helper.setInfoText(component, values);        
    },
 
	// when user clicks to show options
    handleClick: function(component, event, helper) {
        var mainDiv = component.find('main-div');
        $A.util.addClass(mainDiv, 'slds-is-open');
    },

 
    // method will be called when user select the option
    handleSelection: function(component, event, helper) {
        var item = event.currentTarget;   
        if(item.dataset.value == 'all'){
            let isAllSelected = component.get("v.isAllSelected");
            console.log("isAllSelected:::"+isAllSelected);
            component.set("v.isAllSelected",!isAllSelected);
            if (item && item.dataset) {
                var value = item.dataset.value;
                var selected = item.dataset.selected;
                var options = component.get("v.options");
                
                options.forEach(function(element) {
                    options.forEach(function(element) {
                        element.selected = !isAllSelected;
                    });
                });
                component.set("v.options", options);
                var values = helper.getSelectedValues(component);
                var labels = helper.getSelectedLabels(component);
                helper.setInfoText(component, labels);
                helper.despatchSelectChangeEvent(component, values);
            }
        }
        else{
            
            if (item && item.dataset) {
                var value = item.dataset.value;
                var selected = item.dataset.selected;
                var options = component.get("v.options");
                let isAllSelectedCount = 0;
                options.forEach(function(element) {
                    options.forEach(function(element) {                                                   
                        if (element.Name === value) {
                            element.selected = selected === "true" ? false : true;
                        }                        
                    });
                    if(element.selected){
                        isAllSelectedCount++;
                    } 
                });
                //console.log("isAllSelectedCount:::"+isAllSelectedCount);
                //console.log("options.length:::"+options.length);
                if(isAllSelectedCount==options.length){
                    component.set("v.isAllSelected",true);
                }else{
                    component.set("v.isAllSelected",false);
                }
                
                component.set("v.options", options);
                var values = helper.getSelectedValues(component);
                var labels = helper.getSelectedLabels(component);
                helper.setInfoText(component, labels);
                helper.despatchSelectChangeEvent(component, values);
            }  
        }
              
    }, 

    // hiding the option on mouse out
    handleMouseLeave: function(component, event, helper) {
        component.set("v.dropdownOver", false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
    },
	
    // whrn mouse enters to the multi select component
    handleMouseEnter: function(component, event, helper) {
        component.set("v.dropdownOver", true);
    },

 
	// hiding the option on mouse out
    handleMouseOutButton: function(component, event, helper) {

        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    
                    //if dropdown over, user has hovered over the dropdown, so don't close.
                    if (component.get("v.dropdownOver")) {
                        return;
                    }

                    var mainDiv = component.find('main-div');
                    $A.util.removeClass(mainDiv, 'slds-is-open');
                }
            }), 200
        );
    },
    
    handleRemove : function(component, event) {
        var indexNumber = event.getSource().get('v.name');
        var options = component.get('v.options');
        //make un-selected (means we are removing the pill)
		options[indexNumber].selected = false;
        //update options
        component.set('v.options', options);
        
    }

})