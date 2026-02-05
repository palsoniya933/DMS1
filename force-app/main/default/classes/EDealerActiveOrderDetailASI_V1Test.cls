@isTest
public class EDealerActiveOrderDetailASI_V1Test {
    @isTest
    private static void testFetchActiveOrderData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"customer":"I080","paccer_order":"STZM109","dealerpo":"M071221"},{"customer":"I090","paccer_order":"STZM108","dealerpo":"M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"true","bolno":"10","shipped_status":"INVOICED"},{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"true","bolno":"10","shipped_status":""},{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"true","bolno":"10","qtybo":"10.00","qty_shipped":10.00,"shipped_status":"INVOICED"},{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"true","bolno":"10","qtybo":"10.00","qty_shipped":10.00,"shipped_status":""},{"itmid":"11-03942-0500","line_status":"ALLOCATED","qtyalc":"20.00","dsp":"true","prono":"1010","qty_shipped":10.00,"shipped_status":"INVOICED","qtybo":"15.00"},{"itmid":"11-03942-0500","line_status":"ALLOCATED","qtyalc":"20.00","dsp":"true","prono":"1010","qty_shipped":10.00,"shipped_status":"","qtybo":"15.00"},{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"true","shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
       
        EDealerActiveOrderDetailASI_V1.fetchActiveOrderData('I080','EMGK847');
        Test.stopTest(); 
    }
    @isTest
    private static void EDealerActiveOrderDetailASITestMethod02(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}, {"customer": "I090", "paccer_order":"STZM108", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"true","bolno":"10","shipped_status":"INVOICED"},{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"true","bolno":"10","qtybo":"10.00","qty_shipped":10.00,"shipped_status":"INVOICED"},{"itmid":"11-03942-0500","line_status":"ALLOCATED","qtyalc":"20.00","dsp":"true","prono":"1010","qty_shipped":10.00,"shipped_status":"INVOICED","qtybo":"15.00"},{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"true","shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
      
        Test.startTest();
        //String UserId = UserInfo.getUserId();
        EDealerActiveOrderDetailASI_V1.ResponseWrapper resWrapp = EDealerActiveOrderDetailASI_V1.fetchActiveOrderData('I080','EMGK847');
        system.assertEquals('I080', resWrapp.activeOrder.response[0].customer);
        Test.stopTest();
    }
}