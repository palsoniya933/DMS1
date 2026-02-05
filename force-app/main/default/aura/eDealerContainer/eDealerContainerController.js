({
    handleMenuChange : function(component, event, helper) {
        try{            
            let menuNameForMultiDealerSelection = component.get("v.menuNameForMultiDealerSelection");
            var partNumber = event.getParam("partNumber");
            component.set("v.partNumber",partNumber); 
            var csrNumber = event.getParam("csrNumber");
            component.set("v.csrNum",csrNumber); 
            var csrPartNumber = event.getParam("csrPartNumber");
            component.set("v.csrPartNumber",csrPartNumber);  
            console.log('csrPartNumber :: '  +csrPartNumber);
            
            var menuName = event.getParam("menuName");
            var subTabName = event.getParam("tabName");
            var subTabLabel = event.getParam("selectedTabLabel");
            
            
            const multiSelectDealerMenus = [
                'createCSR',
                'csrandvolumnsales',
                'dashboardDemo',
                'dashboardDivV2',
                'loyalty',
                'offerPDF',  
                'RPMScoreCard'
            ];            
            
            if (multiSelectDealerMenus.includes(menuName)) {
                // place holder for multiselect dealer code menu
            }

            
            else{                
                // single select option menus
                var allLocations = component.get("v.allAccessibleDealersLocs")
                var firstLocation = helper.getFirstCode(component, allLocations);                
                
                var defaultLocation = [];
                defaultLocation.push(firstLocation);                
                component.set("v.selectedLocation.listSelectedLoc", defaultLocation);
                component.set("v.selectedLocationObjString",JSON.stringify(component.get("v.selectedLocation")));
            }
            
            component.set("v.subTabName",subTabName);
            component.set("v.selectedMenu",menuName);
            component.set("v.selectedTabLabel",subTabLabel);
            
            if(menuName == 'createCSR'){
                component.set("v.enableCsrEditing", true);
                component.set("v.csrnumber",null);
                component.set("v.csrphase",null);
                helper.updateTrackingDetails(component, event, helper,'Create New CSR');
            }
            
            if(menuName == 'csrandvolumnsales'){
                helper.updateTrackingDetails(component, event, helper,'CSR Dashboard');
            }
            
            if(component.get('v.selectedMenu') == 'partnumberdetail'){
                debugger;
                var csrPartNumber = event.getParam("csrPartNumber");
                component.set("v.csrPartNumber",csrPartNumber); 
                var child=component.find('csrpartnumbersearch');
                if(Array.isArray(child)){
                    child[0].handleByContainer();
                }
                else{
                    child.handleByContainer();
                }
            }
            
            if(component.get('v.selectedMenu') == 'csrdetail'){
                debugger;
                var child=component.find('csrnumbersearch');
                if(Array.isArray(child))
                {
                    child[0].handleByContainer();
                }
                else
                {
                    child.handleByContainer();
                }
            }
            
            var orderNumber = event.getParam("orderNumber");
            component.set("v.orderNumber",orderNumber);
            
            var poNumber = event.getParam("poNumber");
            component.set("v.poNumber",poNumber);
            
            var tabName = event.getParam("tabName");
            component.set("v.selectedTab",tabName);           
            
            
            var selectedoption = event.getParam("selectedoption");
            component.set("v.selectedoption",selectedoption);
            
            var reportName = event.getParam("reportName");
            component.set("v.selectedReport",reportName);
            
            var orderType = event.getParam("orderType");            
            component.set("v.orderType",orderType);
            //component.set("v.isOrderScreenPageOpen",false);
            
            var selectedLocation = component.get("v.selectedLocation");
            
            var allAccessibleDealersLocs = component.get("v.allAccessibleDealersLocs");                
            
            allAccessibleDealersLocs.forEach(function(accessDealer) {  
                if(!$A.util.isUndefinedOrNull(selectedLocation)){
                    //handle single dealer selection 
                    if(!$A.util.isUndefinedOrNull(selectedLocation.selectedLoc) && accessDealer.Name.split(" ")[0] == selectedLocation.selectedLoc){
                        accessDealer.selected = true;
                    }
                    //handle multiple dealer selection
                    else if(!$A.util.isUndefinedOrNull(selectedLocation.listSelectedLoc) && selectedLocation.listSelectedLoc.length > 1 && selectedLocation.listSelectedLoc.includes(accessDealer.Name.split(" ")[0])){
                        accessDealer.selected = true;
                    }
                        else{
                            accessDealer.selected = false;
                        }
                }
                else{
                    accessDealer.selected = false;
                }
            });
            
            
            if(menuNameForMultiDealerSelection.includes(menuName)){
                component.set("v.isOrderScreenPageOpen",false);
            }else if(menuName=="activeordersdetail"){
                component.set("v.isOrderScreenPageOpen",true);
                component.set("v.isSummerydetailsOpen",true);
            }else if(menuName=="partnumberdetail" || menuName=="csrdetail"){
                component.set("v.isOrderScreenPageOpen",false);                
                component.set("v.isSummerydetailsOpen",false);
            }else{
                component.set("v.isOrderScreenPageOpen",true);
                component.set("v.isSummerydetailsOpen",false);
            }
            
            component.set("v.selectedMenu",menuName);
        }
        catch(ex){
            alert(ex);
        }
        
    },
    
    
    onload : function(component, event, helper) {
        //fetching current user details  
        helper.currentUserDeatails_Apex(component, event, helper); 
        var cData = {};
        cData.suggestedOrders = [];
        component.set("v.cacheData", cData); 
    },    
    
    onRender : function(component, event, helper) {
        component.set("v.showAnnouncements", true);
        let child = component.find("announcementComp");
        if (child) {
            child.initialize(); 
        } 
    },
 
    handleLocationChange : function(component, event, helper) { 
        
        var locObj = {};
        locObj.selectedLoc = event.getParam('selectedLoc');
        locObj.listSelectedLoc = event.getParam('listSelectedLoc');
        locObj.selectedGrp = event.getParam('selectedGrp');
        locObj.selectedDivision = event.getParam('selectedDivision');
        component.set("v.selectedLocation",locObj);
        component.set("v.selectedLocationObjString",JSON.stringify(locObj));
        //16-12-2021
        let userDetail = component.get("v.userDetail");
        if(userDetail.isNonDealer == true){
            helper.getAccessibleDealerLocationForNonEdalerUsers(component, event, helper,locObj.selectedLoc);
        }
        var payload = {
            detail: "refreshlocation"
        };
        console.log('built payload');
        console.log('find: '+ component.find("eDealerCSR"));
        component.find("eDealerCSR").publish(payload);
        console.log('sent payload');
        
        var unavailabledealerloc=false ;
        
        if(userDetail.accessDivision != 'All'){
            
            if(locObj.listSelectedLoc){
                locObj.listSelectedLoc.forEach(item => {
                    if(!JSON.stringify(component.get("v.allAccessibleDealersLocs")).includes(item)){
                    unavailabledealerloc = true;  
                    var currentUrl = window.location.href;
                    var createCsrBaseURL = currentUrl.split('?')[0];
                    if (currentUrl !== createCsrBaseURL) {
                    history.replaceState(null, null, createCsrBaseURL);  
                }
                                               }
                                               }
                                              );
            }
            else if(locObj.selectedLoc){
                unavailabledealerloc = !JSON.stringify(component.get("v.allAccessibleDealersLocs")).includes(locObj.selectedLoc);
                if(unavailabledealerloc){
                    var currentUrl = window.location.href;
                    var createCsrBaseURL = currentUrl.split('?')[0];
                    if (currentUrl !== createCsrBaseURL) {
                        history.replaceState(null, null, createCsrBaseURL);  
                    }
                }
            }  
            component.set("v.unavailableDealerLoc",unavailabledealerloc);
        }
        
        if(component.get('v.selectedMenu') == 'partnumberdetail'){
            debugger;
            var child=component.find('csrpartnumbersearch');
            if(Array.isArray(child))
            {
                child[0].handleByContainer();
            }
            else
            {
                child.handleByContainer();
            }
        }
        
        if(component.get('v.selectedMenu') == 'csrdetail'){
            debugger;
            var child=component.find('csrnumbersearch');
            if(Array.isArray(child))
            {
                child[0].handleByContainer();
            }
            else
            {
                child.handleByContainer();
            }
        }
        
        
    },
    
    myAction : function(component, event, helper) {        
        // placing objects inside variables
        var content = $('.contentBox');
        var sidebar = $('.sidebarBox');
        
        // get content and sidebar height in variables
        var getContentHeight = content.outerHeight();
        var getSidebarHeight = sidebar.outerHeight();
        
        // check if content height is bigger than sidebar
        if ( getContentHeight > getSidebarHeight ) {
            sidebar.css('min-height', getContentHeight);
        }
        
        // check if sidebar height is bigger than content
        if ( getSidebarHeight > getContentHeight ) {
            content.css('min-height', getSidebarHeight);
        }
    },
    
    handleOpenCSRListing: function(component, event, helper) {   
        component.set("v.selectedMenu", 'csrlisting');
        component.set("v.csrlistingtype", event.getParam("csrlistingoption"));
        component.set("v.csrlistingsubtype", event.getParam("csrtype"));
        component.set("v.csrlistingfrequency",  event.getParam("frequency"));
        component.set("v.selectedLocation", event.getParam("dealercodes"));   
        component.set("v.selectedLocationObjString",JSON.stringify(event.getParam("dealercodes")));
        
    },
    
    handleOpenCSRListingOnNewWindow: function(component, event, helper) { 
        component.set("v.csrlistingtype", event.getParam("csrlistingoption"));
        component.set("v.csrlistingsubtype", event.getParam("csrtype"));
        component.set("v.csrlistingfrequency",  event.getParam("frequency"));
        component.set("v.selectedLocation", event.getParam("dealercodes"));   
        component.set("v.selectedLocationObjString",JSON.stringify(event.getParam("dealercodes")));
        
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?csrlisting="+component.get("v.csrlistingtype")+"&csrtype="+component.get("v.csrlistingsubtype")+"&csrFrequency="+component.get("v.csrlistingfrequency")+"&loc="+component.get("v.selectedLocation.listSelectedLoc")),
            "isredirect": true
        });
        urlEvent.fire();
        console.log('event fired');
    },
    
    handleOpenDraftList: function(component, event, helper){
        let urlEvent = $A.get("e.force:navigateToURL");
        var draftcsrcount = event.getParam("draftcount");
        var dealercodes = event.getParam("dealercodes");
        urlEvent.setParams({
            "url": ("?draftcsrlist="+draftcsrcount+"&dealercodes="+dealercodes+""),
            "isredirect": true
        });
        urlEvent.fire();
    },
    handleOpenCSRDetail: function(component,event,helper){
        var selectedcsr = event.getParam("csrNumber");
        var selectedcsrphase = event.getParam("csrphase");
        var selectedLocation = event.getParam("location");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": ("?csrdetail="+selectedcsr+"&selectedcsrphase="+selectedcsrphase+"&loc="+selectedLocation),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    handleOpenCSREdit: function(component,event,helper){
        console.log('in edit url::');
        var division = component.get('v.userDetail.division');
        var selectedLocs = component.get('v.selectedLocation');
        var selectedcsrnumber = event.getParam("csrNumber");
        var selectedcsrphase = event.getParam("csrphase");
        var selectedLocation = event.getParam("location");
        let userDetail = component.get("v.userDetail");
        let urlEvent = $A.get("e.force:navigateToURL");
        if(userDetail.isNonDealer == true){
            urlEvent.setParams({
                "url": ("?csredit="+selectedcsrnumber+"&selectedcsrphase="+selectedcsrphase+"&loc="+selectedLocation+"&division="+division),
                "isredirect": true
            });
            helper.getAccessibleDealerLocationForNonEdalerUsers(component, event, helper,selectedLocation);
        }else{
            urlEvent.setParams({
                "url": ("?csredit="+selectedcsrnumber+"&selectedcsrphase="+selectedcsrphase+"&loc="+selectedLocation),
                "isredirect": true
            });  
        }
        urlEvent.fire();
    },
    
    handleupdateheaderkpicontainer: function(component,event,helper){
        var dashboardTranslation = event.getParam("dashboardTranslation");
        component.set("v.eDealer_CSR_Dashboard_Label", dashboardTranslation);
        var csrlistTranslation = event.getParam("csrlistTranslation"); 
        component.set("v.eDealer_CSR_List_Label", csrlistTranslation);   
        
        
    },
    //handles messages from the message channel
    handleMessageChannel: function(component,event,helper){
        if(event._params.detail == "createmode"){
            
            component.set("v.csrnumber",null);
            component.set("v.csrphase",null);
            component.set("v.enableCsrEditing",true)
            
            console.log('clearparamsCreateCSR successfull');
        }       
    }
})