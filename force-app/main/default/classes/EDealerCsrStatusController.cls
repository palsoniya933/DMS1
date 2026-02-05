public class EDealerCsrStatusController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getCsrStatus() {
        List<Map<String,String>> options = new List<Map<String,String>>();
        
        //this is the method which will return the current user logged in information
        User usr = new User();
        usr = EDealerUserUtils.fetchLoggedInUserdetails();  
        eDealer_Config__mdt csrStatus = new eDealer_Config__mdt();
        if(usr.IsPortalEnabled == true){  

            //get Dealer status from edealer config
            csrStatus = EDealerConfigUtils.getConfigByDeveloperName('CSR_Dealer_Status');
            
        }else if(usr.IsPortalEnabled != true){
            
            //get PPD Sales Status from edealer config
            csrStatus = EDealerConfigUtils.getConfigByDeveloperName('CSR_PPD_Status');
          
        }
        if(csrStatus != null){
            List<Object> allLanguageTranslation = (List<Object>) JSON.deserializeUntyped(csrStatus.Long_Value__c); 
            for(Object picklistValuesWithAttributes : allLanguageTranslation){
                Map<String,object> picklistAttributes = (Map<String,object>) picklistValuesWithAttributes;
                String picklistLabel = (String) picklistAttributes.get(UserInfo.getLanguage());
                String picklistPickListValue = (String) picklistAttributes.get('value');
                
                Map <String, String> values = new Map < String, String > {
                        'label' => picklistLabel,
                        'value' => picklistPickListValue
                        }; 
                options.add(values);            
            }    
            return options;
        }
        return null;
    }  
}