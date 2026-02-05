@isTest
public class EDealerLogUtilsTest{ 
    private final HttpResponse response;
    private HttpRequest request;
     public EDealerLogUtilsTest(HttpResponse response) {
        this.response = response; 
    }

    public HttpResponse respond(HttpRequest request) {
        this.request = request;
        return response;
    } 
    
    @isTest
    private static void EDealerLogUtilsTestMethod(){
        HTTPRequest request = new HTTPRequest();
         HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "abcdecode": "A", "parts_type": "NON ENGINE", "total_parts": 5, "total_value": 32.31}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "ENGINE", "total_parts": 2, "total_value": 10.08}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "NON ENGINE", "total_parts": 36, "total_value": 2646.53}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "NON ENGINE", "total_parts": 63, "total_value": 1844.4}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "ENGINE", "total_parts": 6, "total_value": 119.94}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "NON ENGINE", "total_parts": 1937, "total_value": 731963.25}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "ENGINE", "total_parts": 190, "total_value": 13978.94}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Test.startTest();
        EDealerLogUtils.createAPIErrorLog(mockResponse,request,'eDealer_Carrier__c');
        EDealerLogUtils.createAPICacheLog(mockResponse,request,'eDealer_Carrier__c');
        EDealerLogUtils.createAPIErrorLog(mockResponse,request,'eDealer_Carrier__c','API Log');
        try{
            Account objAccount =new Account(Dealer_Code__c='V648',PACCARDivision__c='P');
            insert objAccount;
            
        }catch(Exception ex){    
            system.debug('ex::'+ex.getMessage());
            EDealerLogUtils.createExceptionLog(ex, 'EDealerDaysOnhandController');  
            EDealerLogUtils.createExceptionLog('EDealerDaysOnhandController', ex.getMessage(),ex.getStackTraceString());
        }
        //eDealer_Log__c logRec =new eDealer_Log__c();
        
        eDealer_Log__c logRec =[select id,Apex_Trace__c,API_Name__c,Log_Type__c from eDealer_Log__c where Class_Name__c='EDealerDaysOnhandController' limit 1];
        logRec.Log_Type__c=EDealerConstants.APICACHELOG;
        update logRec;
        System.assert(logRec.Id != null,'Id should not null.');
        EDealerLogUtils.createAPICacheLog(mockResponse,request,'EDealerDaysOnhandController');
        EDealerLogUtils.createAPICacheLog(mockResponse,request,'EDealerDaysOnhandController');
        Test.stopTest();
    }

}