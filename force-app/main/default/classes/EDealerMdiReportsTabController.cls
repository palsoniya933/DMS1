public without sharing class EDealerMdiReportsTabController {
    
    @AuraEnabled
    public static List<String> getUserList(){  
        List<EDealer_Analyst__mdt> lstAnalysts = new List<EDealer_Analyst__mdt>();
        List<String> names = new List<String>();
        if(Schema.sObjectType.EDealer_Analyst__mdt.fields.First_Name__c.isAccessible()
           && Schema.sObjectType.EDealer_Analyst__mdt.fields.Last_Name__c.isAccessible()
          ){
              lstAnalysts = [SELECT First_Name__c,Last_Name__c from EDealer_Analyst__mdt LIMIT 2000];
          }
        for(EDealer_Analyst__mdt analyst : lstAnalysts){            
            String name = analyst.First_Name__c+' '+analyst.Last_Name__c;            
            names.add(name);
        }         
        return names;
    }    
    
    @AuraEnabled
    public static EDealerContainerController.UserWrapper getUserDetail(string SelectedUser){
        
        EDealerContainerController.UserWrapper userWrap = new EDealerContainerController.UserWrapper();
        
        //Get the ASI username
        User u = EDealerUserUtils.fetchLoggedInUserdetails();
        //api call to get accessible dealer codes
        string selectedUserName = u.Name.toUppercase();
        if(!String.isBlank(SelectedUser)){
            selectedUserName = SelectedUser.toUppercase();
        }
        //system.debug('\n--selectedUserName--'+selectedUserName);
        MDIAnalystResponseWrapper analystDetails =  fetchAWSAnalystData(selectedUserName);
        
        if(analystDetails != null && analystDetails.response != null && !analystDetails.response.isEmpty()){
            List<EDealer_Relationship__c> lstCreateRelationships = new List<EDealer_Relationship__c>();
            Map<String,String> dealerLocs = new Map<String,String>();
            for(MDIAnalystDealerWrapper wrap : analystDetails.response){
                //to remove duplicate locations (using map)
                dealerLocs.put(wrap.loc,wrap.loc);
            }
            
            if(!dealerLocs.isEmpty()){
                //sort the dealercodes in Ascending order
                List<String> locs = dealerLocs.values();
                locs.sort();
                for(String dcode : locs){
                    EDealer_Relationship__c dealerRel = new EDealer_Relationship__c();
                    dealerRel.ASI_Dealer_Code__c = dcode;
                    dealerRel.Price_Inquiry__c = true;//default
                    lstCreateRelationships.add(dealerRel);
                }
            }
            
            
            if(analystDetails.response[0].div == 'PB'){
                userWrap.division = 'P';  
            }else if(analystDetails.response[0].div == 'KW'){
                userWrap.division = 'K';  
            }
            
            userWrap.accessibleDealersLocation = lstCreateRelationships;
        }
        else{
            //throw new AuraHandledException('you do not have any dealer location.');
        }
        
        //system.debug('\n---userWrap-'+userWrap);
        return userWrap;
        
    }
    
    
    public static MDIAnalystResponseWrapper fetchAWSAnalystData(String analystName){
        MDIAnalystResponseWrapper awsReportResultData = new MDIAnalystResponseWrapper();
        
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        
        calloutDetails.put('endpoint','/mdi-analyst/dealer-location/dealer?');       
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body','{"ANALYST" : ["'+analystName+'"]}');
        calloutDetails.put('classname','EDealerMdiReportsTabController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);     
        //system.debug('\n--jsonRes--'+jsonRes);
        
        if(jsonRes != null)
            awsReportResultData = (MDIAnalystResponseWrapper)System.JSON.deserialize(jsonRes, MDIAnalystResponseWrapper.class);
        
        return awsReportResultData;
    }
    
    /*** To save Quarter To Date Report Api result ***/
    public class MDIAnalystResponseWrapper{
        @AuraEnabled public List<MDIAnalystDealerWrapper> response {get;set;}
        @AuraEnabled public String error  {get;set;}
    }
    
    public class MDIAnalystDealerWrapper{
        @AuraEnabled public String div  {get;set;}
        @AuraEnabled public String analyst  {get;set;}
        @AuraEnabled public String grp_nbr  {get;set;}
        @AuraEnabled public String loc  {get;set;}
    }
    
    
}