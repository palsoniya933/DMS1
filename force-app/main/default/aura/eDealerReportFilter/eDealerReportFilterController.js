({
    doInit : function(component, event, helper){
        
        // adding first filter
        helper.restFilter(component, event, helper);
    },
    
    clearFilter : function(component, event, helper){
        
        // adding blank filter
        helper.restFilter(component, event, helper);
    },
    
    setOperators : function(component, event, helper){
    }
    
})