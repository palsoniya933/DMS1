@isTest
public class EDealerCNRRSVPartsTileControllerTest {
    @isTest
    private static void validateFetchDealerCNRRSVKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "A875", "cnr_count": 27}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('A875');
        lstDealer.add('I081');
        EDealerCNRRSVPartsTileController.CNRRSVKPIResponseWrapper masterResWrapp = EDealerCNRRSVPartsTileController.fetchDealerCNRRSVKPIData(lstDealer,'division');
        system.assertEquals('A875', masterResWrapp.response[0].dealer_code);
        Test.stopTest();
    }

}