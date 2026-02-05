@isTest
public class EDealerConfirmedOrdersTest {
    @isTest
    private static void validateGetConfirmedOrder(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "frequency": "Annually", "date_month_quarter": "2021", "ordercount": 294}, {"cstno": "A875", "frequency": "Quarterly", "date_month_quarter": "2", "ordercount": 224}, {"cstno": "A875", "frequency": "Daily", "date_month_quarter": "2021-05-24", "ordercount": 17}, {"cstno": "A875", "frequency": "Weekly", "date_month_quarter": "21", "ordercount": 17}, {"cstno": "A875", "frequency": "Monthly", "date_month_quarter": "5", "ordercount": 112}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        
        EDealerConfirmedOrders.ConfirmedOrderWrapper ConfirmedOrderData =  EDealerConfirmedOrders.fetchEDealerConfirmedOrders('A875','K');
        System.assert(ConfirmedOrderData != null, 'data no available');
        System.assert(ConfirmedOrderData.response.size()>0, 'orders detail not available');
        Test.stopTest();
        
    }

}