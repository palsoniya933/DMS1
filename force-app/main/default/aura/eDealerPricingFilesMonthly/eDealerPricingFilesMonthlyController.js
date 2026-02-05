({
    Init: function(component, event, helper) {
        var today = new Date();        
        var yyyy = today.getFullYear();
        component.set("v.year",yyyy);
        helper.fetchURLLinks(component, event, helper);        
    }
});