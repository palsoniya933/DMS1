({
    doInit : function(component, event, helper) {
        //default slected column
        component.set("v.activeColumnName", "All");
        component.set("v.displayLoading",true);
        var orderType = component.get('v.orderType');
        if(orderType == 'all'){
            orderType = '';
        }
        if(!orderType
           && helper.getParams('ordertype')){
            component.set("v.orderType",helper.getParams('ordertype'))
        }
      
   let selectedFrequencies = component.get("v.selectedFrequencies"); 

        if(!selectedFrequencies){

            helper.getFrequencyTranslation(component, event, helper);

        }else{

            helper.fetchOrdersData(component, event, helper);

           // helper.fetchColumnDetailsData(component, event, helper);

        }    },
    
    openOrder : function(component, event, helper) {
        // fire event
        var orderNum = event.currentTarget.name;
        // Currently not working due to missing components
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
            "url": ("?orderNum="+orderNum+'&loc='+dealerCode+"&division="+dealerDivision),
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

  
    /*downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },*/
    
    /*downloadReportData : function(component, event, helper) {
        debugger;
        component.set("v.displayLoading",true);
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.fetchOrdersData(component, event, helper, true, offset);
        }
    },*/
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },
    
     getOrders:function(component, event, helper){
        var status = event.currentTarget.name;
        component.set("v.activeColumnName", status); 
        var masterData = JSON.parse(component.get("v.masterData"));
        component.set("v.displayLoading",true);
        var tempOrderData = [];
        if(status!="All"){
            //console.log("In If");
            for(var i=0;i<masterData.length;i++){
                if(status==masterData[i].orderstatus){
                    tempOrderData.push(masterData[i]);
                }
            }
        }else{
            //console.log("In else");
            tempOrderData=masterData;
        }
        //console.log("tempOrderData length::"+tempOrderData.length);
        component.set("v.invData", tempOrderData);
        component.set("v.displayLoading",false);        
    }        
    
})