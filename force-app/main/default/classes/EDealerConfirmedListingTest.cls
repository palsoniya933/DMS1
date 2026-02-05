@isTest
public class EDealerConfirmedListingTest {
    @isTest
    private static void testConfirmOrdersData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"paccar_po":"DS-XC95155","dealerCode": "A875", "frequency": "Quarterly"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerConfirmedListing.confirmOrdersData(new List<String>{'I080'}, 'Quarterly','All',0,2000);    
        Test.stopTest();            
    }
    
    @isTest
    private static void testWrapperData(){
        EDealerConfirmedListing.MasterActiveOrderWrapper objMaster=new EDealerConfirmedListing.MasterActiveOrderWrapper();
        objMaster.createdby='TestUser';
        objMaster.cstno='220';
        objMaster.paccar_po ='DS-XC95155';
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
    }
}