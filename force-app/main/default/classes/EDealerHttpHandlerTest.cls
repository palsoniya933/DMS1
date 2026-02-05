@isTest
public class EDealerHttpHandlerTest {
    @isTest
    private static void validateCallout(){
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint','/purchase_order_creation/789/orders');
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body','{"Action": "ReservePO","DealerCode": "789"}');
        object mapHeader=new map<string,string>{'containtType'=>'application/JSON'};
        calloutDetails.put('headers',mapHeader);
        calloutDetails.put('classname','EDealerPlaceOrderController');
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"cstno": "A875", "ordno": "XSXS820", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS819", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS821", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC512", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "X", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC391", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS576", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS577", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS575", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "XSXS574", "orderdate": "2021-05-24", "ordertype": "XS", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "STUC390", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "1", "createdby": "ARKANSAS KENWORTH", "ordsrc": "B"}, {"cstno": "A875", "ordno": "EM96387", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "BRENT WAGGONER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95874", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "X", "createdby": "CRAIG DUNCAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "STUD797", "orderdate": "2021-05-24", "ordertype": "ST", "orderstatus": "2", "createdby": "MATT BAKER", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM95883", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "1", "createdby": "MICHAEL THOMAS", "ordsrc": "D"}, {"cstno": "A875", "ordno": "XE58801", "orderdate": "2021-05-24", "ordertype": "XE", "orderstatus": "1", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}, {"cstno": "A875", "ordno": "EM96810", "orderdate": "2021-05-24", "ordertype": "EM", "orderstatus": "2", "createdby": "WESTON RUHLMAN", "ordsrc": "D"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
       String jsonResRef=EDealerHttpHandler.callout(calloutDetails);
          System.assert(jsonResRef != null, 'EDealer Http  Handler object is null.');
         Test.stopTest();
    }
}