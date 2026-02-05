@isTest
public class EDealerFreightChargesControllerTest {
    @isTest
    private static void valitedateGetActiveOrder(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "cstsfx": "", "frequency": "Daily", "date_month_quarter": "2021-05-24", "em_freightcharges": 1011.04, "td_freightcharges": 0.0, "other_freightcharges": 0.0}, {"cstno": "A875", "cstsfx": "", "frequency": "Monthly", "date_month_quarter": "5", "em_freightcharges": 9887.23, "td_freightcharges": 661.42, "other_freightcharges": 1191.11}, {"cstno": "A875", "cstsfx": "", "frequency": "Quarterly", "date_month_quarter": "2", "em_freightcharges": 23565.93, "td_freightcharges": 1964.06, "other_freightcharges": 2746.88}, {"cstno": "A875", "cstsfx": "", "frequency": "Weekly", "date_month_quarter": "21", "em_freightcharges": 1011.04, "td_freightcharges": 0.0, "other_freightcharges": 0.0}, {"cstno": "A875", "cstsfx": "", "frequency": "Annually", "date_month_quarter": "2021", "em_freightcharges": 58736.48, "td_freightcharges": 4402.77, "other_freightcharges": 9657.18}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('A875');
        lstDealer.add('I081');
        EDealerFreightChargesController.ResponseWrapper masterResWrapp = EDealerFreightChargesController.getFreightChargeDetails(lstDealer);
        system.assertEquals('A875', masterResWrapp.response[0].cstno);
        Test.stopTest();
    }

}