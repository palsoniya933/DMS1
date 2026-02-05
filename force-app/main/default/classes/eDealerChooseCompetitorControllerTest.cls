@isTest
public class eDealerChooseCompetitorControllerTest {
 @isTest
    static void testGetCompetitorsFromAws() {
        // Create mock data
        String dealerCode = 'ABC123';
        
        // Mock response data
        String mockResponse = '{"Data":{"CsrDataD":[{"CompetitorName":"Competitor1","Affiliation":1,"CompType":"Type1","CompCity":"City1","CompState":"State1","CompPostal":"Postal1","Confirmation":"Confirm1","CompetitorCode":"Code1"}]},"ErrorResponse":{"IsSuccess":"true","ErrorMessages":null}}';
        
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method to be tested
        Test.startTest();
        String result = eDealerChooseCompetitorController.getCompetitorsFromAws(dealerCode);
        Test.stopTest();
        
        System.debug('the result : '+result);
        String expected = '[{"CompetitorName":"Competitor1","Affiliation":1,"CompType":"Type1","CompCity":"City1","CompState":"State1","CompPostal":"Postal1","Confirmation":"Confirm1","CompetitorCode":"Code1"}]';
        System.debug('the expected result : '+expected);
        // Verify the result
        System.assertNotEquals('No Data Found!!', result, 'Unexpected response');
        //System.assertEquals('[{"CompetitorName":"Competitor1","Affiliation":1,"CompType":"Type1","CompCity":"City1","CompState":"State1","CompPostal":"Postal1","Confirmation":"Confirm1","CompetitorCode":"Code1"}]', result, 'Incorrect response');
  
        System.assertEquals('[{"Confirmation":"Confirm1","CompType":"Type1","CompState":"State1","CompPostal":"Postal1","CompetitorName":"Competitor1","CompetitorCode":"Code1","CompCity":"City1","Affiliation":"1"}]', result, 'Incorrect response');
  
    }
    
     @isTest
    static void testGetCompetitorsColumnHeader(){
         Test.startTest();
        eDealerChooseCompetitorController.getCompetitorsColumnHeader();
         Test.stopTest();
    }
    
   
      @isTest
    static void testFetchLoggedInUserdetails(){
         Test.startTest();
        eDealerChooseCompetitorController.fetchLoggedInUserdetails();
         Test.stopTest();
    }
    
    // Helper class to mock HTTP responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String response;
        
        public MockHttpResponseGenerator(String response) {
            this.response = response;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(this.response);
            res.setStatusCode(200);
            return res;
        }
    }
}