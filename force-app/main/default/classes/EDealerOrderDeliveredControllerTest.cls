@isTest
public class EDealerOrderDeliveredControllerTest {
    @isTest
    private static void validategetDeliveredOrdersDetail(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
       // mockResponse.setBody('');
        mockResponse.setBody('{"response": [{"division": "KW", "dealer_codes":"A876","offSet":10}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
     
        Test.startTest();
        EDealerOrderDeliveredController.getDeliveredOrdersDetail('dealerCode');
        
        mockResponse.setBody('{"response": {"LOCNO": "test", "dealer_codes":"A876","STATUS":"test1","OrdersDeliveredTotal":[{"PPD_ORDER":"test1","EST_ARRIVAL_PST":"'+string.valueof(system.now())+'","DELIVERED_DATE_PST":"'+string.valueof(system.now())+'"}]}}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        EDealerOrderDeliveredController.OrdersDeliveredReportResponseWrapper masterResWrapp = EDealerOrderDeliveredController.getTMSDeliveredOrdersReportDetail('dealerCode','');
        system.assertEquals('test', masterResWrapp.response.LOCNO);
        Test.stopTest();
        
    }
}