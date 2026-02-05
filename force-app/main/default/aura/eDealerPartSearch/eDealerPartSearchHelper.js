({
    fetchPartAvailabilityDetail : function(component, event, helper) {
        var searchKey = component.get("v.partNumber");
        var locCode = component.get("v.dealerCode");
        var division = component.get("v.division");
        var recordLimit="10";        
        var offset =0;
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.getPartAvailable");
        action.setParams({
            "dealerCode" : locCode,
            "division" : division,            
            "searchText" : searchKey
        });
        
        action.setCallback(this, function(response) {
            component.set("v.displayLoading",false);
            var state = response.getState();
            component.set("v.responseReceived", true);
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
                if(result != undefined && result.response != undefined){
                    component.set("v.partavailableData", result.response);
                    console.log("partavailableData::"+result.response);
                    component.set("v.languageTranslation", result.languageTranslation);
                    helper.setGridColumns(component, event, helper);
                }
                 
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
        //var tableData = component.get("v.tableData");
        
        var languageTranslation = component.get("v.languageTranslation");
        var sortlanguageTranslation = {};
        for (let [key, value] of Object.entries(languageTranslation)) {
            sortlanguageTranslation[value.order] = value.columnAPIName;
            //columns.push({key:key,value:value.label});            
        }
        console.log('sortlanguageTranslation:::'+JSON.stringify(sortlanguageTranslation));
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(sortlanguageTranslation)) {
            //languageTranslation[value] = value.columnAPIName;
            columns.push({key:value,value:languageTranslation[value].label});        
        }
        console.log('columns:::'+JSON.stringify(columns));        
        
        /*const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            
        }
        console.log('columns2:::'+JSON.stringify(columns));*/
       component.set("v.columnLabelByApiName",columns);
    }
   
    
})