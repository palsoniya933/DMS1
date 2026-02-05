({
    fetchOrdersData : function(component, event, helper) {
        var dealerCode = component.get("v.dealerCode");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(dealerCode)){
            return;
        }
        
        var action = component.get("c.getManualLockdownOrders");
        action.setParams({ 
            "dealerCodes" : dealerCode.listSelectedLoc
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
                if(!$A.util.isUndefinedOrNull(result)){
                    if(!$A.util.isUndefinedOrNull(result.response)){
                        component.set("v.masterData", result.response);
                        component.set("v.invData", result.response);
                        component.set("v.totalParts", result.response.length);
                        
                        component.set("v.languageTranslation", result.languageTranslation);
                        console.log('result.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                        let totalExpiring = 0;
                        
                        //calculating expiring in a month
                        for(var i=0;i<result.response.length;i++){
                            if(result.response[i].is_true == 1){
                                totalExpiring++;
                            }
                        }
                        component.set("v.expiringInMonthParts", totalExpiring);
                    }else{
                        component.set("v.totalParts", 0);
                        component.set("v.expiringInMonthParts", 0);
                    }
                    
                    helper.setGridColumns(component, event, helper);
                }else{
                    component.set("v.totalParts", 0);
                    component.set("v.expiringInMonthParts", 0);
                }
                
            }else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
                // do something
            }else if (state === "ERROR") {
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
    
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        // var tableData = component.get("v.tableData");
        const colmunsDownloadData =[];
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
        }
        component.set("v.columns",colmunsDownloadData);
        component.set("v.columnLabelByApiName",columns);
    }
    
})