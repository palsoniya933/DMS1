@isTest
public class EdealerTrackingControllerTest {
    
    @testSetup
    private static void testSetup() {
        Id profCommunity = [SELECT Id FROM Profile where Name = 'Paccar TCS edealer Community Plus'].Id;
        List<Account> accounts = new List<Account>{new Account(Name='TestAccount', Dealer_Code__c='999990' ,Dealer_Group_Name__c='subz' ,Group_Code__c='C111',PACCARDivision__c='K'),
            new Account(Name='TestAccount2', Dealer_Code__c='999910' ,Dealer_Group_Name__c='subx' ,Group_Code__c='C121',PACCARDivision__c='P')};
                insert accounts; 
        
        List<Contact> contacts = new List<Contact>();
        for(Account acc : accounts){
            contacts.add(new Contact(LastName ='testCon'+acc.Name ,AccountId = acc.Id));
        }
        
        insert contacts;
        List<User> users = New List<User>{new User(alias = 'test123', email ='test123@noemail.com',
                                                   emailencodingkey = 'UTF-8', LastName = 'Testing',
                                                   Languagelocalekey='en_US', localesidkey='en_US',
                                                   ProfileId = profCommunity, country='United States',
                                                   IsActive = true, ContactId = contacts[0].Id,Pass_Group_Permissions__c = 'Field Service',
                                                   timezonesidkey='America/Los_Angeles', username='testKenworth@noemail.com'),
            new User(alias = 'test23', email ='test1234@noemail.com',
                     emailencodingkey = 'UTF-8', LastName = 'Testing',
                     Languagelocalekey='en_US', localesidkey='en_US',
                     ProfileId = profCommunity, country='United States',
                     IsActive = true, ContactId = contacts[1].Id,Pass_Group_Permissions__c = 'Field Service',
                     timezonesidkey='America/Los_Angeles', username='testP@noemail.com')};
                         insert users;
    }
    
    @isTest static void testInsertTrackingDetailsForPeterbiltUser(){
        User userP = [SELECT Id FROM User WHERE username='testP@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(userP) {
            EdealerTrackingController.insertTrackingDetails('Test Track');
        }
        Test.stopTest();
        EDealer_Tracking__c eDealerTracking = [SELECT Id, Peterbilt_User_Visited__c,Dealer_Group__c 
                                               FROM EDealer_Tracking__c LIMIT 1];
        System.assertEquals(1,eDealerTracking.Peterbilt_User_Visited__c);
        System.assertEquals('C121',eDealerTracking.Dealer_Group__c);
    }
    
    @isTest static void testInsertTrackingDetailsForKenworthUser(){
        User userK = [SELECT Id FROM User WHERE username='testKenworth@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(userK) {
            EdealerTrackingController.insertTrackingDetails('Test Track');
        }
        Test.stopTest();
        EDealer_Tracking__c eDealerTracking = [SELECT Id, Kenworth_User_Visited__c,Dealer_Group__c 
                                               FROM EDealer_Tracking__c LIMIT 1];
        System.assertEquals(1,eDealerTracking.Kenworth_User_Visited__c);
        System.assertEquals('C111',eDealerTracking.Dealer_Group__c);
    }
    
    @isTest static void testInsertTrackingDetailsToUpdateExistingRecordForPUser(){
        User userP = [SELECT Id FROM User WHERE username='testP@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(userP) {
            EdealerTrackingController.insertTrackingDetails('Test Track');
            EdealerTrackingController.insertTrackingDetails('Test Track');
        }
        Test.stopTest();
        EDealer_Tracking__c eDealerTracking = [SELECT Id, Peterbilt_User_Visited__c,Dealer_Group__c 
                                               FROM EDealer_Tracking__c LIMIT 1];
        System.assertEquals(2,eDealerTracking.Peterbilt_User_Visited__c);
    }
    
    @isTest static void testInsertTrackingDetailsToUpdateExistingRecordForKUser(){
        User userK = [SELECT Id FROM User WHERE username='testKenworth@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(userK) {
            EdealerTrackingController.insertTrackingDetails('Test Track');
            EdealerTrackingController.insertTrackingDetails('Test Track');
        }
        Test.stopTest();
        EDealer_Tracking__c eDealerTracking = [SELECT Id, Kenworth_User_Visited__c,Dealer_Group__c 
                                               FROM EDealer_Tracking__c LIMIT 1];
        System.assertEquals(2,eDealerTracking.Kenworth_User_Visited__c);
    }
    
    @isTest static void testUpdateTimeSpent(){
        User u = [SELECT Id FROM User WHERE username='testKenworth@noemail.com' LIMIT 1];
        Test.startTest();
        system.runAs(u) {
            EdealerTrackingController.insertTrackingDetails('Test Track');
            EdealerTrackingController.updateTimeSpent('Test Track',12);
        }
        Test.stopTest();
    }
    
}