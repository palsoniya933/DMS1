@isTest
public class EDealerZeroOnHandControllerTest {
    @isTest
    private static void validateFetchAWSZeroOnHandReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"p_date": "2021-05-24", "division": "KW", "group_number": "O997", "dealer_code": "A875", "item": "00212335P", "abc": "C", "on_hand": 0, "days_stocked_out": 1, "on_order": 10, "ord_nbr": "STSW356", "stat": "1", "status_descr": "BACKORDERED", "ord_date": "2021-05-12", "vndid": "14402AB", "p_dlrsplrcode": "00001", "p_altdlrsplrcode": " ", "rsl_csl_msl": " ", "minimum_name": " ", "dist_chan": "PDCUS", "p_12monthhitcount": 5, "p_12monthdemandqty": 7, "si": "Y", "mdi_comments": " ", "dealer_net": 9.36}, {"p_date": "2021-05-24", "division": "KW", "group_number": "O997", "dealer_code": "A875", "item": "079340-43709", "abc": "A", "on_hand": 0, "days_stocked_out": 1, "on_order": 4, "ord_nbr": "STTD770", "stat": "1", "status_descr": "BACKORDERED", "ord_date": "2021-05-14", "vndid": "15580AB", "p_dlrsplrcode": "00001", "p_altdlrsplrcode": " ", "rsl_csl_msl": " ", "minimum_name": " ", "dist_chan": "PDCUS", "p_12monthhitcount": 22, "p_12monthdemandqty": 16, "si": "Y", "mdi_comments": " ", "dealer_net": 17.99}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerZeroOnHandController.ZeroOnHandWrapper obj = new EDealerZeroOnHandController.ZeroOnHandWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        EDealerZeroOnHandController.fetchAWSZeroOnHandReportData(strObj);
        Test.stopTest();
     }
      @isTest
    private static void validateFetchAWSZeroOnHandReportData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"p_date": "2021-05-24", "division": "KW", "group_number": "O997", "dealer_code": "A875", "item": "00212335P", "abc": "C", "on_hand": 0, "days_stocked_out": 1, "on_order": 10, "ord_nbr": "STSW356", "stat": "1", "status_descr": "BACKORDERED", "ord_date": "2021-05-12", "vndid": "14402AB", "p_dlrsplrcode": "00001", "p_altdlrsplrcode": " ", "rsl_csl_msl": " ", "minimum_name": " ", "dist_chan": "PDCUS", "p_12monthhitcount": 5, "p_12monthdemandqty": 7, "si": "Y", "mdi_comments": " ", "dealer_net": 9.36}, {"p_date": "2021-05-24", "division": "KW", "group_number": "O997", "dealer_code": "A875", "item": "079340-43709", "abc": "A", "on_hand": 0, "days_stocked_out": 1, "on_order": 4, "ord_nbr": "STTD770", "stat": "1", "status_descr": "BACKORDERED", "ord_date": "2021-05-14", "vndid": "15580AB", "p_dlrsplrcode": "00001", "p_altdlrsplrcode": " ", "rsl_csl_msl": " ", "minimum_name": " ", "dist_chan": "PDCUS", "p_12monthhitcount": 22, "p_12monthdemandqty": 16, "si": "Y", "mdi_comments": " ", "dealer_net": 17.99}]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerZeroOnHandController.ZeroOnHandWrapper obj = new EDealerZeroOnHandController.ZeroOnHandWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        EDealerZeroOnHandController.fetchAWSZeroOnHandReportData(strObj);
        Test.stopTest();
     }
    
    @isTest
    private static void validateFetchAWSZeroOnHandReportData2(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('null');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerZeroOnHandController.ZeroOnHandWrapper obj = new EDealerZeroOnHandController.ZeroOnHandWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='Not equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        try{
              EDealerZeroOnHandController.fetchAWSZeroOnHandReportData(strObj);
        }
       catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
     }
}