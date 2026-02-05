@isTest
public class eDealerToggleTest {
    
    @testSetup
    private static void testSetup() {
        Id prof = [SELECT Id FROM Profile where Name = 'Paccar TCS edealer Community Plus'].Id;
        
        Account account = new Account(Name='TestAccount', Dealer_Code__c='999990' ,Dealer_Group_Name__c='subz' ,Group_Code__c='C111');
        insert account; 
        
        Contact contact = new Contact(LastName ='testCon' ,AccountId = account.Id);
        insert contact;
        User user = new User(alias = 'test123', email ='test123@noemail.com',
                             emailencodingkey = 'UTF-8', LastName = 'Testing',
                             Languagelocalekey='en_US', localesidkey='en_US',
                             ProfileId = prof, country='United States',
                             IsActive = true, ContactId = contact.Id,Pass_Group_Permissions__c = 'General Plus',
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;  
    }
    
    @isTest
    static void testCsrToggle() {
        Test.startTest();
        Boolean result2 = eDealerToggle.csrToggle();
        Boolean result3 = eDealerToggle.pricingToggle();
        Boolean result4 = eDealerToggle.tcs365Toggle();
        Test.stopTest();
        Assert.isNotNull(result2);
        Assert.isNotNull(result3);
        Assert.isNotNull(result4);
    }
    
    @isTest
    static void testIsLoyaltyMenuVisible(){
        Test.startTest();
        Boolean result2;
        result2 = eDealerToggle.isLoyaltyMenuVisible();
        Test.stopTest();
        Assert.isNotNull(result2); 
    }
    
    @isTest
    static void testPricingToggle(){
            Test.startTest();
            Boolean result2 = eDealerToggle.pricingToggle();
            Test.stopTest();
            Assert.isNotNull(result2); 
    }
    
    @isTest
    static void testIsRPMScoreCardMenuVisible(){
        try{
            Test.startTest();
            Boolean result2 = eDealerToggle.isRPMScoreCardMenuVisible();
            Test.stopTest();
            Assert.isNotNull(result2); 
        }
        catch(Exception err){
            System.debug(err.getMessage());
        }
    }
}