({
    fetchOrdersData : function(component, event, helper, isDownload, offset) {
        component.set("v.displayLoading",true);
        var dealerCode = component.get("v.dealerCode");
        var division = component.get("v.division");
        //alert(dealerCode);
        //check selected  location/dealer code
        var listDealerLoc = component.get("v.selectedLocation");
        
                var listDealerCodes = [];

          if($A.util.isUndefinedOrNull(dealerCode)){

            if($A.util.isUndefinedOrNull(listDealerLoc)){
                return;
            }
            else{
                listDealerCodes = listDealerLoc;
            }
		}
        else{
            listDealerCodes=[dealerCode];
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
        
        var action = component.get("c.getReturnComplianceData");
        action.setParams({ 
            "dealerCode" : listDealerCodes,
            "division" : division,
            "month" : component.get("v.month"),
            "quarter" : component.get("v.quarter"),
            "year" : component.get("v.year"),
            "offSet" : offsetVal,
            "recLimit" : recordLimit,
            "monthDate" : component.get("v.monthDate"),
            "quarterDate" : component.get("v.quarterDate")
        });
        
        action.setBackground();
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                // from the server
                var result = response.getReturnValue();
                if(!isDownload){
                    if(!$A.util.isUndefinedOrNull(result)){
                        
                        if(!$A.util.isUndefinedOrNull(result.response)){
                            component.set("v.masterData", result.response);                            
                            component.set("v.invData", result.response);
                            component.set("v.result", result);
                            
                            component.set("v.languageTranslation", result.languageTranslation);
                            console.log('result.languageTranslation:::'+JSON.stringify(result.languageTranslation));
                            
                            var totalRecords = result.response.length;
                            var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                            var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                            // gettin reminder
                            if(totalRecords % downloadSize > 0){
                                totalAPICalls = totalAPICalls+1;
                            }
                            component.set("v.totaldownloadAPIcalls",totalAPICalls);
                        }else{
                            component.set("v.masterData", {});                            
                            component.set("v.invData", {});
                            component.set("v.result", {});
                            var resultSet = {};
                            resultSet.kpiData = {};
                            resultSet.kpiData.suggested_returns = 0;
                            resultSet.kpiData.sum_suggested_returns = 0;
                            resultSet.kpiData.returned_quantity = 0;
                            resultSet.kpiData.sum_return_amount = 0;
                            resultSet.kpiData.suggested_compliance = 0;
                            component.set("v.result", resultSet);
                        } 
                    }
                    helper.setGridColumns(component, event, helper);
                }
                else{
                    var existingData = component.get("v.downloadData");
                    existingData.push(result.dataJSON);
                    component.set("v.downloadData", existingData);
                    if(component.get("v.totaldownloadAPIcalls") == existingData.length){
                        for(var ele in existingData){
                            var childComponent = component.find("downloadcmp");
                            var message = childComponent.downloadExcel(existingData[ele]);
                        }
                    }
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    setFullMonthName : function(component, event, helper) {
        var month = component.get("v.month");
        if(month != null && month != undefined && month != ''){
            var mon = month.split(' ')[0];
            var year = month.split(' ')[1];
            return 'Month - '+mon+' '+year;
        }
    },
    
    setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        // var tableData = component.get("v.tableData");
        const colmunsDownloadData =[];
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            colmunsDownloadData.push({label: value.label, fieldName: key, type: 'text', sortable: false});
        }
        component.set("v.columns",colmunsDownloadData);
        component.set("v.columnLabelByApiName",columns);
    }
    
})