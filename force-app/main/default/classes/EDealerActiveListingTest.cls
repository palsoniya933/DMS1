@isTest
public class EDealerActiveListingTest {
    @isTest
    private static void testfetchListingData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"paccar_po":"DS-XC95155","cstno": "I080", "cstsfx": "", "ordno": "TD06502", "dealerpo": "TD224BAH", "orderdate": "2022-02-24", "ordertype": "Truck Down", "orderstatus": "Active", "createdby": "BILL HUNTER", "ordersource": "Parts Online", "splitorder": 0}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerActiveListing.ResponseWrapper resWrapp = EDealerActiveListing.fetchListingData(new List<String>{'I080'},'Truck Down','All',0,2000);    
        system.assertEquals('I080', resWrapp.response[0].cstno);
        Test.stopTest();            
    }
    
    @isTest
    private static void testWrapperData(){
        EDealerActiveListing.MasterActiveOrderWrapper objMaster=new EDealerActiveListing.MasterActiveOrderWrapper();
        objMaster.createdby='TestUser';
        objMaster.cstno='220';
        objMaster.paccar_po ='DS-XC95155';
        objMaster.dealerpo='';
        objMaster.orderdate='15/05/2021';
        objMaster.ordersource='Test';
        objMaster.orderstatus='Shipped';
        objMaster.ordertype='';
        objMaster.ordno='MH67'; 
        List<EDealerActiveListing.MasterActiveOrderWrapper> lstMaster=new List<EDealerActiveListing.MasterActiveOrderWrapper>();
        lstMaster.add(objMaster); 
        
        //ResponseWrapper Data 
        EDealerActiveListing.ResponseWrapper resWrap = new EDealerActiveListing.ResponseWrapper();
        resWrap.error='Unknown Error'; 
        resWrap.response=lstMaster; 
    }
}