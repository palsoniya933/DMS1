({
    
    searchboxclear: function(component, event, helper) {
        component.set("v.searchKeyword", undefined);
        component.set("v.showSearchCloseIcon",false);
    },
    
    inputtextlength : function(component, event, helper) {
        jQuery("document").ready(function(){
            
            
        });
    },
    doInit : function(component, event, helper) {
        component.set("v.responseReceived",false); 
        console.log('inventory data::'+JSON.stringify(component.get('v.invData')));
        helper.generateReportColumns(component, event, helper);
    },
    
    updateTableData : function(component, event, helper) {
        var totalRows = component.get("v.invData");
        var searchtext = event.getParam("value");
        //  console.log("current value: " + event.getParam("value"));
        var searchedRows = [];
        
        if(!$A.util.isUndefinedOrNull(totalRows)){
            if(!$A.util.isEmpty(searchtext)){
                for(var i = 0; i< totalRows.length; i++){
                    if(
                        (!$A.util.isUndefinedOrNull(totalRows[i].partName) && totalRows[i].partName.toLocaleLowerCase().indexOf(searchtext.toLocaleLowerCase()) > -1)
                        ||(!$A.util.isUndefinedOrNull(totalRows[i].description) && totalRows[i].description.toLocaleLowerCase().indexOf(searchtext.toLocaleLowerCase()) > -1)
                    ){
                        searchedRows.push(totalRows[i]);
                    }
                    
                }
                component.set("v.tableData", searchedRows);
            }else{
                component.set("v.tableData", totalRows);
            }
        }
        
        
    },
    
    calculateSelectedRows  : function(component, event, helper) {        
        helper.calculateSelectedRowsHelper(component, event, helper);
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    dislpayModal : function(component, event, helper) {
        var name = event.currentTarget.name;
        component.set("v.modalName", name);
        component.set("v.showModal", true);
    },
    
    searchData : function(component, event, helper) {
        var searchKeyword = component.get("v.searchKeyword");
        
        if(!$A.util.isUndefinedOrNull(searchKeyword) && searchKeyword.trim() != ''){
            var searchtext = searchKeyword.trim();
            if(searchtext.length > 2){
                component.set("v.showSearchCloseIcon",true);
                var vx = component.get("v.callSearchData");
                //fire event from child and capture in parent
                $A.enqueueAction(vx);
            }
        }
        /*else{
            var vx = component.get("v.refresh");
            //fire event from child and capture in parent
            $A.enqueueAction(vx);
        }*/
    },
    
    
    refreshTable : function(component, event, helper){
        var vx = component.get("v.refresh");
        //fire event from child and capture in parent
        $A.enqueueAction(vx);
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
    
    searchValidate:function(component, event, helper){
        /*var searchKeyword = component.get("v.searchKeyword");
       var showSearchCloseIcon = component.get("v.showSearchCloseIcon");
        if(!$A.util.isEmpty(searchKeyword) && showSearchCloseIcon == false){
            component.set("v.showSearchCloseIcon",true);
        }else if($A.util.isEmpty(searchKeyword) && showSearchCloseIcon == true){
            component.set("v.showSearchCloseIcon",false);
        }*/
        
    },
    
    openBreakPriceDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        console.log('indexNum ==>> '+indexNum);
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showBreakPrice", true);
    },
    
    openLoyalityDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showLoyality", true);
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
    
    closeModal : function(component, event, helper){
        component.set("v.showBreakPrice", false);
        component.set("v.showLoyality", false);
        component.set("v.showCSR", false);
        component.set("v.showCNR", false);
    },
    
    handleMenu : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var menuEvent = $A.get("e.c:OpenPartEvent");    
        menuEvent.setParams({ "partNumber": partNum});
        menuEvent.fire();  
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var loc = component.get("v.dealerCode");
        var dealerDivision = component.get("v.currentDealerDivision");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?partNum="+partNum+"&loc="+loc+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
})