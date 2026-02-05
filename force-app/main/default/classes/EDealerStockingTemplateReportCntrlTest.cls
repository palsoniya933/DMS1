@isTest
public class EDealerStockingTemplateReportCntrlTest { 
    @isTest
    private static void validateFetchDealerTotalInventoryKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "A875", "engine": 138991.92, "type": "engine"}, {"dealer_code": "A875", "engine": 491391.09, "type": "all_parts"}, {"dealer_code": "A875", "engine": 667590.68, "type": "non_engine"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerStockingTemplateReportCntrl.MDIStockingWrapper obj = new EDealerStockingTemplateReportCntrl.MDIStockingWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        // calling apex class method
        EDealerStockingTemplateReportCntrl.fetchStockingTemplateReport(strObj);
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchDealerTotalInventoryKPIData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "A875", "engine": 138991.92, "type": "engine"}, {"dealer_code": "A875", "engine": 491391.09, "type": "all_parts"}, {"dealer_code": "A875", "engine": 667590.68, "type": "non_engine"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerStockingTemplateReportCntrl.MDIStockingWrapper obj = new EDealerStockingTemplateReportCntrl.MDIStockingWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='A';
        string strObj = JSON.serialize(obj);
        // calling apex class method
        EDealerStockingTemplateReportCntrl.fetchStockingTemplateReport(strObj);
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchDealerTotalInventoryKPIData2(){
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
        
        EDealerStockingTemplateReportCntrl.MDIStockingWrapper obj = new EDealerStockingTemplateReportCntrl.MDIStockingWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealer_codes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='A';
        string strObj = JSON.serialize(obj);
        // calling apex class method
        
        try{
            EDealerStockingTemplateReportCntrl.fetchStockingTemplateReport(strObj);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
        
        Test.stopTest();
    }
    
    @isTest
    private static void wrapperData(){
        
        List<EDealerStockingTemplateReportCntrl.StockingTemplateWrapper> lstTemplate=new List<EDealerStockingTemplateReportCntrl.StockingTemplateWrapper>();
        EDealerStockingTemplateReportCntrl.StockingTemplateWrapper objStockWrap=new EDealerStockingTemplateReportCntrl.StockingTemplateWrapper();
        objStockWrap.abc='Test';
        objStockWrap.cost=340;
        objStockWrap.division='A875';
        objStockWrap.dlrsplrcd='';
        objStockWrap.loc='A877';
        objStockWrap.minss=21;
        objStockWrap.mpscovdur=2;
        objStockWrap.sscov=23;
        objStockWrap.ssrule=2;
        objStockWrap.starlevel=1;
        objStockWrap.stkclass='Test Class';
        objStockWrap.distchan='';
        objStockWrap.abc_level=10;
        lstTemplate.add(objStockWrap);
        
        EDealerStockingTemplateReportCntrl.StockingTemplateReportResponseWrapper stckWrap=new EDealerStockingTemplateReportCntrl.StockingTemplateReportResponseWrapper();
        stckWrap.error='Unknown Error';
        stckWrap.response=lstTemplate;
    }
    
}