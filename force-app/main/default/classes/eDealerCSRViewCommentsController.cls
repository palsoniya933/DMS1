public with sharing class eDealerCSRViewCommentsController {

    @AuraEnabled
    public static String getCsrCommentsFromAws(String csrNumber, String csrPhase) {
        System.debug('\n----csrNumber--' + csrNumber);
        System.debug('\n----csrPhase--' + csrPhase);
        String JSONBody = getEndPointParameters(csrNumber, csrPhase);
        System.debug('\n----JSONBody--' + JSONBody);

        Map<String,Object> calloutDetails = new Map<String,Object>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWGetCSRCmts');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname','eDealerCSRViewCommentsController');
        String responseData = EDealerHttpHandler.callout(calloutDetails);
        
        System.debug('\n----responseData--' + responseData);
        
        if(responseData != null) {
            edealerCommentsWrapper response = (edealerCommentsWrapper)System.JSON.deserialize(responseData, edealerCommentsWrapper.class);
             System.debug('\n----response--' + response);
             //System.debug('response.ErrorResponse.IsSuccess------'+response.ErrorResponse.IsSuccess);
            if(response.ErrorResponse.ErrorMessagesCount == 0) {
               // System.debug('JSON.serialize(response)-----:::'+JSON.serialize(response));
                return JSON.serialize(response);  
            }
            else {
               // System.debug('response.ErrorResponse.ErrorMessage-----:::'+JSON.serialize(response.ErrorResponse.ErrorMessages));
                return JSON.serialize(response.ErrorResponse.ErrorMessages);
            }
        }
        else {
            return 'No Data Found';
        }
    }
    
    private static String getEndPointParameters(String csrNumber, String csrPhase) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('CSRNumber', csrNumber);
        gen.writeObjectField('Phase', Integer.valueOf(csrPhase));
        //gen.writeObjectField('UserName', EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c);
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    @AuraEnabled(cacheable=true)
    public static List <Map<String,String>> getCommentsColumnHeaders(){
        return EDealerMetadataUtility.tableColumnHeaderTranslations('View_Comments');
    }
    //this is the method which will return the current user logged in information  
    @AuraEnabled
    public static UserWrapper fetchLoggedInUserDetails(){
        List<EDealer_Relationship__c> lstDealerRelationships = new List<EDealer_Relationship__c>();
        
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
                        System.debug('lstDealerRelationshi323ps----'+lstDealerRelationships);

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
    
    public class edealerCommentsWrapper{
        public Data Data;
        public ErrorResponse ErrorResponse;
    }
    
    public class Data {
        public String CSRNumber;
        public String Phase;
        public List<HeaderCommentData> HeaderCmts;
        public List<LineCommentData> LineCmts;
    }
    
    public class HeaderCommentData {
        public Integer HCmtLine;
        public String HCmtType;
        public String HLngCode;
        public String HComment;
        public Integer HDteAdded;
        public String HTimeAdded;
        public String HAddUser;
        public Integer HLstUpdDate;
        public Integer HLstUpdTime;
        public String HLstUpdUser;
    }
    
    public class LineCommentData {
        public Integer LCSRLine;
        public Integer LCmtLine;
        public String LCmtTyp;
        public String LComment;
        public Integer LDteAdded;
        public Integer LTimeAdded;
        public String LAddUser;
        public Integer LLstUpdDate;
        public Integer LLstUpdTime;
        public String LLstUpdUser;
    }
    
    public class ErrorResponse {
        public String IsSuccess;
        public Integer ErrorMessagesCount;
        public List<ErrorMessage> ErrorMessages;
    }
    
    public class ErrorMessage {
        public String ErrorDescription;
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
            /*roleId = u.UserRoleId;
            if(u.UserRoleId != null){
                roleName = u.UserRole.Name;
            }*/
        }       
    }
}