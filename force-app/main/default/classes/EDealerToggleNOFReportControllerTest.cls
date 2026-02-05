@isTest
public class EDealerToggleNOFReportControllerTest {
    @isTest
    private static void validateFetchToggleNOFRecordsData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{ "grp_nbr": "A085", "dealer": "I137","pdc_saleableind": "Y"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();  
        lstDealerCode.add('I081');
        lstDealerCode.add('I080');
        
        EDealerToggleNOFReportController.toggleWrapper obj = new EDealerToggleNOFReportController.toggleWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        EDealerToggleNOFReportController.toggleNOFReportResponseWrapper masterResWrapp = EDealerToggleNOFReportController.fetchToggleNOFRecordsData(strObj);
        system.assertEquals('A085', masterResWrapp.response[0].grp_nbr);
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchToggleNOFRecordsData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{ "grp_nbr": "A085", "loc": "I081",  "si": "C"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerToggleNOFReportController.toggleWrapper obj = new EDealerToggleNOFReportController.toggleWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
        EDealerToggleNOFReportController.toggleNOFReportResponseWrapper masterResWrapp = EDealerToggleNOFReportController.fetchToggleNOFRecordsData(strObj);
        system.assertEquals('A085', masterResWrapp.response[0].grp_nbr);
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSNonYSaleableRecordsData2(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('null');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerToggleNOFReportController.toggleWrapper obj = new EDealerToggleNOFReportController.toggleWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
        
        try{
            EDealerToggleNOFReportController.toggleNOFReportResponseWrapper masterResWrapp = EDealerToggleNOFReportController.fetchToggleNOFRecordsData(strObj);
            system.assertEquals('A085', masterResWrapp.response[0].grp_nbr);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
        Test.stopTest();
    }
    
    
    
}