@isTest
private class EDealerCsrPartSearchControllerTest {
    
    @testSetup
    private static void testSetup() {
        Id profCommunity = [SELECT Id FROM Profile where Name = 'Paccar TCS edealer Community Plus'].Id;
        Id profAdministrator = [SELECT Id FROM Profile where Name = 'System Administrator'].Id;
        Account account = new Account(Name='TestAccount', Dealer_Code__c='999990' ,Dealer_Group_Name__c='subz' ,Group_Code__c='C111',ShippingCountry='MX');
        insert account; 
        
        Contact contact = new Contact(LastName ='testCon' ,AccountId = account.Id);
        insert contact;
        List<User> users = New List<User>{new User(alias = 'test123', email ='test123@noemail.com',
                                                   emailencodingkey = 'UTF-8', LastName = 'Testing',
                                                   Languagelocalekey='en_US', localesidkey='en_US',
                                                   ProfileId = profCommunity, country='United States',
                                                   IsActive = true, ContactId = contact.Id,Pass_Group_Permissions__c = 'Field Service',
                                                   timezonesidkey='America/Los_Angeles', username='testExternalUser@noemail.com'),
            new User(alias = 'test23', email ='internaltest1223@noemail.com',
                     emailencodingkey = 'UTF-8', LastName = 'Testing',
                     Languagelocalekey='en_US', localesidkey='en_US',
                     ProfileId = profAdministrator, country='United States',
                     IsActive = true, 
                     timezonesidkey='America/Los_Angeles', username='testerInternalUser@noemail.com')};
                         insert users;
    }

    @isTest
    static void testGetPartListFromAws() {
        // Provide test data as needed
        String dealerCode = 'I080';
        String partNum = 'AC10';
        String division = 'K';

        // Mock the external callout using Test.setMock
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"part_number": "1031B0R", "OpartNumber": "1031B0R", "decription": "LIGHTS-LED (1PK = 2 BULBS)", "min_sfty_Stk": 0, "stkcls": "", "inventory_on_hand": 0, "velocity_code": "D", "PriceDetail": {"supplier": "WHS", "ListPrice": 19.98, "ReSale": 13.59, "WqtypromoCode": "", "best_net": 8.79, "CsrNumber": 0, "CsrPhase": 0, "CsrLine": 0, "CsrQty": 0, "CsrBestNet": 0.0, "CsrEffectiveDate": "", "CsrExpiryDate": "", "EffectiveDate": "2019-01-07", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 8.79, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "N", "WhsSupplier": "WHS", "WhsStdNet": 8.79, "WhsBestNet": 8.79, "WhsFinalNet": 8.79}}], "offset_value": 1, "record_count": 1, "refresh_date": "2021-05-25 01:49:18"}');
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));

        // Call the method to be tested
        Test.startTest();
        String result = eDealerCsrPartSearchController.getPartListFromAws(partNum);
        System.debug('result in test class---'+result);
        Test.stopTest();

        // Add assertions based on the expected outcome
        System.assertNotEquals(null, result);
        // Add more assertions as needed
    }

    @isTest
    static void testGetPartAltPartDetails() {
        // Provide test data as needed
        String dealerId = 'I080';
        String dealerSfx = 'AC1001';
        String partNumber = '';
        Integer qty = 1; // Adjust quantity as needed

        // Mock the external callout using Test.setMock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        String result = EDealerCsrPartSearchController.getPartAltPartDetails(dealerId, dealerSfx, partNumber, qty);
       
        Test.stopTest();

        // Add assertions based on the expected outcome
        System.assertNotEquals(null, result);
        // Add more assertions as needed
    }
    // Add more test methods for other functionalities in the class
 @isTest
    static void testGetPartAltPartDetails1() {
        // Provide test data as needed
        String dealerId = 'I080';
        String dealerSfx = 'AC1001';
        String partNumber = '';
        Integer qty = 1; // Adjust quantity as needed

        // Mock the external callout using Test.setMock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        String result = EDealerCsrPartSearchController.getPartAltPartDetails(dealerId, dealerSfx, partNumber, qty);
       
        Test.stopTest();

        // Add assertions based on the expected outcome
        System.assertNotEquals(null, result);
        // Add more assertions as needed
    }

    // Helper class to mock the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"ErrorDescription": "Sample Error"}]}}');
            res.setStatusCode(200);
            system.debug('res---'+res);
           
            return res;
        }
    }
     
    @isTest
    static void testGetPartSearchColumnHeaders() {
       
        // Call the method that depends on eDealerMetadataUtility
        Test.startTest();
        List<Map<String, String>> result = EDealerCsrPartSearchController.getPartSearchColumnHeaders();
		Test.stopTest();      
    }
    
    @isTest
    static void testgetAltPartDetailsColumnHeaders() {       
        // Call the method that depends on eDealerMetadataUtility
        Test.startTest();
        List<Map<String, String>> result = EDealerCsrPartSearchController.getAltPartDetailsColumnHeaders();
		Test.stopTest();
       
    }
    
    @isTest
    static void testGetUsersCountryForInternalUser(){
        User internalUser = [SELECT Id FROM user WHERE username='testerInternalUser@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(internalUser) {
            try{
                EDealerCsrPartSearchController.getUsersCountry();
            }
            catch(Exception err){
                System.assertEquals('Logged in user is an Internal User',err.getMessage());
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetUsersCountryForExternalUser(){
        User externalUser = [SELECT Id FROM user WHERE username='testExternalUser@noemail.com' LIMIT 1];
        String country;
        Test.startTest();
        system.runAs(externalUser) {
            country = EDealerCsrPartSearchController.getUsersCountry();
        }
        System.assertEquals('MX',country);
        Test.stopTest();
    }
}