({
    restFilter : function(component, event, helper) {
        component.set("v.selectedFilter", []);        
        var filterList = [];
        
        // initalize filters
        var filterObject = {};
        filterObject.fieldName = '';
        filterObject.fieldOperator = '';
        filterObject.fieldValue = '';
        filterList.push(filterObject); 
        
        // set the filter
        component.set("v.selectedFilter", filterList);
        console.log("doinit");
        var reportName = component.get("v.reportName");
        var action = component.get("c.translateReportFilterField");
        action.setParams({"reportName":reportName});
        action.setCallback(this, function(response) {            
            var state = response.getState();
            if (state === "SUCCESS") { 
                var filterColumns = [];
                var languageTranslationFilter = response.getReturnValue(); 
                for(const key in languageTranslationFilter) { 
                    let value = languageTranslationFilter[key];                    
                    filterColumns.push({label: value, fieldName: key.split("|")[0], type: key.split("|")[1]});
                }
                console.log("filterColumns:::"+JSON.stringify(filterColumns));
                component.set('v.columns', filterColumns);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})