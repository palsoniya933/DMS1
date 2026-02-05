({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        
        //get today date in PST
        var todayDate = new Date();
        var pstDate = todayDate.toLocaleString("en-US", {timeZone: "America/Los_Angeles"});
        var pstDateString = pstDate.toString().split(",")[0];
        component.set("v.todayPSTDateString",pstDateString);
    },
	    
})