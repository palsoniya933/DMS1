({
    doInit : function(component, event, helper) {
        var data  = component.get('v.invData');
        var header = component.get('v.columnAPIName');
        component.set('v.cellValue',data[header]);
    },

})