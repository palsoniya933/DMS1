({
    getActiveOrderData : function(component, event, helper) { 
        var dealerCode = component.get("v.dealerCode");
        
        if($A.util.isUndefinedOrNull(dealerCode)){
            return;
        }
        
        var divisionCode = component.get("v.dealerDivision");
        var orderNum = component.get("v.orderNumber");
        console.log("orderNum:::"+orderNum);
        if(!$A.util.isUndefinedOrNull(orderNum)){
            orderNum = orderNum.replace('&loc','');
        }else{
            orderNum = '';
        }        
        component.set("v.orderNumber",orderNum);
        //show Spinner
        component.set("v.displayLoading",true);
        
        var action = component.get("c.fetchActiveOrderData");
        component.set("v.APICalled",false);
        component.set("v.isOrderfound",true);
        
        action.setParams({
            "dealerCode" : component.get("v.dealerCode"),
            "orderNumber" : orderNum,
        });
        
        action.setCallback(this, function(response) { 
            component.set("v.displayLoading",false);
            component.set("v.APICalled",true);
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue(); 
                //console.log('resultData');
                console.log('resultData::'+JSON.stringify(resultData));
                if(!resultData.activeOrder.response){
                    component.set("v.isOrderfound",false);
                    return;
                }
                if(!$A.util.isEmpty(resultData)){
                    // show error
                }
                
                if($A.util.isEmpty(resultData) 
                   || !$A.util.isEmpty(resultData.error) 
                   || $A.util.isEmpty(resultData.activeOrder.response[0])
                  ){
                    
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else{
                    component.set("v.activeOrderWorkflow",resultData.activeOrder.order_workflow);
                    component.set("v.activeOrderWorkflowItems",resultData.activeOrder.order_workflow_item_details);
                    component.set("v.PaginationList",resultData.processingList);
                    if(resultData.dsp == 'true'){
                        component.set("v.isDSPOrder",true);
                    }
                    else{
                        component.set("v.isDSPOrder",false);
                    }
                    var comments = [];
                    
                    if(!$A.util.isUndefinedOrNull(resultData.activeOrder.response[0].comment)){
                        //comments = resultData.activeOrder.response[0].comment.split(',');
                        component.set("v.comments", resultData.activeOrder.response[0].comment);
                    }
                    
                    // gettng shiping method
                    var shippingMethods = [];
                    for(var ele in resultData.activeOrder.order_workflow){
                        if(resultData.activeOrder.order_workflow[ele].shipping_method){
                            if(!shippingMethods.includes(resultData.activeOrder.order_workflow[ele].shipping_method)){
                                shippingMethods.push(resultData.activeOrder.order_workflow[ele].shipping_method);
                            }
                        }                        
                    }
                    resultData.activeOrder.response[0].allshipments = shippingMethods.join(' , ');
                    component.set("v.activeOrderSummary",resultData.activeOrder.response[0]);
                    component.set("v.languageTranslationBO", resultData.languageTranslationBO);
                    component.set("v.languageTranslationCO", resultData.languageTranslationCO);
                    component.set("v.languageTranslationPO", resultData.languageTranslationPO);
                    component.set("v.languageTranslationProcessing", resultData.languageTranslationProcessing);
                    component.set("v.result",resultData);
                    this.setGridColumns(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorToast(component, event, helper, errors[0].message);
                    }
                }
            }
            
            //hide Spinner
            component.set("v.APICalled",true);
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    setGridColumns : function(component, event, helper) {
        console.log("setGridColumns");
        var languageTranslationBO = component.get("v.languageTranslationBO");
        var languageTranslationCO = component.get("v.languageTranslationCO");
        var languageTranslationPO = component.get("v.languageTranslationPO");
        var languageTranslationProcessing = component.get("v.languageTranslationProcessing");
        var columns =[];
        for (let [key, value] of Object.entries(languageTranslationBO)) {
            columns.push({key:key,value:value.label});            
        }        
        component.set("v.columnLabelByApiNameBO",columns);
        console.log("columnLabelByApiNameBO::"+component.get("v.columnLabelByApiNameBO"));
        columns =[];
        for (let [key, value] of Object.entries(languageTranslationCO)) {
            columns.push({key:key,value:value.label});            
        }        
        component.set("v.columnLabelByApiNameCO",columns);
        console.log("columnLabelByApiNameCO::"+component.get("v.columnLabelByApiNameCO"));
        columns =[];
        for (let [key, value] of Object.entries(languageTranslationPO)) {
            columns.push({key:key,value:value.label});            
        }        
        component.set("v.columnLabelByApiNamePO",columns);
        console.log("columnLabelByApiNamePO::"+component.get("v.columnLabelByApiNamePO"));
        columns =[];
        for (let [key, value] of Object.entries(languageTranslationProcessing)) {
            columns.push({key:key,value:value.label});            
        }        
        component.set("v.columnLabelByApiNameProcessing",columns);        
                
        //console.log("columnLabelByApiNameProcessing::"+component.get("v.columnLabelByApiNameProcessing"));
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