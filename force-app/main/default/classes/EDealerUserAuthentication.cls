public with sharing class EDealerUserAuthentication {
    
    @AuraEnabled
    public static Boolean ASIAuthenticationByPass(){
        
         User u = EDealerUserUtils.fetchLoggedInUserdetails();
        List<Edealer_Access__mdt> nonDealersAccess = EDealerMetadataUtility.getEdealerAccessMetadataByProfilesName(new Set<String>{u.Profile.Name});

        if(!nonDealersAccess.isEmpty() && nonDealersAccess[0].ASI_Authentication__c == false){
            return true;
        }else{
            return false;
        }
    }
    
    /****
* 16-02-2021
* This method use to authenticate user in ASI System via API call
*/ 
    @AuraEnabled
    public static ASIAuthenticationResponseWrapper ASIUserAuthentication(String name, String pwd){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        
        if(String.isBlank(name) || String.isBlank(pwd)){
            throw new AuraHandledException('Please check Username/Password');
        }
        
        ASIAuthenticationResponseWrapper responseResultData = new ASIAuthenticationResponseWrapper();
       
        calloutDetails.put('endpoint','/asi/user-aunthentication/user');
        calloutDetails.put('method','POST');   
        calloutDetails.put('body', '{"InputUser": "'+name+'","InputPassword": "'+pwd+'"}');
       
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes:::'+jsonRes);
        //Call EDealerLogUtils class based on response status code.
        try{
            // parsing the actual results
            responseResultData = (ASIAuthenticationResponseWrapper)System.JSON.deserialize(jsonRes, ASIAuthenticationResponseWrapper.class);
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerUserAuthentication', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException('Please contact with Administrator.');
        }
        
        //update current user record with ASI username
        if(responseResultData != null 
           && responseResultData.response == 'Authenticated'){
               
               User u = new User();
               u.Id = UserInfo.getUserId();
               u.ASI_Username__c = name;
               //UPDATE
             
               
               if(Schema.sObjectType.User.fields.ASI_Username__c.isUpdateable()){
                   update u;
               }else{
                   throw new AuraHandledException('You don\'t have sufficient Permission. Please contact with Administrator.');
               }
               
           }
        
        return responseResultData;
    }
    
    /****
* 17-02-2021
* This method use to get the Dealer Code for the ASI User and save the response on current user contact
*/ 
    @AuraEnabled
    public static Boolean getAndSaveASIDealersLocations(String userName){
        System.debug('userName=>'+userName);
        Boolean Dealer_Doe_Status = false;
        
        ASIUserDealersLocationResponseWrapper wrap =  ASIUserDealerLocations(userName);
        System.debug('wrap at user authentication:::'+wrap);
        if(wrap != null && wrap.error != null){
            throw new AuraHandledException(wrap.error);
        }
        
        //get current user details
        User u = EDealerUserUtils.fetchLoggedInUserdetails();
        System.debug('u in auth::'+u);
        //Date 24-02-2021
        //Save the Dealer relationships in EDealer Relationship Object
        //1. Delete the All relationship if exist With Current user Contact/ user record
        List<EDealer_Relationship__c> relList = new List<EDealer_Relationship__c>(); 
        if(u.IsPortalEnabled == true){
            relList = EDealerRelationshipUtil.getRelationships(u.ContactId);
        }else{
            relList = EDealerRelationshipUtil.getUserRelationships(u.Id);
        }
        
        if(!relList.isEmpty()){
            if(EDealer_Relationship__c.sObjectType.getDescribe().isDeletable()){
                delete relList;
            }
        }
        
        //2. Create new Relationships with Current user Contact
        if(wrap.response != null 
           && wrap.response.Accessible_Dealers != null
           && !wrap.response.Accessible_Dealers.isEmpty()){
               //2.1 create a map <Dealercode-subCode, Accessible dealer data>
               Map<String, AccessibleDealer> mapAccessibleDealerData = new Map<String, AccessibleDealer>();
               //2.2 update map <Dealercode-subCode, Accessible dealer data>Ap
               for(AccessibleDealer ad : wrap.response.Accessible_Dealers){
                   if(String.isNotBlank(ad.dealer_code)){
                       String customKey = String.isBlank(ad.dealer_suffix) ? ad.dealer_code : (ad.dealer_code +'-'+ad.dealer_suffix); 
                           mapAccessibleDealerData.put(customKey, ad);
                   }
                   
               }
               //2.3 Create Relationship data
               List<EDealer_Relationship__c> lstCreateRelationships = new List<EDealer_Relationship__c>();
               for(String dealercodeKey : mapAccessibleDealerData.keySet()){
                   AccessibleDealer adWrap = mapAccessibleDealerData.get(dealercodeKey);
                   EDealer_Relationship__c dealerRel = new EDealer_Relationship__c();
                   
                   ////////////
                   if(u.IsPortalEnabled == true){
                       dealerRel.Contact__c = u.ContactId;
                   }else{
                       dealerRel.User__c = u.Id;
                   }
                   
                   dealerRel.ASI_Dealer_Code__c = adWrap.dealer_code; 
                   dealerRel.Customer_Name__c = adWrap.cstnam;
                   dealerRel.Sub_Code__c = adWrap.dealer_suffix;
                   dealerRel.Division__c = adWrap.dealer_div;
                   dealerRel.Currency_Code__c = wrap.response.currencycode;
                   dealerRel.Country__c = wrap.response.country;
                   System.debug('dealerRel.Country__c'+dealerRel.Country__c);
                   dealerRel.Allow_Download_Of_Reports__c = (String.isNotBlank(wrap.response.allow_download_of_reports) && wrap.response.allow_download_of_reports == 'Y') ? true : false;
                   dealerRel.Allow_Upload_Of_Orders__c = (String.isNotBlank(wrap.response.allow_upload_of_orders) && wrap.response.allow_upload_of_orders == 'Y') ? true : false;
                   dealerRel.Allow_Upload_Of_Rma__c = (String.isNotBlank(wrap.response.allow_upload_of_rma) && wrap.response.allow_upload_of_rma == 'Y') ? true : false;
                   dealerRel.Availability_Inquiry__c = (String.isNotBlank(wrap.response.availability_inquiry) && wrap.response.availability_inquiry == 'Y') ? true : false;
                   dealerRel.Dealer_Control_Of_Doests__c = (String.isNotBlank(wrap.response.dealer_control_of_doests) && wrap.response.dealer_control_of_doests == 'Y') ? true : false;
                   dealerRel.Dealer_Doe_Status__c = (String.isNotBlank(wrap.response.dealer_doe_status) && wrap.response.dealer_doe_status == 'A') ? true : false;
                   dealerRel.Interactive_Order_Entry__c = (String.isNotBlank(wrap.response.interactive_order_entry) && wrap.response.interactive_order_entry == 'Y') ? true : false;
                   dealerRel.Order_Inquiry__c = (String.isNotBlank(wrap.response.order_inquiry) && wrap.response.order_inquiry == 'Y') ? true : false;
                   dealerRel.Price_Inquiry__c = (String.isNotBlank(wrap.response.price_inquiry) && wrap.response.price_inquiry == 'Y') ? true : false;
                   dealerRel.Return_Inquiry__c = (String.isNotBlank(wrap.response.return_inquiry) && wrap.response.return_inquiry == 'Y') ? true : false; 
                   dealerRel.Dealer_Group__c = adWrap.dealer_group_number;
                   lstCreateRelationships.add(dealerRel);
               }
               //2.4 Insert the Relationships data in salesforce 
               if(!lstCreateRelationships.isEmpty()){
                   if(Schema.sObjectType.EDealer_Relationship__c.fields.Contact__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.User__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.ASI_Dealer_Code__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Customer_Name__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Sub_Code__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Division__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Currency_Code__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Download_Of_Reports__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Orders__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Allow_Upload_Of_Rma__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Availability_Inquiry__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Control_Of_Doests__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Doe_Status__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Interactive_Order_Entry__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Order_Inquiry__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Price_Inquiry__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Return_Inquiry__c.isCreateable()
                      && Schema.sObjectType.EDealer_Relationship__c.fields.Dealer_Group__c.isCreateable()
                     ){                        
                         insert lstCreateRelationships;                         
                     }
               }               
           }
        
        //return the status of "interactive order entry"
        //if "interactive order entry" is true then allow user to access edealer page. 
        //otherwise show error when user click on edealer tile (TCS dashboard --- home page )
        if(wrap.response != null){
            Dealer_Doe_Status = (String.isNotBlank(wrap.response.dealer_doe_status) && wrap.response.dealer_doe_status == 'A') ? true : false;
        }
        return Dealer_Doe_Status;
        
    }
    
    /****
* 17-02-2021
* This method use to get the Dealer Code for the ASI User
*/ 
    @AuraEnabled
    public static ASIUserDealersLocationResponseWrapper ASIUserDealerLocations(String name){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ASIUserDealersLocationResponseWrapper responseResultData = new ASIUserDealersLocationResponseWrapper();
        
        calloutDetails.put('endpoint','/asi/user-dealer-codes/dealers/'+name);
        calloutDetails.put('method','GET'); 
        System.debug('calloutDetails------'+calloutDetails);
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes for dealer codes==>> '+jsonRes);    
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null)
        {
         responseResultData = (ASIUserDealersLocationResponseWrapper)System.JSON.deserialize(jsonRes, ASIUserDealersLocationResponseWrapper.class);   
        } // 
        else{
           throw new AuraHandledException('Please contact with Administrator.');  
        }
           
        
        return responseResultData;
    }
    
    
    /****
* 18-02-2021
* This method use to get the ASI user name which is saved on user record
*/ 
    @AuraEnabled
    public static String checkASIUsername(){ 
        String asiUsername;
        User u = EDealerUserUtils.fetchLoggedInUserdetails();
        System.debug('User=>'+u);
        if(String.isNotBlank(u.ASI_Username__c)){
            asiUsername = u.ASI_Username__c;
        } 
        return asiUsername;
    }
    
    
    public class ASIAuthenticationResponseWrapper {
        @AuraEnabled
        public string error;
        @AuraEnabled
        public string response;
    }
    
    
    public class ASIUserDealersLocationResponseWrapper {
        @AuraEnabled
        public ASIUserDealersLocationWrapper response;
        @AuraEnabled
        public string error;
        @AuraEnabled
        public string message; //also an internel server error
        
    }
    
    public class ASIUserDealersLocationWrapper {
        @AuraEnabled
        public String primary_dealer{get;set;}
        @AuraEnabled
        public String dealer_doe_status{get;set;}
        @AuraEnabled
        public String interactive_order_entry{get;set;}
        @AuraEnabled
        public String allow_upload_of_orders{get;set;}
        @AuraEnabled
        public String allow_upload_of_rma{get;set;}
        @AuraEnabled
        public String availability_inquiry{get;set;}
        @AuraEnabled
        public String price_inquiry{get;set;}
        @AuraEnabled
        public String order_inquiry{get;set;}
        @AuraEnabled
        public String return_inquiry{get;set;}
        @AuraEnabled
        public String allow_download_of_reports{get;set;}
        @AuraEnabled
        public String dealer_control_of_doests{get;set;}
        @AuraEnabled
        public String currencycode{get;set;}  
        @AuraEnabled
        public String country{get;set;}
        @AuraEnabled
        public List<AccessibleDealer> Accessible_Dealers{get;set;}
    }
    
    public class AccessibleDealer {
        @AuraEnabled
        public String dealer_code{get;set;}
        @AuraEnabled
        public String dealer_suffix{get;set;}
        @AuraEnabled
        public String cstnam{get;set;}
        @AuraEnabled
        public String dealer_div{get;set;}
        @AuraEnabled
        public String dealer_group_number{get;set;}
    }
    
}