@isTest
public class EDealerOrderListingControllerTest {
    @isTest
    private static void validateGetConfirmedOrders(){
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
    
        EDealerConfirmedListing.ResponseWrapper masterResWrapp =
            EDealerOrderListingController.getConfirmedOrders(dealerCode,'frequency','XS',0,2000);
        system.assertEquals('XS', masterResWrapp.response[0].ordertype);
        Test.stopTest();

    }
    @isTest
    private static void validateGetPendingOrders(){
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
    private static void validateGetActiveOrders(){
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
        EDealerActiveListing.ResponseWrapper masterResWrapp = EDealerOrderListingController.getActiveOrders(dealerCode,'frequency','XS',0,2000);
        system.assertEquals('XS', masterResWrapp.response[0].ordertype);
        Test.stopTest();
        
    }
    @isTest
    private static void validateGetInTransitOrders(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820","LOCNO": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
  
        EDealerOrderIntransitController.OrdersInTransitReportResponseWrapper masterResWrapp = EDealerOrderListingController.getInTransitOrders('dealerCode','XS');
        system.assertEquals('XSXS820', masterResWrapp.response[0].LOCNO);
        Test.stopTest();
        
    }
    
    @isTest
    private static void validateGetDeleveredOrders(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": {"LOCNO": "test", "STATUS":"pass" }}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getDeleveredOrders('dealerCode','frequency');
        
        Test.stopTest();
        
    }
   
    @isTest
    private static void validateGetDelieveryMetricsOrders(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getDelieveryMetricsOrders('dealerCode','frequency');
        
        Test.stopTest();
        
    }
    @isTest
    private static void validateGetDelieveryGetUnConfirmedOrders(){
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
    private static void validateGetDelieveryGetManualLockdownOrders(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getManualLockdownOrders(new List<String>{'A875'});
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void validategetColumnHeaders(){
        // setting mock response
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getColumnHeaders('Emergency Lines');
        
        Test.stopTest();
        
    }
      @isTest
    private static void validateGetDelieveryGetColumnHeaders(){
       
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getColumnHeaders('Confirmed Order File');
        Test.stopTest();
        
    }
    
          @isTest
    private static void validateGetDelieveryGetFrequencyTranslations(){
       
        Test.startTest();
        
        // calling apex class method
        EDealerOrderListingController.getFrequencyTranslations();
        
        Test.stopTest();
        
    }
}