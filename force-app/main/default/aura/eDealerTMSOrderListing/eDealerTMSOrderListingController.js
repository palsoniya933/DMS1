({
	doInit : function(component, event, helper) {
        component.set("v.displayLoading",true);
        let selectedMenu = component.get("v.selectedMenu");
        let downloadReportName;
        let frequency = component.get("v.selectedoption");
        
        if(selectedMenu == "intransitorders"){
            component.set('v.columns', [
                { label: 'Order#', fieldName: 'PPD_ORDER', type: 'text', sortable: false },
                { label: 'Status', fieldName: 'status', type: 'text', sortable: false },
                { label: 'PRO#', fieldName: 'PRO_NUM', type: 'text', sortable: false },
                { label: 'Pickup Date', fieldName: 'EST_PICKED_UP_DATE_PST', type: 'text', sortable: false },
                { label: 'Estimated Arrival', fieldName: 'EST_ARRIVAL_SF_DT', type: 'text', sortable: false }
            ]);
            
            downloadReportName = 'In_TransitOrders-'+ frequency; 
        }
        else if(selectedMenu == "deliveredorders"){
            component.set('v.columns', [
                { label: 'Order#', fieldName: 'PPD_ORDER', type: 'text', sortable: false },
                { label: 'Status', fieldName: 'status', type: 'text', sortable: false },
                { label: 'Pro', fieldName: 'PRO_NUM', type: 'text', sortable: false },
                { label: 'Estimated Arrival', fieldName: 'EST_ARRIVAL_SF_DT', type: 'text', sortable: false },
                { label: 'Delivered Date', fieldName: 'EST_DELIVERED_DATE_PST_DT', type: 'text', sortable: false }
            ]);
            
            downloadReportName = 'Shipments_DeliveredOrders-'+ frequency; 
        }
        else if(selectedMenu == "partsdeliverymetrics"){
            component.set('v.columns', [
                { label: 'Order#', fieldName: 'PPD_ORDER', type: 'text', sortable: false },
                { label: 'Status', fieldName: 'status', type: 'text', sortable: false },
                { label: 'Estimated Arrival', fieldName: 'EST_ARRIVAL_SF_DT', type: 'text', sortable: false },
                { label: 'Delivered Date', fieldName: 'DELIVERED_DATE_SF_DT', type: 'text', sortable: false }
            ]);
            
            downloadReportName = 'Shipment_Perf_MetricsOrders-'+ frequency;
        }
          
        //update the file name for upload 
        component.set('v.downloadReportName', downloadReportName);
		helper.fetchOrdersData(component, event, helper);
	},
    
    openOrder : function(component, event, helper) {
    	// fire event
        var orderNum = event.currentTarget.name;
        var menuEvent = $A.get("e.c:eDealerMenuClickedEvent");    
        menuEvent.setParams({
            "menuName" : "activeordersdetail",
            "orderNumber" : orderNum
        });
        menuEvent.fire();
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?orderNum="+partNum+'&loc='+dealerCode+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },
    
})