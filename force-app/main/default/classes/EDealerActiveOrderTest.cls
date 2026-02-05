@isTest
public class EDealerActiveOrderTest {
    @isTest
    private static void validateGetActiveOrder(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"total": 782, "em": 75, "st": 544, "td": 158,"frequency": "All"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerActiveOrder.MasterResponseWrapper masterResWrapp = EDealerActiveOrder.getActiveOrders(lstDealer,'All');
        system.assertEquals(75, masterResWrapp.response[0].em);
        Test.stopTest();
        
    }

}