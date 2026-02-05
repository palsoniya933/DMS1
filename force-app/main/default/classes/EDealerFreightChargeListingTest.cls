@isTest
public class EDealerFreightChargeListingTest {
 @isTest
    private static void testOrdersSummaryData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"paccarorder":"XSNV755","paccar_po":"XS-XU3394488","dealerpo":"161730","orderdate":"2024-01-08","freighttotal":0.0},{"paccarorder":"STLB133","paccar_po":null,"dealerpo":"162500","orderdate":"2024-02-09","freighttotal":0.0}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerFreightChargesListingController.fetchFreightChargesListingData('I080', 'All','Quarterly',10,5); 
        list<string> listDealerCode = new list<string>();
        listDealerCode.add('I080');
        
        EDealerFreightChargesListingController.getEndPointParameters(listDealerCode,10,5,'All','Quarterly');  
        Test.stopTest();            
    }
}