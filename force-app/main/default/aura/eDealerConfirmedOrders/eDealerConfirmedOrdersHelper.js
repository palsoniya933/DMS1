({
    fetchConfirmedOrders : function(component, event, helper) {
        //show Spinner
        component.set("v.displayLoading",true);
        var dealerCode = component.get('v.dealerCode');  
        var divisionCode = component.get('v.division');
        var action = component.get("c.fetchEDealerConfirmedOrders");        
        component.set("v.APICalled",false);
        
        action.setParams({
            "dealerCode": dealerCode,
            "division" : divisionCode
        });
        
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else{
                    if($A.util.isUndefinedOrNull(resultData.response)){
                        //helper.showErrorToast(component, event, helper, 'No record found');
                    }else{
                        component.set("v.PaginationList", resultData.response);
                        component.set("v.tableData", resultData.response);
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                        if(!$A.util.isUndefinedOrNull(resultData.summary)){
                            
                            component.set("v.summary", resultData.summary[0]);
                        }
                    }
                }
                helper.setGridColumns(component, event, helper);
            }
            else {
                // console.log("Failed with state: " + state);
                // console.log(response.getError());
            }
            
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
  
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        var tableData = component.get("v.tableData");
        
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            
        }
       component.set("v.columnLabelByApiName",columns);
    }
})