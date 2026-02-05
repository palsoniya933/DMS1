@isTest
public class EDealerSuggestedOrderUtilsTest {
    
    @testSetup
    static void setup(){
       
        Account objAcc=new Account(Name='KWAccount',Dealer_Code__c='999990');
        insert objAcc; 
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
    }
    
    @isTest
    private static void testGetFieldsNames() {
        
        List<String> fieldNames = EDealerSuggestedOrderUtils.getFieldsNames();
        System.assert(!fieldNames.isEmpty(),'Field Name should not be empty.');
    } 
    
    @isTest
    private static void testGetSuggestedOrdersForToday(){
            
        Set<String> setDealerLocs=new Set<String>();
        setDealerLocs.add('999990');
        
        List<EDealer_Suggested_Order__c> sofList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(setDealerLocs);     
        System.assert(!sofList.isEmpty(),'Suggestion list should not be empty.');
    }
    
    @isTest
    private static void testGetSuggestedOrdersForToday1(){
        
        Account acc=[Select Id FROM Account where name='KWAccount' limit 1];
        EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(acc.Id, 'EM','SOF');
        List<EDealer_Suggested_Order__c> sofList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(acc.Id,'SOF');
        System.assert(!sofList.isEmpty(),'Suggestion list should not be empty.');
    }
    
    
    @isTest
    private static void testcallSuggestedOrdersApi(){
       
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
       // mockResponse.setBody('');
         mockResponse.setBody('{"response": [{"division": "b400", "dealerCodes": 17}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerSuggestedOrderUtils.SuggestedOrderFileWrapper resSOFAPI = EDealerSuggestedOrderUtils.callSuggestedOrdersApi(new List<string>{'999990'},'K', false);      
        System.assert(resSOFAPI != null, 'resSOFAPI not be  null');
        System.assert(resSOFAPI.response != null, 'response not be  null');
        Test.stopTest();            
    }
    
    @isTest
    private static void testcallSuggestedOrdersApiWrapper(){
       
        EDealerSuggestedOrderUtils.PolicyDataWrapper objPolicy=new EDealerSuggestedOrderUtils.PolicyDataWrapper();
        objPolicy.PromoNumber='OFF50';
        objPolicy.PromoValue='50';
        List<EDealerSuggestedOrderUtils.PolicyDataWrapper> lstPolicy=new List<EDealerSuggestedOrderUtils.PolicyDataWrapper>();
        lstPolicy.add(objPolicy);
        //QtyBreakWrapper data
        List<EDealerSuggestedOrderUtils.QtyBreakWrapper> qtyWrap=new List<EDealerSuggestedOrderUtils.QtyBreakWrapper>();
        EDealerSuggestedOrderUtils.QtyBreakWrapper wrapObj=new EDealerSuggestedOrderUtils.QtyBreakWrapper();
        wrapObj.QtyBreak='Test';
        wrapObj.QtyDiscPerc=25;
        wrapObj.QtyPrice=100;  
        qtyWrap.add(wrapObj);
        
        //SuggestedPartPriceWrapper data
        EDealerSuggestedOrderUtils.SuggestedPartPriceWrapper objSugg=new EDealerSuggestedOrderUtils.SuggestedPartPriceWrapper();
        objSugg.Core='Test';
        objSugg.ListPrice=1;
        objSugg.CustomerNumber='MH2345';
        objSugg.WhsQtyBreak=qtyWrap;
        objSugg.DspQtyBreak=qtyWrap;
        objSugg.PolicyData=lstPolicy;
        objSugg.LoyaltyEndDate=15;
        objSugg.CorePrice=200;
        objSugg.CustomerSuffix='';
        objSugg.DqtypromoCode='TestFree';
        objSugg.DspFinalNet=12;
        objSugg.DspStdNet=2;
        objSugg.LoyaltyBegDate=4;
        objSugg.LoyaltyDiscount=15;
        objSugg.LoyaltyCode='LoyaltyTest';
        objSugg.OpartNumber='TestOpart';
        objSugg.Quantity=12;
        objSugg.ReSale=1;
        objSugg.WhsDspFlag='True';
        objSugg.WhsFinalNet=12;
        objSugg.WhsStdNet=1;
        objSugg.WqtypromoCode='TestPromo';
        objSugg.dealer_quantity_per_day=10;
        objSugg.unit_of_measure='';
        objSugg.cnr_effective_date='';
        objSugg.cnr_end_date='';
        objSugg.loyaltyflag='Y';
        objSugg.discountamount=15;
        objSugg.couponcode='';
        objSugg.printcode='TestPrint';
        
        //OrderWrapper data       
        EDealerSuggestedOrderUtils.OrderWrapper  objOrder=new EDealerSuggestedOrderUtils.OrderWrapper();
        //objOrder.dealer_inventory_qty=1;
        objOrder.dealer_supplier_code='SupplierCode';
        objOrder.decription='Test';
        objOrder.emergency_indicator='Test';
        objOrder.lead_time=2;
        objOrder.part_category_type='';
        objOrder.part_name='';
        objOrder.PriceDetail=objSugg;
        objOrder.qty_on_order=4;
        objOrder.qtyInTodayCart=2;
        //objOrder.qtyForOrder=4;
        objOrder.serial_number=420;
        objOrder.suggested_qty=12;
        
        Test.startTest();
        EDealerSuggestedOrderUtils.SuggestedOrderWrapper objEdealer=new EDealerSuggestedOrderUtils.SuggestedOrderWrapper(objOrder, '99909');
       	System.assert(objEdealer != null,'Field Should not be null. ');
        Test.stopTest();
    }
    
}