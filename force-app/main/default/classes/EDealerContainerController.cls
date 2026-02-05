/******
*  Name : EDealerContainerController
*  Description : This is the controller class for eDealerContainer Component
*  Modified : Vivian D. Mirador - 04/02/2024
*  Description : Added code for PASS group permission (#passGroup)
**/ 

public with sharing class EDealerContainerController{
    
    // this is the method which will return the current user logged in information  
    @AuraEnabled
    public static UserWrapper fetchLoggedInUserDetails(){
        List<EDealer_Relationship__c> lstDealerRelationships = new List<EDealer_Relationship__c>();
        EDealerUserUtils.checkAndAssignPermissionSetsToLoggedInUser();
        User u = EDealerUserUtils.fetchLoggedInUserdetails();        
        Boolean isNonDealer = false;
        
        UserWrapper userWrap = new UserWrapper(u);
        
        if(u.IsPortalEnabled != true){
            //non dealer
            List<Edealer_Access__mdt> nonDealersAccess = EDealerMetadataUtility.getEdealerAccessMetadataByProfilesName(new Set<String>{u.Profile.Name});
            if(!nonDealersAccess.isEmpty() && nonDealersAccess[0].ASI_Authentication__c == false){
                isNonDealer = true;
            }
        }
        
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:u.Id ];
        
        String dealerMdt =  EDealerMetadataUtility.dealerAccessType(userDetails.Profile.Name,userDetails.UserRole.Name);
        
        userWrap.accessDivision = dealerMdt;
        
        userWrap.isNonDealer = isNonDealer;
        //get Relationships (ASI based Accessible dealer details)        
        if(u.IsPortalEnabled == true){
            lstDealerRelationships = getAccessibleDealerLocs(u.ContactId, true);
        }else{
            lstDealerRelationships = getAccessibleDealerLocs(u.Id, false);
        }        
        //error if current user is not authorized by ASI
        if((u.IsPortalEnabled == false && isNonDealer == false && lstDealerRelationships.isEMpty()) || (u.IsPortalEnabled == true && lstDealerRelationships.isEMpty())){
            throw new AuraHandledException('No Dealer found.');
        }
        
        userWrap.accessibleDealersLocation = lstDealerRelationships;
        //default currecy code is USD
        userWrap.currencyCode = 'USD';
        
        if(!lstDealerRelationships.isEmpty()){
            //get division
            userWrap.division = lstDealerRelationships[0].Division__c;
            
            //get country
            userWrap.country = lstDealerRelationships[0].country__c;
            
            //get ISO currency code 
            if(String.isNotBlank(lstDealerRelationships[0].Currency_Code__c)){
                // get currency mapping metadata
                List<eDealer_Config__mdt> currencyMappingMdt = new List<eDealer_Config__mdt>();
                if( Schema.sObjectType.eDealer_Config__mdt.fields.Long_Value__c.isAccessible()
                   && Schema.sObjectType.eDealer_Config__mdt.fields.DeveloperName.isAccessible()
                  ){
                      currencyMappingMdt = [SELECT Id, Long_Value__c FROM eDealer_Config__mdt WHERE DeveloperName ='Currency_Code_Mapping'];
                  }
                
                if(!currencyMappingMdt.isEmpty() && String.isnotBlank(currencyMappingMdt[0].Long_Value__c)){
                    map<String,String> currencyCodeMapping = (map<string,string>)JSON.deserialize(currencyMappingMdt[0].Long_Value__c, map<string,string>.class);
                    if(currencyCodeMapping.containsKey(lstDealerRelationships[0].Currency_Code__c)){
                        userWrap.currencyCode = currencyCodeMapping.get(lstDealerRelationships[0].Currency_Code__c);
                    }
                }
            }
            
        }
        
        
        return userWrap;
    }
    
    
    /*** this method return the list of Accessible Dealer Locations with Ascending Order by dealer location ***/
    public static List<EDealer_Relationship__c> getAccessibleDealerLocs(Id id, Boolean isPortalUser){
        List<EDealer_Relationship__c> lstDealerRelationships = new List<EDealer_Relationship__c>();
        if(isPortalUser == true){
            lstDealerRelationships = EDealerRelationshipUtil.getRelationships(id);
        }else{
            lstDealerRelationships = EDealerRelationshipUtil.getUserRelationships(id);
        }
        
        List<String> dealerLocs = new List<String>();
        if(!lstDealerRelationships.isEmpty()){
            Map<String,EDealer_Relationship__c> MapRelationships = new Map<String,EDealer_Relationship__c>();
            //sort the list in Ascending order
            for(EDealer_Relationship__c rel : lstDealerRelationships){
                String loc = String.isNotBlank(rel.Sub_Code__c) ? (rel.ASI_Dealer_Code__c+'-'+rel.Sub_Code__c) : rel.ASI_Dealer_Code__c;
                MapRelationships.put(loc, rel);
                dealerLocs.add(loc);
                
            }            
            //Sort Dealer Locs
            dealerLocs.sort();
            
            lstDealerRelationships.clear();
            
            for(String loc : dealerLocs){
                lstDealerRelationships.add(MapRelationships.get(loc));
            }            
        }        
        return lstDealerRelationships;
        
    }
    
    
    /***
     * Wrapper to store Current user Info
     */ 
    public class UserWrapper{
        @AuraEnabled public Id userId {get;set;}
        @AuraEnabled public String userName {get;set;}
        @AuraEnabled public String asiUserName {get;set;}
        @AuraEnabled public Id contactId {get;set;}
        @AuraEnabled public Id accountId {get;set;}
        @AuraEnabled public String division {get;set;}
        @AuraEnabled public String dealerGroupCode {get;set;}
        @AuraEnabled public String dealerGroupName {get;set;}
        @AuraEnabled public String photoUrl {get;set;}
        @AuraEnabled public String roleId {get;set;}
        @AuraEnabled public String roleName {get;set;}
        @AuraEnabled public List<EDealer_Relationship__c> accessibleDealersLocation {get;set;}
        @AuraEnabled public Boolean isNonDealer;
        @AuraEnabled public String currencyCode;
        @AuraEnabled public String country;
        @AuraEnabled public String passGroup;  //#passGroup
        @AuraEnabled public String accessDivision {get;set;}
        public UserWrapper(){
            accessibleDealersLocation = new List<EDealer_Relationship__c>();
        }
        
        public UserWrapper(User u){
            userName = u.Name;
            userId = u.Id;
            asiUserName = u.ASI_Username__c;
            contactId = u.ContactId;
            if(u.ContactId != null){
                accountId = u.Contact.AccountId; 
            }
            if(u.ContactId != null && u.Contact.AccountId != null){
                dealerGroupName = u.Contact.Account.Dealer_Group_Name__c;
                dealerGroupCode = u.Contact.Account.Group_Code__c;
            }
            photoUrl = u.SmallPhotoUrl;
            passGroup = u.Pass_Group_Permissions__c;  //#passGroup
            
            /*roleId = u.UserRoleId;
            if(u.UserRoleId != null){
                roleName = u.UserRole.Name;
            }*/
            
            accessDivision ='All';
        }       
    }
    
    
    // this will save the options for picklist
    public class PicklistOptions{       
        
        @AuraEnabled public string label {get;set;}
        @AuraEnabled public string value {get;set;}
        @AuraEnabled public boolean defaultValue {get;set;}
        @AuraEnabled public string grpCode {get;set;}
        @AuraEnabled public string divisionCode {get;set;}
        
        // constructor
        public PicklistOptions(string label, string value, boolean defaultValue, string grpCode, string divisionCode){
            this.value = value;
            this.label = label;
            this.defaultValue = defaultValue;
            this.grpCode = grpCode;
            this.divisionCode = divisionCode;
        }
    }
    
    
    //this method will call by non dealer when they select an dealer location from edealer page
    //this method return the accessible dealer location based on selected dealer location group
    @auraEnabled
    public static List<EDealer_Relationship__c> getNonDealerAccessibleDealerLocations(String dealerCode){
        //dealer group code
        String dealerGroupCode;
        //Accounts where group code are same
        List<Account> lstSameGroupAccounts = new List<Account>();
        //create accessible dealer locations
        List<EDealer_Relationship__c> lstDealerRelationships = new List<EDealer_Relationship__c>();
        
        //check this dealer location account in salesforce
        List<Account> lstAccounts = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        //get dealer code
        if(!lstAccounts.isEmpty()){
            dealerGroupCode = lstAccounts[0].Group_Code__c;
        }
        
        //get dealer locations where group code are same
        if(String.isNotBlank(dealerGroupCode)){
            lstSameGroupAccounts = EdealerAccountUtils.getDealersAccountByGroup(new Set<String> {dealerGroupCode});
        }
        for(Account acc : lstSameGroupAccounts){
            EDealer_Relationship__c rel = new EDealer_Relationship__c();
            rel.Customer_Name__c = acc.Name;
            rel.ASI_Dealer_Code__c = acc.Dealer_Code__c;
            lstDealerRelationships.add(rel);
        }
        
        return lstDealerRelationships;
        
    }
    
}