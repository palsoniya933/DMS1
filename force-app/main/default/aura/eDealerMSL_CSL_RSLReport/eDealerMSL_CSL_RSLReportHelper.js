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
    
    getCSLRSLReportData : function(component, event, helper, isDownload, offset) {    
        debugger;        
        var fromLocList = component.get("v.fromLocList");
        var lstSelectedDealerCodes = [];
        
        for(var i=0; i<fromLocList.length; i++){
            if(fromLocList[i].selected && !$A.util.isUndefinedOrNull(fromLocList[i].Name)){
                lstSelectedDealerCodes.push(fromLocList[i].Name);
            }
        }
        
        // if the selected dealer code is not selected then return back
        if(lstSelectedDealerCodes.length < 1)
            return;        
        
        // setting report Limit Default
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
        reportGnerateObject.dealer_division = component.get("v.dealerDivision");        
        reportGnerateObject.dealerCodes = lstSelectedDealerCodes;
        reportGnerateObject.offSet = offsetVal;
        reportGnerateObject.recLimit = recordLimit;
        console.log('reportGnerateObject::'+JSON.stringify(reportGnerateObject));
        
        //show Spinner
        component.set("v.displayLoading",true);
        component.set("v.APICalled",false);
        var action = component.get("c.fetchAWSMSL_CSL_RSLReport");
        
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
                        component.set("v.MSL_CSL_RSLReportData", resultData.response);
                        component.set("v.tableData", resultData.response);
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                        
                        var totalRecords = resultData.RowCount;
                        var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                        console.log("totalRecords:::"+totalRecords);
                        console.log("downloadSize:::"+downloadSize);
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
        var languageTranslation = component.get("v.languageTranslation");
        
        var columns = [];
        
         //currecy code
        var currencyCode = component.get("v.currencyCode");
        
        for (const key in languageTranslation) {
            var value = languageTranslation[key];
            
            if(value == 'minss' || value == 'oh' || value =='minss' || value == 'p_12monthhitcount' || value == 'twelve_month_demand_qty'){
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'Number', sortable: false});
            }
            else if(key == 'dnet'|| key == 'ext_dnet'){
                if(!$A.util.isEmpty(currencyCode)){
                    value = value + ' ('+currencyCode+ ')';
                }
                columns.push({label: value, fieldName: key, type: 'currency', typeAttributes: { 
                    minimumFractionDigits: '2', maximumFractionDigits: '2'}, sortable: false});
            }
            else if(key == 'Estimated_ABC_Once_Expired'){
                columns.push({label: value, fieldName: key, type: 'text', sortable: false});
            }
            
            else{
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'text', sortable: false});
            }
        }
        console.log('columns ::: ' + JSON.stringify(columns));
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
            var cloneData = cmp.get("v.quarterToDateReportData").slice(0);
            cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
            cmp.set('v.MSL_CSL_RSLReportData', cloneData);
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
    }
    
})