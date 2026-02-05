({
    // showing text on select of options
    setInfoText: function(component, labels) {
        
        if (labels.length === 0) {
            component.set("v.infoText", $A.get("$Label.c.Select_Option"));
        }    
        
        if (labels.length === 1) {
            component.set("v.infoText", labels[0]);
        }  
        
        else if (labels.length > 1) {
           var selectedOptionText = $A.get("$Label.c.edealer_options_selected");	
            component.set("v.infoText", labels.length + " "+selectedOptionText);	
        }
        
    },
    
    
    // getting selected values
    getSelectedValues: function(component){
        var options = component.get("v.options");
        //console.log('options:='+options);
        var values = [];
        if(options!==undefined){
            options.forEach(function(element) {
                if (element.selected) {
                    values.push(element.Name);
                }
            });
        }
        return values;        
    },
    
    // getting selected labels
    getSelectedLabels: function(component){        
        var options = component.get("v.options");        
        var labels = [];        
        if(options!==undefined){            
            options.forEach(function(element) {                
                if (element.selected) {                    
                    labels.push(element.Name);                    
                }                
            });              
        }        
        return labels;        
    },
    
    
    // if we want to fire the event on change
    despatchSelectChangeEvent: function(component,values){        
        var compEvent = component.getEvent("selectChange");        
        compEvent.setParams({ "values": values });        
        compEvent.fire();        
    }
    
})