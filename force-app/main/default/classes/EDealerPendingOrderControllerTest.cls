@isTest
private class EDealerPendingOrderControllerTest {
    
    @isTest
    private static void valitedateGetPendingOrder(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"ordercount":687,"emergencyorders":83,"stockorders":446,"truckdownorders":152}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerPendingOrderController.MasterResponseWrapper masterResWrapp = EDealerPendingOrderController.getPendingOrders(lstDealer,'ordercount');
        system.assertEquals(83, masterResWrapp.response[0].emergencyorders);
        
        Test.stopTest();
    }
}