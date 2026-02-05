@isTest
public class EDealerCarrierCreateSchedulerTest {
    @isTest
    public static void validateExecute(){
        
        eDealer_Carrier__c objCarrier = new eDealer_Carrier__c();
        objCarrier.name='test1';
        objCarrier.Carrier_Code__c='testxx';
        insert objCarrier;
        System.assertEquals('test1', [SELECT Name FROM eDealer_Carrier__c WHERE Carrier_Code__c='testxx'].Name, 'Invalid Dealer Carrier.');
        
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{ "response":[ { "frt_carr":"AAAX", "carr_nm":"AAA EXPRESS", "rtg_instr":"Y ", "frt_carr_desc_p":"" } ] }');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerCarrierCreateScheduler sc = new EDealerCarrierCreateScheduler();
        sc.execute(null);
        //EDealerCarrierCreateScheduler.execute(new List<String>{'A123'},'division',10);
        EDealerCarrierCreateScheduler.ResponseWrapper objResponse = new EDealerCarrierCreateScheduler.ResponseWrapper();
        objResponse.error='Unknown error';
        
        Test.stopTest(); 
    }

}