({
    doInit : function(component, event, helper) {
        component.set("v.headerColumns", []);
        helper.getDealerLocations(component, event, helper);  
        helper.updateTrackingDetails(component, event, helper,'MDI Zero On-Hand Report');
        helper.getLanguageTranslation(component, event, helper);
        component.set("v.staticFilters", 'CONSECUTIVE_DAYS_STOCKED_OUT > 1 AND  MDI_COMMENT not in ["Shipment in Process", "Backordered"]');
        // In Aura component's controller
        component.set("v.sortMap", {
            "GRP_NBR": "asc",
            "LOC": "asc",
            "CONSECUTIVE_DAYS_STOCKED_OUT": "desc",
            "ITEM": "asc"
        });

    },
    
    fetchReportData : function(component, event, helper) {   
        component.set("v.displayLoading",true);
        component.set("v.zeroOnHandReportData", []);
        helper.getReportData(component, event, helper);
        
        component.set("v.showCRMA", true);
        var crmadataComponent = component.find('crmadataComponent');
        crmadataComponent.generateReport();
    },
    
    downloadReportData : function(component, event, helper) {
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getReportData(component, event, helper, true, offset);
        }
    },
    
    handleToFilterChange : function(component, event, helper) {
        debugger;         
        var fromLoc = component.get("v.fromLocList"); 
        
        // this will be used to save if the any from location is selected
        var isFromLocSelected = false;
        
        // checking if we ahve any selected from location
        for(var ele in fromLoc){            
            if(fromLoc[ele].selected){
                isFromLocSelected = true;
            }
        }        
        
        // checking we all of them have values
        if(isFromLocSelected){
            component.set("v.disabledReportButton",false);
        }
        else{
            component.set("v.disabledReportButton",true);
        }
    },
    
    handleSort: function(component, event, helper) {        
        helper.handleSort(component, event);
    },
    
    updateTableData : function(component, event, helper) {
        var paginationDataList = component.get("v.PaginationList");
        component.set("v.data", paginationDataList);
        helper.handleSort(component, event);
    },
    
    handleHeaderAction: function (component, event, helper) {
        debugger;
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        console.log("colDef ==>> "+JSON.stringify(colDef));
        var columns = cmp.get('v.columns');
        var activeFilter = cmp.get('v.activeFilter');
        debugger;
        if (actionName !== 'clipText' && actionName !== 'wrapText' && actionName !== activeFilter) {
            var idx = -1;
            columns.some(function(column, i) {
                if (column.fieldName === colDef.fieldName) {
                    idx = i;
                    return true;
                }
            });
        }
    },
    handleZeroOnHandReportData: function(component, event, helper) {
        let dataToSend = event.getParam("dataToSend");
        component.set("v.crmaData", dataToSend);
        

       
    }
    
    
})