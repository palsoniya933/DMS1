@isTest
public class EDealerTotalPartsOrderedKPICtrlTest { 
    @isTest
    private static void valitedateGetTotalPartsOrdered(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "part_count_total": 918, "part_count": 205, "part_count_pre": 713, "frequency": "Weekly", "type": "Actual", "doller_value": 30905.8, "doller_value_pre": 120466.01, "doller_value_per": -74.34, "part_count_per": -71.25}, {"cstno": "A875", "part_count_total": 205, "part_count": 205, "part_count_pre": 0, "frequency": "Daily", "type": "Actual", "doller_value": 30905.8, "doller_value_pre": 0.0, "doller_value_per": 0.0, "part_count_per": 0.0}, {"cstno": "A875", "part_count_total": 10296, "part_count": 10296, "part_count_pre": 0, "frequency": "Annually", "type": "Open", "doller_value": 1977545.65, "doller_value_pre": 0.0, "doller_value_per": 0.0, "part_count_per": 0.0}, {"cstno": "A875", "part_count_total": 10296, "part_count": 305, "part_count_pre": 9991, "frequency": "Daily", "type": "Open", "doller_value": 49136.14, "doller_value_pre": 1928409.51, "doller_value_per": -97.45, "part_count_per": -96.95}, {"cstno": "A875", "part_count_total": 10296, "part_count": 10296, "part_count_pre": 0, "frequency": "Monthly", "type": "Open", "doller_value": 1977545.65, "doller_value_pre": 0.0, "doller_value_per": 0.0, "part_count_per": 0.0}, {"cstno": "A875", "part_count_total": 10296, "part_count": 10296, "part_count_pre": 0, "frequency": "Quarterly", "type": "Open", "doller_value": 1977545.65, "doller_value_pre": 0.0, "doller_value_per": 0.0, "part_count_per": 0.0}, {"cstno": "A875", "part_count_total": 45440, "part_count": 14860, "part_count_pre": 30580, "frequency": "Annually", "type": "Actual", "doller_value": 2686328.62, "doller_value_pre": 5321450.68, "doller_value_per": -49.52, "part_count_per": -51.41}, {"cstno": "A875", "part_count_total": 5784, "part_count": 2287, "part_count_pre": 3497, "frequency": "Monthly", "type": "Actual", "doller_value": 410865.02, "doller_value_pre": 711884.27, "doller_value_per": -42.28, "part_count_per": -34.6}, {"cstno": "A875", "part_count_total": 10296, "part_count": 305, "part_count_pre": 9991, "frequency": "Weekly", "type": "Open", "doller_value": 49136.14, "doller_value_pre": 1928409.51, "doller_value_per": -97.45, "part_count_per": -96.95}, {"cstno": "A875", "part_count_total": 14860, "part_count": 5784, "part_count_pre": 9076, "frequency": "Quarterly", "type": "Actual", "doller_value": 1122749.3, "doller_value_pre": 1563579.32, "doller_value_per": -28.19, "part_count_per": -36.27}]}'
                            );
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('A875');
        lstDealer.add('I081');
        EDealerTotalPartsOrderedKPICtrl.PartsOrderResponseWrapper masterResWrapp = EDealerTotalPartsOrderedKPICtrl.getTotalPartsOrderes(lstDealer,'invoiced');
        String cstovalue = 'A875';
        system.assertEquals(cstovalue, masterResWrapp.response[0].cstno);
        Test.stopTest();
    }
    
}