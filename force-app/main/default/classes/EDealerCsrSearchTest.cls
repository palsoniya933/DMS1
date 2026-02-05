@isTest
public class EDealerCsrSearchTest {
    static testMethod void testGetCSRbySearchKey_Error() {
        EDealerCsrSearch.ErrorResponse errorResponse = new EDealerCsrSearch.ErrorResponse();
        errorResponse.IsSuccess = 'false';
        errorResponse.ErrorMessagesCount = 1;
        EDealerCsrSearch.HeaderCmts errorComment = new EDealerCsrSearch.HeaderCmts();
        errorComment.Comments = 'Error occurred while processing the request';
        errorResponse.ErrorMessages = new List<EDealerCsrSearch.HeaderCmts>{errorComment};
        EDealerCsrSearch.MasterEditDataWrapper responseWrapper = new EDealerCsrSearch.MasterEditDataWrapper();
        responseWrapper.ErrorResponse = errorResponse;
        String jsonResponse = JSON.serialize(responseWrapper);
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody(jsonResponse);
        HttpRequest mockRequest = new HttpRequest();
        mockRequest.setEndpoint('/csr/search/kpi');
        mockRequest.setMethod('POST');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        List<String> dealerCodes = new List<String>{'I080'};
            List<String> statuses = new List<String>{''};
                String searchText = 'hdgygyuy';
        Test.startTest();
        String result = EDealerCsrSearch.getCSRbySearchKey(new List<String>{''}, statuses, searchText);
        String result1 = EDealerCsrSearch.getCSRbySearchKey(dealerCodes, statuses, '303');
        Test.stopTest();
    }
    static testMethod void testGetCSRbySearchKey_Error1() {
        EDealerCsrSearch.ErrorResponse errorResponse = new EDealerCsrSearch.ErrorResponse();
        errorResponse.IsSuccess = 'false';
        errorResponse.ErrorMessagesCount = 1;
        EDealerCsrSearch.HeaderCmts errorComment = new EDealerCsrSearch.HeaderCmts();
        errorComment.Comments = 'Error occurred while processing the request';
        errorResponse.ErrorMessages = new List<EDealerCsrSearch.HeaderCmts>{errorComment}; 
            EDealerCsrSearch.MasterEditDataWrapper responseWrapper = new EDealerCsrSearch.MasterEditDataWrapper();
        responseWrapper.ErrorResponse = errorResponse;
        String jsonResponse = JSON.serialize(responseWrapper);
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody(jsonResponse);
        mockResponse.setStatusCode(200);
        // Create a mock HTTP callout
        HttpRequest mockRequest = new HttpRequest();
        mockRequest.setEndpoint('/csr/search/kpi');
        mockRequest.setMethod('POST');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        List<String> dealerCodes = new List<String>{'I080'};
            List<String> statuses = new List<String>{''};
                String searchText = '303';
        Test.startTest();
        String result = EDealerCsrSearch.getCSRbySearchKey(dealerCodes, statuses, searchText);
        Test.stopTest();
    }
    
    // Mock HTTP response generator class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.mockResponse = response;
        }
        
        public HttpResponse respond(HttpRequest request) {
            return mockResponse;
        }
    }
}