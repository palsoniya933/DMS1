({
	doInit : function(component, event, helper) {
		var oDetail = component.get("v.orderAndTrackDetails");
        if(oDetail.infoList != null && oDetail.infoList.length > 0){
            component.set("v.headerName", oDetail.name);
            component.set("v.orderInNumbers", oDetail.infoList[0].ordersNumber);
            component.set("v.isGood", oDetail.infoList[0].isPositive);
        }
	},
})