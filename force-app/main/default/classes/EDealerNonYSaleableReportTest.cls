@isTest
public class EDealerNonYSaleableReportTest {
   @isTest
    private static void validateFetchAWSNonYSaleableRecordsData(){
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
        lstDealerCode.add('I081');
        lstDealerCode.add('I080');
        
        EDealerNonYSaleableReport.NonYWrapper obj = new EDealerNonYSaleableReport.NonYWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
          EDealerNonYSaleableReport.NonYSaleableReportResponseWrapper masterResWrapp = EDealerNonYSaleableReport.fetchAWSNonYSaleableRecordsData(strObj);
        system.assertEquals('A085', masterResWrapp.response[0].grp_nbr);
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSNonYSaleableRecordsData1(){
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
        
        EDealerNonYSaleableReport.NonYWrapper obj = new EDealerNonYSaleableReport.NonYWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
       obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
        EDealerNonYSaleableReport.NonYSaleableReportResponseWrapper masterResWrapp = EDealerNonYSaleableReport.fetchAWSNonYSaleableRecordsData(strObj);
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
        
        EDealerNonYSaleableReport.NonYWrapper obj = new EDealerNonYSaleableReport.NonYWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
       
         try{
         EDealerNonYSaleableReport.NonYSaleableReportResponseWrapper masterResWrapp = EDealerNonYSaleableReport.fetchAWSNonYSaleableRecordsData(strObj);
        system.assertEquals('A085', masterResWrapp.response[0].grp_nbr);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
        Test.stopTest();
    }
    
 

}