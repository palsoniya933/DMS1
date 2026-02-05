({
    doInit : function(component, event, helper) {
        //default selected column
        component.set("v.activeColumnName", "All");
        component.set("v.downloadFileName",$A.get("$Label.c.EDealer_CNR_Order"));    
        component.set("v.displayLoading",true);
        component.set('v.columns', [
            { label: $A.get('$Label.c.Return_Compliance'), fieldName: 'part', type: 'text', sortable: false },
            { label: $A.get('$Label.c.Edealer_PART_DESCRIPTION'), fieldName: 'partdescription', type: 'text', sortable: false },
            { label: $A.get('$Label.c.Saleable_Indicator'), fieldName: 'saleableindicator', type: 'text', sortable: false },
            { label: $A.get('$Label.c.Limit_Qty'), fieldName: 'limitqty', type: 'text', sortable: false },
        ]);  
        helper.fetchOrdersData(component, event, helper);
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
            
    getOrders:function(component, event, helper){
        var status = event.currentTarget.name;
        component.set("v.activeColumnName", status);
        var masterData = JSON.parse(component.get("v.masterData"));
        component.set("v.displayLoading",true);
        var tempOrderData = [];
        if(status!="All"){
            for(var i=0;i<masterData.length;i++){
                if(status==masterData[i].saleableindicator){
                    tempOrderData.push(masterData[i]);
                }else if(status=="" && masterData[i].saleableindicator!="CNR" && masterData[i].saleableindicator!="RSV"){
                    tempOrderData.push(masterData[i]);
                }
            }
        }else{
            tempOrderData=masterData; 
        }
        component.set("v.invData", tempOrderData);
        component.set("v.displayLoading",false);        
    }         
})