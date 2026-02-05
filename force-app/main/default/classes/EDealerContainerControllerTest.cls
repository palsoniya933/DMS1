@isTest
public class EDealerContainerControllerTest {
    
    @testSetup
    private static void testSetup() {
        Id profCommunity = [SELECT Id FROM Profile where Name = 'Paccar TCS edealer Community Plus'].Id;
        Id profAdministrator = [SELECT Id FROM Profile where Name = 'System Administrator'].Id;
        Account account = new Account(Name='TestAccount', Dealer_Code__c='999990' ,Dealer_Group_Name__c='subz' ,Group_Code__c='C111');
        insert account; 
        
        Contact contact = new Contact(LastName ='testCon' ,AccountId = account.Id);
        insert contact;
        List<User> users = New List<User>{new User(alias = 'test123', email ='test123@noemail.com',
                                                   emailencodingkey = 'UTF-8', LastName = 'Testing',
                                                   Languagelocalekey='en_US', localesidkey='en_US',
                                                   ProfileId = profCommunity, country='United States',
                                                   IsActive = true, ContactId = contact.Id,Pass_Group_Permissions__c = 'Field Service',
                                                   timezonesidkey='America/Los_Angeles', username='tester@noemail.com'),
            new User(alias = 'test23', email ='internaltest1223@noemail.com',
                     emailencodingkey = 'UTF-8', LastName = 'Testing',
                     Languagelocalekey='en_US', localesidkey='en_US',
                     ProfileId = profAdministrator, country='United States',
                     IsActive = true, 
                     timezonesidkey='America/Los_Angeles', username='testerInternal@noemail.com')};
                         insert users;
    }
    
    @isTest
    private static void testFetchLoggedInUserDetails(){
        Contact contact = new Contact();
        contact.LastName='Test';
        insert contact;
        
        EDealer_Relationship__c objRel = new EDealer_Relationship__c();
        objRel.Contact__c = contact.Id;
        objRel.Currency_Code__c = 'USD';
        insert objRel;
        User user1 = [SELECT Id, Name, ContactId, AccountId FROM User WHERE Email ='test123@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(user1) {
            EDealerContainerController.getAccessibleDealerLocs(contact.Id, true);
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testWrapperData() {
        User user1 = [SELECT Id, Name, ContactId, AccountId FROM User WHERE Email ='test123@noemail.com' LIMIT 1];
        
        EDealer_Relationship__c objRel = new EDealer_Relationship__c();
        objRel.Contact__c = user1.ContactId;
        objRel.Currency_Code__c = 'USD';
        objRel.ASI_Dealer_Code__c = 'testing';
        insert objRel;
        
        Test.startTest();
        system.runAs(user1) {
            
            EDealerContainerController.getAccessibleDealerLocs(user1.ContactId, false);
            User u = EDealerUserUtils.fetchLoggedInUserdetails();
            List<eDealer_Config__mdt> currencyMappingMdt= [SELECT Id, Long_Value__c FROM eDealer_Config__mdt WHERE DeveloperName ='Currency_Code_Mapping']; 
            EDealerContainerController.fetchLoggedInUserdetails();
            EDealerContainerController.UserWrapper objWrap1 = new  EDealerContainerController.UserWrapper(u);
            EDealerContainerController.UserWrapper objWrap = new  EDealerContainerController.UserWrapper();                
            objWrap.accountId=user1.AccountId;
            objWrap.asiUserName='TestUser';
            objWrap.contactId=user1.ContactId;
            objWrap.dealerGroupCode='';
            objWrap.dealerGroupName='';
            objWrap.division='KW';
            objWrap.photoUrl='';
            objWrap.roleId='';
            objWrap.roleName='Standard User';
            objWrap.userId=user1.Id;
        }
        Test.stopTest();
        EDealerContainerController.PicklistOptions objOption=new EDealerContainerController.PicklistOptions('Test', 'Test', false, 'O997', 'KW');
        objOption.defaultValue=false;
        objOption.divisionCode='KW';
        objOption.grpCode='O997';
        objOption.label='';
        objOption.value='';
        // call to get non dealer accessible locations 
        List<EDealer_Relationship__c> resWrapp = EDealerContainerController.getNonDealerAccessibleDealerLocations('999990');
    }
    
    
    @isTest
    private static void testFetchLoggedInUserDetailsForInternal(){
        User user1 = [SELECT Id, Name, ContactId, AccountId FROM User WHERE Email ='internaltest1223@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(user1) {
            EDealerContainerController.fetchLoggedInUserDetails();
        }
        Test.stopTest();
    }
    
    
}