({
    Init: function(component, event, helper) {
        var today = new Date(); 
        var yyyy = today.getFullYear();
        var mm = today.getMonth() + 1;
        component.set("v.year",yyyy);
        component.set("v.month",mm);
        helper.fetchURLLinks(component, event, helper);        
    }
});