({
	getReportData : function(component, event, helper) { 
        var locCode = component.get("v.dealerLoc");
        console.log('locCode::'+locCode);
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        var action = component.get("c.getQuarterToDateTileTableData");
        action.setParams({
            "dealerCode" : locCode
        });
        
        action.setBackground();
        action.setCallback(this, function(response) {   
            var state = response.getState();
            if (state === "SUCCESS") {
              
                var reportData = response.getReturnValue(); 
                component.set("v.reportTableData", reportData);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
 
   checkDataInCacheOtherWiseFetchData : function(component, event, helper) {
        var locCode = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        //getting cache
        let cacheMap = component.get("v.quarterToDateReportDataMapCache");
        //check selected loc/dealer data in cache
        if(!$A.util.isUndefinedOrNull(cacheMap) && !$A.util.isUndefinedOrNull(locCode) && cacheMap.has(locCode)){
            var orderDetail = cacheMap.get(locCode);
            component.set("v.quarterToDateReportData", orderDetail);
        }else{
            //fatch the data
            helper.getTileData(component, event, helper);
        }
    },    
    
	getTileData : function(component, event, helper) {  
        var locCode = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        var lstDealers = [];
        lstDealers.push(locCode);
        
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.fetchAWSQuarterToDateReportData");
        action.setBackground();
        action.setParams({
            "dealerCodes" : JSON.stringify(lstDealers),
            "division" : component.get("v.currentDealerDivision"),
            "year":component.get("v.currentYear"),
            "quarter":component.get("v.currentQuarter")
        });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                   // helper.showErrorToast(component, event, helper, resultData.error);
                }else{
                    component.set("v.quarterToDateReportData", resultData.response);
                    //update cache
                	helper.updateCacheDetails(component, event, helper);
                } 
            }
            else {
                //console.log("Failed with state: " + state);
            }
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    updateCacheDetails : function(component, event, helper) {
        let cacheMap = component.get("v.quarterToDateReportDataMapCache");
        if($A.util.isUndefinedOrNull(cacheMap)){
            cacheMap = new Map();       
        }
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        var order = component.get("v.quarterToDateReportData");
        
        cacheMap.set(locCode, order);
        //update cache 
        component.set("v.quarterToDateReportDataMapCache", cacheMap);
    },
    
    defaultTileDetails : function(component, event, helper) {
        component.set("v.availability", 0);
        component.set("v.breadth", 0);
        component.set("v.autoacceptutil",0);     // MDI Tier Level Changes 07/27/2023
        component.set("v.trendingTier", undefined);
        component.set("v.currentTier", undefined);
    },
    
})