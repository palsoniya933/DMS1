@isTest
public class EDealerReturnComplianceTest {
    @isTest
    private static void validateFetchAWSReturnsComplianceData(){ 
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "rmatype": "RM", "itemid": "008-290-00", "suggested_date": "2021-05-06", "suggested_qty": 1, "suggested_amt": 94.00848, "returned_date": null, "returned_qty": null, "returned_amt": null, "avg_retun_compliance": 0.0, "return_status": "No Return"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();         
        // calling apex class method
        
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerReturnCompliance.ReturnWrapper obj = new EDealerReturnCompliance.ReturnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.month = 'dec 2021';
        obj.quarter = 'q4 2021';
        obj.year='2020';        
        EDealerReturnCompliance.fetchAWSReturnsComplianceData(JSON.serialize(obj)); 
        //obj.month = '';        
        //EDealerReturnCompliance.fetchAWSReturnsComplianceData(JSON.serialize(obj));  
        Test.stopTest();
    } 
    
    @isTest
    private static void validateFetchAWSReturnsComplianceDataQuarter(){ 
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "rmatype": "RM", "itemid": "008-290-00", "suggested_date": "2021-05-06", "suggested_qty": 1, "suggested_amt": 94.00848, "returned_date": null, "returned_qty": null, "returned_amt": null, "avg_retun_compliance": 0.0, "return_status": "No Return"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();         
        // calling apex class method
        
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerReturnCompliance.ReturnWrapper obj = new EDealerReturnCompliance.ReturnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.quarter = 'q4 2021';
        EDealerReturnCompliance.fetchAWSReturnsComplianceData(JSON.serialize(obj)); 
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSReturnsComplianceDataYear(){ 
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "rmatype": "RM", "itemid": "008-290-00", "suggested_date": "2021-05-06", "suggested_qty": 1, "suggested_amt": 94.00848, "returned_date": null, "returned_qty": null, "returned_amt": null, "avg_retun_compliance": 0.0, "return_status": "No Return"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();         
        // calling apex class method
        
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerReturnCompliance.ReturnWrapper obj = new EDealerReturnCompliance.ReturnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.year = '2021';
        EDealerReturnCompliance.fetchAWSReturnsComplianceData(JSON.serialize(obj)); 
        EDealerReturnCompliance.getMonthsTranslation();
        Test.stopTest();
    }
    
    @isTest
    private static void validategetStartEndDates(){        
        EDealerReturnCompliance.getStartEndDates('jan 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('feb 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('mar 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('apr 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('may 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('jun 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('jul 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('aug 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('sep 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('oct 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('nov 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('dec 2021','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('','q1 2021','2020');
        EDealerReturnCompliance.getStartEndDates('','q2 2021','2020');
        EDealerReturnCompliance.getStartEndDates('','q3 2021','2020');
        EDealerReturnCompliance.getStartEndDates('','q4 2021','2020');
        EDealerReturnCompliance.getStartEndDates('','','2020');
    }
        
    @isTest
    private static void validateFetchAWSReturnsComplianceData1(){ 
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dlrcode": "A875", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "rmatype": "RM", "itemid": "008-290-00", "suggested_date": "2021-05-06", "suggested_qty": 1, "suggested_amt": 94.00848, "returned_date": null, "returned_qty": null, "returned_amt": null, "avg_retun_compliance": 0.0, "return_status": "No Return"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();         
        // calling apex class method
        
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerReturnCompliance.ReturnWrapper obj = new EDealerReturnCompliance.ReturnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.month = 'dec 2021';
        obj.quarter = 'q4 2021';
        obj.quarter='2020';
        obj.field='ITEM';
        obj.operator='Equals to';
        obj.value='2272926PE';
        
        string strObj = JSON.serialize(obj);
        
        EDealerReturnCompliance.fetchAWSReturnsComplianceData(strObj); 
        
        Test.stopTest();
    }
}