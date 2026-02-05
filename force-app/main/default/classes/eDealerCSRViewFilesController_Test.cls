@isTest
public without sharing class eDealerCSRViewFilesController_Test {
    @isTest
    public static void getCsrFilesFromAws_Test() {
         // string mockresponse = '{"file_info": [{"Key": "CsrFiles/F302/3245675/1/t2.pdf","Size": 34779},{"Key": "CsrFiles/F302/3245675/1/t3.pdf","Size": 34779},{"Key": "CsrFiles/F302/3245675/1/t4.pdf","Size": 34779}]}';
        // responseData = mockresponse;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        eDealerCSRViewFilesController.getCsrFilesFromAws('I080', '99999999', '1');
        Test.stopTest();


    }
    @isTest
    public static void getCsrLettersFromAws_Test() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        eDealerCSRViewFilesController.getCsrLettersFromAws('I080', '99999999', '1');
        Test.stopTest();

    }
    @isTest
    public static void getFilesColumnHeaders_Test() {

        Test.startTest();
        eDealerCSRViewFilesController.getFilesColumnHeaders();
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