@isTest
public class EDealerCNRListingTest {
 @isTest
    private static void testCNRListingData(){
        
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "I080", "part": "2180879PE", "partdescription": "COOLANT THERMOSTAT, 85C", "limitqty": 1, "saleableindicator": "CNR"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerCNRListingCtrl.ResponseWrapper masterResWrapp = EDealerCNRListingCtrl.getCNRListingData(new List<String>{'I080'},'k'); 
        system.assertEquals('I080', masterResWrapp.response[0].dealer_code);
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