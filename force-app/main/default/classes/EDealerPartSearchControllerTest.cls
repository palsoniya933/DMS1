@isTest
public class EDealerPartSearchControllerTest {
    @isTest
    private static void validateGetPartAvailable(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"part_number": "1031B0R", "OpartNumber": "1031B0R", "decription": "LIGHTS-LED (1PK = 2 BULBS)", "min_sfty_Stk": 0, "stkcls": "", "inventory_on_hand": 0, "velocity_code": "D", "PriceDetail": {"supplier": "WHS", "ListPrice": 19.99, "ReSale": 13.59, "WqtypromoCode": "", "best_net": 8.79, "CsrNumber": 0, "CsrPhase": 0, "CsrLine": 0, "CsrQty": 0, "CsrBestNet": 0.0, "CsrEffectiveDate": "", "CsrExpiryDate": "", "EffectiveDate": "2019-01-07", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 8.79, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "N", "WhsSupplier": "WHS", "WhsStdNet": 8.79, "WhsBestNet": 8.79, "WhsFinalNet": 8.79}}], "offset_value": 1, "record_count": 1, "refresh_date": "2021-05-25 01:49:18"}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerPartSearchController.getPartAvailable('dealerCode','division','searchText','Test123');
        
        Test.stopTest();
    }

}