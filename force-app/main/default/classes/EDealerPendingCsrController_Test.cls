@isTest 
public with sharing class EDealerPendingCsrController_Test {
    @isTest
    public static void getPendingCSR_Test() {
       // Set up test data
        List<String> dealerCodeList = new List<String>{'I080', 'I086'};

        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        String resultData = EDealerPendingCsrController.getPendingCSR(dealerCodeList);
        Test.stopTest();

        // Assert the result
        System.assertEquals('{"status":"success"}', resultData, 'Result data should be {"status":"success"}');
    }
    
    @isTest
    public static void getPendingCSRTileTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerPendingCsrController.getPendingCSRTileTranslations();
        Test.stopTest();
    }

   
  
     // Mock callout class
     public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
}