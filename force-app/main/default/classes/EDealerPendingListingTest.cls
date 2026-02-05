@isTest
public class EDealerPendingListingTest {
    
    @isTest
    private static void testFetchListingData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"paccar_po":"DS-XC95155","cstno":"I080","cstsfx":"","ordno":"STCK517","dealerpo":"IND022522CNR","orderdate":"2022-02-25","ordertype":"Stock Order","orderstatus":"Backorder","createdby":"GARRETT DAY","ordersource":"Parts Online","splitorder":10}]}');

        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerPendingListing.ResponseWrapper resWrrap = EDealerPendingListing.fetchListingData(new List<String>{'I080'},'Stock Order','All',0,2000); 
        system.assertEquals('I080', resWrrap.response[0].cstno);
        Test.stopTest();            
    }
    
    @isTest
    private static void testWrapperData(){
        EDealerPendingListing.MasterActiveOrderWrapper objMaster=new EDealerPendingListing.MasterActiveOrderWrapper();
        objMaster.createdby='TestUser';
        objMaster.cstno='220';
        objMaster.paccar_po ='DS-XC95155';
        objMaster.dealerpo='';
        objMaster.orderdate='15/05/2021';
        objMaster.ordersource='Test';
        objMaster.orderstatus='Shipped';
        objMaster.ordertype='XS';
        objMaster.ordno='MH67'; 
        List<EDealerPendingListing.MasterActiveOrderWrapper> lstMaster=new List<EDealerPendingListing.MasterActiveOrderWrapper>();
        lstMaster.add(objMaster); 
        
        //ResponseWrapper Data 
        EDealerPendingListing.ResponseWrapper resWrap=new EDealerPendingListing.ResponseWrapper();
        resWrap.error='Unknown Error'; 
        resWrap.response=lstMaster; 
    }
    
}