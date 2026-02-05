({
    // this method will be called onload of the component
    doInit : function(component, event, helper) {
        component.set("v.selectoptions",[
            {label: 'monthly', value: $A.get("$Label.c.EDealer_filters_dates_M")},
            {label: 'quaterly', value: $A.get("$Label.c.EDealer_filters_dates_Q")},
            {label: 'yearly', value: $A.get("$Label.c.EDealer_filters_dates_1Y")},
            {label: 'annually', value: $A.get("$Label.c.EDealer_filters_dates_YTD")}]);
        //set default 
        helper.defaultSelectedOption(component);        
        //Check data in cache or fetch data
        helper.fetchReturnComplianceData(component, event, helper); 
    },
    
    // when user have clicked on menu of the tiles
    updateTileDetails : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'MDI Return Compliance');
        var index = event.target.name;
        //var currentEl = event.currentTarget.name;
        var orderDetail = component.get("v.returnComplianceData");
        component.set("v.selectedoption",index);
        helper.updatePicklistOptionsData(component, event, helper);
    },
    
    changeUIData : function(component, event, helper) {
        helper.updateTrackingDetails(component, event, helper,'MDI Return Compliance');
        console.log("changeUIData");
        var valDate = event.target.value;
        //monthly/quaterly/yearly
        var selectedOption = component.get("v.selectedoption");
        var returnComplianceData = component.get("v.returnComplianceData");
        var rcUIData = {};
        
        if(selectedOption == 'monthly'){
            var lstMonthly = returnComplianceData.month_data;
            for(var i=0;i<lstMonthly.length;i++){
                if(lstMonthly[i].suggested_month_create_date == valDate){
                    rcUIData = lstMonthly[i];
                }
            }
        }else if(selectedOption == 'quaterly'){
            var lstQuarterly = returnComplianceData.quarter_data;
            for(var i=0;i<lstQuarterly.length;i++){
                if(lstQuarterly[i].suggested_quarter_create_date == valDate){
                    rcUIData = lstQuarterly[i];
                }
            }
        }
        else if(selectedOption == 'yearly'){
            var lstyearly = returnComplianceData.previous_year_data;
            for(var i=0;i<lstyearly.length;i++){
                if(lstyearly[i].suggested_year == valDate){
                    rcUIData = lstyearly[i];
                }
            }
        }
            else  if(selectedOption == 'annually'){
            var lstannually = returnComplianceData.current_year_data;
            for(var i=0;i<lstannually.length;i++){
                if(lstannually[i].suggested_year == valDate){
                    rcUIData = lstannually[i];
                }
            }
            }
        component.set('v.rcUIData', rcUIData);
    },
    
    handleOpenInNewWindow : function(component, event, helper) { 
        helper.updateTrackingDetails(component, event, helper,'MDI Return Compliance');
        var option = component.get("v.selectedoption");
        var dealerLoc = component.get("v.dealerLoc");
        var dealerDivision = component.get("v.divisionType");
        
        var url = "?orderlisting=returncompliance";
        
        var rcUIData = component.get('v.rcUIData');
        if(option == 'quaterly'){
            url = url + "&quarter="+helper.getQuarterName(rcUIData.suggested_quarter) +' '+ rcUIData.suggested_year + "&quarterDate="+rcUIData.suggested_quarter_create_date;
        }
        else if(option == 'monthly'){
            url = url + "&month="+helper.getMonthName(rcUIData.suggested_month) +' '+ rcUIData.suggested_year + "&monthDate="+rcUIData.suggested_month_create_date;
        }
            else if(option == 'yearly'){
                url = url + "&year="+rcUIData.suggested_year;
            }
         else if(option == 'annually'){
                url = url + "&year="+rcUIData.suggested_year;
            }
        url = url + "&loc="+dealerLoc+"&division="+dealerDivision;
        
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url,
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    openOrdersTile : function(component, event, helper){
        helper.updateTrackingDetails(component, event, helper,'MDI Return Compliance');
        var rcUIData = component.get('v.rcUIData');
        var option = component.get("v.selectedoption");
        if(option == 'quaterly'){
            component.set("v.quarter",helper.getQuarterName(rcUIData.suggested_quarter) +' '+ rcUIData.suggested_year);
            component.set("v.quarterDate", rcUIData.suggested_quarter_create_date);
        }
        else if(option == 'monthly'){
            component.set("v.month",helper.getMonthName(rcUIData.suggested_month) +' '+ rcUIData.suggested_year);
            component.set("v.monthDate", rcUIData.suggested_month_create_date);
        }
            else if(option == 'yearly'){
                component.set("v.year",rcUIData.suggested_year);
            }
          else if(option == 'annually'){
                component.set("v.year",rcUIData.suggested_year);
            }
        
        component.set("v.selectedSubMenu", "returncompliance");
        
        var menuEvent = $A.get("e.c:eDealerSubMenu");    
        menuEvent.setParams({ "menuName" : 'dashboardDivV2',
                             "submenu" : "returncompliance" });
        menuEvent.fire();
    },
     showTooltip: function(component, event, helper) {
        component.set("v.isTooltipVisible", true);
    },

    hideTooltip: function(component, event, helper) {
        component.set("v.isTooltipVisible", false);
    }  
})