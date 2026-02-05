@isTest
public class EDealerSOFSummaryTest {
    
    @isTest
    private static void validatefetchSOFSummarya(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "V442", "dealer_suffix": "", "dealer_divison": "k", "sof_date": "2021-08-31", "sof_time": "2021-08-31 13:11:00", "time_of_day": "DAY", "sof_count": 63}, {"dealer_code": "V439", "dealer_suffix": "", "dealer_divison": "k", "sof_date": "2021-08-31", "sof_time": "2021-08-31 13:11:00", "time_of_day": "DAY", "sof_count": 95}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
         Test.startTest();
        EDealerSOFSummary.SOFSummaryResponseWrapper responseData = EDealerSOFSummary.fetchSOFSummary(String.valueOf(System.now()));
        
        System.assert(responseData != null && responseData.response != null && !responseData.response.isEmpty(), 'response data shuold not empty');
        
        EDealerSOFSummary.sofSummaryParse(responseData.response);
        
         Test.stopTest();
        
}        
        @isTest
        private static void wrapperData(){
            list<EDealerSOFSummary.SOFSummaryDataWrapper> lstSOFSummaryDataWrapper =new list<EDealerSOFSummary.SOFSummaryDataWrapper>();
            EDealerSOFSummary.SOFSummaryDataWrapper objSOFSummaryDataWrapper =new EDealerSOFSummary.SOFSummaryDataWrapper();        
            objSOFSummaryDataWrapper.dealer_code='A123';
            objSOFSummaryDataWrapper.dealer_suffix='A';
            objSOFSummaryDataWrapper.dealer_divison='test';
            objSOFSummaryDataWrapper.sof_date='31-08-2021';
            objSOFSummaryDataWrapper.sof_time='12.30pm';
            objSOFSummaryDataWrapper.time_of_day='';
            objSOFSummaryDataWrapper.sof_count=10;
            lstSOFSummaryDataWrapper.add(objSOFSummaryDataWrapper);
            
            
            
            EDealerSOFSummary.SOFSummaryResponseWrapper objSOFSummaryResponseWrapper =new EDealerSOFSummary.SOFSummaryResponseWrapper();
            objSOFSummaryResponseWrapper.response=lstSOFSummaryDataWrapper;
            System.assert(objSOFSummaryResponseWrapper.response != null,'Response should not be null.');
            objSOFSummaryResponseWrapper.error='unknown error';
        }
}