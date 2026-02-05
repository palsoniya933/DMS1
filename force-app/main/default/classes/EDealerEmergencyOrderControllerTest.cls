@isTest
public class EDealerEmergencyOrderControllerTest {  
    @isTest
    private static void validateFetchAWSEmergencyKPIData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":{"daily_order":{"emergency_order":0,"total_order":0,"percent_emr_order":0},"weekly_order":{"emergency_order":34,"total_order":767,"percent_emr_order":4.43},"monthly_order":{"emergency_order":194,"total_order":5086,"percent_emr_order":3.81}}}}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerEmergencyOrderController.OrderWrapper wrapper = new EDealerEmergencyOrderController.OrderWrapper();
        wrapper.cstno='A875';
        wrapper.cstsfx='test1';
        wrapper.emergency_order=115;
        wrapper.total_order=565;
        wrapper.percent_emr_order='20.35';
        
        EDealerEmergencyOrderController.EmergencyOrderWrapper objEmergencyOrderWrapper = new EDealerEmergencyOrderController.EmergencyOrderWrapper();
        objEmergencyOrderWrapper.daily_order = wrapper;
        objEmergencyOrderWrapper.monthly_order = null;
        objEmergencyOrderWrapper.quaterly_order = null;
        objEmergencyOrderWrapper.two_yearly_order = null;
        objEmergencyOrderWrapper.weekly_order = null;
        objEmergencyOrderWrapper.yearly_order = null;
        
        string JSONEmergencyOrderWrapper = JSON.serialize(objEmergencyOrderWrapper);
        EDealerEmergencyOrderController.parse(JSONEmergencyOrderWrapper);
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('A875');
        lstDealer.add('I081');
        EDealerEmergencyOrderController.EmergencyOrderWrapper masterResWrapp = EDealerEmergencyOrderController.fetchAWSEmergencyKPIData(lstDealer);
        //system.assertEquals(0, masterResWrapp.daily_order.emergency_order);
        Test.stopTest();

  }
}