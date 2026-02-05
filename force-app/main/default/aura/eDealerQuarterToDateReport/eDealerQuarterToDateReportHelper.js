({
    getReportData : function(component, event, helper, isDownload, offset) { 
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
        
        //show Spinner
        component.set("v.displayLoading",true);
        
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
        
        var action = component.get("c.fetchAWSQuarterToDateReportData");
        component.set("v.APICalled",false);
        action.setParams({
            "dealerCodes" : JSON.stringify(lstSelectedDealerCodes),
            "division" : component.get("v.divisionType"),
            "year" : component.get("v.year"),
            "quarter" :component.get("v.quarter"),
            "offSet" : offsetVal,
            "recLimit": recordLimit
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            component.set("v.APICalled",true);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    
                }else{
                    if(!isDownload){
                        component.set("v.quarterToDateReportData", resultData.response);                        
                        //Update cache
                        if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                            //show error message
                        }
                        
                        console.log('resultData');
                        console.log(resultData);
                        //debugger;
                        var totalRecords = resultData.response.length;		
                        var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                        var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                        
                        // gettin reminder
                        if(totalRecords % downloadSize > 0){
                            totalAPICalls = totalAPICalls+1;
                        }
                        component.set("v.totaldownloadAPIcalls",totalAPICalls);
                    }
                    else{
                        
                        var existingData = component.get("v.downloadData");
                        existingData.push(resultData.dataJSON);
                        component.set("v.downloadData", existingData);
                        console.log('\n--existingData--'+existingData);
                        console.log('\n--existingData.length--'+existingData.length);
                        if(component.get("v.totaldownloadAPIcalls") == existingData.length){
                            for(var ele in existingData){
                                var childComponent = component.find("downloadcmp");
                                var message = childComponent.downloadExcel(existingData[ele]);
                            }
                        }
                    }
                }
                component.set("v.languageTranslation", resultData.languageTranslation);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log('error -->> '+errors[0].message);
                    }
                }
            }
            
            helper.handleReportSelection(component, event, helper);
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
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
    
    handleReportSelection : function(component, event, helper) {
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+languageTranslation['Dealer']);
        
        var columns = [];
        //debugger;
        
        for (const key in languageTranslation) {
            console.log(key);
            var value = languageTranslation[key];
            console.log(value);
            
            columns.push({label: value, fieldName: key.toLowerCase(), type: 'text', sortable: false});
            
        }
        component.set('v.columns', columns);
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
            cmp.set('v.quarterToDateReportData', cloneData);
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
    
    validateForm : function(component, event, helper) {
        var validity = component.find("quarterselect");
        return validity.checkValidity();  
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
        
        var validateForm = helper.validateForm(component, event, helper);
        
        // checking we all of them have values
        if(isFromLocSelected && validateForm){
            component.set("v.disabledReportButton",false);
        }
        else{
            component.set("v.disabledReportButton",true);
        }
    },
})