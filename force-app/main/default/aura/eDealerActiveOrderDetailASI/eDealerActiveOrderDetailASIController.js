({
    doInit : function(component, event, helper) {        
        helper.getActiveOrderData(component, event, helper);
    },
     handleActive: function (component, event, helper) {
        helper.loadTabs(component, event);
    },
    showCommentModal : function(component, event, helper) {
        component.set("v.showCommentModal", true);
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showCommentModal", false);
    },
    
    showLineCommentModal : function(component, event, helper) {
        try{
            var lineObj = event.getSource().get("v.name"); 
            var index = event.getSource().get("v.alternativeText");
            component.set("v.lineComm", lineObj.lineComm);
            component.set("v.selectedPartnumber", lineObj.itmid);
            component.set("v.selectedLineNumber", index /*(index + 1)*/);
            
            component.set("v.showLineCommentModal", true);
        }
        catch(ex){
            //alert(ex)
        } 
    },
    
    closeLineModal : function(component, event, helper) {
        component.set("v.showLineCommentModal", false);
    },
})