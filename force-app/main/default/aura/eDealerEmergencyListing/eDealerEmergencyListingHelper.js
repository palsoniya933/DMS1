({
    fetchOrdersData : function(component, event, helper) {
        var action;
        var selectedMenu = component.get("v.selectedMenu");
        var dealerCodeObj = component.get("v.dealerCode");
        var frequency = component.get("v.selectedoption");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(dealerCodeObj)){
            return;
        }
        helper.setFrequecy(component, event, helper);
        
        action = component.get("c.getEmergencyData");
        action.setParams({ 
            dealerCodes : dealerCodeObj.listSelectedLoc,                
            timeFrame : frequency,
            limits : 10000,
            offset : 0
            
        });
        action.setBackground();
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                // from the server
                var result = response.getReturnValue();
                component.set("v.invData", result.response);
                component.set("v.PaginationList", result.response);
                helper.setSummaryHeader(component, event, helper, result);
                
                component.set("v.languageTranslation", result.languageTranslation);
                console.log('result.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                
                helper.setGridColumns(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    setSummaryHeader : function(component, event, helper, result){
        var frequency = component.get("v.selectedoption");
        var kpiData = result.kpiDetails;
        
        if(frequency == "Week"){
            component.set("v.emergencyLines", kpiData.weekly_order.percent_emr_order);
            component.set("v.totalEmergencyOrders", kpiData.weekly_order.emergency_order);
            component.set("v.totalOrders", kpiData.weekly_order.total_order);
        }else if(frequency == "Month"){
            component.set("v.emergencyLines", kpiData.monthly_order.percent_emr_order);
            component.set("v.totalEmergencyOrders", kpiData.monthly_order.emergency_order);
            component.set("v.totalOrders", kpiData.monthly_order.total_order);
        }else if(frequency == "Quarter"){
            component.set("v.emergencyLines", kpiData.quaterly_order.percent_emr_order);
            component.set("v.totalEmergencyOrders", kpiData.quaterly_order.emergency_order);
            component.set("v.totalOrders", kpiData.quaterly_order.total_order);
        }else if(frequency == "Year"){
            component.set("v.emergencyLines", kpiData.yearly_order.percent_emr_order);
            component.set("v.totalEmergencyOrders", kpiData.yearly_order.emergency_order);
            component.set("v.totalOrders", kpiData.yearly_order.total_order);
        }else{
            component.set("v.emergencyLines", kpiData.two_yearly_order.percent_emr_order);
            component.set("v.totalEmergencyOrders", kpiData.two_yearly_order.emergency_order);
            component.set("v.totalOrders", kpiData.two_yearly_order.total_order);
        }
    },
    
    
    setFrequecy : function(component, event, helper){
        var frequency = component.get("v.selectedoption");
        if(frequency == "Week"){
            component.set("v.frequency", "Weekly");
        }else if(frequency == "Month"){
            component.set("v.frequency", "Monthly");
        }else if(frequency == "Quarter"){
            component.set("v.frequency", "Quarterly");
        }else if(frequency == "Year"){
            component.set("v.frequency", "Annually");
        }else{
            component.set("v.frequency", "All");
        }
        component.set("v.downloadFileName",$A.get('$Label.c.EDealer_Header_Emergency_Lines') +' '+ component.get("v.frequency"));  
    },
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        
        const colmunsDownloadData =[];
        
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
        }
        component.set("v.columnLabelByApiName",columns);
        component.set("v.columns",colmunsDownloadData);
    }
})