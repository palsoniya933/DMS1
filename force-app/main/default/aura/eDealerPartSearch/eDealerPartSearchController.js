({
    doInit : function(component, event, helper) {
        component.set("v.displayLoading",true);
        component.set("v.responseReceived",false);
        //component.set("v.partavailableData",[]);
        helper.fetchPartAvailabilityDetail(component, event, helper);
    },
    
    openPart : function(component, event, helper) {
		component.set("v.partNumberDetail",event.currentTarget.name);  
        component.set("v.displayParts",true); 
	},
    
    closePartModel : function(component, event, helper) {
        component.set("v.partNumberDetail",'');  
        component.set("v.displayParts",false); 
    },
    
    openCNRDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        //console.log('indexNum ==>> '+indexNum);
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showCNR", true);
    },
    
    checkSelectAll  : function(component, event, helper) {
        /*window.setTimeout(
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
        );*/
    },
    
    handleOpenInNewWindow : function(component, event, helper) {
        var partNum = event.currentTarget.name;
        var dealerCode = component.get("v.dealerCode");
        var dealerDivision = component.get("v.division");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?partNum="+partNum+'&loc='+dealerCode+"&division="+dealerDivision),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openBreakPriceDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        //console.log('indexNum ==>> '+indexNum);
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showBreakPrice", true);
    },
    
    openLoyalityDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
       // console.log('indexNum ==>> '+indexNum);
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showLoyality", true);
    },
    
    openCSRDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        //console.log('indexNum ==>> '+indexNum);
        
        //get part details which need to show with Qty Break 
        var PaginationList = component.get("v.PaginationList");
        component.set("v.sofPartDetailWithQtyBreak", PaginationList[indexNum]);
        component.set("v.showCSR", true);
    },
    
    openCNRDetailModal : function(component, event, helper){
        //INdex number
        var indexNum = event.currentTarget.name;
        //console.log('indexNum ==>> '+indexNum);
        
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
})