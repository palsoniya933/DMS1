public with sharing class eDealerTileFilterController {
    @AuraEnabled
    public static List<Object> getCmpFilters(String ComponentName){
            Map<String,Object> eDealerFilterTranslation = EDealerMetadataUtility.eDealerFilterTranslation;

            Map <String, Object> allLanguageTranslations = (Map <String, Object>) eDealerFilterTranslation.get(ComponentName);   
            List<Object> s = (List<Object>) allLanguageTranslations.get(UserInfo.getLanguage());
            return s;
        
    }
}