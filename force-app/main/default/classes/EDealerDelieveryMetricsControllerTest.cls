@isTest
public class EDealerDelieveryMetricsControllerTest {
    @isTest
    private static void EDealerDelieveryMetricsControllerTestMethod(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"LOCNO":"test1","CRITERIA":"abc","DeliveredMetrics":{"delayOrders":[{"PPD_ORDER":"123","PRO_NUM":"10","EST_ARRIVAL_PST":"'+string.valueOf(system.now())+'","DELIVERED_DATE_PST":"'+string.valueOf(system.now())+'"}],"onTimeOrders":[{"PPD_ORDER":"123","PRO_NUM":"10"}]}}]}');
       // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        //EDealerDelieveryMetricsController.getDelieveryMetricsDetail('A875');
        
        //quarter to date metadata
        EDealerDelieveryMetricsController.getTMSDelieveryMetricsOrdersReportDetail('A875','timeFrame');
        EDealerDelieveryMetricsController.OrdersDeliveredMetricsReportResponseWrapper cl1= new EDealerDelieveryMetricsController.OrdersDeliveredMetricsReportResponseWrapper();
        EDealerDelieveryMetricsController.OrdersDeliveredMetricsReportWrapper cl2 = new EDealerDelieveryMetricsController.OrdersDeliveredMetricsReportWrapper();
        
        
        
        Test.stopTest(); 
    }
	
    @isTest
    private static void getDelieveryMetricsDetailTest(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"LOCNO":"test1","DeliveredMetrics":[{"dayDelay":3.0}]}]}');
       // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        //calling apex class method
        EDealerDelieveryMetricsController.getDelieveryMetricsDetail('A875');       
        Test.stopTest(); 
    }
}