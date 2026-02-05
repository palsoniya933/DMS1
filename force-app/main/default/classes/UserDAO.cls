/**
 * @author anthony.beran@slalom.com
 * @date 2019-05-24
 * @version 1.0
 * @description UserDAO
 */

public with sharing class UserDAO {

    public static List<User> getById(Set<Id> ids) {
        return [
            SELECT UserUid__c, Username, Email, FirstName, LastName, Alias, IsActive, ContactId, IsPortalEnabled, Profile.Name, Contact.Account.Dealer_Code__c, Name
            FROM User
            WHERE Id IN :ids
        ];
    }

    public static List<User> getByUID(Set<String> uids) {
        return [
            SELECT profileid, 
                    CommunityNickname, 
                    UserUid__c, 
                    Username, 
                    Email, 
                    LastName, 
                    Alias, 
                    IsActive, 
                    ContactId, 
                    IsPortalEnabled, 
                    Contact.Account.Dealer_Code__c,                    
                    Contact.Account.Fleet_Account_Code__c,
                    LanguageLocaleKey
            FROM User
            WHERE UserUid__c IN :uids AND UserUid__c != null
        ];
    }

    public static List<User> getByAccount(Set<Id> accountIds) {
        return [
            SELECT IsPortalEnabled, IsActive
            FROM User
            WHERE User.Contact.AccountId IN :accountIds
        ];
    }

    public static List<User> getAccountInfo(Set<Id> ids) {
        return [
            SELECT Id, Contact.Account.PACCARDivision__c, Contact.Account.Name, Contact.Account.Region__c
            FROM User
            WHERE Id IN :ids
        ];
    }
    
    public static List<User> getAllUsersWithCSRAccess() {
        return [
            SELECT Id, Name
            FROM User
            WHERE IsActive = TRUE
            AND Id IN (
                SELECT AssigneeId
                FROM PermissionSetAssignment
                WHERE PermissionSet.Name = 'CSR_Processor'
            )
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC
        ];
    }

    /**
     * Fetch CSR Approver Id for the current user.
     */
    public static Decimal getApproverIdForCurrentUser() {
        User u = [
            SELECT csr_Approver_Id__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        return u.csr_Approver_Id__c;
    }
}