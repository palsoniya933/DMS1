/*** 
 * Name        :   EDealerCartUtils
 *  Description :   This is a Utility class for Cart Object. (Bascally will used for Query cart data )
 */ 
public without sharing class EDealerCartUtils {
    
    /**
     * This method will pick the cart items to be displayed for all tabs for a specific dealer
     ***/
    public static List<EDealerCart__c> getCartDetails(Set<Id> cartIDs){
        List<EDealerCart__c> lstEDealerCarts;
        lstEDealerCarts = [SELECT Id, Name, Dealer_Location__c, Dealer_Location__r.Dealer_Code__c,
                           Order_Type__c, Quantity__c, Suggested_Order__c, Suggested_Order__r.Part_Name__c,
                           Suggested_Order__r.Part_Description__c, Suggested_Order__r.Part_Category_Type__c,
                           Suggested_Order__r.Serial_Number__c, Suggested_Order__r.Type__c,
                           Suggested_Order__r.DBS_Type__c, Suggested_Order__r.Is_Special_Order_Part__c,
                           Suggested_Order__r.Pricing_Detail__c, Type__c
                           FROM EDealerCart__c
                           WHERE Id IN :cartIDs];
        return lstEDealerCarts;
    }
    
    /**
     * This method will return the carts details for a specific type
     ***/
    public static List<EDealerCart__c> getCartDetails(Set<Id> cartIDs, String cartType){
        List<EDealerCart__c> lstEDealerCarts;
        if(Schema.sObjectType.EDealerCart__c.fields.Id.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isAccessible()
           && Schema.sObjectType.Account.fields.Dealer_Code__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Description__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Category_Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Serial_Number__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.DBS_Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Is_Special_Order_Part__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Pricing_Detail__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Type__c.isAccessible()
          ){
              lstEDealerCarts = [SELECT Id, Name, Dealer_Location__c, Dealer_Location__r.Dealer_Code__c, Order_Type__c,
                                 Quantity__c, Suggested_Order__c, Suggested_Order__r.Part_Name__c,
                                 Suggested_Order__r.Part_Description__c, Suggested_Order__r.Part_Category_Type__c,
                                 Suggested_Order__r.Serial_Number__c, Suggested_Order__r.Type__c,
                                 Suggested_Order__r.DBS_Type__c, Suggested_Order__r.Is_Special_Order_Part__c,
                                 Suggested_Order__r.Pricing_Detail__c, Type__c
                                 FROM EDealerCart__c
                                 WHERE Id IN :cartIDs AND Type__c = :cartType];
          }
        return lstEDealerCarts;
    }
    
     
    /**
     * This method will pick the cart items to be displayed for all tabs for a specific dealer
     ***/
    public static List<EDealerCart__c> getCartDetails(string dealerAccountId, set<string> orderTypes, set<string> cartTypes){
        List<EDealerCart__c> lstEDealerCarts;
        if(Schema.sObjectType.EDealerCart__c.fields.Id.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isAccessible()
           && Schema.sObjectType.Account.fields.Dealer_Code__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Description__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Category_Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Serial_Number__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.DBS_Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Is_Special_Order_Part__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Pricing_Detail__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Type__c.isAccessible()
          ){
              lstEDealerCarts = [SELECT Id, Name, Dealer_Location__c, Dealer_Location__r.Dealer_Code__c, Order_Type__c,
                                 Quantity__c, Suggested_Order__c, Suggested_Order__r.Part_Name__c,
                                 Suggested_Order__r.Part_Description__c, Suggested_Order__r.Part_Category_Type__c,
                                 Suggested_Order__r.Serial_Number__c, Suggested_Order__r.Type__c,
                                 Suggested_Order__r.DBS_Type__c, Suggested_Order__r.Is_Special_Order_Part__c,
                                 Suggested_Order__r.Pricing_Detail__c, Type__c
                                 FROM EDealerCart__c
                                 WHERE Dealer_Location__c = :dealerAccountId
                                 AND Type__c IN :cartTypes
                                 AND Order_Type__c IN :orderTypes];
          }
        
        return lstEDealerCarts;
    }
    
    
    /**
     * This method will used to get the cart items which created for suggested orders
     ***/
    public static List<EDealerCart__c> getCartDetails(Set<Id> soIDs, Set<String> orderTypes, String cartType){
        List<EDealerCart__c> lstEDealerCarts;
        if(Schema.sObjectType.EDealerCart__c.fields.Id.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Type__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Is_Special_Order_Part__c.isAccessible()
           && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Pricing_Detail__c.isAccessible()
           && Schema.sObjectType.EDealerCart__c.fields.Type__c.isAccessible()
          ){
              lstEDealerCarts = [SELECT Id, Name, Dealer_Location__c, Order_Type__c, Quantity__c, Suggested_Order__c,
                Suggested_Order__r.Part_Name__c, Suggested_Order__r.Type__c, Type__c,
                Suggested_Order__r.Is_Special_Order_Part__c, Suggested_Order__r.Pricing_Detail__c
                FROM EDealerCart__c
                WHERE Type__c =:cartType
                AND Order_Type__c IN :orderTypes
                AND Suggested_Order__c IN :soIDs];
          }
        
        return lstEDealerCarts;
    } 

}