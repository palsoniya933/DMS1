@isTest
public class EDealerPartDetailsTest {
    @isTest
    private static void EDealerPartDetailsTestMethod(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"dealer_code": "A875", "engine": 138991.92, "type": "engine"}, {"dealer_code": "A875", "engine": 491391.09, "type": "all_parts"}, {"dealer_code": "A875", "engine": 667590.68, "type": "non_engine"}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Test.startTest();
        List<String> dealerCodeString = new List<String>();
        EDealerPartDetails.PartDetailsResponseWrapper partDetails = new EDealerPartDetails.PartDetailsResponseWrapper();
        
        dealerCodeString.add('dealer_code');
        dealerCodeString.add('dealerCode');        
        EDealerPartDetails.fetchPartAvailabilityDetails('A875','138991.92','userName');
        EDealerPartDetails.stringToInteger('1389912');
        
        mockResponse.setBody('{"response": {"part_Num": "A875", "cdn_path": ["Test"], "document": ["Test"],"video":["Test","Test1"]}}');
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        EDealerPartDetails.fetchOnloadDetails_apex('138991.92','division');
        
        
        mockResponse.setBody('{"response": {"part_Num": "A875", "part_name": "Test"}}');
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        EDealerPartDetails.PartDetailFromSnowFlake('138991.92','EN','division','A875');
        Test.stopTest();
    }
    
    @isTest
    private static void clsWrapper(){
        
        EDealerPartDetails.cls_response objClsWrapper = new EDealerPartDetails.cls_response();
        objClsWrapper.part_number='A875';
        objClsWrapper.part_name='test';
        objClsWrapper.alternate_parts=new list<EDealerPartDetails.AlternativePartWrapper>();
        
        
        
        EDealerPartDetails.PartDetailFromSnowFlakeResponseWrapper objPartDetail = new EDealerPartDetails.PartDetailFromSnowFlakeResponseWrapper();
        objPartDetail.response= objClsWrapper;
        objPartDetail.error='unknown error';
        
        list<EDealerPartDetails.PartAvailabilityItemWrapper> lstPartAvailabilty =new list<EDealerPartDetails.PartAvailabilityItemWrapper>();
        EDealerPartDetails.PartAvailabilityItemWrapper objPartAvailabilty = new EDealerPartDetails.PartAvailabilityItemWrapper();
        objPartAvailabilty.PdcCode='';
        objPartAvailabilty.AvailQty='';
        objPartAvailabilty.AvailQtyInt=10;
        objPartAvailabilty.IntranQty='';
        objPartAvailabilty.IntranQtyInt=10;
        objPartAvailabilty.EstDate='';
        objPartAvailabilty.OrderQty='';
        objPartAvailabilty.OrderQtyInt=10;
        objPartAvailabilty.EstAvail='';
        objPartAvailabilty.PdcLeadTm='1230';        
        objPartAvailabilty.qtyForOrder=10;
        objPartAvailabilty.checked=true;    
        lstPartAvailabilty.add(objPartAvailabilty);
        
        EDealerPartDetails.PartAvailabilityWrapper objPartAvailabilityWrapper =new EDealerPartDetails.PartAvailabilityWrapper();
        objPartAvailabilityWrapper.PartAvl= new list<EDealerPartDetails.PartAvailabilityItemWrapper>();
        objPartAvailabilityWrapper.PartAvl=lstPartAvailabilty;
        objPartAvailabilityWrapper.ErrorMSG='';
        objPartAvailabilityWrapper.NoOfRecords=10;
        objPartAvailabilityWrapper.DspStdDays='';
        objPartAvailabilityWrapper.DspEmDays='';
        objPartAvailabilityWrapper.SuppLeadTm='';
        objPartAvailabilityWrapper.TrukLeadTm='';
        
        EDealerPartDetails.PartDetailsWrapper objPartDetailsWrapper = new EDealerPartDetails.PartDetailsWrapper();
        objPartDetailsWrapper.part_Num='';
        objPartDetailsWrapper.cdn_path = new list<string>{'test1','test2'};
        objPartDetailsWrapper.document = new list<string>{'test1','test2'};    
        objPartDetailsWrapper.video = new list<string>{'test1','test2'};
        
        EDealerPartDetails.PartDetailsResponseWrapper objResponseWrapper = new EDealerPartDetails.PartDetailsResponseWrapper();
        objResponseWrapper.response = objPartDetailsWrapper;
        objResponseWrapper.error ='unknown error';
        
        list<EDealerPartDetails.AlternativePartWrapper> lstAlPartWrapper = new list<EDealerPartDetails.AlternativePartWrapper>();
        EDealerPartDetails.AlternativePartWrapper objAlternativePartWrapper = new EDealerPartDetails.AlternativePartWrapper();
        objAlternativePartWrapper.part_number='123';
        objAlternativePartWrapper.description='';
        objAlternativePartWrapper.saleableindicator='test1';
        objAlternativePartWrapper.relationship_type='';
        lstAlPartWrapper.add(objAlternativePartWrapper);
        
        list<EDealerPartDetails.PartDetailWrapper> lstPartDetailWrapper = new list<EDealerPartDetails.PartDetailWrapper>();
         EDealerPartDetails.PartDetailWrapper objPartDetailWrapper = new EDealerPartDetails.PartDetailWrapper();
        objPartDetailWrapper.partid=12.5;
        objPartDetailWrapper.partnumber='';
        objPartDetailWrapper.languagecode='test1';
        objPartDetailWrapper.attributename='';
        objPartDetailWrapper.value='';
        lstPartDetailWrapper.add(objPartDetailWrapper);
        
         list<EDealerPartDetails.DealerDataWrapper> lstDealerDataWrapper = new list<EDealerPartDetails.DealerDataWrapper>();
         EDealerPartDetails.DealerDataWrapper objDealerDataWrapper = new EDealerPartDetails.DealerDataWrapper();
        objDealerDataWrapper.availibility='';
        objDealerDataWrapper.dealer_code='';
        objDealerDataWrapper.dealer_name='test1';
        objDealerDataWrapper.location='';
        objDealerDataWrapper.phone_number='02112';
        lstDealerDataWrapper.add(objDealerDataWrapper);
    }
}