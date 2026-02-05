({
    doInit : function(component, event, helper) {
        //default slected coumn
        component.set("v.activeColumnName", "All");
        //show spinner
        component.set("v.displayLoading",true);
        component.set("v.masterData", []);
        component.set("v.invData", []);
        
        helper.fetchOrdersData(component, event, helper);
    },
    
   getOrders:function(component, event, helper){
        var status = event.currentTarget.name;
              var status = event.currentTarget.name;
        component.set("v.activeColumnName", status);
        var masterData = component.get("v.masterData");
        component.set("v.displayLoading",true);
        var tempOrderData = [];
        if(status != "All"){
            for(var i=0;i<masterData.length;i++){
                if(masterData[i].is_true == 1){
                    tempOrderData.push(masterData[i]);
                }
            }
        }else{
            tempOrderData=masterData;
            
        }
        console.log("tempOrderData length::"+tempOrderData.length);
        component.set("v.invData", tempOrderData);
        component.set("v.displayLoading",false);        
    },
    
    downloadReportData : function(component, event, helper) {
        var childComponent = component.find("downloadcmp");
        var message = childComponent.downloadExcel(JSON.stringify(component.get("v.invData")));
    },
    
})