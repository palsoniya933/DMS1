({
	fetchReturnComplianceData : function(component, event, helper) {
        //list of dealer location
         var listDealerLoc;
        //selected loc/dealer code
        var selLocationObj = component.get("v.selectedLocation");
        
        if(!$A.util.isUndefinedOrNull(selLocationObj)){
            listDealerLoc = selLocationObj.listSelectedLoc;
        }
        
       
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(listDealerLoc) || $A.util.isEmpty(listDealerLoc)){
                return;
        }

        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.fetchAWSReturnsComplianceKPIData"); 
        action.setParams({
            "dealerCodes" : listDealerLoc,
            "division" : component.get("v.divisionType")
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
               
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                }else{
                    component.set("v.returnComplianceData", resultData.response);
                    //update cache
                    if(!$A.util.isUndefinedOrNull(resultData.response)){
                        //helper.updateReturnComplianceCacheDetails(component, event, helper);
                    }
                    //update U.I.
                    helper.updatePicklistOptionsData(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            //Hide spinner
            component.set("v.displayLoading", false);
        });
        $A.enqueueAction(action);
		
	},
    
    updatePicklistOptionsData : function(component, event, helper) {
        //monthly/quaterly/yearly
        var selectedOption = component.get("v.selectedoption");
        var returnComplianceData = component.get("v.returnComplianceData");
        var listOfPicklistOptions = [];
        var rcUIDataDefault;
        
        if(!$A.util.isUndefinedOrNull(returnComplianceData)){
            if(selectedOption == 'monthly' && !$A.util.isUndefinedOrNull(returnComplianceData.month_data)){
                var lstMonthly = returnComplianceData.month_data;
                for(var i=0;i<lstMonthly.length;i++){
                    if(lstMonthly[i].suggested_month_create_date != undefined){
                        var opt = {};
                        opt.value = lstMonthly[i].suggested_month_create_date;
                        opt.label = helper.getMonthName(lstMonthly[i].suggested_month) + ' ' + lstMonthly[i].suggested_year;
                        listOfPicklistOptions.push(opt);
                        rcUIDataDefault = (rcUIDataDefault == undefined) ? lstMonthly[i] : rcUIDataDefault;
                    }
                }
            }else if(selectedOption == 'quaterly'  && !$A.util.isUndefinedOrNull(returnComplianceData.quarter_data)){
                var lstQuarterly = returnComplianceData.quarter_data;
                for(var i=0;i<lstQuarterly.length;i++){
                    if(lstQuarterly[i].suggested_quarter_create_date != undefined){
                        var opt = {};
                        opt.value = lstQuarterly[i].suggested_quarter_create_date;
                        opt.label = helper.getQuarterName(lstQuarterly[i].suggested_quarter) + ' ' + lstQuarterly[i].suggested_year;
                        listOfPicklistOptions.push(opt);
                        rcUIDataDefault = (rcUIDataDefault == undefined) ? lstQuarterly[i] : rcUIDataDefault;
                    }
                }
            } 
            else if(selectedOption == 'yearly' && !$A.util.isUndefinedOrNull(returnComplianceData.previous_year_data)){
                var lstYearly = returnComplianceData.previous_year_data;
                for(var i=0;i<lstYearly.length;i++){
                    if(lstYearly[i].suggested_year != undefined){
                        var opt = {};
                        opt.value = lstYearly[i].suggested_year;
                        opt.label = lstYearly[i].suggested_year;
                        listOfPicklistOptions.push(opt);
                        rcUIDataDefault = (rcUIDataDefault == undefined) ? lstYearly[i] : rcUIDataDefault;
                    }
                }
            } 
            else if(selectedOption == 'annually' && !$A.util.isUndefinedOrNull(returnComplianceData.current_year_data)){
                var lstYearly = returnComplianceData.current_year_data;
                for(var i=0;i<lstYearly.length;i++){
                    if(lstYearly[i].suggested_year != undefined){
                        var opt = {};
                        opt.value = lstYearly[i].suggested_year;
                        opt.label = lstYearly[i].suggested_year;
                        listOfPicklistOptions.push(opt);
                        rcUIDataDefault = (rcUIDataDefault == undefined) ? lstYearly[i] : rcUIDataDefault;
                    }
                }
            } 
        }
        
        component.set('v.lstOptions', listOfPicklistOptions);
        if(rcUIDataDefault == undefined){
            rcUIDataDefault = {};
        }
        component.set('v.rcUIData', rcUIDataDefault);
    },
        
    getMonthName : function(monInt) {
        if(monInt == 1){
            return 'Jan';
        }else if(monInt == 2){
            return 'Feb';
        }else if(monInt == 3){
            return 'Mar';
        }else if(monInt == 4){
            return 'Apr';
        }else if(monInt == 5){
            return 'May';
        }else if(monInt == 6){
            return 'Jun';
        }else if(monInt == 7){
            return 'Jul';
        }else if(monInt == 8){
            return 'Aug';
        }else if(monInt == 9){
            return 'Sep';
        }else if(monInt == 10){
            return 'Oct';
        }else if(monInt == 11){
            return 'Nov';
        }else if(monInt == 12){
            return 'Dec';
        }else{
            return undefined;
        }
        
    },
    
    getQuarterName : function(monInt) {
        if(monInt > 0 && monInt < 4){
            return 'Q1';
        }else if(monInt > 3 && monInt < 7){
            return 'Q2';
        }else if(monInt > 6 && monInt < 10){
            return 'Q3';
        }if(monInt > 9 && monInt <= 12){
            return 'Q4';
        }else{
            return undefined;
        }
        
    },
    
    updateReturnComplianceCacheDetails : function(component, event, helper) {
        let cacheMap = component.get("v.returnComplianceMapCache");
        if($A.util.isUndefinedOrNull(cacheMap)){
            cacheMap = new Map();        }
        
        //selected loc/dealer code
        var locCode = component.get("v.dealerLoc");
        var order = component.get("v.returnComplianceData");
        
        cacheMap.set(locCode, order);
        
        //update cache for emergency lines
        component.set("v.returnComplianceMapCache", cacheMap);
    },
    
    defaultSelectedOption : function(component) {
        debugger;
        component.set("v.rcUIData", undefined);
        component.set("v.returnComplianceData", undefined);
        component.set("v.lstOptions", []);
        component.set("v.selectedoption", "monthly");
        /*component.set("v.suggestedReturns", 0);
        component.set("v.sumOfAllReturns", 0);
        component.set("v.valueOfAllReturns", 0.00);
        component.set("v.suggestedCompliancePercentage", 0.00);*/
    },
    
    
})