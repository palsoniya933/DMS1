({
    checkDataInCacheOtherWiseFatchData : function(component, event, helper) {
        //getting cache
        let cacheMap = component.get("v.daysOnHandMapCache");
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        if($A.util.isUndefinedOrNull(locCode)){
            return locCode;
        }
        
        //check selected loc/dealer data in cache
        if(!$A.util.isUndefinedOrNull(cacheMap) && !$A.util.isUndefinedOrNull(locCode) && cacheMap.has(locCode)){
            var orderDetail = cacheMap.get(locCode);
            component.set("v.daysOnHandData", orderDetail);
            helper.updateTileUIData(component, event, helper);
            
        }else{
            //fatch the data
            helper.fetchDaysOnHandDetail(component, event, helper);
        }
    },
    
    fetchDaysOnHandDetail : function(component, event, helper) {
        var locCode;
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        if($A.util.isUndefinedOrNull(locCode)){
            return locCode;
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.fetchAWSDaysOnHandData");
        action.setParams({
            "dealerCode" : locCode,
            "division" : component.get("v.currentDealerDivision")             
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);            
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                //alert(resultData);
                //alert(resultData.response);
                //alert(resultData.response.length);
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                }
                else if(!$A.util.isEmpty(resultData.response) 
                        && resultData.response.length > 0){
                    component.set("v.daysOnHandData",resultData.response)
                    
                    // update tile data
                    helper.updateTileUIData(component, event, helper);
                    
                    //update cache
                    helper.updateCacheDetails(component, event, helper);
                }                
            }
            else {
                console.log("Failed with state: " + state);
            }            
        });
        $A.enqueueAction(action);
        
    },
    
    updateCacheDetails : function(component, event, helper) {
        let cacheMap = component.get("v.daysOnHandMapCache");
        if($A.util.isUndefinedOrNull(cacheMap)){
            cacheMap = new Map();        }
        
        
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        if($A.util.isUndefinedOrNull(locCode)){
            return locCode;
        }
        var order = component.get("v.daysOnHandData");
        
        cacheMap.set(locCode, order);
        
        //update cache for days On Hand
        component.set("v.daysOnHandMapCache", cacheMap);
    },
    
    defaultSelectedOption : function(component) {
        component.set("v.selectedoption", "monthly");
        component.set("v.totalDays", 0);
    },
    
    updateTileUIData : function(component, event, helper) {        
        var isEngine = component.get("v.isEngine");
        var daysOnHandData = component.get("v.daysOnHandData");
        var uiData;
        
        if(!$A.util.isUndefinedOrNull(daysOnHandData) 
           && daysOnHandData.length > 0){
            for(var i=0;i<daysOnHandData.length;i++){
                if(isEngine == false
                   && daysOnHandData[i].parts_type == 'NON ENGINE'){
                    uiData = daysOnHandData[i]; 
                }
                if(isEngine == true
                   && daysOnHandData[i].parts_type == 'ENGINE'){
                    uiData = daysOnHandData[i];  
                }
            }
        }        
        console.log("uiData == >> "+JSON.stringify(uiData));
        component.set("v.daysOnHandDisplaydata", uiData); 
        
    }
    
    
})