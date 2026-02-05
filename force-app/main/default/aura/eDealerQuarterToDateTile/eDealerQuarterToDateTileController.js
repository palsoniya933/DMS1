({
	doInit : function(component, event, helper) {
    	var currentDate = new Date();        
        component.set("v.date", currentDate);
        component.set("v.quarterToDateReportData", []);
        // get current year and quarter from current date
        component.set("v.currentYear", currentDate.getFullYear().toString());
        component.set("v.currentQuarter", Math.ceil((currentDate.getMonth() + 1) / 3).toString());  
        // tool tip
		component.set("v.isTooltipVisible", false);
        
        //language translation changes for the Selected Options
        component.set('v.selectoptions', [
            {label: 'ELITE +', value: $A.get("$Label.c.Edealer_ELITE_PLUS")},
            {label: 'Elite', value: $A.get("$Label.c.Edealer_ELITE")},
            {label: 'Tier 1', value: $A.get("$Label.c.Edealer_TIER_1")},
            {label: 'No Benefits', value: $A.get("$Label.c.Edealer_NO_BENEFITS")},
            {label: 'New Dealer', value: $A.get("$Label.c.Edealer_NEW")}]
                     );  

        //Check data in cache or fetch data
        helper.checkDataInCacheOtherWiseFetchData(component, event, helper); 
		helper.getReportData(component, event, helper);
	},
    // New Text hover method
    handleCustomMouseHover: function(component, event, helper) {
        // Logic for infoTextIconPosition
        component.set("v.togglehover", true); 
    },    
    
    handleMouseHover: function(component, event, helper) {
        component.set("v.togglehover",true);
    },
    handleMouseOut: function(component, event, helper) {
        component.set("v.togglehover",false);
    },
    
    updateTileDetails : function(component, event, helper) {
        
        var dataList = component.get("v.quarterToDateReportData");
        if(!$A.util.isUndefinedOrNull(dataList) && dataList.length > 0){
            var availability = 0;
            var breadth = 0;
            var autoacceptutil = 0;     // for MDI Tier Level changes 07/27/2023
            var trendingTier = undefined;
            var currentTier = undefined;
            
            if(!$A.util.isUndefinedOrNull(dataList[0].availability)){
                availability = Number.parseFloat(dataList[0].availability);
            }
            if(!$A.util.isUndefinedOrNull(dataList[0].breadth)){
                breadth = Number.parseFloat(dataList[0].breadth);
            }
            // MDI Tier Level Changes 07/27/2023 - Start
            if(!$A.util.isUndefinedOrNull(dataList[0].auto_accept_util)){
                autoacceptutil = Number.parseFloat(dataList[0].auto_accept_util);
            }         
            // MDI Tier Level Changes 07/27/2023 - End
            /*if(!$A.util.isUndefinedOrNull(dataList[0].qtd_trending_tier)){
                trendingTier = dataList[0].qtd_trending_tier;
            }*/
            if(!$A.util.isUndefinedOrNull(dataList[0].qtd_trending_tier)){
                if(dataList[0].qtd_trending_tier == 'Elite Plus' || dataList[0].qtd_trending_tier == 'ELITE PLUS'){
                    trendingTier = 'ELITE +';
                }else{
                    trendingTier = dataList[0].qtd_trending_tier;
                }
                
                
            }
            
            if(!$A.util.isUndefinedOrNull(dataList[0].current_tier)){
                if(dataList[0].current_tier == 'Elite Plus' || dataList[0].current_tier == 'ELITE PLUS'){
                    currentTier = 'ELITE +';
                }else{
                    currentTier = dataList[0].current_tier;
                }
            }
            component.set("v.availability", availability);
            component.set("v.breadth", breadth);
            component.set("v.autoacceptutil",autoacceptutil);    // MDI Tier Level Changes - 07/27/2023
            component.set("v.trendingTier", trendingTier);
            component.set("v.currentTier", currentTier);
            
        }else{
            //set default values
            helper.defaultTileDetails(component, event, helper);
        }
    },
    showTooltip: function(component, event, helper) {
        component.set("v.isTooltipVisible", true);
    },

    hideTooltip: function(component, event, helper) {
        component.set("v.isTooltipVisible", false);
    }    

})