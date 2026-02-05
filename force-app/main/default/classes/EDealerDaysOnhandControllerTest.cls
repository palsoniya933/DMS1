@isTest
public class EDealerDaysOnhandControllerTest {
    @isTest
    private static void validateFetchAWSDaysOnHandData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "A875", "days_on_hand_monthly": 17, "days_on_hand_yearly": 525}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerDaysOnhandController.fetchAWSDaysOnHandData('dealerCode','division');
        
        Test.stopTest();
        
    }

}