({
    doInit : function(component, event, helper) {
    },
    handleReportSelection : function(component, event, helper) {
        var selectedRep = event.target.name;
        try{
              console.log("selectedRep "+selectedRep);
            component.set("v.selectedReport",selectedRep);
        }catch(e){
            console.log("e ==>> "+e.message);
        }
    }
})