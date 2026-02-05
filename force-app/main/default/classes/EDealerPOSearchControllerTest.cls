@isTest
public class EDealerPOSearchControllerTest {
 @isTest
    private static void testGetPODetailsData(){
        
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealerpo": "TD091021WS", "ordno": "TD41271", "order_status": "INVOICED", "ordersource": "Parts Online", "createdby": "WILL SKIRVIN", "created_date": "2021-09-10", "splitorder": 1}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerPOSearchController.getPODetails('I080','TD091021WS');    
        Test.stopTest();            
    }
    
    /*@isTest
    private static void testWrapperData(){
       EDealerConfirmedListing.MasterActiveOrderWrapper objMaster=new EDealerConfirmedListing.MasterActiveOrderWrapper();
       objMaster.createdby='TestUser';
       objMaster.cstno='220';
       objMaster.dealerpo='';
       objMaster.orderdate='15/05/2021';
       objMaster.ordersource='Test';
       objMaster.orderstatus='Shipped';
       objMaster.ordertype='';
       objMaster.ordno='MH67'; 
       List<EDealerConfirmedListing.MasterActiveOrderWrapper> lstMaster=new List<EDealerConfirmedListing.MasterActiveOrderWrapper>();
       lstMaster.add(objMaster); 
        
       //ResponseWrapper Data 
       EDealerConfirmedListing.ResponseWrapper resWrap=new EDealerConfirmedListing.ResponseWrapper();
       resWrap.error='Unknown Error'; 
       resWrap.response=lstMaster; 
    }*/
}