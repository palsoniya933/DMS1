({
    fetchSearchOrdersDetail : function(component, event, helper) {
        var searchKey = component.get("v.orderNumber");
        var locCode = component.get("v.dealerCode");
        //var division = component.get("v.division");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(searchKey)){
            return;
        }
        
        var action = component.get("c.searchOrders");
        action.setParams({
            "dealerCode" : locCode,           
            "searchText" : searchKey
        });
        
        action.setCallback(this, function(response) {
            component.set("v.displayLoading",false);
            var state = response.getState();
            component.set("v.responseReceived", true);
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
                if(result != undefined && result.response != undefined){
                    component.set("v.searchedOrdersData", result.response);
                    //9-08
                    component.set("v.languageTranslation", result.languageTranslation);
                    console.log('resultData.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                }
                  helper.setGridColumns(component, event, helper);
            }
            else if(state === "ERROR") {
               // console.log("Failed with state: " + state);
               // console.log('Error : '+ response.getError()[0].message);
            }
            else{
               // console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
       // var tableData = component.get("v.tableData");
        
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            
        }
        console.log('.columns:::'+columns);
       component.set("v.columnLabelByApiName",columns);
    }
})