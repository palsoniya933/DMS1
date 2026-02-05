@isTest
public class EDealerBackOrdersControllerTest {
    
    @isTest
    private static void testFetchAWSBackOrdersReportData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_codes": ["C220"],"recLimit":2000,"offSet":0,"field":"ITEM","operator":"Not equal to","value":""}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();  
        // calling apex class method 
        List<String> lstDealerCode=new List<String>();
        lstDealerCode.add('A876');
        lstDealerCode.add('A875');
        EDealerBackOrdersController.backOrderFilterWrapper obj = new EDealerBackOrdersController.backOrderFilterWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        EDealerBackOrdersController.fetchAWSBackOrdersReportData(strObj);
        Test.stopTest();
    }
    
    @isTest
    private static void testFetchAWSBackOrdersReportData1(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_codes": ["C220"],"recLimit":2000,"offSet":0,"field":"ITEM","operator":"Not equal to","value":""}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();  
        // calling apex class method 
        List<String> lstDealerCode=new List<String>();
        lstDealerCode.add('C220');
        
        EDealerBackOrdersController.backOrderFilterWrapper obj = new EDealerBackOrdersController.backOrderFilterWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        EDealerBackOrdersController.fetchAWSBackOrdersReportData(strObj);
        Test.stopTest();
    }
    
    @isTest
    private static void testFetchAWSBackOrdersReportData2(){
        
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
        lstDealerCode.add('C220');
        
        EDealerBackOrdersController.backOrderFilterWrapper obj = new EDealerBackOrdersController.backOrderFilterWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        try{
             EDealerBackOrdersController.fetchAWSBackOrdersReportData(strObj);
        }
        catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
        Test.stopTest();
    }
    
    @isTest
    private static void wrapperData(){
        
        List<EDealerBackOrdersController.BackOrderWrapper> lstEdealerWrap=new List<EDealerBackOrdersController.BackOrderWrapper>();
        EDealerBackOrdersController.BackOrderWrapper objBackOrder=new EDealerBackOrdersController.BackOrderWrapper();
        
        objBackOrder.grp_nbr='';
        objBackOrder.loc='A875';
        objBackOrder.item='00212335P';
        objBackOrder.order_date='2021-08-19';
        objBackOrder.order_type='XS';
        objBackOrder.order_number='875';
        objBackOrder.po_number='23';       
        objBackOrder.status='';
        objBackOrder.status_descr='';
        objBackOrder.qty_order=23;
        objBackOrder.ext_net=10;
        objBackOrder.vendor_id='420';
        objBackOrder.vendor_name='2';
        objBackOrder.saleable_ind='';
        objBackOrder.oh=12;
        objBackOrder.distchan='Test';
        objBackOrder.abc='Test';
        objBackOrder.dlrrslnumber='';
        
        lstEdealerWrap.add(objBackOrder);
    }
}