@isTest
public class EDealerHeaderControllerTest {
    
    @isTest
    private static void validateGetPartAvailable(){
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
        insert objAcc; 
        System.assertEquals('TestAccount',[SELECT Name FROM Account WHERE Dealer_Code__c='999990'].Name, 'Unexpected Account');
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c=EDealerConstants.SO_PART_CATEGORY_TYPE_EM,Type__c=EDealerConstants.SO_TYPE_SOF);
        insert objEDealer;
        System.assertEquals(EDealerConstants.SO_PART_CATEGORY_TYPE_EM,[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c LIMIT 1].Part_Category_Type__c, 'Unexpected eDealer Suggested Order');
        
        List<EDealer_Suggested_Order__c> suggestedOrderLst = new List<EDealer_Suggested_Order__c>();
        EDealer_Suggested_Order__c suggestedOrder = new EDealer_Suggested_Order__c();
        suggestedOrder.Part_Category_Type__c= EDealerConstants.SO_PART_CATEGORY_TYPE_EM;
        suggestedOrder.Dealer_Location__c= objAcc.id;
        suggestedOrderLst.add(suggestedOrder);
        insert suggestedOrderLst;
        System.assertEquals(EDealerConstants.SO_PART_CATEGORY_TYPE_EM,[SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c LIMIT 1].Part_Category_Type__c, 'Unexpected eDealer Suggested Order');
        
        List<EDealerCart__c> dealerCartLst = new List<EDealerCart__c>();
        EDealerCart__c dealerCart = new EDealerCart__c();
        
        dealerCart.Dealer_Location__c= objAcc.id;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_STOCK;
        dealerCart.Order_Type__c= EDealerConstants.CART_ORDER_TYPE_DSP;
        dealerCart.Quantity__c= 4;
        dealerCart.Suggested_Order__c= suggestedOrderLst[0].id;
        dealerCart.Type__c= EDealerConstants.CART_TYPE_CART;
        dealerCartLst.add(dealerCart);
        
        insert dealerCartLst;
        System.assertEquals(4,[SELECT Quantity__c FROM EDealerCart__c LIMIT 1].Quantity__c, 'Unexpected EDealer Cart');
        Test.startTest();
        
        // calling apex class method
        EDealerHeaderController.fetchCartItemsDetails('999990');
        EDealerHeaderController.fetchCartItemsDetails(null);
        Test.stopTest();
    }
    
}