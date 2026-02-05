({
    doInitHelper : function(component, event, helper) {
        component.set("v.partsList", undefined);
        component.set("v.totalOrderSelected", 0);
        component.set("v.offset_value", 0);
        component.set("v.searchKeyword", undefined);
        component.set("v.lastRefreshDate", undefined);
        component.set("v.totalInventroyLines", 0);
        console.log("doInitHelper master inventory");
        helper.fetchMasterInventoryPartsDetails(component, event, helper, undefined, false);
    },
    
    
    fetchMasterInventoryPartsDetails : function(component, event, helper, searchKeyword, isaddMore) {
        console.log("fetchMasterInventoryPartsDetails master inventory");
        var locCode = component.get("v.dealerCode");
        var division = component.get("v.currentDealerDivision");
        var recordLimit = component.get("v.recordLimit");
        var offset = component.get("v.offset_value");
        
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(division)){
            return;
        }
        
        //show spinner
        component.set("v.displayLoading",true);
     	
        var action = component.get("c.getMasterInvParts");
        action.setParams({
            "dealerCode" : locCode,
            "division" : division,
            "offSet" : offset,
            "recordLimit" : recordLimit,
            "searchText":searchKeyword
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.responseReceived",true);
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("resultData master inventory:::"+JSON.stringify(resultData));
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response)){
                    if(isaddMore == true){
                        var partsList = component.get("v.partsList");
                        partsList = partsList.concat(resultData.response);
                        component.set("v.partsList", partsList);
                    }else{
                       component.set("v.partsList", resultData.response); 
                    }
                    component.set("v.languageTranslation", resultData.languageTranslation);
                    console.log("partsList master inventory:::"+JSON.stringify(component.get("v.partsList")));
                    component.set("v.totalInventroyLines", resultData.record_count);
                    component.set("v.lastRefreshDate", resultData.refresh_date);
                    component.set("v.offset_value", resultData.offset_value);
                    helper.setGridColumns(component, event, helper);
                    //component.set("v.dealerCurrencyCode", resultData.dealerCurrencyCode);
                }              
                
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
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    
  
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        var tableData = component.get("v.tableData");
        
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
    },
    
    AddPartsinCart : function(component, event, helper, isEM) {
        //show spinner
        component.set("v.displayLoading",true);
     	
        var action = component.get("c.createSOMasterinventroyParts");
        action.setParams({
            "dealerCode" : component.get("v.dealerCode"),
            "mipList": component.get("v.partsList"),
            "isEmergencyOrder" : isEM
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
                //Show Modal for Selected items now in cart
                if(isEM == true){
                    component.set("v.showEmergencyOrderAddCartModal", true);
                }else{
                    component.set("v.showStockOrderAddCartModal", true);
                }
                
                //hide spinner
                component.set("v.displayLoading",false);
                //event to update cart details (on Header)
                var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
                menuEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " +errors[0].message);
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error!",
            "type": "error",
            "message": message
        });
        toastEvent.fire();
	},
    
})