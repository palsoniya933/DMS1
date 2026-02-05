@isTest
public class EDealerCartUtilsTest {
    
    @isTest
    private static void testGetCartDetails()
    {
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
        insert objAcc; 
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        
        EDealerCart__c objCart=new EDealerCart__c(Dealer_Location__c=objAcc.Id,Order_Type__c='Stock Order',Quantity__c=1,Suggested_Order__c=objEDealer.Id,Type__c='In Cart');
        insert objCart;  
        
        Set<String> cartTypes=new Set<String>();
        cartTypes.add(objCart.Type__c);
        set<string> orderTypes=new set<string>();
        orderTypes.add(objCart.Order_Type__c);
        Set<Id> soIDs=new  Set<Id>();
        soIDs.add(objCart.Suggested_Order__r.Id);
        Set<Id> cartIDs=new Set<Id>(); 
        cartIDs.add(objCart.Id);
        string dealerAccountId=String.valueOf(objAcc.Id);
        List<EDealerCart__c> lstEDealerCarts = EDealerCartUtils.getCartDetails(dealerAccountId, orderTypes, cartTypes);
        
        System.assert(lstEDealerCarts.size()>0,'list EDealer Cart Detail size should be greater than zero.');
        System.assertNotEquals(null,lstEDealerCarts[0].Name,'Name Should not be null.');
        
        List<EDealerCart__c> lstEDealerCarts1 = EDealerCartUtils.getCartDetails(soIDs, orderTypes,EDealerConstants.CART_TYPE_CART);
        System.assert(lstEDealerCarts1.size()==0,'list EDealer Cart Detail size should be zero.');
        
        List<EDealerCart__c> lstEDealerCarts2 = EDealerCartUtils.getCartDetails(cartIDs);
        System.assert(lstEDealerCarts2.size()>0,'list EDealer Cart Detail size should be greater than zero.');

        List<EDealerCart__c> lstEDealerCarts3 = EDealerCartUtils.getCartDetails(cartIDs, EDealerConstants.CART_TYPE_CART);
        System.assert(lstEDealerCarts3.size()>0,'list EDealer Cart Detail size should be greater than zero.');

    }   
}