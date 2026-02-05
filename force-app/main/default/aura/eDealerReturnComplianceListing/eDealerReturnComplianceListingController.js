({
    doInit : function(component, event, helper) {
        component.set("v.displayLoading",true);
        component.set("v.masterData", []);
        component.set("v.invData", []);
        var frequency = '';
        var month = component.get("v.month");    
        var quarter = component.get("v.quarter");    
        var year = component.get("v.year"); 
        if(!$A.util.isEmpty(month)){
            frequency = helper.setFullMonthName(component, event, helper);     
            component.set("v.fullMonth", 'Month - '+helper.setFullMonthName(component, event, helper));
        }else if(!$A.util.isEmpty(quarter)){
            frequency = "Quarter - "+quarter;
        }else if(!$A.util.isEmpty(year)){
            frequency = "Year - "+year;
        }
        component.set("v.frequency",frequency);
        component.set("v.downloadReportName",$A.get('$Label.c.Return_Compliance') +' '+frequency);  
        
        helper.fetchOrdersData(component, event, helper);
    },
    
   getOrders : function(component, event, helper){
        var status = event.currentTarget.name;
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
        component.set("v.invData", tempOrderData);
        component.set("v.displayLoading",false);        
    },
    
    downloadReportData : function(component, event, helper) {
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.fetchOrdersData(component, event, helper, true, offset);
        }
    },
    
})