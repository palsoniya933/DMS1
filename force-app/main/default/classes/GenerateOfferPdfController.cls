global with sharing class GenerateOfferPdfController {
    @AuraEnabled
    public static Map<String,List<Map<String,Object>>> getOfferPdfTranslations(String language) {
        return new Map<String,List<Map<String,Object>>>{
            'offerPdfHeader' => LoyaltyMetadataUtility.getTableColumnHeaderTranslations('Offer_Pdfs_Table_Header',language),
                'months' => LoyaltyMetadataUtility.getTableColumnHeaderTranslations('MonthNameTranslations',language)
        };
    }
    
    @AuraEnabled
    public static Map<String, Object> getCurrentLoggedInUserDetails() {
        User currentUser = [SELECT Id, Profile.Name, ASI_Username__c, Name,Dealer_Code__c,contactId
                            FROM User 
                            WHERE Id = :UserInfo.getUserId()
                            LIMIT 1];
        
        Map<String, Object> userDetails = new Map<String, Object>();
        
        if (currentUser != null) {
            userDetails.put('isDealerUser', currentUser.contactId != null);
            userDetails.put('dealerCode', currentUser.Dealer_Code__c);
        }
        
        return userDetails;
    }
    
}