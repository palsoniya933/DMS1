@isTest
public class EDealerUserUtilsTest {
    @isTest
    private static void validateFetchLoggedInUserdetails(){
         // setting mock response
        //HttpResponse mockResponse = new HttpResponse();
        //mockResponse.setStatus('OK');
        //mockResponse.setStatusCode(200); 
        //mockResponse.setHeader('Content-Type', 'application/json');
        //mockResponse.setBody('');
        // setting mock apex class
        //Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
       User u1= EDealerUserUtils.fetchLoggedInUserdetails();
        System.Assert(u1!=null,'Edealer user Utils is null');
        Test.stopTest(); 
    }

}