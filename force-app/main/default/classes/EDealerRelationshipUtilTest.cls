@isTest
public class EDealerRelationshipUtilTest {
    
    @isTest
    private static void EDealerRelationshipUtilTestMethod(){
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
        insert objAcc; 
         Contact con = new Contact();
        con.AccountId = objAcc.id;
        con.LastName = 'Service';
        
        insert con;
     EDealerRelationshipUtil.getRelationships(con.id);  
     EDealerRelationshipUtil.getUserRelationships(USerInfo.getUserId());    
    }
}