({
    currentUserDeatails_Apex : function(component, event, helper) {   
        
        var action = component.get("c.fetchLoggedInUserDetails");
        
        action.setBackground();
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.userDetail", response.getReturnValue());
                component.set("v.division",response.getReturnValue().division);
                helper.displaypage(component, event, helper);
                // handle order number use case
                if(helper.getJsonFromUrl().orderNum){                                     
                    helper.gotoPartDetailPage(component, event, helper);
                }
                // handle part number user case
                else if(helper.getJsonFromUrl().partNum){
                    helper.gotoPartDetailPage(component, event, helper);                        
                }
                
                // handler order listing use case
                else if(helper.getJsonFromUrl().orderlisting){                                
                    helper.gotoPartDetailPage(component, event, helper);                    
                }
                // handler csr listing use case
                else if(helper.getJsonFromUrl().csrlisting){       
                    
                    helper.gotoPartDetailPage(component, event, helper);                    
                }
                // handler csr detail use case
                else if(helper.getJsonFromUrl().csrdetail){
                    helper.gotoPartDetailPage(component, event, helper);
                }
                //handler draft csr listing use case
                else if(helper.getJsonFromUrl().draftcsrlist){
                    helper.gotoPartDetailPage(component, event, helper);
                }
                //Handler edit draft csr use case
                else if(helper.getJsonFromUrl().csredit){
                    helper.gotoPartDetailPage(component, event, helper);
                }
                
                // if no params which means default
                else{
                    component.set("v.selectedMenu","dashboardDemo");                        
                }
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    gotoPartDetailPage : function(component, event, helper){
        
        var userDetail =  component.get("v.userDetail");
        const queryString = window.location.search;        
        const urlParams = new URLSearchParams(queryString);        
        const division = urlParams.get('division');
        if(!$A.util.isUndefinedOrNull(userDetail) && !$A.util.isEmpty(division)  && userDetail.division != division){
            userDetail.division = division;
            component.set("v.userDetail", userDetail);
        }
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        
        if(!$A.util.isEmpty(sPageURL)){
            var sURLKey = sPageURL.split("=")[0]; 
            var sURLValue = sPageURL.split("=")[1];
            var queryParam = sPageURL.split("&");
            
            
            if(sURLKey == 'orderlisting'){
                var param1 = queryParam[0];
                var param2 = queryParam[1];

                var param3 = queryParam[2]
                var dealercodesvalue
                if(param1.split("=")[1] == 'manuallockdownparts'){
                     dealercodesvalue = param2.split("=")[1];
                }
                else if(param1.split("=")[1] == 'emergencyorderlisting'){
                     dealercodesvalue = param3.split("=")[1];
                }
                
                
                if(param2.split("=")[0] == "option"){
                    helper.updateSelectedOption(component, param2);
                }
                
                // for return compliance listing
                if(param2.split("=")[0] == "month"){
                    component.set("v.month",param2.split("=")[1]);
                    const monthDate = urlParams.get('monthDate');
                    component.set("v.monthDate", monthDate);
                }
                else if(param2.split("=")[0] == "quarter"){
                    component.set("v.quarter",param2.split("=")[1]);
                    const quarterDate = urlParams.get('quarterDate');
                    component.set("v.quarterDate", quarterDate);
                }
                else if(param2.split("=")[0] == "year"){
                    component.set("v.year",param2.split("=")[1]);
                }
                
                /*** get order type from url params ***/
                if(param2.split("=")[0] == "ordertype"){
                    helper.updateOrderType(component, param2);
                }else if(!$A.util.isUndefinedOrNull(queryParam[2])){
                    if(queryParam[2].split("=")[0] == "ordertype"){
                        helper.updateOrderType(component, queryParam[2]);
                    }
                } 
                
                var listselectedLoc = [];
                listselectedLoc.push(dealercodesvalue);
                component.set("v.selectedLocation.listSelectedLoc",listselectedLoc);
                component.set("v.selectedMenu", param1.split("=")[1]);
                component.set("v.calledFromOnLoad", true);
            }
            else if(sURLKey == 'orderNum'){
                component.set("v.orderNumber", sURLValue);
                component.set("v.selectedMenu", "activeordersdetail");
            }
            else if(sURLKey == 'csrlisting'){
                    
                var param1 = queryParam[0];
                var param2 = queryParam[1];
                var param3 = queryParam[2];
                var param4 = queryParam[3];
                var csrtype = param1.split("=")[1];
                
                var csrsubtype = param2.split("=")[1];
                var frequency = param3.split("=")[1];
                    var dealercodesvalue = param4.split("=")[1];
                console.log(param1);
                console.log(param2);
                console.log(param3);
                var listselectedLoc = [];
                listselectedLoc.push(dealercodesvalue);
                component.set("v.selectedMenu", 'csrlisting');
                component.set("v.csrlistingtype",csrtype); 
                component.set("v.csrlistingsubtype",csrsubtype); 
                component.set("v.csrlistingfrequency",frequency); 
                component.set("v.selectedLocation.listSelectedLoc",listselectedLoc);
                component.set("v.calledFromOnLoad", true);
                
            }
            else if(sURLKey == 'csrdetail'){
                var param1 = queryParam[0];
                var param2 = queryParam[1];
                var csrnumbervalue = param1.split("=")[1];
                var csrphasevalue = param2.split("=")[1];
                component.set("v.selectedMenu", 'createCSR');
                component.set("v.csrnumber", csrnumbervalue);
                component.set("v.csrphase", csrphasevalue);
                component.set("v.enableCsrEditing", false);
                component.set("v.calledFromOnLoad", true);
            }
            
            else if(sURLKey == 'csredit'){
                var param1 = queryParam[0];
                var param2 = queryParam[1];
                var csrnumbervalue = param1.split("=")[1];
                var csrphasevalue = param2.split("=")[1];
                component.set("v.selectedMenu", 'createCSR');
                component.set("v.csrnumber", csrnumbervalue);
                component.set("v.csrphase", csrphasevalue);
                component.set("v.enableCsrEditing", true);
                component.set("v.calledFromOnLoad", true);
                
            }
            else{
                component.set("v.partNumber", sURLValue);
                component.set("v.selectedMenu", "partdetail");
            }
        }
    },
    
    
    updateSelectedOption : function(component, urlParams) {
        if(urlParams.split("=")[1] == "Daily"){
            component.set("v.selectedoption", "Day");
        }
        else if(urlParams.split("=")[1] == "Weekly" || urlParams.split("=")[1] == "weekly" ){
            component.set("v.selectedoption", "Week");
        }
        else if(urlParams.split("=")[1] == "Monthly" || urlParams.split("=")[1] == "monthly"){
            component.set("v.selectedoption", "Month");
        }
        else if(urlParams.split("=")[1] == "Quarterly" || urlParams.split("=")[1] == "quaterly"){
            component.set("v.selectedoption", "Quarter");
        }
        else if(urlParams.split("=")[1] == "Annually" || urlParams.split("=")[1] == "yearly"){
            component.set("v.selectedoption", "Year");
        }
        else if(urlParams.split("=")[1] == "All" || urlParams.split("=")[1] == "Two Years" || urlParams.split("=")[1] == "twoyear"){
            component.set("v.selectedoption", "All");
        }
    },
    
    updateOrderType : function(component, urlParams) {
        if(urlParams.split("=")[1] == 'Truck'){
            component.set("v.orderType", "td");
        }
        else if(urlParams.split("=")[1] == 'Emergency'){
            component.set("v.orderType", "em");
        }
        else if(urlParams.split("=")[1] == 'Stock'){
            component.set("v.orderType", "st");
        }
        else if(urlParams.split("=")[1] == 'invoiceorders'){
            component.set("v.orderType", "Invoiceorder");
        }
        else if(urlParams.split("=")[1] == 'Cancelledorders'){
            component.set("v.orderType", "Cancelledorders");
        }else if(urlParams.split("=")[1] == 'Activeorders'){
            component.set("v.orderType", "Activeorders");
        }else if(urlParams.split("=")[1] == 'Backorders'){
            component.set("v.orderType", "Backorders");
        }
        else if(urlParams.split("=")[1] == 'All'){
            component.set("v.orderType", "All");
        }
        else{
            component.set("v.orderType", "all");
        }
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
    
    getJsonFromUrl : function () {
        var result = {};
        const searchParams = new URLSearchParams(location.search);

        searchParams.forEach(function(value,key) {
            
                const item0 = decodeURIComponent(key);
                const item1 = decodeURIComponent(value);
                result[item0] = item1; 
        });     
            
               
        console.log('result: '+JSON.stringify(result));
       
        return result; 
    },    
    getAccessibleDealerLocationForNonEdalerUsers : function(component, event, helper, locCode) {
        var action = component.get("c.getNonDealerAccessibleDealerLocations");
        action.setParams({ "dealerCode" : locCode });
        action.setBackground();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                let userDetail = component.get("v.userDetail");
                console.log('user details'+JSON.stringify(userDetail));
                if(!$A.util.isUndefinedOrNull(userDetail)){
                    userDetail = {};
                    userDetail.accessibleDealersLocation = [];
                }
                component.set("v.userDetail.accessibleDealersLocation", response.getReturnValue());
                helper.displaypage(component, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    displaypage : function(component, event, helper) {  
        let userDetail = component.get("v.userDetail");
        if(!$A.util.isUndefinedOrNull(userDetail)
        && !$A.util.isUndefinedOrNull(userDetail.accessibleDealersLocation)
        && userDetail.accessibleDealersLocation.length > 0
        && userDetail.isNonDealer == false){
            if(userDetail.accessibleDealersLocation[0].Dealer_Doe_Status__c != true){
                helper.showErrorToast(component, event, helper,"Your account is inactive, please contact your External Dealer Admin to get your account activated.");
            }
        }        
    }, 
     
    getFirstCode: function(component, list) {
        if (list && list.length > 0 && list[0].Name) {
            let fullName = list[0].Name; // "A875 MHC KENWORTH-LITTLE ROCK"
            let code = fullName.split(" ")[0]; // "A875"
            return code;
        }
        return null;
    }
})