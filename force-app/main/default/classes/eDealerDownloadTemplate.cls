public without sharing class eDealerDownloadTemplate  {
    
    @AuraEnabled
    public static string getDownloadTemplateId() {
        // Get the current logged-in user's language
        return UserInfo.getLanguage();
        //String userLanguage = UserInfo.getLanguage();
        // System.debug(userLanguage);
        // // Call the EDealerConfigUtils static method to get the config by developer name
        // eDealer_Config__mdt config = EDealerConfigUtils.getConfigByDeveloperName('CSR_Mass_Upload_File');
        
        
        // // Parse Long_Value__c field into a Map<String, String>
        // Map<String, String> configMap = new Map<String, String>();
        // if (config != null && config.Long_Value__c != null) {
        //     system.debug('\n--config.Long_Value__--'+config.Long_Value__c);
        //     Map<String, Object> configMapUntyped = (Map<String, Object>) JSON.deserializeUntyped(config.Long_Value__c);
        //     System.debug('data'+configMapUntyped.get(userLanguage));
        //     if(configMapUntyped.containsKey(userLanguage)){
        //         String resourceID = (String)configMapUntyped.get(userLanguage);
        //         if(Schema.sObjectType.StaticResource.fields.Name.isAccessible() && Schema.sObjectType.StaticResource.fields.Body.isAccessible() ){
        //             StaticResource resource = [SELECT Id, name,body FROM StaticResource  WHERE id =:resourceID  LIMIT 1];
        //             // String baseUrl = URL.getOrgDomainURL().toExternalForm();
        //             // PageReference resourcePageRef = PageReference.forResource(resource.name);
        //             // String resourceUrl = baseUrl + resourcePageRef.getUrl();
        //             // System.debug(resourceUrl);
        //             // return resourceUrl;
        //             return '/resource/'+resource.Id+'/'+resource.Name;
        //         }
        //         else{
        //             return null;
        //         }
              
        //     }            
        //     // Create a new map with String values            
        //     // for (String key : configMapUntyped.keySet()) {
        //     //     configMap.put(key, String.valueOf(configMapUntyped.get(key)));
        //     // }
            
        // }
        
        // // Get the value from the map based on the logged-in user's language
        // // String configValue = configMap.get(userLanguage);
        
        // // // Return the config value
        // // return configValue;
        // // String  BASE_URL = URL.getOrgDomainURL().toExternalForm();
        // // ContentVersion file = new ContentVersion();
        // // file = [SELECT Id, Title,ContentdocumentId FROM ContentVersion where Title = 'ExportedEstimate (1)' LIMIT 1];
        // // String DownmloadURL = BASE_URL + '/sfc/servlet.shepherd/document/download/'+file.ContentdocumentId;
        //  return null;
    }
}