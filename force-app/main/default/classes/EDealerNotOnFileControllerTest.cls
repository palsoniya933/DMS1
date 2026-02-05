@isTest
public class EDealerNotOnFileControllerTest {
    @isTest
    private static void validateFetchAWSNotOnFileReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "4352365CUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 1738.43, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}, {"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "5579354CUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 1321.26, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}, {"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "5579403PXCUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 643.89, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
         // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerNotOnFileController.NotOnWrapper obj = new EDealerNotOnFileController.NotOnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        EDealerNotOnFileController.fetchAWSNotOnFileReportData(strObj);
        
        Test.stopTest();
    }
    @isTest
    private static void validateFetchAWSNotOnFileReportData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "4352365CUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 1738.43, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}, {"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "5579354CUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 1321.26, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}, {"analyst": "ANDREA O\u2019LEARY", "p_plannercode": "M15", "grp_num": "O997", "cust_nm": "MHC KENWORTH-LITTLE ROCK", "loc": "A875", "item": "5579403PXCUM", "program": "CUMMINS_500_CSL", "type": "CSL", "initialdate": "2021-03-31 00:00:00.000", "enddate": "2022-03-31 00:00:00.000", "active": 1, "rbq": 1, "stdnet": 643.89, "sbucode": "D16", "oh": 0.0, "abc": "NOF", "demand": 0, "sku_coding": null, "pdc": "OKC", "saleableind": "Y"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
         // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerNotOnFileController.NotOnWrapper obj = new EDealerNotOnFileController.NotOnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='TYPE';
        obj.operator='Equals to';
        obj.value='CSL';
        string strObj = JSON.serialize(obj);
        
        EDealerNotOnFileController.fetchAWSNotOnFileReportData(strObj);
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSNotOnFileReportData2(){
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
        
        EDealerNotOnFileController.NotOnWrapper obj = new EDealerNotOnFileController.NotOnWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='TYPE';
        obj.operator='Equals to';
        obj.value='CSL';
        string strObj = JSON.serialize(obj);
        
        try{
            EDealerNotOnFileController.fetchAWSNotOnFileReportData(strObj);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
        Test.stopTest();
    }
}