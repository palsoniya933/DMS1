({
    doInit : function(component, event, helper) {
        helper.getDealerLocations(component, event, helper); 
         component.set(
            'v.loadTime',
            Date.now()
        );
        helper.updateTrackingDetails(component, event, helper,'MDI Internal Transfer Report');
        window.addEventListener('beforeunload',function(){
            helper.updateTrackingTime(component, event, helper, 'MDI Internal Transfer Report',component.get('v.loadTime'));
        });
    },
    
    fetchReportData : function(component, event, helper) {            
        component.set("v.internaltransferdata",[]);
        helper.getInternalTransferReportData(component, event, helper);
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    
    handleFilterClick : function(component, event, helper) {
        var selectedFromLocationList = component.get("v.fromLocList");
        var selectedToLocationList = component.get("v.toLocList");
        var tempToLocationList = [];
        var tempFROMLocationList = [];
        
        // for each selected action
        for(var ele in selectedFromLocationList){
            if(selectedFromLocationList[ele].selected){
                tempFROMLocationList.push(selectedFromLocationList[ele].Name);
            }
        }    
        
        // for each selected action
        for(var ele in selectedToLocationList){
            if(selectedToLocationList[ele].selected){
                tempToLocationList.push(selectedToLocationList[ele].Name);
            }
        }
        
        tempFROMLocationList = tempFROMLocationList.sort();
        tempToLocationList = tempToLocationList.sort();
        
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var filters = params.filters;
            helper.getFilteredData(component, event, helper, filters, tempFROMLocationList, tempToLocationList);
        }
    },
    
    handleHeaderAction: function (cmp, event, helper) {
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        var columns = cmp.get('v.columns');
        var activeFilter = cmp.get('v.activeFilter');
        
        if (actionName !== 'clipText' && actionName !== 'wrapText') {// && actionName !== activeFilter
            var idx = -1;
            columns.some(function(column, i) {
                if (column.fieldName === colDef.fieldName) {
                    idx = i;
                    return true;
                }
            });
            
            var actions = columns[idx].actions;
            if (actions) {
                actions.forEach(function (action) {
                    action.checked = action.name === actionName;
                });
                
                var oblList = [];
                for(var i=0;i<columns.length;i++){
                    var tempActions = columns[i].actions;
                    if(tempActions != undefined && tempActions.length > 0){
                        for(var z=0;z<tempActions.length;z++){
                            if(tempActions[z].checked){
                                var tempObj = {};
                                tempObj.actionName = tempActions[z].name;
                                tempObj.fieldName = columns[i].fieldName;
                                oblList.push(tempObj);
                            }
                        }
                    }
                }
                
                cmp.set('v.activeFilter', actionName);
                helper.updateBooks(cmp, oblList);//colDef.fieldName
                cmp.set('v.columns', columns);
            }
            
        }
    },
    
    handleFromFilterChange : function(component, event, helper) {
        //var toLoc = component.get("v.toloc");
        var fromLocList = JSON.parse(JSON.stringify(component.get("v.fromLocList"))); 
        var toLocList = JSON.parse(JSON.stringify(component.get("v.toLocList")));   
        // checking if we ahve any selected from location
        var fromSelectedLocMAP = new Map();
        
        for(var ele in fromLocList){
            if(fromLocList[ele].selected == true){
                //fromSelectedLocMAP[fromLocList[ele].Name] = fromLocList[ele].Name;
                fromSelectedLocMAP.set(fromLocList[ele].Name, fromLocList[ele].Name);
            }
        }
        
        for(var ele in toLocList){            
            if(fromSelectedLocMAP.has(toLocList[ele].Name)){
                toLocList[ele].display = false;
                toLocList[ele].selected = false;
            }
            else{
                toLocList[ele].display = true;
            }
        }
        
        component.set("v.toLocList",toLocList);
        
    },
    
    handleToFilterChange : function(component, event, helper) {
        //var toLoc = component.get("v.toloc");
        var fromLocList = component.get("v.fromLocList");
        var toLocList = component.get("v.toLocList");    
        
        // this will be used to save if the any to location is selected
        var isToLocSelected = false;
        var isFROMLocSelected = false;
        
        // checking if we ahve any selected from location
        for(var ele in fromLocList){            
            if(fromLocList[ele].selected){
                isFROMLocSelected = true;
            }
        } 
        
        // checking if we ahve any selected to location
        for(var ele in toLocList){            
            if(toLocList[ele].selected){
                isToLocSelected = true;
            }
        }        
        
        // checking we all of them have values
        if(isToLocSelected
           && isToLocSelected){
            component.set("v.disabledReportButton",false);
        }
        else{
            component.set("v.disabledReportButton",true);
        }
        
        
    },
    
    downloadReportData : function(component, event, helper) {
        var selectedFromLocationList = component.get("v.fromLocList");
        var selectedToLocationList = component.get("v.toLocList");
        var tempToLocationList = [];
        var tempFROMLocationList = [];
        
        // for each selected action
        for(var ele in selectedFromLocationList){
            if(selectedFromLocationList[ele].selected){
                tempFROMLocationList.push(selectedFromLocationList[ele].Name);
            }
        }    
        
        // for each selected action
        for(var ele in selectedToLocationList){
            if(selectedToLocationList[ele].selected){
                tempToLocationList.push(selectedToLocationList[ele].Name);
            }
        }    
        
        tempFROMLocationList = tempFROMLocationList.sort();
        tempToLocationList = tempToLocationList.sort();
        component.set("v.downloadData", []);
        var totalAPICalls = component.get("v.totaldownloadAPIcalls");
        for(var count = 0 ;count <totalAPICalls ; count++ ){
            var offset = $A.get("$Label.c.eDealerDownloadSize") * count;
            helper.getInternalTransferReportData(component, event, helper, tempFROMLocationList, tempToLocationList, true, offset);
        }
    },
    handleDestroy : function(component, event, helper) { 
        helper.updateTrackingTime(component, event, helper, 'MDI Internal Transfer Report',component.get('v.loadTime'));
    }
})