@isTest
public with sharing class EDealerConfirmedListing_Test {

    // Mock HTTP Response class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private String mockResponse;
        private Integer statusCode;

        public MockHttpResponseGenerator(String mockResponse, Integer statusCode) {
            this.mockResponse = mockResponse;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(mockResponse);
            res.setStatusCode(statusCode);
            res.setHeader('Content-Type', 'application/json');
            return res;
        }
    }

    @isTest
    public static void testConfirmOrdersData_Success() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080', 'I086'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Day';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[{"cstno":"123","paccar_po":"PO123","cstsfx":"A","ordno":"ORD001",' +
            '"dealerpo":"DPO123","orderdate":"2026-02-04","ordertype":"CONFIRMED","orderstatus":"ACTIVE",' +
            '"ordersource":"EDEALER","createdby":"USER1","splitorder":"N"}],"error":null,"rowcount":1}';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(null, result.response, 'Response list should not be null');
        System.assertEquals(1, result.response.size(), 'Should have 1 order');
        System.assertEquals('123', result.response[0].cstno, 'CST number should match');
        System.assertEquals('PO123', result.response[0].paccar_po, 'PACCAR PO should match');
        System.assertEquals(1, result.rowcount, 'Row count should be 1');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Week() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'PENDING';
        String timeFrame = 'Week';
        Integer offset = 0;
        Integer limit = 20;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.rowcount, 'Row count should be 0');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Monthly() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080', 'I086'};
        String orderType = 'ACTIVE';
        String timeFrame = 'Month';
        Integer offset = 0;
        Integer limit = 50;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Quarterly() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Quarter';
        Integer offset = 10;
        Integer limit = 25;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Annually() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080', 'I086', 'I090'};
        String orderType = 'PENDING';
        String timeFrame = 'Year';
        Integer offset = 0;
        Integer limit = 100;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_All() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'ALL';
        String timeFrame = 'All';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Weekly() {
        // Arrange - testing "Weekly" variant
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Weekly';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Monthly_Variant() {
        // Arrange - testing "Monthly" variant
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Monthly';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Quarterly_Variant() {
        // Arrange - testing "Quarterly" variant
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Quarterly';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_TimeFrame_Annually_Variant() {
        // Arrange - testing "Annually" variant
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Annually';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testConfirmOrdersData_MultipleOrders() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080', 'I086'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Day';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":[' +
            '{"cstno":"123","paccar_po":"PO123","cstsfx":"A","ordno":"ORD001","dealerpo":"DPO123","orderdate":"2026-02-04","ordertype":"CONFIRMED","orderstatus":"ACTIVE","ordersource":"EDEALER","createdby":"USER1","splitorder":"N"},' +
            '{"cstno":"124","paccar_po":"PO124","cstsfx":"B","ordno":"ORD002","dealerpo":"DPO124","orderdate":"2026-02-03","ordertype":"CONFIRMED","orderstatus":"SHIPPED","ordersource":"EDEALER","createdby":"USER2","splitorder":"Y"}' +
            '],"error":null,"rowcount":2}';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        // Assert
        System.assertEquals(2, result.response.size(), 'Should have 2 orders');
        System.assertEquals('ORD001', result.response[0].ordno, 'First order number should match');
        System.assertEquals('ORD002', result.response[1].ordno, 'Second order number should match');
        System.assertEquals('Y', result.response[1].splitorder, 'Split order flag should match');
    }

    @isTest
    public static void testConfirmOrdersData_WithError() {
        // Arrange
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Day';
        Integer offset = 0;
        Integer limit = 10;

        String mockResponse = '{"response":null,"error":"Invalid dealer code","rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 400));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('Invalid dealer code', result.error, 'Error message should match');
    }

    @isTest
    public static void testConfirmOrdersData_WithPagination() {
        // Arrange - test pagination with offset and limit
        List<String> dealerCodes = new List<String>{'I080'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Day';
        Integer offset = 50;
        Integer limit = 25;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    public static void testMasterActiveOrderWrapperFields() {
        // Arrange
        EDealerConfirmedListing.MasterActiveOrderWrapper order = new EDealerConfirmedListing.MasterActiveOrderWrapper();

        Test.startTest();
        // Set fields
        order.cstno = '123';
        order.paccar_po = 'PO123';
        order.cstsfx = 'A';
        order.ordno = 'ORD001';
        order.dealerpo = 'DPO123';
        order.orderdate = '2026-02-04';
        order.ordertype = 'CONFIRMED';
        order.orderstatus = 'ACTIVE';
        order.ordersource = 'EDEALER';
        order.createdby = 'USER1';
        order.splitorder = 'N';
        Test.stopTest();

        // Assert
        System.assertEquals('123', order.cstno, 'CST number should match');
        System.assertEquals('PO123', order.paccar_po, 'PACCAR PO should match');
        System.assertEquals('A', order.cstsfx, 'CST suffix should match');
        System.assertEquals('ORD001', order.ordno, 'Order number should match');
        System.assertEquals('DPO123', order.dealerpo, 'Dealer PO should match');
        System.assertEquals('2026-02-04', order.orderdate, 'Order date should match');
        System.assertEquals('CONFIRMED', order.ordertype, 'Order type should match');
        System.assertEquals('ACTIVE', order.orderstatus, 'Order status should match');
        System.assertEquals('EDEALER', order.ordersource, 'Order source should match');
        System.assertEquals('USER1', order.createdby, 'Created by should match');
        System.assertEquals('N', order.splitorder, 'Split order flag should match');
    }

    @isTest
    public static void testResponseWrapperFields() {
        // Arrange
        EDealerConfirmedListing.ResponseWrapper wrapper = new EDealerConfirmedListing.ResponseWrapper();

        Test.startTest();
        // Set fields
        wrapper.response = new List<EDealerConfirmedListing.MasterActiveOrderWrapper>();
        wrapper.error = null;
        wrapper.rowcount = 5;
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, wrapper.response, 'Response should not be null');
        System.assertEquals(null, wrapper.error, 'Error should be null');
        System.assertEquals(5, wrapper.rowcount, 'Row count should be 5');
    }

    @isTest
    public static void testConfirmOrdersData_LargeDataSet() {
        // Arrange - test with large dataset
        List<String> dealerCodes = new List<String>{'I080', 'I086', 'I090', 'I095'};
        String orderType = 'CONFIRMED';
        String timeFrame = 'Day';
        Integer offset = 0;
        Integer limit = 1000;

        String mockResponse = '{"response":[],"error":null,"rowcount":0}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        Test.startTest();
        EDealerConfirmedListing.ResponseWrapper result = EDealerConfirmedListing.confirmOrdersData(
            dealerCodes, orderType, timeFrame, offset, limit
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }
}