@IsTest
public class eDealerCSRViewCommentsControllerTest {
    
    @TestSetup static void createTestData() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.Dealer_Code__c = 'I080';
        account.Dealer_Group_Name__c='test';
        account.Dealer_Group_Code__c='I080';
        account.PACCARDivision__c = 'K';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer Groups and Dealerships').getRecordTypeId();
        insert account;
        
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.AccountId = account.Id;
        contact.Email = 'testing@nonemail.com';
        
        insert contact;
        
        EDealer_Relationship__c eDealerRel = new EDealer_Relationship__c();
        eDealerRel.Contact__c = contact.Id;
        eDealerRel.ASI_Dealer_Code__c = 'I080';
        eDealerRel.Sub_Code__c = '009';
        eDealerRel.Customer_Name__c = 'Testing EDealer Relationship';
        eDealerRel.Allow_Download_Of_Reports__c = true;
        eDealerRel.Allow_Upload_Of_Orders__c = true;
        eDealerRel.Allow_Upload_Of_Rma__c = true;
        eDealerRel.Availability_Inquiry__c = true;
        eDealerRel.Dealer_Control_Of_Doests__c = true;
        eDealerRel.Dealer_Doe_Status__c = true;
        eDealerRel.Interactive_Order_Entry__c = true;
        eDealerRel.Order_Inquiry__c = true;
        eDealerRel.Price_Inquiry__c = true;
        eDealerRel.Return_Inquiry__c = true;
        eDealerRel.Division__c = 'K';
        eDealerRel.Currency_Code__c = 'USD';
        eDealerRel.Dealer_Group__c = 'I080';
        eDealerRel.Dealer_Doe_Status__c = true;
        eDealerRel.Dealer_Doe_Status__c = true;
        insert eDealerRel;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='Paccar TCS edealer Community Plus']; 
        User user = new User();
        user.Alias = 'standt';
        user.Email = 'systemAdministrator@nonemail.com';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.FirstName = 'Testing';
        user.LastName = 'User';
        user.LanguageLocaleKey = 'en_US';
        user.ContactId=contact.Id;
        user.LocaleSidKey = 'en_US';
        user.ProfileId = profile.Id;
        user.ASI_Username__c='I080';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.UserName = 'systemAdministrator@testorg.io';
        insert user;
        
        EDealer_Relationship__c eDealerRelForUser = new EDealer_Relationship__c();
        eDealerRelForUser.User__c = user.Id;
        eDealerRelForUser.ASI_Dealer_Code__c = 'I080';
        eDealerRelForUser.Sub_Code__c = '009';
        eDealerRelForUser.Customer_Name__c = 'EDealer Relationship for User';
        eDealerRelForUser.Allow_Download_Of_Reports__c = true;
        eDealerRelForUser.Allow_Upload_Of_Orders__c = true;
        eDealerRelForUser.Allow_Upload_Of_Rma__c = true;
        eDealerRelForUser.Availability_Inquiry__c = true;
        eDealerRelForUser.Dealer_Control_Of_Doests__c = true;
        eDealerRelForUser.Dealer_Doe_Status__c = true;
        eDealerRelForUser.Interactive_Order_Entry__c = true;
        eDealerRelForUser.Order_Inquiry__c = true;
        eDealerRelForUser.Price_Inquiry__c = true;
        eDealerRelForUser.Return_Inquiry__c = true;
        eDealerRelForUser.Division__c = 'K';
        eDealerRelForUser.Currency_Code__c = 'USD';
        eDealerRelForUser.Dealer_Group__c = 'I080';
        eDealerRelForUser.Dealer_Doe_Status__c = true;
        eDealerRelForUser.Dealer_Doe_Status__c = true;
        insert eDealerRelForUser;
        
    }
    
    @IsTest static void validateGetCsrCommentsFromAws() {
        String csrNumber = '30348092';
        String csrPhase = '1';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String responseData = eDealerCSRViewCommentsController.getCsrCommentsFromAws(csrNumber, csrPhase);
        
        Test.stopTest();
        
        Assert.isNotNull(responseData, 'CSR Comment retrieval fails.');
    }
    
    @IsTest static void validateGetCommentsColumnHeaders() {
        Test.startTest();
        List<Map<String,String>> columnHeader = eDealerCSRViewCommentsController.getCommentsColumnHeaders();
        Test.stopTest();
        
        Assert.isFalse(columnHeader.isEmpty(), 'No such column header founds.');
    }
    
    /**@IsTest static void validateFetchLoggedInUserDetailsWithAdmin() {
        User user = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Testing' AND LastName = 'User'];
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        
        System.runAs(user) {
            eDealerCSRViewCommentsController.UserWrapper userDetails = eDealerCSRViewCommentsController.fetchLoggedInUserDetails();
        }
    }**/
    
    @IsTest static void validateFetchLoggedInUserDetailsWithPortalUser() {
        List<EDealer_Relationship__c> lstDealerRelationships = new List<EDealer_Relationship__c>(); 
        User user = [SELECT Id,IsPortalEnabled,ContactId FROM User Where IsPortalEnabled = true and IsActive = true LIMIT 1];
        eDealerCSRViewCommentsController.UserWrapper userDetails;
        System.runAs(user) {            
            try {
                test.startTest();
                userDetails = eDealerCSRViewCommentsController.fetchLoggedInUserDetails();                
                test.stopTest();
                
                
                // Add assertions here if the method execution is expected to be successful
            } catch (AuraHandledException ex) {
                // This block will handle the AuraHandledException
                // Add assertions here to verify the behavior when the exception is thrown
                System.assertEquals('Script-thrown exception', ex.getMessage(), 'Unexpected exception message');
            }            
        }        
    }
    
    @IsTest static void validateAccessibleDealerLocs() {
        Id contactId = [SELECT Id FROM User LIMIT 1].Id;
        Boolean isPortalUser = false;        
        Test.startTest();
        List<EDealer_Relationship__c> eDealerRels = eDealerCSRViewCommentsController.getAccessibleDealerLocs(contactId, isPortalUser);
        Test.stopTest();
    }
    
    @IsTest static void validateNotAccessibleDealerLocs() {
        Id userId = [SELECT Id FROM User WHERE FirstName = 'Testing' AND LastName = 'User' LIMIT 1].Id;
        Boolean isPortalUser = false;
        
        Test.startTest();
        List<EDealer_Relationship__c> eDealerRels = eDealerCSRViewCommentsController.getAccessibleDealerLocs(userId, isPortalUser);
        Test.stopTest();        
    }
    
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"ErrorDescription": "Sample Error"}]}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
}