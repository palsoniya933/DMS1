({
	setDashboardLanguage : function(component) {
        const currentLanguage = $A.get("$Locale.langLocale");
		if(currentLanguage.toLowerCase() == 'es_mx'){
            component.set('v.showFrenchDashboard',false);
            component.set('v.showSpanishDashboard',true);
            component.set('v.showEnglishDashboard',false);
        }
        else if(currentLanguage.toLowerCase() == 'fr_ca'){
            component.set('v.showFrenchDashboard',true);
            component.set('v.showSpanishDashboard',false);
            component.set('v.showEnglishDashboard',false);
        }
            else{
                component.set('v.showFrenchDashboard',false);
                component.set('v.showSpanishDashboard',false);
                component.set('v.showEnglishDashboard',true);
                
            }
	},
    
    setFilterOnDatasets : function(component, event, helper) {
        component.set("v.showDashboard",false);
        component.set('v.showErrorMessage',false);
        let dealerCode = component.get('v.dealerCode');
        let lstSelectedLocation = component.get('v.lstSelectedLocation');
        if(helper.isAllSelectedDealerCodeContainsDealerSuffix(lstSelectedLocation)){
            component.set('v.showErrorMessage',true);
            component.set("v.showDashboard",false);
            return;
        }
        const dealersWithoutSuffix = helper.removeDealersWithSuffix(lstSelectedLocation);
        if(dealersWithoutSuffix.length == 0){
            dealersWithoutSuffix =['NullIn'];
        }
        helper.setFilters(component,helper,dealersWithoutSuffix);
        helper.idetifyRenderingLanguage(component);
        component.set("v.showDashboard",true); 
    },
    
    isAllSelectedDealerCodeContainsDealerSuffix :  function(lstSelectedLocation) {
        return lstSelectedLocation.every((selectedLocation) =>{
            return selectedLocation.includes('-');
        })
    },
    
    removeDealersWithSuffix : function (lstSelectedLocation){
        const dealersWithoutSuffix = lstSelectedLocation.filter((selectedLocation)=>{
            return !selectedLocation.includes('-');
        })
        return dealersWithoutSuffix;
    },
    
    setFilters : function(component, helper,lstSelectedLocation){
        const dealersInfo = component.get('v.dealersInfo');
        let filter = {
            "datasets": {
                "RPM_Drill_Down": [
                    {
                        "fields": [
                            "DealerCode"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Loyalty_Program_Active_Users_Growth_Dataset_2": [
                    {
                        "fields": [
                            "PREFERREDDEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Training_Points_Dataset": [
                    {
                        "fields": [
                            "LOCATIONCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "RedemptionSummaryDataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Marketing_Campaign_Utilization_Dataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Active_Users_Year_Dataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ],
                "Loyalty_Program_Active_Users_Growth_Dataset": [
                    {
                        "fields": [
                            "DEALERCODE"
                        ],
                        "filter": {
                            "operator": "in",
                            "values": lstSelectedLocation
                        }
                    }
                ]
            }
        };
        component.set("v.filters",JSON.stringify(filter));  
    },
    
    idetifyRenderingLanguage : function(component){
        const currentLanguage = $A.get("$Locale.langLocale");
        if(currentLanguage.toLowerCase() == 'es_mx'){
            component.set('v.showFrenchDashboard',false);
            component.set('v.showSpanishDashboard',true);
            component.set('v.showEnglishDashboard',false);
        }
        else if(currentLanguage.toLowerCase() == 'fr_ca'){
            component.set('v.showFrenchDashboard',true);
            component.set('v.showSpanishDashboard',false);
            component.set('v.showEnglishDashboard',false);
        }
            else{
                component.set('v.showFrenchDashboard',false);
                component.set('v.showSpanishDashboard',false);
                component.set('v.showEnglishDashboard',true);
                
            }
        
    },
})