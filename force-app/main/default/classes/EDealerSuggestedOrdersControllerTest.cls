@isTest
public class EDealerSuggestedOrdersControllerTest {

    @isTest
    private static void fetchDealerAllSuggestedOrdersDetails(){ 
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='A875'); 
        insert objAcc; 
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='PDC',Type__c='SOF');
        insert objEDealer;
        
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders=new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        EDealerSuggestedOrderUtils.SuggestedOrderWrapper objWrap=new EDealerSuggestedOrderUtils.SuggestedOrderWrapper();
        objWrap.checked=true;
        objWrap.dealer_code='A897'; 
        objWrap.Dealer_Ineventory_Qty=2;
        objWrap.dealer_supplier_code='SUPPLIER';
        objWrap.DualPartSelectedPriceType='DSP';
        objWrap.Emergency_Indicator=true;
        objWrap.Lead_Time=23;
        objWrap.Part_category_Type='';
        objWrap.Part_Description='Test Desc';
        objWrap.Part_Name='';
        objWrap.Qty_on_Order=3;
        objWrap.qtyForOrder=34;
        objWrap.qtyForOrderPlaceHolder=23;
        objWrap.qtyInTodayCart=2;
        objWrap.qtyOrdered=7;
        objWrap.Serial_Number=420;
        objWrap.sof_file_time=Date.today();
        objWrap.Stocking_list_Type='';
        objWrap.Suggested_Qty=7;
        objWrap.Supersession_Indicator=true;
        objWrap.suggestedOrderId=objEDealer.Id;
        //suggestedOrders.add(objWrap);
        
        objWrap=new EDealerSuggestedOrderUtils.SuggestedOrderWrapper();
        objWrap.checked=true;
        objWrap.dealer_code='A897'; 
        objWrap.Dealer_Ineventory_Qty=2;
        objWrap.dealer_supplier_code='SUPPLIER';
        objWrap.DualPartSelectedPriceType='PDC';
        objWrap.Emergency_Indicator=true;
        objWrap.Lead_Time=23;
        objWrap.Part_category_Type='';
        objWrap.Part_Description='Test Desc';
        objWrap.Part_Name='';
        objWrap.Qty_on_Order=3;
        objWrap.qtyForOrder=34;
        objWrap.qtyForOrderPlaceHolder=23;
        objWrap.qtyInTodayCart=2;
        objWrap.qtyOrdered=7;
        objWrap.Serial_Number=420;
        objWrap.sof_file_time=Date.today();
        objWrap.Stocking_list_Type='';
        objWrap.Suggested_Qty=7;
        objWrap.Supersession_Indicator=true;
        objWrap.suggestedOrderId=objEDealer.Id;
        suggestedOrders.add(objWrap);
            
        EDealerSuggestedOrdersController.fetchDealerAllSuggestedPartsDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerPDCSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerDSPSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerNonPaccarSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerDUALSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchSOFFileCreatedDate('A875');
        EDealerSuggestedOrdersController.fetchSOFFileCreatedDate('');
        EDealerSuggestedOrdersController.IsPromoAvailableForDealerLocation('A875');
        EDealerSuggestedOrdersController.sofDealerLocAdditionDetails('A875', false);
        
        objEDealer.Part_Category_Type__c = EDealerConstants.SO_PART_CATEGORY_TYPE_NONPACCAR;
        update objEDealer;
       
        EDealerSuggestedOrdersController.fetchNonPaccarSuggestionInfoAvailability('A875');
        EDealerSuggestedOrdersController.upsertItemsInEmergencyCart(suggestedOrders);
        
        
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= objEDealer.id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart);
        
        EDealerCart__c dealerCart1 = new EDealerCart__c();
        
        dealerCart1.Dealer_Location__c= objAcc.id;
        dealerCart1.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_DSP;
        dealerCart1.Quantity__c= 4;
        dealerCart1.Suggested_Order__c= objEDealer.id;
        dealerCart1.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart1);
        
        EDealerCart__c dealerCart2 = new EDealerCart__c();
        
        dealerCart2.Dealer_Location__c= objAcc.id;
        dealerCart2.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_STOCK;
        dealerCart2.Quantity__c= 4;
        dealerCart2.Suggested_Order__c= objEDealer.id;
        dealerCart2.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart2);
        insert dealerCartLst;
        
        List<EDealerCart__c> carList = EDealerCartUtils.getCartDetails(new Set<Id>{objEDealer.Id}, new set<String>{EDealerConstants.CART_ORDER_TYPE_EMERGENCY}, EDealerConstants.CART_TYPE_CART);
        System.assert(!carList.isEmpty());
        EDealerSuggestedOrdersController.upsertItemsInStockCart(suggestedOrders);
        EDealerSuggestedOrdersController.upsertItemsInDSPCart(suggestedOrders);
        EDealerSuggestedOrdersController.upsertItemsInDSPEmergencyCart(suggestedOrders);
        EDealerSuggestedOrdersController.upsertItemsInDSPAndPPDCStockCart(suggestedOrders);
        EDealerSuggestedOrdersController.upsertSelectedItemsInCart(suggestedOrders,EDealerConstants.CART_TYPE_CART,EDealerConstants.CART_ORDER_TYPE_STOCK);
        carList = EDealerCartUtils.getCartDetails(new Set<Id>{objEDealer.Id}, new set<String>{EDealerConstants.CART_TYPE_CART}, EDealerConstants.CART_ORDER_TYPE_STOCK);
        System.assert(carList.isEmpty());
    }
    
    @isTest static void test3(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"part_name": "01-5390-72GR0", "suggested_qty": 7.0, "decription": "LIGHT STT LED RED, BULK", "dealer_supplier_code": "P", "Part_category_Type": "PDCUS", "inventory_on_hand": 8, "Serial_Number": 1, "stocking_list_type": null, "qty_on_order": 0.0, "supersession_indicator": "Y", "lead_time": 5, "requested_quantity": 7, "velocity_code": "A", "PriceDetail": {"supplier": "DSP", "ListPrice": 38.99, "ReSale": 22.22, "DqtypromoCode": "", "best_net": 14.63, "EffectiveDate": "2021-08-02", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 14.63, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "Y", "WhsFlag": "Y", "DspSupplier": "DSP", "DspStdNet": 15.4, "DspBestNet": 14.63, "DspFinalNet": 14.63, "DspQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 15.4, "QtyDiscPerc": 0.0, "DISChannel": "DSP", "StdNet": 15.4, "BeatCode": "", "QtyFinal": 14.63, "CSR": "NA", "FNLNET": 14.63, "INCENTIVE": 5.0}], "WqtypromoCode": "", "WhsSupplier": "WHS", "WhsStdNet": 16.57, "WhsBestNet": 15.74, "WhsFinalNet": 15.74, "WhsQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 16.57, "QtyDiscPerc": 0.0, "DISChannel": "WHS", "StdNet": 16.57, "BeatCode": "", "QtyFinal": 15.74, "CSR": "NA", "FNLNET": 15.74, "INCENTIVE": 5.0}]}}, {"part_name": "033-00079", "suggested_qty": 50.0, "decription": "BRACKET-ANTI SAIL T6A", "dealer_supplier_code": "D113F", "Part_category_Type": "DSPUS", "inventory_on_hand": 39, "Serial_Number": 1, "stocking_list_type": null, "qty_on_order": 0.0, "supersession_indicator": "Y", "lead_time": 15, "requested_quantity": 50, "velocity_code": "A", "PriceDetail": {"supplier": "DSP", "ListPrice": 25.72, "ReSale": 16.72, "DqtypromoCode": "", "best_net": 10.75, "EffectiveDate": "2021-08-02", "pdcfrz": "", "DSPFRZ": "", "FinalNet": 10.75, "CoreFlag": "", "CorePrice": 0.0, "CoreGroup": "", "CoreClass": "", "dealer_quantity_per_day": 0, "unit_of_measure": "", "cnr_effective_date": "", "cnr_end_date": "", "loyalty_coupon": "", "monthly_loyalty_coupon": 0.0, "yearly_loyalty_coupon": 0.0, "loyalty_start_date": "", "loyalty_end_date": "", "DspFlag": "Y", "WhsFlag": "Y", "DspSupplier": "DSP", "DspStdNet": 11.32, "DspBestNet": 10.75, "DspFinalNet": 10.75, "DspQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 11.32, "QtyDiscPerc": 0.0, "DISChannel": "DSP", "StdNet": 11.32, "BeatCode": "", "QtyFinal": 10.75, "CSR": "NA", "FNLNET": 10.75, "INCENTIVE": 5.0}], "WqtypromoCode": "", "WhsSupplier": "WHS", "WhsStdNet": 14.43, "WhsBestNet": 13.71, "WhsFinalNet": 13.71, "WhsQtyBreak": [{"QtyBreak": "1-9999", "QtyPrice": 14.43, "QtyDiscPerc": 0.0, "DISChannel": "WHS", "StdNet": 14.43, "BeatCode": "", "QtyFinal": 13.71, "CSR": "NA", "FNLNET": 13.71, "INCENTIVE": 5.0}]}}], "sof_file_time": "2021-08-31 21:41:13", "dealer_code": "I080"}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='A875'); 
        insert objAcc; 
        
        Test.startTest();
        EDealerSuggestedOrdersController.generateSofonDemand('A875', 'K', false);
        EDealerSuggestedOrdersController.fetchDealerPDCSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerDSPSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerNonPaccarSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchDealerDUALSuggestedOrdersDetails('A875', false);
        EDealerSuggestedOrdersController.fetchSOFFileCreatedDate('A875');
        EDealerSuggestedOrdersController.fetchSOFFileCreatedDate('');
        EDealerSuggestedOrdersController.IsPromoAvailableForDealerLocation('A875');
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> lstSOFs = EDealerSuggestedOrdersController.fetchDealerAllSuggestedPartsDetails('A875', false);
        System.assert(!lstSOFs.isEmpty());
        EDealerSuggestedOrdersController.sofAdditonalInformation addInfo = EDealerSuggestedOrdersController.sofDealerLocAdditionDetails('A875', false);
        System.assert(addInfo != null);
        Test.stopTest();
    }
    
    
    @isTest
    private static void getSpecialCommentInDetailTest(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"comments":"01-5390-72GR0"},{"comments":"033-00079"}],"error":""}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Test.startTest();
        EDealerSuggestedOrdersController.SpecialCommentResponse commentData = EDealerSuggestedOrdersController.getSpecialCommentInDetail('A875','K','test1','test');
        System.assertEquals(commentData.response.size(), 2);
        Test.stopTest();
    }
    
}