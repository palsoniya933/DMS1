({
    // this method will be used to get the location picklist onload of the component
    getDealerLocations : function(component, event, helper) {    
        var accessibleDealersLoctionsList = component.get("v.accessibleDealersLocs");
        
        var lstDealerCodes = [];
        // this will save all the dealer code
        var allCodes = [];
        
        for (var i=0;i<accessibleDealersLoctionsList.length;i++) {
            if($A.util.isEmpty(accessibleDealersLoctionsList[i].Sub_Code__c)){
                lstDealerCodes.push(accessibleDealersLoctionsList[i].ASI_Dealer_Code__c);
                var obj = {};
                obj.Name = accessibleDealersLoctionsList[i].ASI_Dealer_Code__c;
                obj.selected = false;
                obj.display = true;
                allCodes.push(obj);
            }
        }
        component.set("v.fromLocList", allCodes);
    },
   
    getManualLockDownReportData : function(component, event, helper, isDownload, offset) { 
        var fromLocList = component.get("v.fromLocList");
        var lstSelectedDealerCodes = [];
        
        for(var i=0;i<fromLocList.length;i++){
            if(fromLocList[i].selected && !$A.util.isUndefinedOrNull(fromLocList[i].Name)){
                lstSelectedDealerCodes.push(fromLocList[i].Name);
            }
        }
        
        //list of selected dealercodes
        if(lstSelectedDealerCodes.length < 1){
            return;
        }
        
        // setting report Limit
        var recordLimit = 2000;
        if(isDownload){
            recordLimit = $A.get("$Label.c.eDealerDownloadSize");
        }
        
        var offsetVal = component.get("v.offset");
        if(offset){
            offsetVal = offset;
        }
        
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
        
        //Checking one of the filter field non empty
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
        reportGnerateObject.dealer_division = component.get("v.dealerDivision");        
        reportGnerateObject.dealerCodes = lstSelectedDealerCodes;
        reportGnerateObject.offSet = offsetVal;
        reportGnerateObject.recLimit = recordLimit;
        reportGnerateObject.StartDate = component.get("v.startDate");
        reportGnerateObject.EndDate = component.get("v.endDate");
        
        //show Spinner
        component.set("v.displayLoading",true);
        component.set("v.APICalled",false);
        var action = component.get("c.fetchAWSManualLockDownRecordsData");
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
                        component.set("v.manualLockdownReportData", resultData.response);
                        component.set("v.tableData", resultData.response);
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        
                        console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                        
                        var totalRecords = resultData.RowCount[0].rowcount;
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
                helper.setGridColumns(component, event, helper);
            }     
        });
        $A.enqueueAction(action);
    },
    
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        var tableData = component.get("v.tableData");
        
        //Header Actions
        var headerActionsForOrderType = [
            {
                label: 'All',
                checked: true,
                name:'all'
            }];
        
        if(!$A.util.isUndefinedOrNull(tableData) && tableData.length > 0){
            //SET
            var set1 = new Set(); 
            //Table Columns iteration
            for(var i=0;i<tableData.length;i++){
                if(!$A.util.isUndefinedOrNull(tableData[i].status) && !set1.has(tableData[i].status)){
                    set1.add(tableData[i].status);
                    var objTemp = {};
                    objTemp.label = tableData[i].status;
                    objTemp.checked = false;
                    objTemp.name = tableData[i].status;
                    
                    headerActionsForOrderType.push(objTemp);
                }
            }
        }
        
        var languageTranslation = component.get("v.languageTranslation");
        
        var columns = [];
         //currecy code
        var currencyCode = component.get("v.currencyCode");
        
        for (const key in languageTranslation) {
            var value = languageTranslation[key];
            
            if(value == 'oh' || value == 'dnet' ){
                
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'Number', sortable: false});
            }
            else if(!$A.util.isEmpty(currencyCode) && key == 'dnet' ){
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
            
            debugger;
            var cloneData = cmp.get("v.tableData").slice(0);
            debugger;
            cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
            debugger;
            //cmp.set('v.manualLockdownReportData', cloneData);
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
    
    getDateWithFormat : function(component, event, helper, dateParam) {
        var now     = dateParam;
        var year    = now.getFullYear();
        var month   = now.getMonth()+1; 
        var day     = now.getDate(); 
        if(month.toString().length == 1) {
            month = '0'+month;
        }
        if(day.toString().length == 1) {
            day = '0'+day;
        }   
        var datestr = year+'-'+month+'-'+day;   
        return datestr;
    },
    
    validateInputs: function (cmp, event, helper) {
        var allValid = cmp.find('myinput').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true); 
        
        if(!allValid){
            cmp.set("v.disabledReportButton",true);
            component.set("v.APICalled",false);
            cmp.set("v.manualLockdownReportData", []);
        }
        else{
            cmp.set("v.disabledReportButton",false);
        }
        return allValid;
    }   
   
})