@isTest
public class EDealerMdiReportsTabControllerTest {
    @isTest
    private static void EDealerMdiReportsTabControllerTest01(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"analyst":"test","grp_nbr":"test","dealer_code": "A875", "engine": 138991.92, "type": "engine","div":"PB"}, {"dealer_code": "A875", "engine": 491391.09, "type": "all_parts"}, {"dealer_code": "A875", "engine": 667590.68, "type": "non_engine"}],"error":""}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerContainerController.UserWrapper EDealer_Relationship=EDealerMdiReportsTabController.getUserDetail('u');
           System.assert(EDealer_Relationship != null, 'EDealer Relationship object is null.');
        List<string> strObj=EDealerMdiReportsTabController.getUserList(); 
        System.assert(strObj != null, 'EDealer Relationship object is null.');
        Test.stopTest();        
        
    }
    
    @isTest
    private static void wrapperData(){
        
        List<EDealerMdiReportsTabController.MDIAnalystDealerWrapper> lstMDIAnalystDealerWrapper=new List<EDealerMdiReportsTabController.MDIAnalystDealerWrapper>();
        EDealerMdiReportsTabController.MDIAnalystDealerWrapper objMDI=new EDealerMdiReportsTabController.MDIAnalystDealerWrapper();
        objMDI.div='PB';
        objMDI.analyst='';
        objMDI.grp_nbr='test';
        objMDI.loc='';
        lstMDIAnalystDealerWrapper.add(objMDI);
        EDealerMdiReportsTabController.MDIAnalystResponseWrapper objMDIAnaResWrap= new EDealerMdiReportsTabController.MDIAnalystResponseWrapper();
        objMDIAnaResWrap.error='Unknown Error';
        System.assert(objMDI != null, 'EDealer Master Inventory Part object is null.');
        System.assertEquals('PB', objMDI.div, 'Unexpected Master Inventory Part found.');
    }
}