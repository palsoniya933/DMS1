@isTest
public class EDealerOrderIntransitControllerTest {
    @isTest
    private static void validategetIntransitOrdersDetail(){
        
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
        EDealerOrderIntransitController.getIntransitOrdersDetail('dealerCode');
        
        mockResponse.setBody('{"response": [{"LOCNO": "test","CRITERIA":"tst","STATUS":"test1","OrdersTransitTotal":[{"PPD_ORDER":"test1","EST_ARRIVAL_PST":"'+string.valueof(system.now())+'","PICKED_UP_DATE_PST":"'+string.valueof(system.now())+'"}]}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        EDealerOrderIntransitController.OrdersInTransitReportResponseWrapper masterResWrapp = EDealerOrderIntransitController.getTMSInTransitOrdersReportDetail('dealerCode','timeFrame');
        system.assertEquals('test', masterResWrapp.response[0].LOCNO);
        
        EDealerOrderIntransitController.OrdersInTransitTotalReportWrapper objOrderINTransit = new EDealerOrderIntransitController.OrdersInTransitTotalReportWrapper();
        
        Test.stopTest();
    }
}