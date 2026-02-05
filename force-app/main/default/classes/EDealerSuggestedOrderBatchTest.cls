@isTest
public class EDealerSuggestedOrderBatchTest {
    @isTest
    private static void EDealerSuggestedOrderBatchTestMethod(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"part_name": "01-5390-72GR0", "suggested_qty": 7.0, "decription": "LIGHT STT LED RED, BULK", "dealer_supplier_code": "P", "Part_category_Type": "PDCUS", "inventory_on_hand": 8, "Serial_Number": 1, "stocking_list_type": null, "qty_on_order": 0.0, "supersession_indicator": "Y", "lead_time": 5, "requested_quantity": 7, "velocity_code": "A", "PriceDetail": {"supplier": "DSP", "ListPrice": 38.99, "ReSale": 22.22, "DqtypromoCode": "", "best_net": 14.63, "EffectiveDate": "2021-08-02", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 14.63, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "Y", "WhsFlag": "Y", "DspSupplier": "DSP", "DspStdNet": 15.4, "DspBestNet": 14.63, "DspFinalNet": 14.63, "DspQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 15.4, "QtyDiscPerc": 0.0, "DISChannel": "DSP", "StdNet": 15.4, "BeatCode": "", "QtyFinal": 14.63, "CSR": "NA", "FNLNET": 14.63, "INCENTIVE": 5.0}], "WqtypromoCode": "", "WhsSupplier": "WHS", "WhsStdNet": 16.57, "WhsBestNet": 15.74, "WhsFinalNet": 15.74, "WhsQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 16.57, "QtyDiscPerc": 0.0, "DISChannel": "WHS", "StdNet": 16.57, "BeatCode": "", "QtyFinal": 15.74, "CSR": "NA", "FNLNET": 15.74, "INCENTIVE": 5.0}]}}, {"part_name": "033-00079", "suggested_qty": 50.0, "decription": "BRACKET-ANTI SAIL T6A", "dealer_supplier_code": "D113F", "Part_category_Type": "DSPUS", "inventory_on_hand": 39, "Serial_Number": 1, "stocking_list_type": null, "qty_on_order": 0.0, "supersession_indicator": "Y", "lead_time": 15, "requested_quantity": 50, "velocity_code": "A", "PriceDetail": {"supplier": "DSP", "ListPrice": 25.72, "ReSale": 16.72, "DqtypromoCode": "", "best_net": 10.75, "EffectiveDate": "2021-08-02", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 10.75, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "Y", "WhsFlag": "Y", "DspSupplier": "DSP", "DspStdNet": 11.32, "DspBestNet": 10.75, "DspFinalNet": 10.75, "DspQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 11.32, "QtyDiscPerc": 0.0, "DISChannel": "DSP", "StdNet": 11.32, "BeatCode": "", "QtyFinal": 10.75, "CSR": "NA", "FNLNET": 10.75, "INCENTIVE": 5.0}], "WqtypromoCode": "", "WhsSupplier": "WHS", "WhsStdNet": 14.43, "WhsBestNet": 13.71, "WhsFinalNet": 13.71, "WhsQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 14.43, "QtyDiscPerc": 0.0, "DISChannel": "WHS", "StdNet": 14.43, "BeatCode": "", "QtyFinal": 13.71, "CSR": "NA", "FNLNET": 13.71, "INCENTIVE": 5.0}]}}], "sof_file_time": "2021-08-31 21:41:13", "dealer_code": "I080"}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        //Sof Summary 
        EDealer_SOF_Summary__c summary = new EDealer_SOF_Summary__c();
        summary.Dealer_Code__c = 'I080';
        summary.Dealer_Divison__c = 'K';
        summary.SOF_Count__c = 2;
        summary.SOF_Date_Time__c = DateTime.now();
        summary.Time_of_Day__c = 'Day';
        
        insert summary;
        
        //Dealer Account
        Account acc = new Account();
        acc.Name = 'Kenworth';
        acc.PACCARDivision__c = 'K';
        acc.Dealer_Code__c = 'I080';
        
        insert acc;
        
        System.assert(acc.Id != null,'Account Id should not null.');
        
        Test.startTest();
        EDealerSuggestedOrderBatch sh1 = new EDealerSuggestedOrderBatch();

        String sch = '0 0 23 * * ?'; 
        system.schedule('TE Dealer Suggested Order', sch, sh1); 
        Test.stopTest(); 
    }

    
}