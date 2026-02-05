@isTest
public class EDealerTotalInventoryKPITest {
    @isTest
    private static void validateFetchDealerTotalInventoryKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"report":"No_Move","total":2994759.3418999994},{"report":"Total_Healthy_Inventory","total":2994759.3418999994},{"report":"Total_Inventory_NonEngine","total":2994759.3418999994},{"report":"Excess_90_Days","total":2994759.3418999994},{"report":"Total_Inventory","total":2994759.3418999994}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerTotalInventoryKPI.TotalInventoryKPIResponseWrapper masterResWrapp = EDealerTotalInventoryKPI.fetchDealerTotalInventoryKPIData(lstDealer);
        system.assertEquals('No_Move', masterResWrapp.response[0].report);
        Test.stopTest();
    }
}