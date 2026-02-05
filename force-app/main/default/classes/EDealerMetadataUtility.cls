// add tag here
public with sharing class EDealerMetadataUtility {
    
    public static List<Edealer_Access__mdt> getEdealerAccessMetadataByProfilesName(Set<String> profilesName){
        return [SELECT Id, DeveloperName,
                Profile_Name__c,
                ASI_Authentication__c
                FROM Edealer_Access__mdt
                WHERE Profile_Name__c IN :profilesName];
    }
    
    public static map<string,string> translateColumnHeaders(string reportName ){
        eDealer_Language_Translation__mdt languageTranslation;
        
        if(Schema.sObjectType.eDealer_Language_Translation__mdt.fields.DeveloperName.isAccessible()
           && Schema.sObjectType.eDealer_Language_Translation__mdt.fields.Translation_json__c.isAccessible()
           && Schema.sObjectType.eDealer_Language_Translation__mdt.fields.label.isAccessible()
           && Schema.sObjectType.eDealer_Language_Translation__mdt.fields.Language__c.isAccessible()
          ){
              languageTranslation = [select id,DeveloperName,Translation_json__c FROM eDealer_Language_Translation__mdt where label=:reportName AND Language__c=:UserInfo.getLanguage()];
          }
        
        if(languageTranslation.Translation_json__c != null){
            map<string,string> mapLanguageTranslated = translateReportColumns(languageTranslation.Translation_json__c);
            return mapLanguageTranslated;
        }
        return null;
    }
    
    private static map<string,string> translateReportColumns(string translateJSON){
        map<string,string> mapTranslatedJSON = (map<string,string>)JSON.deserialize(translateJSON, map<string,string>.class);
        return mapTranslatedJSON;
    }
    
    //Method used for getting filter fields transalation data
    @testVisible
    public static map<string,string> translateReportFilterField(string reportName){
      eDealer_Language_Translation__mdt languageTranslation = [select id,DeveloperName,Translation_json__c
                                                                 
                                                                 FROM eDealer_Language_Translation__mdt where label=:reportName 
                                                                 
                                                                 AND Language__c=:UserInfo.getLanguage()];  
                                                                 if(languageTranslation.Translation_json__c != null){
                                                                     map<string,string> mapLanguageTranslated = translateReportColumns(languageTranslation.Translation_json__c);
                                                                     return mapLanguageTranslated;
                                                                 }
        return null;        
    }
    
    
    // add comment here
    public static Map<String,Object>  translateColumnHeadersVersion2(string reportName){ 
        // query the metadata
        // call the eDealerTranslationServiceVersion2 method getTableDetailsInLoggedInUserLanguage and pass the query json
        // return the output of the method
        eDealer_Language_Translation__mdt activeOrderListingTable= [select id,DeveloperName,Translation_json__c FROM eDealer_Language_Translation__mdt WHERE label=:reportName AND Language__c=:UserInfo.getLanguage()];
        if(activeOrderListingTable.Translation_json__c !=null){
            Map<String,Object> mapActiveOrderListingTable = eDealerTranslationServiceVersion2.getTableDetailsInLoggedInUserLanguage(activeOrderListingTable.Translation_json__c);
            return mapActiveOrderListingTable;
        }
        return null;
    }
    
    /** 
* this code is to query the custom metadata and in same transaction if value is present it will return value without again query
*/ 
    public static map<String,Object> csrHeaderTranslations {
        get {
            if (csrHeaderTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'CSRHeaderTranslations'});
                if(!translations.isEmpty()){
                    csrHeaderTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return csrHeaderTranslations;
        }
        private set;
    }
    
    /*vs_VolumeSalesBundle*/
     public static map<String,Object> volumeSalesBundle {
        get {
            if (VolumeSalesBundle == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'vs_VolumeSalesBundle'});
                if(!translations.isEmpty()){
                    VolumeSalesBundle = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return VolumeSalesBundle;
        }
        private set;
    }
    
    
    /*made by deepak */
    public static map<String,Object> volumeSaleQuoteTranslation {
        get {
            if (volumeSaleQuoteTranslation == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'Volume_sale_quote_translation'});
                if(!translations.isEmpty()){
                    volumeSaleQuoteTranslation = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return volumeSaleQuoteTranslation;
        }
        private set;
    }
    
    public static List<Map<String,String>> tableColumnHeaderTranslations(String reportName) {
        List<Map<String,String>> options = new List<Map<String,String>>();
        List<eDealer_Language_Translation__mdt> translations = 
            getEdealerTranslationRecordByDeveloperName(new Set<String>{reportName});
        System.debug('translations :'+translations);
        if(!translations.isEmpty()){
            List<Object> allLanguageTranslation = (List<Object>) JSON.deserializeUntyped(translations[0].Translation_json__c); 
            for(Object picklistValuesWithAttributes : allLanguageTranslation){
                Map<String,object> picklistAttributes = (Map<String,object>) picklistValuesWithAttributes;
                String picklistLabel = (String) picklistAttributes.get(UserInfo.getLanguage());
                String picklistPickListValue = (String) picklistAttributes.get('columnAPIName');
                
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
    
    private static List<eDealer_Language_Translation__mdt> getEdealerTranslationRecordByDeveloperName(Set<String> developerNames){
        if(Schema.sObjectType.eDealer_Language_Translation__mdt.fields.DeveloperName.isAccessible()
           && Schema.sObjectType.eDealer_Language_Translation__mdt.fields.Translation_json__c.isAccessible()){
               return [select Translation_json__c FROM eDealer_Language_Translation__mdt where DeveloperName IN: developerNames];
           }
        return null;
    }
    
    public static Map<String,Object> csrTileTranslations {
        get {
            if (csrTileTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'CSRTileTranslations'});
                if(!translations.isEmpty()){
                    csrTileTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return csrTileTranslations;
        }
        private set;
    }
    
    public static Map<String,Object> myCSRTileTranslations {
        get {
            if (myCSRTileTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'MyCSRTileTranslations'});
                if(!translations.isEmpty()){
                    myCSRTileTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return myCSRTileTranslations;
        }
        private set;
    }
    
    public static Map<String,Object> pendingCSRTileTranslations {
        get {
            if (pendingCSRTileTranslations == null) {
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'PendingCSRTileTranslations'});
                if(!translations.isEmpty()){
                    pendingCSRTileTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }
            }
            return pendingCSRTileTranslations;
        }
        private set;
    }
    
    public static Map<String,Object> csrPartNumberSearchTranslations {
    get {
        if (csrPartNumberSearchTranslations == null) {
            List<eDealer_Language_Translation__mdt> translations = 
                getEdealerTranslationRecordByDeveloperName(new Set<String>{'eDealerPartNumberSearch'});
            if (!translations.isEmpty()) {
                csrPartNumberSearchTranslations = (Map<String,Object>) 
                    JSON.deserializeUntyped(translations[0].Translation_json__c);
            }
        }
        return csrPartNumberSearchTranslations;
    }
    private set;
}
    
    public static Map<String,Object> csrDrilldownTranslations {
        get { 
            if (csrDrilldownTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'CSRDrilldownTranslations'});
                if(!translations.isEmpty()){
                    csrDrilldownTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return csrDrilldownTranslations;
        }
        private set;
    }
    
    public static Map<String,Object> csrDashboardTranslations{
        get {
            if (csrDashboardTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'csrDashboardTranslations'});
                if(!translations.isEmpty()){
                    csrDashboardTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return csrDashboardTranslations;
        }
        private set;
    }
    
    public static map<String,Object> CSRAnnouncementTranslations {
        get {
            if (csrAnnouncementTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'CSRAnnouncementTranslations'});
                if(!translations.isEmpty()){
                    csrAnnouncementTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return CSRAnnouncementTranslations;
        }
        private set;
    }    
    
    public static String dealerAccessType(String profileName,String roleName){
        
        
        eDealer_Dealer_Type_Access__mdt[] dealerMdt = [select id,Profile_Name__c,Role_Name__c,Division__c from eDealer_Dealer_Type_Access__mdt where Profile_Name__c =:profileName AND Role_Name__c=:roleName];
        
        if(!dealerMdt.isEmpty()){
            System.debug('dealerMdt[0].Division__c'+dealerMdt[0].Division__c);
            return dealerMdt[0].Division__c;
        }
        return 'All';
    }
    
    public static Map<String,Object> quoteRequestTranslations  {
        get { 
            if (quoteRequestTranslations == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'VolumeSalesQuoteTranslation'});
                if(!translations.isEmpty()){
                    quoteRequestTranslations = (map<String,Object>) 
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return quoteRequestTranslations;
        }
        private set;
    }
    
    public static Map<String,Object> volumeSalesCustomButtonsTranslation  {
        get { 
            if (volumeSalesCustomButtonsTranslation == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'VS_CommunityCustomButtons'});
                if(!translations.isEmpty()){
                    volumeSalesCustomButtonsTranslation = (map<String,Object>)  
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return volumeSalesCustomButtonsTranslation;
        }
        private set;
    }

    public static Map<String,Object> volumeSalesQuoteToOrderTranslation  {
        get { 
            if (volumeSalesQuoteToOrderTranslation == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'vsQuoteToOrder'});
                if(!translations.isEmpty()){
                    volumeSalesQuoteToOrderTranslation = (map<String,Object>)  
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return volumeSalesQuoteToOrderTranslation;
        }
        private set;
    }
    
    public static Map<String,Object> eDealerFilterTranslation  {
        get { 
            if (eDealerFilterTranslation == null) { 
                List<eDealer_Language_Translation__mdt> translations = 
                    getEdealerTranslationRecordByDeveloperName(new Set<String>{'eDealerFilters'});
                if(!translations.isEmpty()){
                    eDealerFilterTranslation = (map<String,Object>)  
                        JSON.deserializeUntyped(translations[0].Translation_json__c);
                }                
            }
            return eDealerFilterTranslation;
        }
        private set;
    }
    
       public static Map<String,Object> frequencyTranslations {
         get { 
                if (frequencyTranslations == null) { 
                    List<eDealer_Language_Translation__mdt> translations = 
                            getEdealerTranslationRecordByDeveloperName(new Set<String>{'eDealerFrequency'});
                    if(!translations.isEmpty()){
                        frequencyTranslations = (map<String,Object>)  
                            JSON.deserializeUntyped(translations[0].Translation_json__c);
                    }                
                }
                return frequencyTranslations;
            }
            private set;
    }

    public static Map<String, Object> getVolumeSalesValues() {
        Map<String, Object> configValues = new Map<String, Object>();
        try {
            List<EDealer_Config__mdt> configs = [
                SELECT DeveloperName, Long_Value__c
                FROM EDealer_Config__mdt
                WHERE DeveloperName IN ('Included_Region_for_Volume_Sales_Bundle', 'Volume_Sales_URL')
            ];

            for (EDealer_Config__mdt cfg : configs) {
                if (cfg.DeveloperName == 'Included_Region_for_Volume_Sales_Bundle') {                    
                    configValues.put('includedRegions', 
                        (List<String>) JSON.deserialize(cfg.Long_Value__c, List<String>.class));
                }
                
                if (cfg.DeveloperName == 'Volume_Sales_URL') {                    
                    configValues.put('volumeSalesUrl', 
                        String.valueOf(JSON.deserializeUntyped(cfg.Long_Value__c)).replace('"',''));
                }
            }
        } catch (Exception e) {
            System.debug('Error fetching EDealer Config metadata: ' + e.getMessage());
        }
        return configValues;
    }
}