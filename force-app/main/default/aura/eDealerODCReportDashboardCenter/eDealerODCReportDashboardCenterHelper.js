({
    getOPCReportData : function(component, event, helper,isDownload){
        
        //show Spinner
        component.set("v.displayLoading",true);
        component.set("v.APICalled",false);
        
        // making object instance for calling the apex class
        var reportGnerateObject = {};
        reportGnerateObject.country=component.get('v.country');    
        reportGnerateObject.branch_Type=component.get('v.setCode');
        reportGnerateObject.year=component.get('v.setYear');
        reportGnerateObject.dealer_Code=component.get('v.dealerCode');
        reportGnerateObject.customer_Entered =component.get('v.CustEnter'); 
        var getCode = component.get('v.setCode');
        var action ='';
        if(getCode =='BRANCH_DEALER_CODE'){
            action = component.get("c.fetchAWSOPCBarnchReportData");
        }else{
            action = component.get("c.fetchAWSOPCReportData");
        }
        
        action.setParams({
            "reportParamsJson" : JSON.stringify(reportGnerateObject)
        });
        
        action.setCallback(this, function(response) {            
            var state = response.getState();
            component.set("v.APICalled",true);
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    // this is for the error part
                }else{     
                    
                    component.set("v.internaltransferdata", resultData.response);
                    component.set("v.invData", resultData.response);
                   // component.set("v.totalOPCData", resultData.opcDealerSalesTotalData);
                    console.log('resultData.response:::'+JSON.stringify(resultData.response));
                    component.set("v.tableData", resultData.response);
                    component.set("v.languageTranslation", resultData.languageTranslation);
                    var totalRecords = resultData.RowCount;
                    var downloadSize = $A.get("$Label.c.eDealerDownloadSize");
                    var totalAPICalls = Math.trunc(totalRecords / parseInt(downloadSize));
                    
                    // calc total API calls we have to do while downloading the report
                    if(totalRecords % downloadSize > 0){
                        totalAPICalls = totalAPICalls+1;
                    }
                    component.set("v.totaldownloadAPIcalls",totalAPICalls);
                    console.log('resultData.languageTranslation:::'+JSON.stringify(resultData.languageTranslation));
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
        
        var languageTranslation = component.get("v.languageTranslation");
        
        var columns = [];
        var data =[];
       for (let [key, value] of Object.entries(languageTranslation)) {
          //  var value = languageTranslation[key];
            
            
            if(key == 'dealership_group_code' || key =='dealer_name'){
                columns.push({label: value, fieldName: key, type: 'text', sortable: false, hideDefaultActions: true});    
                data.push({key:key,value:value.label, type: 'text'});
            }
            else if(key == 'branch_dealer_code' || key =='branch_name'){
                columns.push({label: value, fieldName: key, type: 'text', sortable: false, hideDefaultActions: true});    
                data.push({key:key,value:value.label, type: 'text'});
            }else{
                columns.push({label: value, fieldName: key, type: 'currency', sortable: false, hideDefaultActions: true}); 
                data.push({key:key,value:value.label, type: 'currency'});
            }
        }
        component.set("v.columnLabelByApiName",data);
        
        component.set('v.columns', columns);
        
        console.log('columns'+columns);
    }
    
    
})