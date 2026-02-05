@isTest
public class EDealerTurnsControllerTest {
    @isTest
    private static void validateFetchAWSTurnsData(){ 
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "A875", "monthly_turns": 14.64, "yearly_turns": 0.48}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerTurnsController.TurnsResponseWrapper masterResWrapp = EDealerTurnsController.fetchAWSTurnsData(lstDealer,'division');
        system.assertEquals('A875', masterResWrapp.response[0].loc);
        
        Test.stopTest();
    }

}