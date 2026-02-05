@isTest
public class EDealerPlaceOrderControllerTest {
    @isTest
    private static void EDealerPlaceOrderControllerTestMethod(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK'); 
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"Data":{"OrderNumber":"STXM573","DealerID":"I080","Status":"1","OrderPartDetails":[{"ItemID":"1822166PE","PartQuantity":26.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1856834PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1858464PE","PartQuantity":3.0,"LineStatus":"1","CustomerSKU":""},{"ItemID":"1876833PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1905547PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""}]},"MsgResponse":{"IsSuccess":"","MessagesCount":0,"Messages":[]}}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc; 
        System.assert(objAcc!=null,'Account is Empty' );
        System.assertEquals('TestAccount',[SELECT Name FROM Account LIMIT 1].Name, 'Expected Account Name: TestAccount but Get'+[SELECT Name FROM Account LIMIT 1].Name);
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        System.assert(objEDealer!=null,'EDealer Suggested Order is Empty');
        System.assertEquals('EM', objEDealer.Part_Category_Type__c, 'Expected Part Category Type: TestAccount but Get'+objEDealer.Part_Category_Type__c);
        
        List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
        EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
        suggestedOrder.Part_Category_Type__c= 'EM';
        suggestedOrder.Dealer_Location__c= objAcc.id;
        suggestedOrderLst.add(suggestedOrder);
        insert suggestedOrderLst;
        System.assert(suggestedOrderLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, suggestedOrderLst.size(), 'EDealer Suggested Order is Empty');
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart);
        
        insert dealerCartLst;
        System.assert(dealerCartLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, dealerCartLst.size(), 'EDealer Suggested Order is Empty');
        
        List<EDealerCartController.CartItemWrapper> wrapLst = new List<EDealerCartController.CartItemWrapper>();
        EDealerCartController.CartItemWrapper wrap = new EDealerCartController.CartItemWrapper();
        wrap.cartId= dealerCartLst[0].id;
        wrap.suggestedOrderId= dealerCartLst[0].id;
        wrap.Serial_Number=1234;
        wrap.Part_Name='Testpart';
        wrap.Part_Description='Description Test';
        wrap.qtyForOrder= 3;
        wrap.source=EDealerConstants.CART_TYPE_CART;
        wrapLst.add(wrap);
        System.assert(wrapLst!=null, 'EDealer Place Order  is Empty');
        System.assertEquals(1, wrapLst.size(), 'EDealer Place Order  is Empty');
        Test.startTest();
        EDealerPlaceOrderController.PlaceOrderNumberWrapper obj=EDealerPlaceOrderController.fetchPlaceOrderNumber('A875');   
        System.assert(obj!=null, 'EDealer Place Order  is Empty');
        
        Test.stopTest();
    }
    @isTest
    private static void EDealerPlaceOrderControllerTestMethod02(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"OrderUpdateStatus":{"result":"success","message":"Purchase Order Updated","acceptedPartsNumbers":["1822166PE","1856834PE","1858464PE","1876833PE","1905547PE"],"nonacceptedPartsNumbers":[],"recordCount":"5"}}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc; 
        System.assertEquals('TestAccount',[SELECT Name FROM Account LIMIT 1].Name, 'Expected Account Name: TestAccount but Get'+[SELECT Name FROM Account LIMIT 1].Name);
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        System.assert(objEDealer!=null,'EDealer Suggested Order is Empty');
        System.assertEquals('EM', objEDealer.Part_Category_Type__c, 'Expected Part Category Type: TestAccount but Get'+objEDealer.Part_Category_Type__c);
        
        List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
        EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
        suggestedOrder.Part_Category_Type__c= 'EM';
        suggestedOrder.Dealer_Location__c= objAcc.id;
        suggestedOrder.Part_Name__c = 'AF27958FLG';
        suggestedOrderLst.add(suggestedOrder);
        insert suggestedOrderLst;
        System.assert(suggestedOrderLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, suggestedOrderLst.size(), 'EDealer Suggested Order is Empty');
        
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_PLACED;
        dealerCartLst.add(dealerCart);
        
        insert dealerCartLst;
        System.assert(dealerCartLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, dealerCartLst.size(), 'EDealer Suggested Order is Empty');
        
        List<EDealerCartController.CartItemWrapper> wrapLst = new List<EDealerCartController.CartItemWrapper>();
        EDealerCartController.CartItemWrapper wrap = new EDealerCartController.CartItemWrapper();
        wrap.cartId= dealerCartLst[0].Id;
        wrap.suggestedOrderId= dealerCartLst[0].id;
        wrap.Serial_Number=1234;
        wrap.Part_Name='Testpart';
        wrap.Part_Description='Description Test';
        wrap.qtyForOrder= 3;
        wrap.source=EDealerConstants.CART_TYPE_PLACED;
        wrapLst.add(wrap);
        
        Test.startTest();
        EDealerPlaceOrderController.OrderUpdateWrapper obj=EDealerPlaceOrderController.updatePurchaseOrderDetailsOnDSI('A875','AF27958FLG',wrapLst);
        System.assert(obj!=null, 'EDealer Place Order  is Empty');
        
        Test.stopTest();
    }
    
    @isTest
    private static void placeOrderWrapper(){
        
        EDealerPlaceOrderController.OrderUpdateStatusWrapper objOrderUpdateStatusWrapper = new EDealerPlaceOrderController.OrderUpdateStatusWrapper();
        objOrderUpdateStatusWrapper.result='A875';
        objOrderUpdateStatusWrapper.message='test';
        objOrderUpdateStatusWrapper.errorMessage='test';
        objOrderUpdateStatusWrapper.recordCount='test';
        
        
        EDealerPlaceOrderController.OrderUpdateWrapper objOrderUpdateWrapper= new EDealerPlaceOrderController.OrderUpdateWrapper();
        objOrderUpdateWrapper.OrderUpdateStatus= objOrderUpdateStatusWrapper;
        objOrderUpdateWrapper.error='unknown error';
        
        
        list<EDealerPlaceOrderController.OrderMessageWrapper> lstOrderMessageWrapper = new list<EDealerPlaceOrderController.OrderMessageWrapper>();
        EDealerPlaceOrderController.OrderMessageWrapper objOrderMessageWrapper =new EDealerPlaceOrderController.OrderMessageWrapper();
        objOrderMessageWrapper.MsgIdentifier='';
        objOrderMessageWrapper.MsgLine=10;
        objOrderMessageWrapper.MsgItmid='';
        objOrderMessageWrapper.Description='';
        lstOrderMessageWrapper.add(objOrderMessageWrapper);
        
        EDealerPlaceOrderController.MsgResponseWrapper objMsgResponseWrapper =new EDealerPlaceOrderController.MsgResponseWrapper();
        objMsgResponseWrapper.IsSuccess='';
        objMsgResponseWrapper.Messages=lstOrderMessageWrapper;
        objMsgResponseWrapper.MessagesCount=10;
        
        EDealerPlaceOrderController.PlaceOrderNumberWrapper objPlaceOrderNumberWrapper = new EDealerPlaceOrderController.PlaceOrderNumberWrapper();
        objPlaceOrderNumberWrapper.error='unknown error';
        objPlaceOrderNumberWrapper.purchaseOrderNumber='123';
        
        
        list<EDealerPlaceOrderController.OrderPartDetailWrapper> lstOrderPartDetailWrapper = new list<EDealerPlaceOrderController.OrderPartDetailWrapper>();
        EDealerPlaceOrderController.OrderPartDetailWrapper objOrderPartDetailWrapper =new EDealerPlaceOrderController.OrderPartDetailWrapper();
        objOrderPartDetailWrapper.ItemID='';
        objOrderPartDetailWrapper.PartQuantity=10;
        objOrderPartDetailWrapper.LineStatus='pass';        
        lstOrderPartDetailWrapper.add(objOrderPartDetailWrapper);
        
        EDealerPlaceOrderController.OrderDetailWrapper objOrderDetailWrapper= new EDealerPlaceOrderController.OrderDetailWrapper();
        objOrderDetailWrapper.OrderNumber= '';
        objOrderDetailWrapper.DealerID='';
        objOrderDetailWrapper.Status='';
        objOrderDetailWrapper.OrderPartDetails=lstOrderPartDetailWrapper;
        System.assert(objOrderDetailWrapper != null, 'Wrapper should not be null.');
    }
    @isTest
    private static void EDealerPlaceOrderControllerTestMethod1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK'); 
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"Data":{"OrderNumber":"STXM573","DealerID":"I080","Status":"1","OrderPartDetails":[{"ItemID":"1822166PE","PartQuantity":26.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1856834PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1858464PE","PartQuantity":3.0,"LineStatus":"1","CustomerSKU":""},{"ItemID":"1876833PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""},{"ItemID":"1905547PE","PartQuantity":1.0,"LineStatus":"2","CustomerSKU":""}]},"MsgResponse":{"IsSuccess":"","MessagesCount":0,"Messages":[]}}');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='A875');
        insert objAcc; 
        System.assertEquals('TestAccount',[SELECT Name FROM Account LIMIT 1].Name, 'Expected Account Name: TestAccount but Get'+[SELECT Name FROM Account LIMIT 1].Name);
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        System.assert(objEDealer!=null,'EDealer Suggested Order is Empty');
        System.assertEquals('EM', objEDealer.Part_Category_Type__c, 'Expected Part Category Type: TestAccount but Get'+objEDealer.Part_Category_Type__c);
        
        List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
        EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
        suggestedOrder.Part_Category_Type__c= 'EM';
        suggestedOrder.Dealer_Location__c= objAcc.id;
        suggestedOrder.Is_Special_Order_Part__c = true;
        suggestedOrder.Part_Name__c = '1822166PE';
        suggestedOrderLst.add(suggestedOrder);
        
        insert suggestedOrderLst;
        System.assert(suggestedOrderLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, suggestedOrderLst.size(), 'EDealer Suggested Order is Empty');
        
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart);
        
        insert dealerCartLst;
        System.assert(dealerCartLst!=null, 'EDealer Suggested Order is Empty');
        System.assertEquals(1, dealerCartLst.size(), 'EDealer Suggested Order is Empty');
        
        List<EDealerCartController.CartItemWrapper> wrapLst = new List<EDealerCartController.CartItemWrapper>();
        EDealerCartController.CartItemWrapper wrap = new EDealerCartController.CartItemWrapper();
        wrap.cartId= dealerCartLst[0].id;
        wrap.suggestedOrderId= dealerCartLst[0].id;
        wrap.Serial_Number=1234;
        wrap.Part_Name='1822166PE';
        wrap.Part_Description='Description Test';
        wrap.qtyForOrder= 3;
        wrap.source=EDealerConstants.CART_TYPE_CART;
        wrapLst.add(wrap);
        
        Test.startTest();
        EDealerPlaceOrderController.ConfirmedOrderNumberWrapper obj=EDealerPlaceOrderController.placeOrderToASI('A875','Emergency Order','201001','abc',System.today(),'comments',wrapLst);
        System.assert(obj!=null, 'EDealer Place Order  is Empty');
        Test.stopTest();
    }
}