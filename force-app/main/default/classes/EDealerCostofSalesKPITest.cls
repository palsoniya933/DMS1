@isTest
public class EDealerCostofSalesKPITest {
    @isTest
    private static void validateFetchCostOfSalesKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"date_month_quarter":8,"cost_of_sales":0,"pre_cos":0,"cost_percentage":0.0,"frequency":"Weekly"},{"date_month_quarter":2,"cost_of_sales":0.0,"pre_cos":592617.5499999999,"cost_percentage":-100.0,"frequency":"Monthly"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        // calling apex class method
        EDealerCostofSalesKPI.CostOfSalesKPIResponseWrapper masterResWrapp = EDealerCostofSalesKPI.fetchCostOfSalesKPIData(lstDealer,'division');
        system.assertEquals('0', masterResWrapp.response[0].cost_of_sales);
        Test.stopTest();

 }
}