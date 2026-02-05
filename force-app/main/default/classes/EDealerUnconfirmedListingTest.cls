@isTest
public class EDealerUnconfirmedListingTest {
    @isTest
    private static void testUnConfirmOrdersListing(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"cstno":"I080","cstsfx":"","ordno":"EMGK847","dealerpo":"IWP7096.","orderdate":"2022-02-08","ordertype":"Emergency Order","orderstatus":"Unconfirmed","createdby":"KENWORTH OF INDIANAPOLIS","ordersource":"Queued Order","splitorder":1}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerUnconfirmedListing.ResponseWrapper masterResWrapp = EDealerUnconfirmedListing.unConfirmOrdersListingData(new List<String>{'I080'}, 'Quarterly','All',0,2000);  
        system.assertEquals('EMGK847', masterResWrapp.response[0].ordno);
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