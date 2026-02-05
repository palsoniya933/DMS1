@isTest
public class eDealerExcess90DaysTest {
 @isTest
    private static void validategetExcess90DaysData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        //mockResponse.setBody('{"dealers":[{"total_inventory":14000,"total_inventory_mdi_90_day_excess_sugg":7000,"total_inventory_not_mdi_90_day_excess_sugg":7000,"total_inventory_mdi_90_day_excess_sugg_percentage":50.0,"total_inventory_not_mdi_90_day_excess_sugg_percentage":50.0,"total_percentage":10,"total_pdc_mdi_90_day_excess_sugg":3200,"total_dsp_mdi_90_day_excess_sugg":4200,"total_pdc_not_mdi_90_day_excess_sugg":2200,"total_dsp_not_mdi_90_day_excess_sugg":1800,"total_pdc":5400,"total_dsp":6000,"loc":"I080"}],"total":{"total_inventory":400000,"total_inventory_mdi_90_day_excess_sugg":300000,"total_inventory_not_mdi_90_day_excess_sugg":100000,"total_inventory_mdi_90_day_excess_sugg_percentage":75.0,"total_inventory_not_mdi_90_day_excess_sugg_percentage":25.0,"total_percentage":90,"total_pdc_mdi_90_day_excess_sugg":32000,"total_dsp_mdi_90_day_excess_sugg":42000,"total_pdc_not_mdi_90_day_excess_sugg":22000,"total_dsp_not_mdi_90_day_excess_sugg":18000,"total_pdc":54000,"total_dsp":6000}');        
        mockResponse.setBody('{"dealers":[{"total_inventory":14000,"total_inventory_mdi_90_day_excess_sugg":7000,"total_inventory_not_mdi_90_day_excess_sugg":7000,"total_inventory_mdi_90_day_excess_sugg_percentage":50.0,"total_inventory_not_mdi_90_day_excess_sugg_percentage":50.0,"total_percentage":10,"total_pdc_mdi_90_day_excess_sugg":3200,"total_dsp_mdi_90_day_excess_sugg":4200,"total_pdc_not_mdi_90_day_excess_sugg":2200,"total_dsp_not_mdi_90_day_excess_sugg":1800,"total_pdc":5400,"total_dsp":6000,"loc":"I080"}],"total":{"total_inventory":400000,"total_inventory_mdi_90_day_excess_sugg":300000,"total_inventory_not_mdi_90_day_excess_sugg":100000,"total_inventory_mdi_90_day_excess_sugg_percentage":75.0,"total_inventory_not_mdi_90_day_excess_sugg_percentage":25.0,"total_percentage":90,"total_pdc_mdi_90_day_excess_sugg":32000,"total_dsp_mdi_90_day_excess_sugg":42000,"total_pdc_not_mdi_90_day_excess_sugg":22000,"total_dsp_not_mdi_90_day_excess_sugg":18000,"total_pdc":54000,"total_dsp":6000}}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        eDealerExcess90Days.excess90DaysResponseWrapper masterResWrapp = eDealerExcess90Days.getExcess90DaysData(lstDealer,'category');
        system.assertEquals(14000, masterResWrapp.dealers[0].total_inventory);
        Test.stopTest();
    }
}