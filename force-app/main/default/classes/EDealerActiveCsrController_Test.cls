@isTest
public with sharing class EDealerActiveCsrController_Test {
    @isTest
    public static void getActiveCSRList_Test() {
        // Set up test data
        List<String> dealerCodeList = new List<String>{'I080', 'I086'};
        String frequency = 'ALL';
        String csrtype = 'C';

        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        
           
             EDealerActiveCsrController.getDraftCsrList(dealerCodeList,frequency);
             EDealerActiveCsrController.getActiveCSR(dealerCodeList,csrtype, frequency);
            EDealerActiveCsrController.getPendingCsrList(dealerCodeList, frequency, csrtype);
        String resultData = EDealerActiveCsrController.getActiveCSRList(dealerCodeList, frequency, csrtype);
        Test.stopTest();

        // Assert the result
        System.assertEquals('{"status":"success"}', resultData, 'Result data should be {"status":"success"}');
    }
   @isTest
    public static void getEndPointParametersTest() {
        // Set up test data
        List<String> dealerCodeList = new List<String>{'I080', 'I086'};

        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        
            String resultData= EDealerActiveCsrController.getEndPointParameters(dealerCodeList);
            
        Test.stopTest();
    }
    
    @isTest
    public static void getPendingCSRList_Test() {
       // Set up test data
        List<String> dealerCodeList = new List<String>{'I080', 'I086'};

        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        EDealerActiveCsrController.getMyCSR(dealerCodeList);
        String resultData = EDealerActiveCsrController.getPendingCSR(dealerCodeList);
        Test.stopTest();

        // Assert the result
        System.assertEquals('{"status":"success"}', resultData, 'Result data should be {"status":"success"}');
    }
    
    @isTest
    public static void getCSRDetails_Test() {
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        EDealerActiveCsrController.getCSRDetails(30096676,1);
        Test.stopTest();
    }
    @isTest
    public static void getCSRPartList_Test() {
       
        //Test.setMock(HttpCalloutMock.class, new EDealerCsrCalloutMock());
        
        Test.startTest();
        EDealerActiveCsrController.getCSRPartList('30002123');
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
    @isTest
    public static void renewCSR_test() {
       
     // Set up test data
        Integer csrNumber = 30002123;
        Integer csrPhase = 1;

        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to be tested
        Test.startTest();
        String resultData = EDealerActiveCsrController.renewCSR(csrNumber, csrPhase,'I080');
        Test.stopTest();

        // Assert the result
        System.assertEquals('{"status":"success"}', resultData, 'Result data should be {"status":"success"}');
    }
        

    
    @isTest
    public static void getCSRTileTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getCSRTileTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getMyCSRTileTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getMyCSRTileTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getPendingCSRTileTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getPendingCSRTileTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getCSRDrilldownTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getCSRDrilldownTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getDraftCsrDrilldownTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getDraftCsrDrilldownTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getPendingCsrDrilldownTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getPendingCsrDrilldownTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getCSRDashboardTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getCSRDashboardTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getDraftCSRDashboardTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getDraftCSRDashboardTranslations();
        Test.stopTest();
    }
    @isTest
    public static void getPendingCSRDashboardTranslations_Test() {
        List<String> dealercodes = new List<String>();

        Test.startTest();
        EDealerActiveCsrController.getPendingCSRDashboardTranslations();
        Test.stopTest();
    }

}