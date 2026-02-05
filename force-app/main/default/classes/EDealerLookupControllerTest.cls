@isTest
public class EDealerLookupControllerTest {
    
    @isTest
    private static void validateLookupContr(){
        Account objAccount =new Account(Dealer_Code__c='V648',Name='account',PACCARDivision__c='P');
        insert objAccount;
        
        List<eDealer_Carrier__c> carrierLst = new List<eDealer_Carrier__c>();
        eDealer_Carrier__c carrier = new eDealer_Carrier__c();
        carrier.Name = 'test Carrier';
        carrierLst.add(carrier);
        insert carrierLst;
        System.assertEquals('test Carrier',carrierLst[0].Name,'Name shold be "test Carrier".');
        
        Test.startTest();
        List < sObject > returnList1 = EDealerLookupController.fetchLookUpValues('Test','eDealer_Carrier__c');
        System.assert(returnList1.size()==1,'list size should be 1.');
        List < sObject > returnList2 = EDealerLookupController.fetchDealerLocValues('V648','account','p');
        System.assert(returnList2.size()==1,'list size should be 1.');
        Test.stopTest();
    }
    
}