/**
 * @author anthony.beran@slalom.com
 * @date 2019-05-26
 * @version 1.0
 * @description AccountDAO
 */

public with sharing class AccountDAO {
    
    /**
    public static List<Account> getAccountByDealerCode(Set<String> dealerCodes) {
        return [
            SELECT Dealer_Code__c, Dealer_ISP_PPFS_ID__c, Billing_Method__c
            FROM Account
            WHERE Dealer_Code__c IN :dealerCodes
        ];
    }
    **/    
    // This is the method which is added as replacement of the above method
    // Now SAML will send the fleet code as well so we have to consider that is the query while reterving the account.
    public static List<Account> getAccountByDealerCode(Set<String> dealerCodes) {    
        
        // make the dealer code in like set so that we can use the like operator
        set<string> setLikeDealerCode = new set<string>();
        for(String strDealderCode : dealerCodes){
           
            setLikeDealerCode.add('%'+strDealderCode+'%');
        }
        
        //new requirement for fleet user changes        
        String accId = null;
        List<Account_PASSCompany_Xref__c> accList=[Select Account__c,Company_UID__C from Account_PASSCompany_Xref__c where Company_UID__C IN: dealerCodes];
        if(accList.size()>0){
          
             accId = accList[0].Account__c;                            
         }       

        return [
            SELECT Name,Dealer_Code__c, Dealer_ISP_PPFS_ID__c, Billing_Method__c,Fleet_Account_Code__c
            FROM Account
            WHERE (Dealer_Code__c IN :dealerCodes 
                    OR Id=: accId
                    ) 
        ];                
    }

    public static List<Account> getById(Set<Id> accountIds) {
        return [
            SELECT Id, Is_Fleet__c, Is_Paclease__c, Type
            FROM Account
            WHERE Id IN :accountIds
        ];
    }

    public static List<Account> getDealerInfo(Set<Id> accountIds) {
        return [
            SELECT Dealer_Code__c, Name, Legal_Name__c, Site, Type, PACCARDivision__c, Currency__c, Tax_Type__c, Tax_ID__c, (
                SELECT FirstName, LastName, MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry, Email, Phone, MailingAddress
                FROM Contacts
            )
            FROM Account
            WHERE Id IN :accountIds
        ];
    }

    public static List<Account> getISPDealersMissingId() {
        Datetime now = Datetime.now();

        return [
            SELECT Id
            FROM Account
            WHERE LastModifiedDate >= :now.addDays(-2)
            AND Dealer_ISP_PPFS_ID__c = NULL
            AND (
                RecordType.DeveloperName = 'Independent_Service_Provider'
                OR PaccarDivision__c = 'PacCentral'
            )
        ];
    }
    
    public static List<Account_PASSCompany_Xref__c> getAccountXref(Set<String> accId) {
       
        return [SELECT Account__c,Company_UID__C 
                FROM Account_PASSCompany_Xref__c 
                WHERE Company_UID__C IN: accId];    
    }
    
    public static List<Account> getAccountsByDealerCodes(Set<String> dealerCodes) {
        if (dealerCodes == null || dealerCodes.isEmpty()) {
            return new List<Account>();
        }
        
        return [
            SELECT Id, Dealer_Code__c
            FROM Account
            WHERE Dealer_Code__c IN :dealerCodes
        ];
    }
}