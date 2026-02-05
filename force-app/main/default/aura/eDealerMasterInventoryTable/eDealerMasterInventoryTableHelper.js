({
    calculateSelectedRowsHelper  : function(component, event, helper) {
        var invData = component.get("v.invData");
        var selectedRows = 0;
        for(var i=0;i<invData.length;i++){
            if(invData[i].checked == true){
                selectedRows++;
            }
        }
        
        component.set("v.totalOrderSelected", selectedRows);
    },
    
    fetchMasterInventoryPartsDetails : function(component, event, helper) {
        //console.log("current value: " + event.getParam("value"));
        var searchText =  event.getParam("value");
        var locCode = component.get("v.dealerCode");
        var division = component.get("v.currentDealerDivision");
        //    var recordLimit = component.get("v.recordLimit");
        var offset =0;// component.get("v.offset_value");
        component.set("v.offset_value",offset);
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.getMasterInvParts");
        action.setParams({
            "dealerCode" : locCode,
            "division" : division,
            "offSet" : offset,
            "searchText":searchText
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.partsList", response.getReturnValue());
                component.set("v.tableData", response.getReturnValue());
                component.set("v.allPartsReportName", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    generateReportColumns : function(component, event, helper){
        var currencyCode = component.get("v.currencyCode");
        var estpricing;
        if(currencyCode!=null){
            
            estpricing = $A.get("$Label.c.EST_PRICING") +' ('+ currencyCode+')';
        }
        else{
            estpricing = $A.get("$Label.c.EST_PRICING");
        }
        component.set('v.columns', [
            {label: $A.get("$Label.c.Parts"), fieldName: 'part_number', type: 'text'},
            {label: $A.get("$Label.c.Description"), fieldName: 'decription', type: 'text'},
            {label: $A.get("$Label.c.Inventory"), fieldName: 'inventory_on_hand', type: 'text'},
            {label: $A.get("$Label.c.MIN_SFTY_STK"), fieldName: 'min_sfty_Stk', type: 'text'},
            {label: $A.get("$Label.c.STK"), fieldName: 'stkcls', type: 'text'},
            {label: estpricing, fieldName: 'PriceDetail', type: 'text'},
            {label: $A.get("$Label.c.DISTCHNL"), fieldName: 'distchan', type: 'text'},
            {label: $A.get("$Label.c.VELOCITY"), fieldName: 'velocity_code', type: 'text'},
            {label: $A.get("$Label.c.SPECIAL"), fieldName: 'SPECIAL', type: 'text'}
        ]);
    },
})