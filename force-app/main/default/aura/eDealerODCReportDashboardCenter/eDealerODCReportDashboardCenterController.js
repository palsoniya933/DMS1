({
    doInit : function(component, event, helper) {
        
        var options = {year: '2-digit'};
        var today = new Date();
        var currentYear = today.toLocaleDateString("en-US", options);
        component.set('v.currentYear',currentYear);
        
        var getLastYear = new Date(today.getFullYear( )- 1, today.getMonth(), today.getDate());
        var lastYear = getLastYear.toLocaleDateString("en-US", options);
        component.set('v.lastYear',lastYear);
      
    },
    
    fetchReportData : function(component, event, helper) {
        helper.getOPCReportData(component, event, helper,true);
    },
    
    handleToFilterChange : function(component, event, helper) {
        var fromLocList = event.getSource().get("v.value") ;
        console.log('fromLocList'+fromLocList);
		
         var fromCode = event.getSource().get("v.value") ;
        
        if(fromLocList  != ''){
            component.set("v.disabledCode",false);
            component.set("v.setYear",fromLocList);
        }else{
            component.set("v.disabledCode",true);
            component.set("v.disabledReportButton",true);
        } 
    },
    
     handleToFilterChange2 : function(component, event, helper) {
        var fromLocList = event.getSource().get("v.value") ;
        console.log('fromLocList'+fromLocList);
		
         var fromCode = event.getSource().get("v.value") ;
        
        if(fromLocList  != ''){
            component.set("v.disabledReportButton",false);
            component.set("v.setCode",fromLocList);
        }else{
            component.set("v.disabledReportButton",true);
        } 
    },
    
    handleToFilterChange3 : function(component, event, helper) {
        var fromLocList = event.getSource().get("v.value") ;
        console.log('fromLocList'+fromLocList);
		
         var fromCode = event.getSource().get("v.value") ;
        
        if(fromLocList  != ''){
            component.set("v.CustEnter",fromLocList);
        }
    },
    
    handleReportSelection : function(component, event, helper) {
        
        var selectedRep = event.target.name;
        try{
            component.set("v.selectedReport",selectedRep);
        }catch(e){
            console.log("OPC report error ==>> "+e.message);
        }
    },
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        console.log('JSON.stringify(component.get("v.invData")'+JSON.stringify(component.get("v.invData")));
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    }
})