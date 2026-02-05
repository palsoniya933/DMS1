({ 
	getReportData : function(component, event, helper, isDownload, offset) {    
        debugger;
        
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
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
        
        var action = component.get("c.fetchAWSGlobalMDIReportData");
        component.set("v.APICalled",false);
        action.setParams({
            "dealerCode" : locCode,
            "division" : component.get("v.dealerDivision"),
            "offSet": offsetVal,
            "recLimit": recordLimit
        });
        
        action.setCallback(this, function(response) {            
            debugger;
            component.set("v.APICalled",true);
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    
                }else{
                    if(!isDownload){
                        component.set("v.reportData", resultData.response);
                        if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                            resultData.response.shift();
                            component.set("v.data", resultData.response);
                        }
                        
                        debugger;
                        var totalRecords = resultData.response.length;		
                        var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                        var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                        
                        // gettin reminder
                        if(totalRecords % downloadSize > 0){
                            totalAPICalls = totalAPICalls+1;
                        }
                        component.set("v.totaldownloadAPIcalls",totalAPICalls);
                        // used for Language Translation for first column of Global Report                        
                        component.set("v.languageTranslation", resultData.languageTranslation);
                        helper.handleReportSelection(component, event, helper);
                    }
                    else{
                        var existingData = component.get("v.downloadData");
                        existingData.push(resultData.dataJSON);
                        component.set("v.downloadData", existingData);
                        console.log('\n--existingData.length--'+existingData.length);
                        if(component.get("v.totaldownloadAPIcalls") == existingData.length){
                            for(var ele in existingData){
                                var childComponent = component.find("downloadcmp");
                                var message = childComponent.downloadExcel(existingData[ele]);
                            }
                        }
                    }
                }
                
                console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
                
                
                console.log('resultData.languageTransMonthYearColumn:::'+JSON.stringify(resultData.languageTransMonthYearColumn));
            }
            else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }            
            //hide Spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },    
    
    //////////////////////////////////////////////////////////    
    handleReportSelection : function(component, event, helper) {
        debugger;
        //APi Data COlumns
        var reportData = component.get("v.reportData");
        var languageTranslation = component.get("v.languageTranslation");
        //First column will use as a Header
        if(!$A.util.isUndefinedOrNull(reportData) && reportData.length > 0){
            component.set('v.columns', [
                { label: languageTranslation[reportData[0].descr], fieldName: 'descr', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col01).split(" ")[0]]+" "+(reportData[0].col01).split(" ")[1], fieldName: 'col01', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col02).split(" ")[0]]+" "+(reportData[0].col02).split(" ")[1], fieldName: 'col02', type: 'text', sortable: false},
                { label: languageTranslation[(reportData[0].col03).split(" ")[0]]+" "+(reportData[0].col03).split(" ")[1], fieldName: 'col03', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col04).split(" ")[0]]+" "+(reportData[0].col04).split(" ")[1], fieldName: 'col04', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col05).split(" ")[0]]+" "+(reportData[0].col05).split(" ")[1], fieldName: 'col05', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col06).split(" ")[0]]+" "+(reportData[0].col06).split(" ")[1], fieldName: 'col06', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col07).split(" ")[0]]+" "+(reportData[0].col07).split(" ")[1], fieldName: 'col07', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col08).split(" ")[0]]+" "+(reportData[0].col08).split(" ")[1], fieldName: 'col08', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col09).split(" ")[0]]+" "+(reportData[0].col09).split(" ")[1], fieldName: 'col09', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col10).split(" ")[0]]+" "+(reportData[0].col10).split(" ")[1], fieldName: 'col10', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col11).split(" ")[0]]+" "+(reportData[0].col11).split(" ")[1], fieldName: 'col11', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col12).split(" ")[0]]+" "+(reportData[0].col12).split(" ")[1], fieldName: 'col12', type: 'text', sortable: false },
                { label: languageTranslation[(reportData[0].col13).split(" ")[0]]+" "+(reportData[0].col13).split(" ")[1], fieldName: 'col13', type: 'text', sortable: false }
            ]);             
            
            reportData.shift();
            component.set("v.reportData", reportData);
            component.set("v.data",reportData);
                
        }else{
            component.set('v.columns', []);
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
     
})