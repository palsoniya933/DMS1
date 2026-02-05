@isTest
public class EDealerConfirmOrderTest {
    @isTest
    private static void valitedateGetConfirmOrder(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "frequency": "Daily", "date_month_quarter": "2021-05-24", "ordercount": 2}, {"cstno": "A875", "frequency": "Weekly", "date_month_quarter": "21", "ordercount": 2}, {"cstno": "A875", "frequency": "Annually", "date_month_quarter": "2021", "ordercount": 7}, {"cstno": "A875", "frequency": "Monthly", "date_month_quarter": "5", "ordercount": 2}, {"cstno": "A875", "frequency": "Quarterly", "date_month_quarter": "2", "ordercount": 4}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerConfirmOrder.MasterResponseWrapper masterResWrapp = EDealerConfirmOrder.getConfirmOrders(lstDealer,'All');
        system.assertEquals('A875', masterResWrapp.response[0].cstno);
        
        Test.stopTest();
    }

}