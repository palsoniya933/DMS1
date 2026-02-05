@isTest
public class EDealerOrderListingTest {
 @isTest
    private static void testGetConfirmedOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
          List<string>dealerCode=new List<string>{'1010','1011'};
        Test.startTest();
       
        // calling apex class method
    
        EDealerConfirmedListing.ResponseWrapper masterResWrapp = EDealerOrderListingController.getConfirmedOrders(dealerCode,'frequency','XS',0,2000);
        system.assertEquals('XS', masterResWrapp.response[0].ordertype);
        Test.stopTest();
           
    }
    @isTest
    private static void testGetPendingOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
         List<string>dealerCode=new List<string>{'A875','A875'};
        // calling apex class method
         EDealerPendingListing.ResponseWrapper masterResWrapp = EDealerOrderListingController.getPendingOrders(dealerCode,'frequency','XS',0,2000);
        system.assertEquals('XS', masterResWrapp.response[0].ordertype);
        Test.stopTest();
                
    }
    
     @isTest
    private static void testGetUnConfirmedOrders(){
         // setting mock response
       HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
         List<string>dealerCode=new List<string>{'A875','A875'};
        // calling apex class method
       EDealerUnconfirmedListing.ResponseWrapper masterResWrapp = EDealerOrderListingController.getUnConfirmedOrders(dealerCode ,'frequency','XS',0,2000);
        system.assertEquals('XS', masterResWrapp.response[0].ordertype);
        Test.stopTest();
        
    }
    
     @isTest
    private static void testGetInTransitOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"division": "KW", "dealer_codes":"A876","offSet":10}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerOrderListingController.getInTransitOrders('A876','Quarterly'); 
        Test.stopTest();            
    }
    
     @isTest
    private static void testGetDeleveredOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": {"LOCNO": "test", "dealer_codes":"A876","STATUS":"test1","OrdersDeliveredTotal":[{"PPD_ORDER":"test1","EST_ARRIVAL_PST":"'+string.valueof(system.now())+'","DELIVERED_DATE_PST":"'+string.valueof(system.now())+'"}]}}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerOrderListingController.getDeleveredOrders('A876','Quarterly'); 
        Test.stopTest();            
    }
    
    
     @isTest
    private static void testGetDelieveryMetricsOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"LOCNO":"test1","CRITERIA":"abc","DeliveredMetrics":{"delayOrders":[{"PPD_ORDER":"123","PRO_NUM":"10","EST_ARRIVAL_PST":"'+string.valueOf(system.now())+'","DELIVERED_DATE_PST":"'+string.valueOf(system.now())+'"}],"onTimeOrders":[{"PPD_ORDER":"123","PRO_NUM":"10"}]}}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerOrderListingController.getDelieveryMetricsOrders('A875','Quarterly'); 
        Test.stopTest();            
    }
    
    
     @isTest
    private static void testGetManualLockdownOrders(){
         // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"grp_nbr":"I080","loc":"I080","sale_ind":"Y","item":"B11-1030M01R","p_abc":"D","oh":0,"dnet":750.49,"p_12monthhitcount":1,"p_mtddemandqty":0,"p_12monthdemandqty":1,"p_dlrsplrcode":"P","p_stkclass":"001B","p_sunsetdate":"2022-10-13","p_dlrrslnumber":" ","p_pdc_spq":1,"p_commenttext":"NS PER TO 10/13/21 SAH","is_true":0}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerOrderListingController.getManualLockdownOrders(new List<String>{'I080'}); 
        Test.stopTest();            
    }
    
              
    
    
}