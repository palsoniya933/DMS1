@isTest
public class eDealerOPCReportControllerTest {

    private static User createUser(String username, String profileName) {
        Profile profile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
        
        // Check if username already has '@example.com' to avoid duplication
        String email = username.contains('@') ? username : username + '@example.com';

        User newUser = new User(
            Username = username,
            Email = email,
            Alias = username.substring(0, Math.min(5, username.length())), // Ensure alias is not longer than 5 characters
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            FirstName = 'Test',
            LastName = 'User',
            IsActive = true
        );
        return newUser;
    }

    @isTest
    static void testFetchAWSOPCReportData() {
        User testUser = createUser('testuser@example.com.vishalkdev', 'Standard User');
        insert testUser;

         // Create a Contact record
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example22.com'
        );
        insert contact; // Insert the contact to get a valid ID
        
        
        // Create a dealer relationship
        edealer_relationship__c eRel = new edealer_relationship__c();
        eRel.Dealer_Group__c = 'V314';
        eRel.Contact__c = contact.Id; // Assuming the user has a contact
        insert eRel;

        // Prepare the report parameters JSON
        String reportParamsJson = '{"country":"MX","branch_Type":"K855","year":"2023","customer_Entered":"None"}';

        // Mocking the EDealerHttpHandler callout
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200);
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealership_group_code": "V314","dealer_name": "KENWORTH ANAHUAC S.A. DE C.V."}]}');

        // Set the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));

        // Test the method
        Test.startTest();
        eDealerOPCReportController.OPCReportResponseWrapper reportData = eDealerOPCReportController.fetchAWSOPCReportData(reportParamsJson);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, reportData, 'The report data should not be null.');
        System.assertEquals(1, reportData.response.size(), 'There should be one report in the response.');
        System.assertEquals('KENWORTH ANAHUAC S.A. DE C.V.', reportData.response[0].dealer_name, 'The dealer name should match the expected value.');
    }

    @isTest
    static void testFetchAWSOPCBarnchReportData() {
        User testUser = createUser('branchuser@example.com', 'Standard User');
        insert testUser;

         // Create a Contact record
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'branchuser@example.com'
        );
        insert contact; // Insert the contact to get a valid ID
        
        // Create a dealer relationship
        edealer_relationship__c eRel = new edealer_relationship__c();
        eRel.Dealer_Group__c = 'B123';
        eRel.Contact__c = contact.Id; // Assuming the user has a contact
        insert eRel;

       
        
        // Prepare the report parameters JSON
        String reportParamsJson = '{"country":"MX","branch_Type":"B123","year":"2023","customer_Entered":"customer-entered"}';

        // Mocking the EDealerHttpHandler callout
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200);
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"branch_dealer_code": "B123","branch_name": "Branch Test"}]}');

        // Set the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));

        // Test the method
        Test.startTest();
        eDealerOPCReportController.OPCBranchDealerCodeReportResponseWrapper branchReportData = eDealerOPCReportController.fetchAWSOPCBarnchReportData(reportParamsJson);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, branchReportData, 'The branch report data should not be null.');
        System.assertEquals(1, branchReportData.response.size(), 'There should be one branch report in the response.');
        System.assertEquals('Branch Test', branchReportData.response[0].branch_name, 'The branch name should match the expected value.');
    }

    @isTest
    static void testFetchAWSOPCReportDataWithException() {
        User testUser = createUser('exceptionuser@example.com', 'Standard User');
        insert testUser;

        // Create a Contact record
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'exceptionuser@example.com'
        );
        insert contact; // Insert the contact to get a valid ID
        
        // Create a dealer relationship
        edealer_relationship__c eRel = new edealer_relationship__c();
        eRel.Dealer_Group__c = 'V314';
        eRel.Contact__c = contact.Id; // Assuming the user has a contact
        insert eRel;

        // Prepare the report parameters JSON
        String reportParamsJson = '{"country":"MX","branch_Type":"K855","year":"2023","customer_Entered":"Customer Entered"}';

        // Mocking the EDealerHttpHandler callout with an error response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('ERROR');
        mockResponse.setStatusCode(500);
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"error": "Internal Server Error"}');

        // Set the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));

        // Test the method and expect an exception
        Test.startTest();
        try {
            eDealerOPCReportController.fetchAWSOPCReportData(reportParamsJson);
            System.assert(false, 'An exception should have been thrown due to the HTTP error.');
        } catch (AuraException e) {
            System.assert(true, 'Expected AuraException was thrown.');
        }
        Test.stopTest();
    }

    @isTest
    static void testFetchAWSOPCBarnchReportDataWithException() {
        User testUser = createUser('branchexceptionuser@example.com', 'Standard User');
        insert testUser;

        
        // Create a Contact record
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'branchexceptionuser@example.com'
        );
        insert contact; // Insert the contact to get a valid ID
        
        // Create a dealer relationship
        edealer_relationship__c eRel = new edealer_relationship__c();
        eRel.Dealer_Group__c = 'B123';
        eRel.Contact__c = contact.Id; // Assuming the user has a contact
        insert eRel;

        // Prepare the report parameters JSON
        String reportParamsJson = '{"country":"MX","branch_Type":"B123","year":"2023","customer_Entered":"Customer Entered"}';

        // Mocking the EDealerHttpHandler callout with an error response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('ERROR');
        mockResponse.setStatusCode(500);
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"error": "Internal Server Error"}');

        // Set the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));

        // Test the method and expect an exception
        Test.startTest();
        try {
            eDealerOPCReportController.fetchAWSOPCBarnchReportData(reportParamsJson);
            System.assert(false, 'An exception should have been thrown due to the HTTP error.');
        } catch (AuraException e) {
            System.assert(true, 'Expected AuraException was thrown.');
        }
        Test.stopTest();
    }
}