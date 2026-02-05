@isTest
public class EDealerEmergencyListingTest {
 @isTest
    private static void testEmergencyData(){
         
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "1", "dealerpo": "EB102721", "item": "3943463CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "3", "dealerpo": "EB102721", "item": "5579368CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "2", "dealerpo": "EB102721", "item": "5457297RXCUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "3", "dealerpo": "EB102721", "item": "5289965CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "3", "dealerpo": "EB102721", "item": "4384812CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "3", "dealerpo": "EB102721", "item": "5283589CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-27", "orderno": "EB54887", "relno": "1", "dealerpo": "EB102721", "item": "3943463CUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-28", "orderno": "EB55094", "relno": "1", "dealerpo": "EB102821", "item": "5496045RXCUM", "orderstatus": "Invoiced"}, {"reqd_date": "2021-10-28", "orderno": "EB55094", "relno": "3", "dealerpo": "EB102821", "item": "4089576CUM", "orderstatus": "Invoiced"}]}');
        
        HttpResponse mockResponse1 = new HttpResponse();
        mockResponse1.setStatus('OK');
        mockResponse1.setStatusCode(200); 
        mockResponse1.setHeader('Content-Type', 'application/json');
        mockResponse1.setBody('{"response":{"daily_order":{},"weekly_order":{"cstno":"I080","emergency_order":20,"total_order":334,"percent_emr_order":5.99},"monthly_order":{"cstno":"I080","emergency_order":117,"total_order":2772,"percent_emr_order":4.22},"quaterly_order":{"cstno":"I080","emergency_order":360,"total_order":9365,"percent_emr_order":3.84},"yearly_order":{"cstno":"I080","emergency_order":1380,"total_order":45401,"percent_emr_order":3.04},"two_yearly_order":{"cstno":"I080","emergency_order":2694,"total_order":98073,"percent_emr_order":2.75}}}');
        EDealerHTTPMockResponseTest returnEmergencyListingContr = new EDealerHTTPMockResponseTest(mockResponse);
        EDealerHTTPMockResponseTest returnEmergencyContr = new EDealerHTTPMockResponseTest(mockResponse1);
        
        // setting mock apex class
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:AWS_EDealer'+'/emergency-order/listing/dealer',returnEmergencyListingContr);
        //endpoint2TestResp.put('callout:AWS_EDealer'+'/emergency-order/kpi/I080/dealer',returnEmergencyContr);
        endpoint2TestResp.put('callout:AWS_EDealer'+'/emergencyorder/dealer',returnEmergencyContr);
        EdealerHttpCalloutServiceMultiMockTest multiCalloutMock = new EdealerHttpCalloutServiceMultiMockTest(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        
        Test.startTest();
        // calling apex class method
        EDealerEmergencyListingCtrl.ResponseWrapper masterResWrapp = EDealerEmergencyListingCtrl.getEmergencyData(new List<String>{'I080'},'month',1000,0);  
        system.assertEquals('2021-10-27', masterResWrapp.response[0].reqd_date);
        Test.stopTest();            
    }
    
    @isTest
    private static void testWrapperData(){
       EDealerEmergencyListingCtrl.MasterEmergencyWrapper objMaster=new EDealerEmergencyListingCtrl.MasterEmergencyWrapper();
    
       objMaster.orderno='220';
       objMaster.dealerpo='';
       objMaster.reqd_date='15/05/2021';
       objMaster.orderstatus='Shipped';
       objMaster.relno='';
       objMaster.item='MH67'; 
       List<EDealerEmergencyListingCtrl.MasterEmergencyWrapper> lstMaster=new List<EDealerEmergencyListingCtrl.MasterEmergencyWrapper>();
       lstMaster.add(objMaster); 
        
       //ResponseWrapper Data 
       EDealerEmergencyListingCtrl.ResponseWrapper resWrap=new EDealerEmergencyListingCtrl.ResponseWrapper();
       resWrap.error='Unknown Error'; 
       resWrap.response=lstMaster; 
       //resWrap.kpiDetails=lstMaster;
    }
}