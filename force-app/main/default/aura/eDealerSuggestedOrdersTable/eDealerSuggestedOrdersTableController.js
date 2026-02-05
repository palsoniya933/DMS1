({
    doInit : function(component, event, helper) {
        var suggestedParts = component.get("v.invData");
        if(!$A.util.isUndefinedOrNull(suggestedParts)){
            for(var i=0;i<suggestedParts.length;i++){
                if(suggestedParts[i].isPromo){
                    component.set("v.showCommentColumn", false);
                    return;
                }
            }
        }
    },
    
	selectAllRows : function(component, event, helper) {
		var isChecked = event.getParam("checked");
        var invData = component.get("v.PaginationList");
        
        for(var i=0;i<invData.length;i++){
            invData[i].checked = isChecked;
            //set ORDER QTY.
            if(isChecked){
                invData[i].qtyForOrder = invData[i].Suggested_Qty - (invData[i].qtyInTodayCart + invData[i].qtyOrdered);
                if(invData[i].qtyForOrder < 0){
                    invData[i].qtyForOrder = 0;
                }
            }else{
                invData[i].qtyForOrder = undefined;
            }
            
        }
        
        component.set("v.PaginationList", invData);
        
        //Re.calculate slelected rows
        helper.calculateSelectedRowsHelper(component, event, helper);
	},
    
    checkSelectAll  : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var invData = component.get("v.PaginationList");
                var isChecked = true;
                for(var i=0;i<invData.length;i++){
                    if(invData[i].checked != true){
                        isChecked = false;
                    }
                }
                
                component.set("v.selectAll", isChecked);
            }), 1500
        );
        
    },
    
    calculateSelectedRows  : function(component, event, helper) {
		var index = event.getSource().get("v.name");
        var isChecked = event.getParam("checked");
        var invData = component.get("v.PaginationList");
        
        if(isChecked){
            invData[index].qtyForOrder = invData[index].Suggested_Qty - (invData[index].qtyInTodayCart + invData[index].qtyOrdered);
            if(invData[index].qtyForOrder < 0){
                invData[index].qtyForOrder = 0;
            }
        }else{
            invData[index].qtyForOrder = undefined;
        }
        
        component.set("v.PaginationList", invData);
        
        helper.calculateSelectedRowsHelper(component, event, helper);
    },
    
    closeModal : function(component, event, helper){
        component.set("v.showQTYONOrder", false);
        component.set("v.showBreakPrice", false);
        component.set("v.showCSR", false);
        component.set("v.showCNR", false);
        component.set("v.showCommentBox", false);
        component.set("v.showLoyalty", false);
    },
    
    openBreakPriceDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showBreakPrice", true);
    },
    
  
    addEmergencyOrders : function(component, event, helper){
        var isValidate = helper.validateSelectedOrdersQTY(component);
        if(isValidate){
            var vx = component.get("v.addOrdersInEMCart");
            //fire event from child and capture in parent
            $A.enqueueAction(vx);
        }else{
            //error
            helper.showErrorToast(component, event, helper, 'Quantity can not be null/blank or equal to 0.');
        }
    },
    
    addStockOrders : function(component, event, helper){
        var isValidate = helper.validateSelectedOrdersQTY(component);
        
        if(isValidate){
            var vx = component.get("v.addOrdersInSOCart");
            //fire event from child and capture in parent
            $A.enqueueAction(vx);
        }else{
            //error
            helper.showErrorToast(component, event, helper, 'Order Quantity can not be null/blank or equal to 0.');
        }
    	
    },
    
    selectRow : function(component, event, helper){
        //get the updated record Id
        var rowIndexNum = event.getSource().get("v.name");
         var rowValue = event.getSource().get("v.value");
        var lstPagination = component.get("v.PaginationList");
        
        if(!$A.util.isEmpty(rowValue)){
            lstPagination[rowIndexNum].checked = true;
        	component.set("v.PaginationList", lstPagination);
            helper.calculateSelectedRowsHelper(component, event, helper);
        }
        
    },
    
    validatePriceSelection : function(component, event, helper){
        //Dual Channel Parts Validation
        helper.SelectedDualChannelPartsValidation(component, event, helper);
    },
    
   handleMenu : function(component, event, helper) {
		var partNum = event.target.name;
        var menuEvent = $A.get("e.c:OpenPartEvent");    
        menuEvent.setParams({ "partNumber": partNum});
        menuEvent.fire();  
	},
    
     
            
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var loc = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?partNum="+partNum+"&loc="+loc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openCSRDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showCSR", true);
    },
    
    openCNRDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showCNR", true);
    },
    
    callToGetCommentInDetail : function(component, event, helper){
         debugger;
        var partNumber = event.currentTarget.name;
        var commentMsg;
        console.log('partNumber ==>>'+partNumber);
        var suggestedParts = component.get("v.invData");
        
        if($A.util.isEmpty(partNumber)){
            return;
        }
        
        if(!$A.util.isUndefinedOrNull(suggestedParts)){
            for(var i=0;i<suggestedParts.length;i++){
                if(suggestedParts[i].Part_Name == partNumber){
                    commentMsg = suggestedParts[i].sof_comments;
                    break;
                }
            }
        }
        
        component.set("v.commentDetailsList", []);
        helper.getSpecialCommentInDetail(component, event, helper, partNumber, commentMsg);
    },
    
})