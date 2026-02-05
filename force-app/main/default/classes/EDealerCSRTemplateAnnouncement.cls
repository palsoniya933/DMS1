public with sharing class EDealerCSRTemplateAnnouncement {
    @AuraEnabled(cacheable=true)  

	public static CSR_Template_Notification__mdt getTemplateDetail() {
    
    	        return [ 
                        SELECT Id, CSR_Template_Start_Date__c, CSR_Template_End_Date__c
                        FROM CSR_Template_Notification__mdt 
                        where DeveloperName ='CSR_Template_Announcement' 
                        LIMIT 1
                ];
	}

    @AuraEnabled(cacheable=true)
    public static CSRAnnouncement getCSRAnnouncementTranslations() {
        Map<String, String> message = getMessageTranslationValue('CSRAnnouncement');
        System.debug('Message '+message);
        return new CSRAnnouncement(message);
    }    
    
    static Map<String, String> getMessageTranslationValue(String attributeName){
        Map<String, String> options = new Map<String, String>();
        Map<String, Object> CSRAnnouncementTranslations = EDealerMetadataUtility.csrAnnouncementTranslations;
        system.debug('CSRAnnouncementTranslations '+CSRAnnouncementTranslations);

        Object allLanguageTranslations = CSRAnnouncementTranslations.get(attributeName);
        system.debug('allLanguageTranslations '+allLanguageTranslations);

        Map<String, object> convertedAttributes = (Map<String, object>) allLanguageTranslations;
        String translationLabel = (String) convertedAttributes.get(UserInfo.getLanguage());
        options.put('label', translationLabel);
        system.debug('Option value '+options);
        return options;
    }

    public class CSRAnnouncement {
        @AuraEnabled
        public Map<String, String> message;
        public CSRAnnouncement(Map<String, String> message) {
            this.message = message;
        }
    } 
   

}