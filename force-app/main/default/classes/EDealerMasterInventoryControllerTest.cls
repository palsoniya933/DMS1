@isTest
public class EDealerMasterInventoryControllerTest {
    
    @isTest
    private static void testGetMasterInvParts(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": 17,"division": "KW","offSet":10,"recordLimit":"10","searchText":"Test"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));   
        Test.startTest();
        // calling apex class method
        EDealerMasterInventoryController.getMasterInvParts('A875','KW',10,'10','Test');      
        Test.stopTest();    
    }
    
    @isTest
    private static void wrapperData(){
        
        EDealerMasterInventoryController.PriceDetailWrapper objPriceDetail=new EDealerMasterInventoryController.PriceDetailWrapper();
        objPriceDetail.supplier='';
        objPriceDetail.curent_list=10;
        objPriceDetail.resale_price=100;
        objPriceDetail.ListPrice=100;
        objPriceDetail.ReSale=6;
        objPriceDetail.WhsFlag='';
        objPriceDetail.DspFlag='';
        objPriceDetail.WhsStdNet=7;
        objPriceDetail.WhsFinalNet=7;
        objPriceDetail.WhsSupplier='';
        objPriceDetail.WhsBestNet=10;
        objPriceDetail.DspStdNet=6;
        objPriceDetail.DspFinalNet=10;
        objPriceDetail.DspSupplier='Supplier';
        objPriceDetail.DspBestNet=98;
        objPriceDetail.WqtypromoCode='';
        objPriceDetail.DqtypromoCode='PROMOCODE';
        objPriceDetail.Core='';
        objPriceDetail.CorePrice=546;
        objPriceDetail.best_net=2;
        objPriceDetail.EffectiveDate='';
        objPriceDetail.pdcfrz='';
        objPriceDetail.DSPFRZ='';
        objPriceDetail.FinalNet=6;
        objPriceDetail.CoreFlag='coreflag';
        objPriceDetail.CoreGroup='grouptest';
        objPriceDetail.CoreClass='';
        objPriceDetail.dealer_quantity_per_day=98;
        objPriceDetail.unit_of_measure='Each';
        objPriceDetail.cnr_effective_date='2021-03-15';     
        objPriceDetail.cnr_end_date='2021-03-19';
        objPriceDetail.loyalty_coupon='';
        objPriceDetail.monthly_loyalty_coupon=10;
        objPriceDetail.yearly_loyalty_coupon=20;
        objPriceDetail.loyalty_start_date='2021-03-19';
        objPriceDetail.loyalty_end_date='2021-03-19';
        
        
        
        list<EDealerMasterInventoryController.MasterInventoryPartWrapper> lstMasterInventoryPartWrapper = new list<EDealerMasterInventoryController.MasterInventoryPartWrapper>();
        EDealerMasterInventoryController.MasterInventoryPartWrapper masterWrap=new EDealerMasterInventoryController.MasterInventoryPartWrapper();
        masterWrap.decription='Test Wrapper data';
        masterWrap.DualPartSelectedPriceType='';
        masterWrap.inventory=12;
        masterWrap.inventory_on_hand=5;
        masterWrap.min_sfty_Stk=2;
        masterWrap.part_number='';
        masterWrap.PriceDetail=objPriceDetail;
        masterWrap.stkcls='';
        masterWrap.velocity_code='';
        masterWrap.zero_price_flag_message=true;
        lstMasterInventoryPartWrapper.add(masterWrap);
        
        EDealerMasterInventoryController.MasterInventoryResponseWrapper objMsrInResWrap = new EDealerMasterInventoryController.MasterInventoryResponseWrapper();
       
        objMsrInResWrap.error='unknown error';
        
        
        
        
    }
    
}