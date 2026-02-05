({ 
    doInit: function(component, event, helper) {
        helper.checkUserPermissions(component);
    },
    handleReportSelection : function(component, event, helper) {
        var selectedRep = event.target.name;
        console.log(selectedRep);
        try{
            component.set("v.selectedReport",selectedRep);
        }catch(e){
            console.log("e ==>> "+e.message);
        }
        console.log(selectedRep);
    },
})