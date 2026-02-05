@isTest
public class EDealerUnConfirmedOrderTest {
    @isTest
    private static void testUnConfirmedOrder(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"total": 4, "emergencyorders": 3, "stockorders": 0, "truckdownorders": 0}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        
        EDealerUnConfirmedOrder.MasterResponseWrapper masterResWrapp = EDealerUnConfirmedOrder.getUnConfirmedOrders(lstDealer);
        
        Decimal emergencyOrdervalue = 3;
        system.assertEquals(emergencyOrdervalue, masterResWrapp.response[0].emergencyorders);
        Test.stopTest();            
    }
}