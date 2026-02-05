@isTest
public class EDealerABCCriteriaControllerTest {
    
     @isTest
    private static void testFetchAWSABCCriteriaReportData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
       // mockResponse.setBody('');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerABCCriteriaController.ABCWrapper obj = new EDealerABCCriteriaController.ABCWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        EDealerABCCriteriaController.fetchAWSABCCriteriaReportData(strObj);          
        Test.stopTest();    
    }
    
      @isTest
    private static void testFetchAWSABCCriteriaReportData1(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
       // mockResponse.setBody('');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerABCCriteriaController.ABCWrapper obj = new EDealerABCCriteriaController.ABCWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='K';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='A';
        
        string strObj = JSON.serialize(obj);
        
        EDealerABCCriteriaController.fetchAWSABCCriteriaReportData(strObj);          
        Test.stopTest();    
    }
    
    @isTest
    private static void testFetchAWSABCCriteriaReportData2(){
        
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
        
        EDealerABCCriteriaController.ABCWrapper obj = new EDealerABCCriteriaController.ABCWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='K';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='A';
        
        string strObj = JSON.serialize(obj);
         try{
             EDealerABCCriteriaController.fetchAWSABCCriteriaReportData(strObj);
        }
        catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
        Test.stopTest();
    }
    
    @isTest
    private static void testWrapperData(){
        
        List<EDealerABCCriteriaController.ABCCriteriaWrapper> lstABCCri=new List<EDealerABCCriteriaController.ABCCriteriaWrapper>();
        EDealerABCCriteriaController.ABCCriteriaWrapper objABCWrap=new EDealerABCCriteriaController.ABCCriteriaWrapper();
        objABCWrap.loc='A875';
        objABCWrap.dlrsplrcd='00001';
        objABCWrap.stkclass='';
        objABCWrap.abc='E';
        objABCWrap.abccriteriaminqty=1;
        lstABCCri.add(objABCWrap);
        
       EDealerABCCriteriaController.ABCCriteriaReportResponseWrapper objABCriteria=new EDealerABCCriteriaController.ABCCriteriaReportResponseWrapper();
       objABCriteria.response=lstABCCri;
       objABCriteria.error='Unknown error'; 
        
        EDealerABCCriteriaController.ABCCriteriaWrapper objABCCriteriaWrapper = new EDealerABCCriteriaController.ABCCriteriaWrapper();
        objABCCriteriaWrapper.distchan='test';
        objABCCriteriaWrapper.abc_level=11.3;

    }

}