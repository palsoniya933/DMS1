({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        helper.getAllPartsReportName(component, event, helper);
    },
	      
    refresh : function(component, event, helper){
        //get updated suggested orders
        helper.doInitHelper(component, event, helper);
        helper.getAllPartsReportName(component, event, helper);
    },

    nameOfAllPartsReport : function(component, event, helper){
    helper.getAllPartsReportName(component, event, helper);
	},

})