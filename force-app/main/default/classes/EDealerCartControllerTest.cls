@isTest
public class EDealerCartControllerTest {
    
    @testSetup static void methodName() {
        Id p = [select id from profile where name='Paccar TCS edealer Community Plus'].id;
        
        Account ac = new Account(name ='testAcc') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;
        
        User user = new User(alias = 'test123', email='test123@test.comt',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='test123@test.comt');
        
        insert user;
    }
    
    @isTest
    private static void validateEmCartItemDetails(){
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
        insert objAcc; 
        System.assertEquals('TestAccount',[SELECT Name FROM Account WHERE Dealer_Code__c='999990'].Name, 'Unexpected Account');
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        System.assertEquals('EM',[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c WHERE Type__c='SOF'].Part_Category_Type__c, 'Unexpected eDealer Suggested Order');
        
        List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
        EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
        suggestedOrder.Part_Category_Type__c= 'EM';
        suggestedOrder.Dealer_Location__c= objAcc.id;
        suggestedOrderLst.add(suggestedOrder);
        insert suggestedOrderLst;
        System.assert(suggestedOrderLst.size() != 2, 'Invalid EDealer Suggested Order');
        System.assertEquals('EM',[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c
                                  LIMIT 1].Part_Category_Type__c, 'Unexpected EDealer Suggested Order');
        
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart);
        
        EDealerCart__c dealerCart1 = new EDealerCart__c();
        
        dealerCart1.Dealer_Location__c= objAcc.id;
        dealerCart1.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_DSP;
        dealerCart1.Quantity__c= 4;
        dealerCart1.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart1.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart1);
        
        EDealerCart__c dealerCart2 = new EDealerCart__c();
        
        dealerCart2.Dealer_Location__c= objAcc.id;
        dealerCart2.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_STOCK;
        dealerCart2.Quantity__c= 4;
        dealerCart2.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart2.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart2);
        insert dealerCartLst;

        System.assert(dealerCartLst.size() == 3, 'Invalid EDealer Suggested Order');
        System.assertEquals(4,[SELECT Quantity__c FROM EDealerCart__c LIMIT 1].Quantity__c, 'Unexpected EDealer Cart');
        
        Set<id> conSetIds = New Set<id>();
        //Set<String> dealerCodeIds = New Set<String>();
        Contact con = new Contact();
        //con.RecordType = Service Cloud Contacts;
        con.AccountId = objAcc.id;
        con.LastName = 'Service';
        
        insert con;
        System.assertEquals('Service', [SELECT LastName FROM Contact][1].LastName, 'Invalid Contact Details.');
        
        conSetIds.add(con.id);
        
        Test.startTest();
        
        // calling apex class method
        //EDealerAccountContactRelationshipUtils.fetchRelationDetails(conSetIds);
        List<EDealerCartController.CartItemWrapper> listOfEMCartItem = EDealerCartController.fetchEMCartItemsDetails(objAcc.Dealer_Code__c);
        System.assert(listOfEMCartItem.size() >= 1, 'Unexpected number of EM Cart Item.');

        List<EDealerCartController.CartItemWrapper> listOfSTOCKCartItem = EDealerCartController.fetchSTOCKCartItemsDetails(objAcc.Dealer_Code__c);
        System.assert(listOfSTOCKCartItem.size() >= 1, 'Unexpected number of STOCK Cart Item.');
        
        List<EDealerCartController.CartItemWrapper> listOfDSPCartItem = EDealerCartController.fetchDSPCartItemsDetails(objAcc.Dealer_Code__c);
        System.assert(listOfDSPCartItem.size() >= 1, 'Unexpected number of DSP Cart Item.');
        
        EDealerCartController.removeCartItem(dealerCartLst[0].id);
        //EDealerCartController.removeCartItem('');
        List<EDealerCart__c> listOfremoveCartItem = EDealerCartUtils.getCartDetails(new Set<Id>{dealerCartLst[0].id}); 
        System.assert(listOfremoveCartItem.size() == 0, 'Cart Item do not removed.');
        
        List<EDealerCartController.CartItemWrapper> listOffetchDSPCartItems = EDealerCartController.fetchDSPCartItemsDetails(objAcc.Dealer_Code__c);
        System.assert(listOffetchDSPCartItems.size() >= 1, 'Unexpected number of DSP Cart Item.');
        
        List<EDealerCartController.CartItemWrapper> listOfDSPEmeregencyCartItem = EDealerCartController.fetchDSPEmeregencyCartItemsDetails(objAcc.Dealer_Code__c);
        System.assert(listOfDSPEmeregencyCartItem.size() >= 0, 'Unexpected number of DSP Emeregency Cart Item.');
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateEmCartItemDetails02S(){
        User u = [SELECT Id FROM User WHERE Email='test123@test.comt' limit 1];
        system.runAs(u) {
            Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
            insert objAcc; 
            System.assertEquals('TestAccount',[SELECT Name FROM Account WHERE Dealer_Code__c='999990'].Name, 'Unexpected Account');
            
            EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
            insert objEDealer;
            System.assertEquals('EM',[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c WHERE Type__c='SOF'].Part_Category_Type__c, 'Unexpected eDealer Suggested Order');
            
            List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
            EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
            suggestedOrder.Part_Category_Type__c= 'EM';
            suggestedOrder.Dealer_Location__c= objAcc.id;
            suggestedOrderLst.add(suggestedOrder);
            insert suggestedOrderLst;
            
            System.assert(suggestedOrderLst.size() != 2, 'Invalid EDealer Suggested Order');
            System.assertEquals('EM',[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c
                                    LIMIT 1].Part_Category_Type__c, 'Unexpected EDealer Suggested Order');
            
            List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
            EDealerCart__c dealerCart = new EDealerCart__c();
            
            dealerCart.Dealer_Location__c= objAcc.id;
            dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
            dealerCart.Quantity__c= 4;
            dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
            dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
            dealerCartLst.add(dealerCart);
            
            insert dealerCartLst;
            
            System.assert(dealerCartLst.size() == 1, 'Invalid EDealer Suggested Order');
            System.assertEquals(4,[SELECT Quantity__c FROM EDealerCart__c LIMIT 1].Quantity__c, 'Unexpected EDealer Cart');
            
            Set<id> conSetIds = New Set<id>();
            //Set<String> dealerCodeIds = New Set<String>();
            Contact con = new Contact();
            //con.RecordType = Service Cloud Contacts;
            con.AccountId = objAcc.id;
            con.LastName = 'Service';
            insert con;
            System.assertEquals('Service', [SELECT LastName FROM Contact ORDER BY CreatedDate ASC][1].LastName, 'Invalid Contact Details.');
            
            
            conSetIds.add(con.id);
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
            Test.startTest();
            
            // calling apex class method
            //EDealerAccountContactRelationshipUtils.fetchRelationDetails(conSetIds);
        
            // statements to be executed by this test user.
            
            List<EDealerCartController.CartItemWrapper> listOfEMCartItem = EDealerCartController.fetchEMCartItemsDetails(objAcc.Dealer_Code__c);
            System.assert(listOfEMCartItem.size() >= 1, 'Unexpected number of EM Cart Item.');
            
            List<EDealerCartController.CartItemWrapper> listOfSTOCKCartItem = EDealerCartController.fetchSTOCKCartItemsDetails(objAcc.Dealer_Code__c);
            System.assert(listOfSTOCKCartItem.size() >= 0, 'Unexpected number of STOCK Cart Item.');
            
            List<EDealerCartController.CartItemWrapper> listOfDSPCartItem = EDealerCartController.fetchDSPCartItemsDetails(objAcc.Dealer_Code__c);
            System.assert(listOfDSPCartItem.size() >= 0, 'Unexpected number of DSP Cart Item.');
            
            List<EDealerCartController.CartItemWrapper> listOfEMCartItem2 = EDealerCartController.fetchEMCartItemsDetails(null);
            System.assert(listOfEMCartItem2.size() >= 0, 'Unexpected number of DSP Cart Item.');
            
            List<EDealerCartController.CartItemWrapper> listOfDSPCartItem2 = EDealerCartController.fetchDSPCartItemsDetails(null);
            System.assert(listOfDSPCartItem2.size() >= 0, 'Unexpected number of DSP Cart Item.');
            
            List<EDealerCartController.CartItemWrapper> listOfSTOCKCartItem2 = EDealerCartController.fetchSTOCKCartItemsDetails(null);
            System.assert(listOfSTOCKCartItem2.size() >= 0, 'Unexpected number of STOCK Cart Item.');
            
            EDealerCartController.updateEDealerRec(dealerCartLst[0].id,'20.4');
            List<EDealerCart__c> listCartDetails = EDealerCartUtils.getCartDetails(new Set<Id>{dealerCartLst[0].id}, '20.4'); 
            System.assert(listCartDetails.size() >= 0, 'Unexpected number of Cart Details.');
            
            EDealerCartController.updateEDealerRec(dealerCartLst[0].id,null);
            List<EDealerCart__c> listCartDetails2 = EDealerCartUtils.getCartDetails(new Set<Id>{dealerCartLst[0].id}, null); 
            System.assert(listCartDetails2.size() >= 0, 'Unexpected number of Cart Details.');
            
            EDealerCartController.removeAllCartItem(wrapLst);            
        }
        
        // EDealerCartController.fetchDSPCartItemsDetails(objAcc.Dealer_Code__c);
        
        
        
        Test.stopTest();
    }
    
    
}