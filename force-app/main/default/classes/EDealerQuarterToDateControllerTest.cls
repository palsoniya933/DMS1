/* Project    : MDI Tier Level Changes
 * Modified by: Chito Bulahan
 * Date       : 07/27/2023 
 * Description: Added Auto_Accept and Auto_Accept_Util fields in JSON format for response body
 * Search Tag : MDI Tier Level Changes
 */ 
@isTest
public class EDealerQuarterToDateControllerTest {
    @isTest
    private static void validateFetchAWSQuarterToDateReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        // MDI Tier Level Changes - Start
        //mockResponse.setBody('{"response": [{"dealer": "A875", "report_date": "2021-03-14", "report_year": 2021, "report_quarter": 1, "division": "KW", "availability": "95.85", "breadth": "97.36", "current_tier": "ELITE PLUS", "qtd_trending_tier": "TIER 1"}, {"dealer": "A875", "report_date": "2021-04-01", "report_year": 2021, "report_quarter": 2, "division": "KW", "availability": "95.74", "breadth": "97.36", "current_tier": "ELITE PLUS", "qtd_trending_tier": "TIER 1"}]}');
        mockResponse.setBody('{"response": [{"dealer": "A875", "report_date": "2021-03-14", "report_year": 2021, "report_quarter": 1, "division": "KW", "availability": "98.0", "breadth": "97.4", "auto_accept": 0, "auto_accept_util": "99.80", "current_tier": "ELITE PLUS", "qtd_trending_tier": "TIER 1"}, {"dealer": "A875", "report_date": "2021-04-01", "report_year": 2021, "report_quarter": 2, "division": "KW", "availability": "95.12", "breadth": "97.5", "auto_accept": 1, "auto_accept_util": "99.1", "current_tier": "ELITE PLUS", "qtd_trending_tier": "TIER 1"}]}');
        // MDI Tier Level Changes - End
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerQuarterToDateController.QuarterToDateReportResponseWrapper resWrrap = EDealerQuarterToDateController.fetchAWSQuarterToDateReportData(new List<String>{'A123'},'division','2021','1',10,10);
        system.assertEquals('A875', resWrrap.response[0].dealer,'dealer vlaue is not equal A875');
        //quarter to date metadata
        EDealerQuarterToDateController.getQuarterToDateTileTableData();
        Test.stopTest(); 
    }
    
}