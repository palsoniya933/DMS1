({
    //Update the list of dealercodes for picklist
    updateLstOfDealerCodesHelper : function(component, event, helper) {
        var accessibleDealersLocs = component.get("v.accessibleDealersLocs");
        // getting the location from URL
        const queryString = window.location.search;        
        const urlParams = new URLSearchParams(queryString);        
        const dealerLoc = urlParams.get('loc');
        const orderNum = urlParams.get('orderNum');
        //OrderListing Page
        const orderlisting = urlParams.get('orderlisting');
        const partNum = urlParams.get('partNum');
        
        var isOrderScreenPageOpen = false;
        if(component.get("v.userType") == 'internal'){
            isOrderScreenPageOpen = true;
        }
        
        
        if(!$A.util.isUndefinedOrNull(orderNum)||!$A.util.isUndefinedOrNull(orderlisting)||!$A.util.isUndefinedOrNull(partNum)){
            isOrderScreenPageOpen = (urlParams.get('orderlisting') == 'emergencyorderlisting' || urlParams.get('orderlisting') == 'manuallockdownparts') ? false : true;
            if(!$A.util.isUndefinedOrNull(orderNum)){
                component.set("v.isSummerydetailsOpen",true);
            }else{
                component.set("v.isSummerydetailsOpen",false);
            }
            
        }else{
            component.set("v.isSummerydetailsOpen",false);
        }
        component.set("v.isOrderScreenPageOpen", isOrderScreenPageOpen);
        
        var selectedLoc;
        // if we have params in URL the set that
        if(dealerLoc){
            component.set("v.selectedLocation", dealerLoc);
            selectedLoc = dealerLoc;
        }else if(accessibleDealersLocs != undefined && accessibleDealersLocs.length > 0){
            //default selected location 
            selectedLoc = (!$A.util.isEmpty(accessibleDealersLocs[0].Sub_Code__c)) ? accessibleDealersLocs[0].ASI_Dealer_Code__c +'-'+accessibleDealersLocs[0].Sub_Code__c : accessibleDealersLocs[0].ASI_Dealer_Code__c;
            component.set("v.selectedLocation", selectedLoc);  
            //Call EVENT
            var selectedLocs = [selectedLoc];
            var menuEvent = $A.get("e.c:eDealerLocationEvent");    
            menuEvent.setParams({"listSelectedLoc" : selectedLocs,
                                 "selectedLoc" : selectedLoc});
            menuEvent.fire(); 
        }
        
        var allCodes= [];
        if(accessibleDealersLocs != undefined){
            
            for (var i=0;i<accessibleDealersLocs.length;i++) {
                var obj = {};
                if($A.util.isEmpty(accessibleDealersLocs[i].Sub_Code__c)){
                    obj.Name = accessibleDealersLocs[i].ASI_Dealer_Code__c + ' '+accessibleDealersLocs[i].Customer_Name__c;
                }else{
                    obj.Name = accessibleDealersLocs[i].ASI_Dealer_Code__c +'-'+accessibleDealersLocs[i].Sub_Code__c + ' '+accessibleDealersLocs[i].Customer_Name__c;
                }
                if(i==0 && $A.util.isUndefinedOrNull(dealerLoc)){
                    obj.selected = true;
                }else if(!$A.util.isUndefinedOrNull(dealerLoc) && (obj.Name).split(" ")[0] == dealerLoc){
                    obj.selected = true;
                }else{
                    obj.selected = false;
                }                
                obj.display = true;
                allCodes.push(obj);
            }
        }
        component.set("v.allAccessibleDealersLocs",allCodes);
        component.set("v.changeAccessibleDealersLocs",allCodes);
        //check current logged in user is nondealer 
        var userdetail = component.get("v.userDetail");
        if(!$A.util.isUndefinedOrNull(userdetail) && userdetail.isNonDealer == true){
            console.log('inside');
            component.set("v.preSearchDealerCode", dealerLoc);
        }
        else{
            //if current user is a dealer
            if(selectedLoc != undefined){
                //Call EVENT
                var menuEvent = $A.get("e.c:eDealerLocationEvent");    
                menuEvent.setParams({"listSelectedLoc" : selectedLocs,
                                     "selectedLoc" : selectedLoc});
                menuEvent.fire(); 
            }
        }
    },
    
})