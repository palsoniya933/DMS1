({
    refresh : function(component, event, helper) {
        
        let selectedReport = component.get("v.selectedReport");
        let userDetail = component.get("v.userDetail");
        if(!$A.util.isUndefinedOrNull(selectedReport) && !$A.util.isEmpty(selectedReport)
          && selectedReport != 'Global Report'
          && !$A.util.isUndefinedOrNull(userDetail) && userDetail.accessibleDealersLocation.length > 0){
            //refrsh the selected report on ui
            component.set("v.selectedReport", '');
            helper.displaySelectedReportTile(component, event, helper, selectedReport);
        } 
    },
    
    handleReportSelection : function(component, event, helper) {
        
        var selectedRep = event.target.name;
        try{
            component.set("v.selectedReport",selectedRep);
        }catch(e){
            console.log("e ==>> "+e.message);
        }
    },
    
      
    
})