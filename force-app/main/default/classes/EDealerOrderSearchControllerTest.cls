@isTest
public class EDealerOrderSearchControllerTest {
  @isTest
    private static void validateSearchOrders(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        // mockResponse.setBody('');
        mockResponse.setBody('{"response": [{"ordno": "12", "dealerpo":"test","order_status":10}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerOrderSearchController.searchOrders('dealerCode','searchText');  
    }

}