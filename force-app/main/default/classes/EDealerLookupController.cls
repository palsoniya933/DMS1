public with sharing class EDealerLookupController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        String searchKey = searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        
        Integer recordLimit = (Integer) eDealer_Config__mdt.getInstance('lookupLimit').Value__c;
        
        String sQuery =  'select id, Name, Carrier_Code__c from ' +ObjectName + ' where Name LIKE : searchKey order by createdDate DESC limit : recordLimit';
        
        List < sObject > lstOfRecords = Database.query(String.escapeSingleQuotes(sQuery));
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        //system.debug('\n--returnList\n--');
        
        return returnList;
    }
    
    @AuraEnabled
    public static List < sObject > fetchDealerLocValues(String searchKeyWord, String ObjectName, String division) {
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        Integer recordLimit = (Integer) eDealer_Config__mdt.getInstance('lookupLimit').Value__c;
        
        String sQuery =  'select id, Name, Dealer_Code__c from ' +ObjectName + ' where Dealer_Code__c LIKE : searchKey AND PACCARDivision__c =:division order by Dealer_Code__c ASC limit : recordLimit';
        
        List < sObject > lstOfRecords = Database.query(String.escapeSingleQuotes(sQuery));
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        
        return returnList;
        
    }
}