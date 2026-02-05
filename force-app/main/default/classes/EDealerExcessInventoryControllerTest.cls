@isTest
public class EDealerExcessInventoryControllerTest {
    @isTest
    private static void validateFetchAWSMdiExcessInventoryReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "abcdecode": "A", "parts_type": "NON ENGINE", "total_parts": 5, "total_value": 32.31}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "ENGINE", "total_parts": 2, "total_value": 10.08}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "NON ENGINE", "total_parts": 36, "total_value": 2646.53}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "NON ENGINE", "total_parts": 63, "total_value": 1844.4}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "ENGINE", "total_parts": 6, "total_value": 119.94}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "NON ENGINE", "total_parts": 1937, "total_value": 731963.25}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "ENGINE", "total_parts": 190, "total_value": 13978.94}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('K175');
        EDealerExcessInventoryController.MDIInventoryWrapper obj = new EDealerExcessInventoryController.MDIInventoryWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        EDealerExcessInventoryController.fetchAWSMdiExcessInventoryReportData(strObj);
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSMdiExcessInventoryReportData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "abcdecode": "A", "parts_type": "NON ENGINE", "total_parts": 5, "total_value": 32.31}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "ENGINE", "total_parts": 2, "total_value": 10.08}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "NON ENGINE", "total_parts": 36, "total_value": 2646.53}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "NON ENGINE", "total_parts": 63, "total_value": 1844.4}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "ENGINE", "total_parts": 6, "total_value": 119.94}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "NON ENGINE", "total_parts": 1937, "total_value": 731963.25}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "ENGINE", "total_parts": 190, "total_value": 13978.94}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('K175');
        EDealerExcessInventoryController.MDIInventoryWrapper obj = new EDealerExcessInventoryController.MDIInventoryWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        EDealerExcessInventoryController.fetchAWSMdiExcessInventoryReportData(strObj);
        Test.stopTest();
    }
    
     @isTest
    private static void validateFetchAWSMdiExcessInventoryReportData2(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('K175');
        EDealerExcessInventoryController.MDIInventoryWrapper obj = new EDealerExcessInventoryController.MDIInventoryWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        try{
            EDealerExcessInventoryController.fetchAWSMdiExcessInventoryReportData(strObj);
        }
       catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSMdiExcessInventoryKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "abcdecode": "A", "parts_type": "NON ENGINE", "total_parts": 5, "total_value": 32.31}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "ENGINE", "total_parts": 2, "total_value": 10.08}, {"dlrcode": "A875", "abcdecode": "B", "parts_type": "NON ENGINE", "total_parts": 36, "total_value": 2646.53}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "NON ENGINE", "total_parts": 63, "total_value": 1844.4}, {"dlrcode": "A875", "abcdecode": "C", "parts_type": "ENGINE", "total_parts": 6, "total_value": 119.94}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "NON ENGINE", "total_parts": 1937, "total_value": 731963.25}, {"dlrcode": "A875", "abcdecode": "D", "parts_type": "ENGINE", "total_parts": 190, "total_value": 13978.94}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        EDealerExcessInventoryController.fetchAWSMdiExcessInventoryKPIData('A875');        
        Test.stopTest();
    }
     @isTest
    private static void validateFetchAWSMdiExcessInventoryKPIData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        
        try{
            EDealerExcessInventoryController.fetchAWSMdiExcessInventoryKPIData('A875'); 
        }
       catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
        Test.stopTest();
    }
}