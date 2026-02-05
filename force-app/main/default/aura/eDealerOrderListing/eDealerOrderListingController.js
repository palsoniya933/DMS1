({
    doInit : function(component, event, helper) {       
        
        //default value to show selected column 
        component.set("v.activeColumnName", "All");
        // Display the selected menu value
        console.log('Selected Menu on Init:', component.get("v.selectedMenu"));
         
        if (component.get("v.selectedMenu") == 'pendingorders') {
            component.set("v.downloadFileName", $A.get("$Label.c.EDealer_Menu_Back_Orders"));
        } else if (component.get("v.selectedMenu") == 'unconfirmedorders') {
            component.set("v.downloadFileName", $A.get("$Label.c.Edealer_Unconfirmed_Order"));
        } else {
            component.set("v.downloadFileName", $A.get("$Label.c.EDealer_Menu_Active_Orders"));
        }

        component.set("v.displayLoading", true);
        component.set("v.masterData", []);
        component.set("v.invData", []);
        component.set("v.PaginationList", []);
        component.set("v.totalOrders", 0);
        
        let selectedFrequencies = component.get("v.selectedFrequencies"); 
        if(!selectedFrequencies){
            helper.getFrequencyTranslation(component, event, helper);
        }else{
            helper.fetchOrdersData(component, event, helper);
        	helper.fetchColumnDetailsData(component, event, helper);
        }
    },

    openOrder : function(component, event, helper) {
        // Fire event
        var orderNum = event.currentTarget.name;a
        //Chito 10/20/2025 based on debug, these line of codes are not working. Missing component to execute IR 
        //var menuEvent = $A.get("e.c:eDealerMenuClickedEvent"); 
        //menuEvent.setParams({
        //    "menuName" : "activeordersdetail",
        //    "orderNumber" : orderNum
        //});
        //menuEvent.fire();
        var dealerCode = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        console.log('Order Number '+orderNum+', '+'Dealer Code '+dealerCode+' , '+'Division '+dealerDivision);    //Chito 10/20/2025  Debug
        urlEvent.setParams({
            "url": ("?orderNum=" + orderNum + '&loc=' + dealerCode + "&division=" + dealerDivision),
            "isredirect": true
        });
      
        urlEvent.fire();        
    }, 
    
    handleOpenInNewWindow : function(component, event, helper) {
        var orderNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        console.log('Order Number '+orderNum+', '+'Dealer Code '+dealerCode+' , '+'Division '+dealerDivision);    //Chito 10/20/2025  Debug
        urlEvent.setParams({
            "url": ("?orderNum=" + orderNum + '&loc=' + dealerCode + "&division=" + dealerDivision),
            "isredirect": true
        });
      
        urlEvent.fire();
    },

    downloadReportData : function(component, event, helper) {
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.fetchOrdersData(component, event, helper, true, offset);
        }
    },
    getOrders: function(component, event, helper) {
        var status = event.currentTarget.name;
        component.set("v.activeColumnName", status);
        
        var masterData = JSON.parse(component.get("v.masterData"));
        component.set("v.displayLoading", true);
        var tempOrderData = [];
        if (status != "All") {
            for (var i = 0; i < masterData.length; i++) {
                if (status == masterData[i].ordertype) {
                    tempOrderData.push(masterData[i]);
                } else if (status == "" && masterData[i].ordertype != "Truck Down" && masterData[i].ordertype != "Emergency Order" && masterData[i].ordertype != "Stock Order") {
                    tempOrderData.push(masterData[i]);
                }
            }
        } else {
            tempOrderData = masterData;
        }
        component.set("v.invData", tempOrderData);
        component.set("v.displayLoading", false);        
    },
})