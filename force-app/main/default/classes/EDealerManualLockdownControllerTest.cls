@isTest
public class EDealerManualLockdownControllerTest {
    @isTest
    private static void validateFetchAWSManualLockdownKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "A875", "ex_parts": 106, "sum_parts": 1085}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        
        EDealerManualLockdownController.ManualLockDownKPIResponseWrapper masterResWrapp = EDealerManualLockdownController.fetchAWSManualLockdownKPIData(lstDealer,'division');
        system.assertEquals('A875', masterResWrapp.response[0].dealer_code);
        Test.stopTest();
        
    }
    
    @isTest
    private static void validateFetchAWSManualLockDownRecordsData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        //mockResponse.setBody('{"response": [{"dealer_code": "A875", "ex_parts": 106, "sum_parts": 1085}]}');
        mockResponse.setBody('{"response": [{"grp_nbr":"I080","item":"5457298RXCUM","loc":"I080"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();  
        lstDealerCode.add('I081');
        lstDealerCode.add('I080');
        
        EDealerManualLockdownController.ManualWrapper obj = new EDealerManualLockdownController.ManualWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.StartDate = system.today();
        obj.EndDate = system.today();
        string strObj = JSON.serialize(obj);
        
        
        
        EDealerManualLockdownController.ManualLockDownReportResponseWrapper masterResWrapp= EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj);     
		EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj); 
        system.assertEquals('I080', masterResWrapp.response[0].grp_nbr);
       
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSManualLockDownRecordsData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"grp_nbr":"I080","item":"5457298RXCUM","loc":"I080"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();        
        // calling apex class method
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerManualLockdownController.ManualWrapper obj = new EDealerManualLockdownController.ManualWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.StartDate = system.today();
        obj.EndDate = system.today();
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
        
        EDealerManualLockdownController.ManualLockDownReportResponseWrapper masterResWrapp= EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj);     
        EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj);   
        system.debug('masterResWrapp'+masterResWrapp);

         system.assertEquals('I080', masterResWrapp.response[0].grp_nbr);
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSManualLockDownRecordsData2(){
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
        
        EDealerManualLockdownController.ManualWrapper obj = new EDealerManualLockdownController.ManualWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.StartDate = system.today();
        obj.EndDate = system.today();
        obj.field='ABC';
        obj.operator='Equals to';
        obj.value='B';
        string strObj = JSON.serialize(obj);
       
         try{
            EDealerManualLockdownController.ManualLockDownReportResponseWrapper masterResWrapp= EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj);     
            EDealerManualLockdownController.fetchAWSManualLockDownRecordsData(strObj); 
         	system.assertEquals('A875', masterResWrapp.response[0].grp_nbr);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    private static void validateManualLockdownListingApi(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"grp_nbr":"I080","loc":"I080","sale_ind":"Y","item":"B11-1030M01R","p_abc":"D","oh":0,"dnet":750.49,"p_12monthhitcount":1,"p_mtddemandqty":0,"p_12monthdemandqty":1,"p_dlrsplrcode":"P","p_stkclass":"001B","p_sunsetdate":"2022-10-13","p_dlrrslnumber":" ","p_pdc_spq":1,"p_commenttext":"NS PER TO 10/13/21 SAH","is_true":0}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerManualLockdownController.ManualLockDownListingResponseWrapper masterResWrapp=  EDealerManualLockdownController.manualLockdownListingApi(new List<String>{'I080'});

        system.assertEquals('I080', masterResWrapp.response[0].grp_nbr);
        
        Test.stopTest();
        
    }

}