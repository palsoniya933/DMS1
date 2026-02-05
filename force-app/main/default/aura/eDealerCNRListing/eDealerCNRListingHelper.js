({
    fetchOrdersData : function(component, event, helper) {
       var action;
        component.set("v.displayLoading",true);
        var dealerCode = component.get("v.dealerCode");
        var division = component.get("v.division");
       
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
        action = component.get("c.getCNRListingData");
        
            action.setParams({ 
            dealerCode : listDealerCodes,                
            dealerDivision : division,
            
        });
     
        action.setBackground();
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                var cnr= 0;
                var rsv = 0;
                for(var i=0; i < result.response.length; i++){
                    if(result.response[i].saleableindicator == 'CNR'){
                        cnr++;
                    }else if(result.response[i].saleableindicator == 'RSV'){
                        rsv++;
                    }
                }
                component.set("v.masterData", JSON.stringify(result.response));
                component.set("v.invData", result.response);
                component.set("v.PaginationList", result.response);
                component.set("v.totalParts", result.response.length); 
                component.set("v.cnr", cnr);
                component.set("v.rsv", rsv);
                
                component.set("v.languageTranslation", result.languageTranslation);                
                helper.setGridColumns(component, event, helper);
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