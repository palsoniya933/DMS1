public class LoyaltyMetadataUtility {
    
    public static List<Loyalty_Language_Translation__mdt> loyaltyLanguageTranslations;
    
    public static List<Map<String,Object>> getTableColumnHeaderTranslations(String reportName, String language) {
        System.debug('Method Entry: LoyaltyMetadataUtility.getTableColumnHeaderTranslations\nreportName:: '+ reportName + '\nlanguage:: '+language);
        List<Map<String,Object>> options = new List<Map<String,Object>>();
        getLoyaltyTranslationRecordByDeveloperName(new Set<String>{reportName});
        System.debug('loyaltyLanguageTranslations=>'+JSON.serialize(loyaltyLanguageTranslations));
        String userLanguage = String.isEmpty(language) ? UserInfo.getLanguage() : language;
        if(!loyaltyLanguageTranslations.isEmpty()){
            List<Object> allLanguageTranslation = (List<Object>) JSON.deserializeUntyped(loyaltyLanguageTranslations[0].Translation_json__c); 
            for(Object picklistValuesWithAttributes : allLanguageTranslation){
                Map<String,object> picklistAttributes = (Map<String,object>) picklistValuesWithAttributes;
                
                String picklistLabel = picklistAttributes.get(userLanguage) != Null ? 
                    (String) picklistAttributes.get(userLanguage) : '';
                String picklistPickListValue = picklistAttributes.get('columnAPIName') != Null ?
                    (String) picklistAttributes.get('columnAPIName') : '';
                Integer order = picklistAttributes.get('order') != Null ? 
                    (Integer) picklistAttributes.get('order') : 0;
                Map <String, Object> values = new Map < String, Object > {
                    'label' => picklistLabel,
                        'value' => picklistPickListValue,
                        'order' => order
                        }; 
                            options.add(values);            
            }  
        }
        loyaltyLanguageTranslations = null;
        System.debug('Method Exit: LoyaltyMetadataUtility.getTableColumnHeaderTranslations\noptions:: '+ options);
        return options;
    }
    
    private static void getLoyaltyTranslationRecordByDeveloperName(Set<String> developerNames){
        if(loyaltyLanguageTranslations == null){
            if(Schema.sObjectType.Loyalty_Language_Translation__mdt.fields.DeveloperName.isAccessible()
               && Schema.sObjectType.Loyalty_Language_Translation__mdt.fields.Translation_json__c.isAccessible()){
                   loyaltyLanguageTranslations = [SELECT Translation_json__c 
                           FROM Loyalty_Language_Translation__mdt 
                           WHERE DeveloperName IN: developerNames];
               }
        }
    }
}