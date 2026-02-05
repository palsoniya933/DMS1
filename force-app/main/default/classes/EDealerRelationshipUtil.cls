public with sharing class EDealerRelationshipUtil {
    
    Public static List<EDealer_Relationship__c> getRelationships(Id contactId){
        List<EDealer_Relationship__c> lstRelationships = new List<EDealer_Relationship__c>();
        
        if( Schema.sObjectType.EDealer_Relationship__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Contact__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.ASI_Dealer_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Sub_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Customer_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Download_Of_Reports__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Orders__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Rma__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Availability_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Control_Of_Doests__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Doe_Status__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Interactive_Order_Entry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Order_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Price_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Return_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.User__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Division__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Currency_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Group__c.isAccessible()
          ){
              lstRelationships = [SELECT Id, Name, Contact__c, ASI_Dealer_Code__c, Sub_Code__c, Customer_Name__c,
                Allow_Download_Of_Reports__c, Allow_Upload_Of_Orders__c, Allow_Upload_Of_Rma__c,
                Availability_Inquiry__c, Dealer_Control_Of_Doests__c, Dealer_Doe_Status__c,
                Interactive_Order_Entry__c, Order_Inquiry__c, Price_Inquiry__c, Return_Inquiry__c,
                User__c, Division__c, Currency_Code__c,country__c,Dealer_Group__c
                FROM EDealer_Relationship__c
                WHERE Contact__c = :contactId Order By ASI_Dealer_Code__c];
          }
        return lstRelationships;
    }
    
    Public static List<EDealer_Relationship__c> getUserRelationships(Id userId){
        system.debug('----userId--' + userId);
        
        List<EDealer_Relationship__c> lstRelationships = new List<EDealer_Relationship__c>();
        if(Schema.sObjectType.EDealer_Relationship__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Contact__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.ASI_Dealer_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Sub_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Customer_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Download_Of_Reports__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Orders__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Rma__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Availability_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Control_Of_Doests__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Doe_Status__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Interactive_Order_Entry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Order_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Price_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Return_Inquiry__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.User__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Division__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Currency_Code__c.isAccessible()
           && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Group__c.isAccessible()
          ){ 
              lstRelationships = [SELECT Id, Name, Contact__c, ASI_Dealer_Code__c, Sub_Code__c, Customer_Name__c,
                Allow_Download_Of_Reports__c, Allow_Upload_Of_Orders__c, Allow_Upload_Of_Rma__c,
                Availability_Inquiry__c, Dealer_Control_Of_Doests__c, Dealer_Doe_Status__c,
                Interactive_Order_Entry__c, Order_Inquiry__c, Price_Inquiry__c,
                Return_Inquiry__c, User__c, Division__c, Currency_Code__c,country__c,Dealer_Group__c
                FROM EDealer_Relationship__c
                WHERE User__c = :userId Order By ASI_Dealer_Code__c];
          }
        return lstRelationships;
    }

}