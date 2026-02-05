/******
 *  This is the class which will be have code related to User Object object i.e. common used method
 *  all queries so that code can be re-used
 *  Modified : Vivian D. Mirador - 04/02/2024
 *  Description : Added code for PASS group permission (#passGroup)
 **/ 

public with sharing class EDealerUserUtils{    
    
    // this is the method which will return the current user logged in information
    public static User fetchLoggedInUserdetails(){
        User u;
        if(Schema.sObjectType.User.fields.ID.isAccessible()
           && Schema.sObjectType.User.fields.Name.isAccessible()
           && Schema.sObjectType.User.fields.SmallPhotoUrl.isAccessible()
           && Schema.sObjectType.User.fields.ContactId.isAccessible()
           && Schema.sObjectType.Contact.fields.AccountId.isAccessible()
           && Schema.sObjectType.Account.fields.PACCARDivision__c.isAccessible()
           && Schema.sObjectType.Account.fields.Dealer_Group_Name__c.isAccessible()
           && Schema.sObjectType.Account.fields.Group_Code__c.isAccessible()
           && Schema.sObjectType.User.fields.ASI_Username__c.isAccessible()
           && Schema.sObjectType.User.fields.IsPortalEnabled.isAccessible()
           && Schema.sObjectType.User.fields.Pass_Group_Permissions__c.isAccessible()
          ){
              u = [SELECT ID, Name, SmallPhotoUrl, ContactId, Contact.AccountId,
                   Contact.Account.PACCARDivision__c, Contact.Account.Dealer_Group_Name__c,
                   Contact.Account.Group_Code__c, Profile.Name, ASI_Username__c,IsPortalEnabled, Pass_Group_Permissions__c,
                   Contact.Account.ShippingCountry
                   FROM User WHERE ID =: UserInfo.getUserId()];
          }
        
        return u;
    }
    
    public static void checkAndAssignPermissionSetsToLoggedInUser(){   
        
        //Specify the Permission Set Name that you want to assign
        Set<String> permissionSetNames = new Set<String>();
        String permissionNames = EDealerConfigUtils.getConfigByDeveloperName('Edealer_PermissionSet_Names').Long_Value__c;
        //Split the text by comma and remove surrounding whitespace
        List<String> permissionElements = permissionNames.split(';');
        for(String s: permissionElements){
            s = s.trim();
            permissionSetNames.add(s);  
        }
        Set<Id> requiredPermissionSetsId = new Set<Id>();
        //Query for the Permission Set Id based on the name
        Map<Id,PermissionSet> permissionSetIdByRecord = new Map<Id,PermissionSet>([SELECT Id FROM PermissionSet WHERE Name IN :permissionSetNames]);    
        System.debug('permissionSetIdByRecord:::'+permissionSetIdByRecord);
        
        Set<Id> assignedPSAIds = new Set<Id>();
        for(PermissionSetAssignment psa : [Select Id, PermissionSetId from PermissionSetAssignment where AssigneeId=:UserInfo.getUserId()]) {
            assignedPSAIds.add(psa.PermissionSetId);
            system.debug('\n--psa--'+psa);
        }
        System.debug('assignedPSAIds::'+assignedPSAIds);
        
        List<PermissionSetAssignment> newPSAList = new List<PermissionSetAssignment>();         
        for(Id reqPSId : permissionSetIdByRecord.keySet()) {
            if(!assignedPSAIds.contains(reqPSId)) {
                PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(
                    AssigneeId = UserInfo.getUserId(),
                    PermissionSetId = reqPSId
                ); 
                newPSAList.add(permissionSetAssignment);
            }
        }
        System.debug('permissionSetNames:::'+permissionSetNames);
        System.debug('newPSAList:::'+newPSAList);
        assignConditionalPermissions(permissionSetNames,assignedPSAIds,newPSAList);
        System.debug('newPSAList after conditional permissons:::'+newPSAList);
        if(!newPSAList.isEmpty()) {
            Database.SaveResult[] results = Database.insert(newPSAList,false);
            logError(results, 'Insert PermissionSet Assignment');
        }
    }   
    
      public static void assignConditionalPermissions(Set<String> processedPermissionSetsName, Set<Id> assignedPSAIds, List<PermissionSetAssignment> newPSAList) {
        try {
            User currentUser = fetchLoggedInUserdetails();
            if (currentUser != null && currentUser.ContactId == null) {
                return;
            }
            else{
                assignConditionalPermissionsToDealers(processedPermissionSetsName,assignedPSAIds,newPSAList,currentUser);
            }
           
        } catch (Exception err) {
            System.debug('Error in assignConditionalPermissions=>'+err.getMessage());
            return;
        }
    }
    
    public static void assignConditionalPermissionsToDealers(Set<String> processedPermissionSetsName, Set<Id> assignedPSAIds, List<PermissionSetAssignment> newPSAList, User currentUser){
        String permissionsJSON = EDealerConfigUtils.getConfigByDeveloperName('Edealer_Conditional_Permissions').Long_Value__c;
        
            List<Object> permissionsSchema = (List<Object>) JSON.deserializeUntyped(permissionsJSON);
            
            Set<String> allPermissionSets = new Set<String>();
            Set<String> allPermissionSetLicenseNames = new Set<String>();
            
            for (Object item : permissionsSchema) {
                if (item instanceof Map<String, Object>) {
                    Map<String, Object> permissionSchema = (Map<String, Object>) item;
                    System.debug('permissionSchema=>'+permissionSchema);
                    
                    if (permissionSchema.containsKey('passGroupPermission') && currentUser.Pass_Group_Permissions__c != Null &&
                        currentUser.Pass_Group_Permissions__c.containsIgnoreCase((String) permissionSchema.get('passGroupPermission'))) {
                            
                            if (permissionSchema.containsKey('PermissionSetLicenses')) {
                                List<Object> permSetLicensesObj = (List<Object>) permissionSchema.get('PermissionSetLicenses');
                                for (Object obj : permSetLicensesObj) {
                                    if (obj instanceof String) {
                                        allPermissionSetLicenseNames.add(((String) obj).trim());
                                    }
                                }
                            }
                            if (permissionSchema.containsKey('permissionSets')) {
                                List<Object> permSetsObj = (List<Object>) permissionSchema.get('permissionSets');
                                for (Object obj : permSetsObj) {
                                    if (obj instanceof String) {
                                        String permSetName = ((String) obj).trim();
                                        if (!processedPermissionSetsName.contains(permSetName)) {
                                            allPermissionSets.add(permSetName);
                                        }
                                    }
                                }
                            }
                        }
                }
            }
        if(!allPermissionSetLicenseNames.isEmpty()){
            insertPermissionSetLicesesForUser(allPermissionSetLicenseNames,currentUser);
        }
        if(!allPermissionSets.isEmpty()){
            updateNewPSAList(newPSAList,allPermissionSets,assignedPSAIds,currentUser);
        }
        
            
    }
    
    private static void insertPermissionSetLicesesForUser(Set<String> allPermissionSetLicenseNames,User currentUser){
        Set<Id> assignedPermissionLicenseIds = new Set<Id>();
        List<PermissionSetLicenseAssign> permSetLicenseAssignmentsToBeInserted = new List<PermissionSetLicenseAssign>();
        
        for (PermissionSetLicenseAssign permSetLicenseAssign : [SELECT PermissionSetLicenseId FROM PermissionSetLicenseAssign WHERE AssigneeId = :currentUser.Id]) {
            assignedPermissionLicenseIds.add(permSetLicenseAssign.PermissionSetLicenseId);
        }
        
        for (PermissionSetLicense permSetLicense : [SELECT Id FROM PermissionSetLicense WHERE DeveloperName IN :allPermissionSetLicenseNames AND Id NOT IN :assignedPermissionLicenseIds]) {
            permSetLicenseAssignmentsToBeInserted.add(new PermissionSetLicenseAssign(AssigneeId = currentUser.Id, PermissionSetLicenseId = permSetLicense.Id));
        }
        
        if (!permSetLicenseAssignmentsToBeInserted.isEmpty()) {
            Database.SaveResult[] results = Database.insert(permSetLicenseAssignmentsToBeInserted, false);
            logError(results, 'Insert PermissionSet Licenses Assignment');
        }
    }
    
    private static void updateNewPSAList(List<PermissionSetAssignment> newPSAList, Set<String> allPermissionSets, Set<Id> assignedPSAIds, User currentUser){
        for (PermissionSet permSet : [SELECT Id, Name FROM PermissionSet WHERE Name IN :allPermissionSets AND Id NOT IN :assignedPSAIds]) {
            newPSAList.add(new PermissionSetAssignment(AssigneeId = currentUser.Id, PermissionSetId = permSet.Id));
        }
    }
    
    public static void logError(Database.SaveResult[] results, String Operation){
        System.debug(Operation);
        for(Database.SaveResult result : results) {
            if(!result.isSuccess()) {
                for(Database.Error error : result.getErrors()) {
                    System.debug('Error Message : ' + error.getMessage() + '\n' +
                                 'Error Status : ' + error.getStatusCode() + '\n' +
                                 'Error Fields : ' + error.getFields());
                }
            }
        }
    }
    
}