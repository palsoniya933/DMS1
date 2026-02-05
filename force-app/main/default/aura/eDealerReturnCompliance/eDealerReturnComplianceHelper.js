({
    
    // this method will be used to get the location picklist onload of the component
    getDealerLocations : function(component, event, helper) { 
        var accessibleDealersLoctionsList = component.get("v.accessibleDealersLocs");
        
        // this will save all the dealer code
        var allCodes = [];
        
        for (var i=0;i<accessibleDealersLoctionsList.length;i++) {
            if($A.util.isEmpty(accessibleDealersLoctionsList[i].Sub_Code__c)){
                var obj = {};
                obj.Name = accessibleDealersLoctionsList[i].ASI_Dealer_Code__c;
                obj.selected = false;
                obj.display = true;
                allCodes.push(obj);
            }
        }
        component.set("v.fromLocList", allCodes);
    },
    
    getMonthTranslations : function(component, event, helper) {
        var action = component.get("c.getMonthsTranslation");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.monthsNameTranslation", response.getReturnValue());
                ///alert("From server: " + response.getReturnValue());
                helper.getMonthYearQuarterData(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
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
        });
        $A.enqueueAction(action);
    },

    
    getMonthYearQuarterData : function(component, event, helper) {
        var today = new Date();
        const month = today.toLocaleString('default', { month: 'short' });
        const year = today.getFullYear();
        const quarter = Math.floor((today.getMonth() + 3) / 3);
        
        var monthsNameTranslation = component.get("v.monthsNameTranslation");
        
        var date = new Date();
        var months = [],
            monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
        for(var i = 0; i < 12; i++) {
            //months.push(monthNames[date.getMonth()] + ' ' + date.getFullYear());
            var mObj = {};
            
            console.log(monthsNameTranslation[monthNames[date.getMonth()]]);
            if(!$A.util.isUndefinedOrNull(monthsNameTranslation) && !$A.util.isUndefinedOrNull(monthsNameTranslation[monthNames[date.getMonth()]]) ){
                mObj.label = monthsNameTranslation[monthNames[date.getMonth()]] + ' ' + date.getFullYear() ;
            }else{
               mObj.label = monthNames[date.getMonth()] + ' ' + date.getFullYear(); 
            }
            
            mObj.value = monthNames[date.getMonth()] + ' ' + date.getFullYear();
            months.push(mObj);
            date.setMonth(date.getMonth() - 1);
        }
        component.set("v.months", months);
        
        var years = [];
        years.push(year);
        years.push(year - 1);
        
        component.set("v.years", years);
        
        var dateNew = new Date();
        var quarters = [];
        for(var i = 0; i < 4; i++) {
            quarters.push('Q' + Math.floor((dateNew.getMonth() + 3) / 3) + ' ' + dateNew.getFullYear());
            dateNew.setMonth(dateNew.getMonth() - 3);
        }
        component.set("v.quarters", quarters);
    },
    
    getReportData : function(component, event, helper, isDownload, offset) {   
        var month = component.get("v.month");
        var quarter = component.get("v.quarter");
        var year = component.get("v.year");
        
        var fromLocList = component.get("v.fromLocList");
        var lstSelectedlocation = [];
        
        for(var i=0;i<fromLocList.length;i++){
            if(fromLocList[i].selected && !$A.util.isUndefinedOrNull(fromLocList[i].Name)){
                lstSelectedlocation.push(fromLocList[i].Name);
            }
        }
        
        //check selected  location/dealer code
        if(lstSelectedlocation.length <= 0){
            return;
        }
       
        // setting report Limit
        var recordLimit = 2000;
        if(isDownload){
            recordLimit = $A.get("$Label.c.eDealerDownloadSize");
        }
        //alert(recordLimit);
        var offsetVal = component.get("v.offset");
        if(offset){
            offsetVal = offset;
        }
        //alert(offsetVal);
        
         // making object instance for calling the apex class
        var reportGnerateObject = {};
        
        // setting the filters selection
        var filterSelected = component.get("v.selectedFilters");
        if(filterSelected.length > 0){
            reportGnerateObject.field = filterSelected[0].fieldName;
            reportGnerateObject.operator = filterSelected[0].fieldOperator;
            reportGnerateObject.value = filterSelected[0].fieldValue;
        }            
        
        /** 
         * validation i.e. if any of the field is having value 
         * and 1 is blank then show error
         */
        
        //Checking non of the filter field non empty
        if(!$A.util.isEmpty(reportGnerateObject.field) || !$A.util.isEmpty(reportGnerateObject.operator) || !$A.util.isEmpty(reportGnerateObject.value)){
            //Checking if any filter field empty or in value field only contains space
            if($A.util.isEmpty(reportGnerateObject.field) || $A.util.isEmpty(reportGnerateObject.operator) || $A.util.isEmpty(reportGnerateObject.value) || (reportGnerateObject.value.length > 0 && /^\s*$/.test(reportGnerateObject.value))){
                helper.showErrorToast(component, event, helper, 'Please Complete Selection in Filters !!')
                return;
            }
        }
        //trimming enter value if having any space at start or at end of value
        reportGnerateObject.value = reportGnerateObject.value.trim();
	        
        console.log('filterSelected:::'+JSON.stringify(filterSelected));
            
        reportGnerateObject.dealer_codes = lstSelectedlocation;
        reportGnerateObject.offset = offsetVal;
        reportGnerateObject.recLimit = recordLimit;
        reportGnerateObject.month = month;
        reportGnerateObject.quarter = quarter;
        reportGnerateObject.year = year;
        console.log('reportGnerateObject::'+JSON.stringify(reportGnerateObject));
        
        //show Spinner
        component.set("v.displayLoading",true);
        component.set("v.APICalled",false);
        var action = component.get("c.fetchAWSReturnsComplianceData");
        action.setParams({
            "reportParamsJson" : JSON.stringify(reportGnerateObject)
        });
        
        action.setCallback(this, function(response) {            
            debugger;
            var state = response.getState();
            component.set("v.APICalled",true);
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    // this is for the error part
                }else{
                    
                    // this part will execute when the code is execute for generating the report
                    if(!isDownload){
                        component.set("v.returnComplinceReportData", resultData.response);
                        component.set("v.tableData", resultData.response);
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                        
                        var totalRecords = resultData.RowCount;
                        console.log('totalRecords::'+totalRecords);
                        var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                        var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                        
                        // calc total API calls we have to do while downloading the report
                        if(totalRecords % downloadSize > 0){
                            totalAPICalls = totalAPICalls+1;
                        }
                        component.set("v.totaldownloadAPIcalls",totalAPICalls);
                    }
                    
                    // this part will execute when the code is execute for Downloading the report
                    else{
                        var existingData = component.get("v.downloadData");
                        existingData.push(resultData.dataJSON);
                        component.set("v.downloadData", existingData);                        
                        if(component.get("v.totaldownloadAPIcalls") == existingData.length){
                            for(var ele in existingData){
                                var childComponent = component.find("downloadcmp");
                                var message = childComponent.downloadExcel(existingData[ele]);
                            }
                        }
                    }
                }  
                            
                helper.handleReportSelection(component, event, helper);
            }     
        });
        $A.enqueueAction(action);
    },
    
    handleReportSelection : function(component, event, helper) {
        //APi Data COlumns
        var tableData = component.get("v.tableData");
        var languageTranslation = component.get("v.languageTranslation");
        
        //currecy code
        var currencyCode = component.get("v.currencyCode");
        
        var columns = [];
        //debugger;
        
        for (const key in languageTranslation) {
            var value = languageTranslation[key];
            
            if(value == 'suggested_qty' || value == 'suggested_extnet' || value == 'returned_qty' || value == 'returned_extnet' || value == 'avg_return_compliance'){
                
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'Number', sortable: false});
            }
            else if(!$A.util.isEmpty(currencyCode) && (key == 'suggested_extnet'|| key == 'returned_extnet') ){
                value = value + ' ('+currencyCode+ ')';
                columns.push({label: value, fieldName: key, type: 'text', sortable: false});
            }
            else{
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'text', sortable: false});
            }
        }
        
        component.set('v.columns', columns);

    },
    
    // Used to sort the 'Age' column
    sortBy: function(field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        
        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },
    
    handleSort: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        if($A.util.isUndefinedOrNull(sortedBy)){
            sortedBy = cmp.get("v.sortedBy");
        }
        var sortDirection = event.getParam('sortDirection');
        if($A.util.isUndefinedOrNull(sortDirection)){
            sortDirection = cmp.get("v.sortDirection");
        }
        
        if(!$A.util.isUndefinedOrNull(sortedBy) && !$A.util.isUndefinedOrNull(sortDirection)){
            var cloneData = cmp.get("v.tableData").slice(0);
            cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
            cmp.set('v.tableData', cloneData);
            cmp.set('v.sortDirection', sortDirection);
            cmp.set('v.sortedBy', sortedBy);
            
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
    
    handleToFilterChangeHelper : function(component, event, helper) {
        var fromLoc = component.get("v.fromLocList");   
        
        // this will be used to save if the any from location is selected
        var isFromLocSelected = false;
        
        // checking if we ahve any selected from location
        for(var ele in fromLoc){            
            if(fromLoc[ele].selected){
                isFromLocSelected = true;
            }
        }        
        
        var month = component.get("v.month");
        var quarter = component.get("v.quarter");
        var year = component.get("v.year");
        
        // checking we all of them have values
        if(isFromLocSelected && (!$A.util.isEmpty(month) || !$A.util.isEmpty(quarter) || !$A.util.isEmpty(year) )){
            component.set("v.disabledReportButton",false);
        }
        else{
            component.set("v.disabledReportButton",true);
        }
    }
   
})