@IsTest
public class UserDAOTest {

    @IsTest
    public static void updateUserTest(){
      Test.startTest();
        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
                IsActive = true,
                LastName = '______TESTInval______',
                FirstName = '_____TESTER______',
                Username = '__Test__User__@testi.com.invalid',
                Email = '__Test__User__@testi.com.invalid',
                CompanyName = 'Test',
                Title = 'Test',
                Alias = 'Test',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
        		FederationIdentifier = '460-a0c6-5ea',
        UserUid__c='Test1234');
        insert u;
        Set<String> dCode=new Set<String>();
        dCode.add('H600');
        dCode.add('Y1995');
        Set<Id> accountIds = new Set<Id>();
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.Dealer_Code__c = 'H600';
        insert acc;
        accountIds.add(acc.Id);
        Contact newcon = new Contact();
        newcon.Email = u.Email;
        newcon.FirstName = u.FirstName;
        newcon.LastName = u.LastName;
        newcon.UserUid__c = u.UserUid__c;
        newcon.AccountId = acc.id;
        insert newcon;
        Set<Id> contactsId=new Set<Id>();
        contactsId.add(newcon.Id);
        Set<String> uids=new Set<String>();
        Set<Id> ids=new Set<Id>();
        ids.add(u.Id);
        uids.add(newcon.UserUid__c);
        UserDAO.getByAccount(accountIds);
        UserDAO.getByUID(uids);
        userDAO.getById(ids);
        userDAO.getAccountInfo(ids);
        userDAO.getAllUsersWithCSRAccess();
        userDAO.getApproverIdForCurrentUser();
     Test.stopTest();  
    }
}