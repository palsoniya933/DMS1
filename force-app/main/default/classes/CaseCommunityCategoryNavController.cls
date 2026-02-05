/**
 * @author anthony.beran@slalom.com
 * @date 2019-05-12
 * @version 1.0
 * @description CaseCommunityCategoryNavController
 */

public with sharing class CaseCommunityCategoryNavController {

    @AuraEnabled(Cacheable=true)
    public static List<Case_Navigation__mdt> getCaseNavigation() {
        Id userId = UserInfo.getUserId();
        List<User> users = UserDAO.getById(new Set<Id>{userId});

        if ( users.isEmpty() ) {
            DebugLogDomain.log(new LogException('Cant find current logged in user'),  userId, 'CaseCommunityCategoryNavController', 'getCaseNavigation');

            throw new AuraHandledException('An unexpected error happened. Please try again later.');
        }

        Set<Id> caseNavProfileIds = new Set<Id>();
        for ( Case_Navigation_Profile__mdt p : MDTCaseNavigationProfileDAO.getByProfile(new Set<String>{users[0].Profile.Name}) ) {
            caseNavProfileIds.add(p.Case_Navigation_RecordType__c);
        }

        return MDTCaseNavigationDAO.getByProfile(caseNavProfileIds);
    }

    @AuraEnabled (Cacheable=true)
    public static Boolean getVSTileToggle(){
        Boolean displayVS = false;
        User user=EDealerUserUtils.fetchLoggedInUserdetails();
        if(user !=null && user.Pass_Group_Permissions__c !=null && user.Pass_Group_Permissions__c.containsIgnoreCase('Purchasing')){
            displayVS=true;
        }
        return displayVS;
    }
    @AuraEnabled
    public static void getLoggingPermissionSet(){
        List<PermissionSetAssignment> newPSAList = new List<PermissionSetAssignment>();  
        Set<Id> assignedPSAIds = new Set<Id>();
        for(PermissionSetAssignment psa : [Select Id, PermissionSetId from PermissionSetAssignment where AssigneeId=:UserInfo.getUserId()]) {
            assignedPSAIds.add(psa.PermissionSetId);
            system.debug('\n--psa--'+psa);
        }
        EDealerUserUtils.assignConditionalPermissions(new Set<String>(),assignedPSAIds,newPSAList);
        System.debug('newPSAList==>'+newPSAList);
        if(!newPSAList.isEmpty()){
            Database.SaveResult[] results = Database.insert(newPSAList, false);
            EDealerUserUtils.logError(results, 'Insert PermissionSet Assignment from CaseCommunityCategoryNavController');
        }
    }
}