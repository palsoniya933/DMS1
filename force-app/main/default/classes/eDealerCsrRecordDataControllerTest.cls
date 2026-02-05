@istest
private class eDealerCsrRecordDataControllerTest {
    @isTest
    static void testgetCSRDetails() {
        // Provide test data as needed
        String csrNumber = '12345678';
        Integer csrPhase = 1;
        
        // Call the method to be tested
        // Mock the external callout using Test.setMock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        Test.startTest();
        String result = eDealerCsrRecordDataController.getCSRDetails(csrNumber, csrPhase,'I080');
        Test.stopTest();
        
        // Add assertions based on the expected outcome
        System.assertNotEquals(null, result);
        // Add more assertions as needed
    }
    
        @isTest
    static void testgetCSRDetailsBadResponse() {
        // Provide test data as needed
        String csrNumber = '12345678';
        Integer csrPhase = 1;
        
        
           HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"Comments": "Sample Error"}]}}');
        mockResponse.setStatusCode(300);
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        // Call the method to be tested
        Test.startTest();
        String result = eDealerCsrRecordDataController.getCSRDetails(csrNumber, csrPhase, 'I080');
        Test.stopTest();
        
    }
    
    
    @isTest
    static void testGetFilesByCSRNumberAndPhase(){
        
        String csrNumber = '12345678';
        String csrPhase = '1';
        String dealerCode = 'I080';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String result = eDealerCsrRecordDataController.getFilesByCSRNumberAndPhase(csrNumber, csrPhase, dealerCode);
        Test.stopTest();
    }
    
    
    
    
    @IsTest static void testGetFilesByCSRNumberAndPhaseBadresponse(){
        String csrNumber = '12345678';
        String csrPhase = '1';
        String dealerCode = 'I080';
        
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"Comments": "Sample Error"}]}}');
        mockResponse.setStatusCode(300);
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        String result = eDealerCsrRecordDataController.getFilesByCSRNumberAndPhase(csrNumber, csrPhase, dealerCode);
        Test.stopTest();
    }
    
    // Helper class to mock the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"Comments": "Sample Error"}]}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
}