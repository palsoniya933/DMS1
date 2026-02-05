({   
    // this method will be used to get the location picklist onload of the component
    getDealerLocations : function(component, event, helper) {  
        var accessibleDealersLoctionsList = component.get("v.accessibleDealersLocs");
        
        var lstDealerCodes = [];
        // this will save all the dealer code
        var allFromLocCodes = [];
        var allToLocCodes = [];
        for (var i=0;i<accessibleDealersLoctionsList.length;i++) {
            if($A.util.isEmpty(accessibleDealersLoctionsList[i].Sub_Code__c)){
                lstDealerCodes.push(accessibleDealersLoctionsList[i].ASI_Dealer_Code__c);
                var obj = {};
                obj.Name = accessibleDealersLoctionsList[i].ASI_Dealer_Code__c;
                obj.selected = false;
                obj.display = true;
                allFromLocCodes.push(obj);
                allToLocCodes.push(obj);
            }
            
        }
        component.set("v.locationList", lstDealerCodes);
        component.set("v.fromLocList", allFromLocCodes);
        component.set("v.toLocList", allToLocCodes);
    },
    
    getInternalTransferReportData : function(component, event, helper, tempFromLocationList, tempToLocationList, isDownload, offset) {    
        
        debugger;        
        var fromLocList = component.get("v.fromLocList");
        var toLocList = component.get("v.toLocList");
        var lstSelectedDealerCodes = [];
        var lstSelectedToDealerCodes = [];
        
        //Pushing selected from transfer dealer code
        for(var i=0; i<fromLocList.length; i++){
            if(fromLocList[i].selected && !$A.util.isUndefinedOrNull(fromLocList[i].Name)){
                lstSelectedDealerCodes.push(fromLocList[i].Name);
            }
        }
        //Pushing selected to transfer dealer code
        for(var i=0; i<toLocList.length; i++){
            if(toLocList[i].selected && !$A.util.isUndefinedOrNull(toLocList[i].Name)){
                lstSelectedToDealerCodes.push(toLocList[i].Name);
            }
        }
        console.log("lstSelectedDealerCodes:::"+JSON.stringify(lstSelectedDealerCodes));
        // if the selected dealer code is not selected then return back
        if(lstSelectedDealerCodes.length < 1)
            return;
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
        console.log("dealerDivision:::"+component.get("v.divisionType"));
        reportGnerateObject.dealer_division = component.get("v.divisionType"); 
        reportGnerateObject.from_loc = lstSelectedDealerCodes;
        reportGnerateObject.to_loc = lstSelectedToDealerCodes;
        
        console.log('reportGnerateObject::'+JSON.stringify(reportGnerateObject));
        
        //show Spinner
        component.set("v.displayLoading",true);
        component.set("v.APICalled",false);
        var action = component.get("c.fetchAWSInternalTransferReportData");
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
                        component.set("v.internaltransferdata", resultData.response);
                        component.set("v.tableData", resultData.response);
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                        
                        var totalRecords = resultData.RowCount;
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
        
        //currecy code
        var currencyCode = component.get("v.currencyCode");
        
        //Header Actions
        var headerActionsForFromLocation = [
            {
                label: 'All',
                checked: true,
                name:'all'
            }];
        var headerActionsForToLocation = [
            {
                label: 'All',
                checked: true,
                name:'all'
            }];
        
        if(!$A.util.isUndefinedOrNull(tableData) && tableData.length > 0){
            //SET
            var set1 = new Set(); 
            var set2 = new Set(); 
            //Table Columns iteration
            for(var i=0;i<tableData.length;i++){
                //to locations
                if(!$A.util.isUndefinedOrNull(tableData[i].to_loc) && !set1.has(tableData[i].to_loc)){
                    set1.add(tableData[i].to_loc);
                    var objTemp = {};
                    objTemp.label = tableData[i].to_loc;
                    objTemp.checked = false;
                    objTemp.name = tableData[i].to_loc;
                    
                    headerActionsForToLocation.push(objTemp);
                }
                //from locations
                if(!$A.util.isUndefinedOrNull(tableData[i].from_loc) && !set1.has(tableData[i].from_loc)){
                    set1.add(tableData[i].from_loc);
                    var objTemp = {};
                    objTemp.label = tableData[i].from_loc;
                    objTemp.checked = false;
                    objTemp.name = tableData[i].from_loc;
                    
                    headerActionsForFromLocation.push(objTemp);
                }
            }
        }
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        //console.log('.languageTranslation:::'+languageTranslation['GROUP']);
        
        var columns = [];
        
        for (const key in languageTranslation) {
            //console.log('key : '+key);
            var value = languageTranslation[key];
            //console.log('value : '+value);
            
            if(value == 'from_dealernet' || value == 'TO_12_Mth_Dmd' || value =='FROM_12_Mth_Dmd' || 
               value=='FROM_12_Mth_Hits'|| value=='oh' || value=='from_ohoo' || 
               value=='TO_12_Mth_Hits' || value=='to_ohoo' || value=='Opportunity_Qty' ||
               value=='Transfer_Qty' || value=='Transfer_Value'){
                columns.push({label: value, fieldName: key.toLowerCase(), type: 'Number', sortable: false});
            }
            else if(!$A.util.isEmpty(currencyCode) && (key=='from_dealernet' || key=='Transfer_Value') ){
                value = value + ' ('+currencyCode+ ')';
                columns.push({label: value, fieldName: key, type: 'text', sortable: false});
            }
            else{
                columns.push({label: value, fieldName: key, type: 'text', sortable: false});
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
            //var cloneData = cmp.get("v.data").slice(0);
            var cloneData = cmp.get("v.tableData");
            cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
            cmp.set('v.tableData', cloneData);
            cmp.set('v.sortDirection', sortDirection);
            cmp.set('v.sortedBy', sortedBy);
            
            //update also the report data (internal transfer data list)
            var intTransferDataList = cmp.get("v.internaltransferdata");
            intTransferDataList.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
            cmp.set('v.internaltransferdata', intTransferDataList);
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