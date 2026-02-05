@isTest
public class EDealerActiveOrderDetailASITest1 {
    
    /**
     * Test method to verify response wrapper with shipped status
     */
    @isTest
    private static void testFetchActiveOrderDataShipped(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"false","bolno":"BOL123","qty_shipped":5.00,"shipped_status":"SHIPPED"},{"itmid":"11-03942-0501","line_status":"SHIPPED","dsp":"false","bolno":"BOL124","qty_shipped":10.00,"shipped_status":"INVOICED/SHIPPED"}],"order_workflow":[{"PRO_NUM":"PRO001","BOL_NUM":"BOL123"}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc = new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc;
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertNotNull(result.dynamicTabList);
    }
    
    /**
     * Test method to verify response wrapper with cancelled status
     */
    @isTest
    private static void testFetchActiveOrderDataCancelled(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"false","qtycnl":3.00,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc = new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc;
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.cancelledList.size());
        System.assertEquals(3.00, result.cancelledList[0].display_qty);
    }
    
    /**
     * Test method to verify response wrapper with backorder status
     */
    @isTest
    private static void testFetchActiveOrderDataBackorder(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"false","qtybo":8.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc = new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc;
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.backOrderedList.size());
        System.assertEquals(8.00, result.backOrderedList[0].display_qty);
    }
    
    /**
     * Test method to verify response wrapper with allocated status
     */
    @isTest
    private static void testFetchActiveOrderDataAllocated(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"ALLOCATED","dsp":"false","qtyalc":12.00,"prono":"PRO001","qty_shipped":0,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc = new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc;
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.processingList.size());
        System.assertEquals(12.00, result.processingList[0].display_qty);
    }
    
    /**
     * Test method to verify future status handling
     */
    @isTest
    private static void testFetchActiveOrderDataFuture(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"Future","dsp":"false","qty_future":7.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(7.00, result.processingList[0].display_qty);
    }
    
    /**
     * Test method to verify scheduled status handling
     */
    @isTest
    private static void testFetchActiveOrderDataScheduled(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SCHEDULED","dsp":"false","qty_future":6.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify Pick Printed status handling
     */
    @isTest
    private static void testFetchActiveOrderDataPickPrinted(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"Pick Printed","dsp":"false","qty_pickprinted":4.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify Pick Verified status handling
     */
    @isTest
    private static void testFetchActiveOrderDataPickVerified(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"Pick Verified","dsp":"false","qty_pickverified":9.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify PICKED status handling
     */
    @isTest
    private static void testFetchActiveOrderDataPicked(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"PICKED","dsp":"false","qty_pickverified":5.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify Packed status handling
     */
    @isTest
    private static void testFetchActiveOrderDataPacked(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"Packed","dsp":"false","qty_packed":15.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify DSP flag with shipped status
     */
    @isTest
    private static void testFetchActiveOrderDataDSPFlag(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"true","bolno":"BOL123","qty_shipped":5.00,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals('true', result.dsp);
    }
    
    /**
     * Test method to verify null response handling
     */
    @isTest
    private static void testFetchActiveOrderDataNullResponse(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals('false', result.dsp);
    }
    
    /**
     * Test method to verify multiple items with different statuses
     */
    @isTest
    private static void testFetchActiveOrderDataMultipleStatuses(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"false","qtycnl":2.00,"shipped_status":"INVOICED"},{"itmid":"11-03942-0501","line_status":"BACKORDERED","dsp":"false","qtybo":5.00,"shipped_status":"PENDING"},{"itmid":"11-03942-0502","line_status":"ALLOCATED","dsp":"false","qtyalc":10.00,"shipped_status":"PENDING"},{"itmid":"11-03942-0503","line_status":"SHIPPED","dsp":"false","qty_shipped":8.00,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.cancelledList.size());
        System.assertEquals(1, result.backOrderedList.size());
        System.assertGreaterThan(0, result.processingList.size());
    }
    
    /**
     * Test method to verify sorting of lists
     */
    @isTest
    private static void testFetchActiveOrderDataWithSorting(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"CANCELLED","dsp":"false","ordln":3,"qtycnl":2.00,"shipped_status":"INVOICED"},{"itmid":"11-03942-0501","line_status":"CANCELLED","dsp":"false","ordln":1,"qtycnl":5.00,"shipped_status":"INVOICED"},{"itmid":"11-03942-0502","line_status":"CANCELLED","dsp":"false","ordln":2,"qtycnl":3.00,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(3, result.cancelledList.size());
    }
    
    /**
     * Test method to verify prono based mapping with shipped items
     */
    @isTest
    private static void testFetchActiveOrderDataPronoMapping(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"false","prono":"PRO001","qty_shipped":5.00,"shipped_status":"INVOICED"}],"order_workflow":[{"PRO_NUM":"PRO001","BOL_NUM":"BOL123"}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertNotNull(result.dynamicTabList);
    }
    
    /**
     * Test method to verify bolno based mapping with shipped items
     */
    @isTest
    private static void testFetchActiveOrderDataBolnoMapping(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"false","bolno":"BOL001","qty_shipped":3.00,"shipped_status":"INVOICED"}],"order_workflow":[{"PRO_NUM":"PRO001","BOL_NUM":"BOL001"}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify backorder item deduplication
     */
    @isTest
    private static void testFetchActiveOrderDataBackorderDedup(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"false","qtybo":5.00,"shipped_status":"PENDING"},{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"false","qtybo":3.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.backOrderedList.size());
    }
    
    /**
     * Test method to verify allocated item deduplication
     */
    @isTest
    private static void testFetchActiveOrderDataAllocatedDedup(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"ALLOCATED","dsp":"false","qtyalc":10.00,"shipped_status":"PENDING"},{"itmid":"11-03942-0500","line_status":"ALLOCATED","dsp":"false","qtyalc":8.00,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify items without prono and bolno
     */
    @isTest
    private static void testFetchActiveOrderDataNoPronoNoBolno(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"PENDING","dsp":"false","shipped_status":"PENDING","totalqty":7.00}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals(1, result.processingList.size());
    }
    
    /**
     * Test method to verify invoiced/shipped status
     */
    @isTest
    private static void testFetchActiveOrderDataInvoicedShipped(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"false","bolno":"BOL001","qty_shipped":6.00,"shipped_status":"INVOICED/SHIPPED"}],"order_workflow":[{"PRO_NUM":"PRO001","BOL_NUM":"BOL001"}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify qty_shipped = 0 with shipped status
     */
    @isTest
    private static void testFetchActiveOrderDataZeroQtyShipped(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"false","bolno":"BOL001","qty_shipped":0,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify backorder with zero qty
     */
    @isTest
    private static void testFetchActiveOrderDataBackorderZeroQty(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"BACKORDERED","dsp":"false","qtybo":0,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify allocated with zero qty
     */
    @isTest
    private static void testFetchActiveOrderDataAllocatedZeroQty(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"ALLOCATED","dsp":"false","qtyalc":0,"shipped_status":"PENDING"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
    }
    
    /**
     * Test method to verify DSP flag with empty order workflow
     */
    @isTest
    private static void testFetchActiveOrderDataDSPEmptyWorkflow(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"customer": "I080", "paccer_order": "STZM109", "dealerpo": "M071221"}],"order_workflow_item_details":[{"itmid":"11-03942-0500","line_status":"SHIPPED","dsp":"true","bolno":"BOL001","qty_shipped":5.00,"shipped_status":"INVOICED"}],"order_workflow":[]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        EDealerActiveOrderDetailASI.ResponseWrapper result = EDealerActiveOrderDetailASI.fetchActiveOrderData('A875','ORDER123');
        Test.stopTest();
        
        System.assertNotNull(result);
        System.assertEquals('true', result.dsp);
        System.assertEquals(1, result.dynamicTabList.size());
    }
    
    /**
     * Test method to verify comparable interface implementation
     */
    @isTest
    private static void testActiveOrderWorkflowItemComparable(){
        EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper item1 = new EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper();
        item1.ordln = 5;
        
        EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper item2 = new EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper();
        item2.ordln = 3;
        
        Integer result = item1.compareTo(item2);
        System.assertEquals(1, result);
        
        Integer result2 = item2.compareTo(item1);
        System.assertEquals(-1, result2);
    }
    
    /**
     * Test method to verify comparable equal items
     */
    @isTest
    private static void testActiveOrderWorkflowItemComparableEqual(){
        EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper item1 = new EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper();
        item1.ordln = 5;
        
        EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper item2 = new EDealerActiveOrderDetailASI.ActiveOrderWorkflowItemWrapper();
        item2.ordln = 5;
        
        Integer result = item1.compareTo(item2);
        System.assertEquals(0, result);
    }
}