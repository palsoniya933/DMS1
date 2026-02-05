public without sharing  class eDealerOPCReportController {
   
    @AuraEnabled
    public static OPCReportResponseWrapper fetchAWSOPCReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            OPCReportResponseWrapper awsReportResultData = new OPCReportResponseWrapper();  
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            calloutDetails.put('endpoint','/OPC_Dealer_Sales_report/monthly');
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParametersForGroup(reportParamsJson));
            calloutDetails.put('classname','eDealerOPCReportController');	
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            if(jsonRes != null){
                awsReportResultData = (OPCReportResponseWrapper) System.JSON.deserialize(jsonRes, OPCReportResponseWrapper.class);
            }
            
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('OPC Report');
            System.debug('awsReportResultData'+awsReportResultData);
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('eDealerOPCReportController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage()); 
        }
        
        
    }    
    
    private static String getEndPointParametersForGroup(String reportParamsJson){
        // Get the JSON string.
        String pretty ='';
        // converting json to Apex
        InternalWrapper reportParams = (InternalWrapper)JSON.deserialize(reportParamsJson, InternalWrapper.class);
        system.debug('\n--reportParams--'+reportParams);
        
        //get current user details
        User u = EDealerUserUtils.fetchLoggedInUserdetails();
        List<edealer_relationship__c> lsteDealerRel = new List<edealer_relationship__c>();
        
        if(u.IsPortalEnabled == true){
            lsteDealerRel = EDealerRelationshipUtil.getRelationships(u.ContactId);
        }else{
            lsteDealerRel = EDealerRelationshipUtil.getUserRelationships(u.Id);
        }
        
        if(!lsteDealerRel.isEmpty()){
            Map<String,edealer_relationship__c> mapStrByGcode=new Map<String,edealer_relationship__c>();
            
              List<edealer_relationship__c> lstDealerWithoutZCode = new List<edealer_relationship__c>();
            
            lstDealerWithoutZCode =[select id,Dealer_Group__c,ASI_Dealer_code__c from edealer_relationship__c where Id IN :lsteDealerRel AND Dealer_Group__c!=NULL AND (NOT ASI_Dealer_code__c LIKE 'Z%')];
            
            for(edealer_relationship__c gCode:lstDealerWithoutZCode){
                mapStrByGcode.put(gCode.Dealer_Group__c,gCode);//This is map and hence it will always have unique values 
            }
            
            List<String> dealerList = new List<String>();
            
            for(edealer_relationship__c lstDeal: mapStrByGcode.values()) {
                dealerList.add(lstDeal.Dealer_Group__c);
            }
            
            System.debug('reportParams.customer_Entered'+ reportParams.customer_Entered);
            //JSON Generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeObjectField('country', reportParams.country);//country
            gen.writeObjectField('type', reportParams.branch_Type);//type
            gen.writeObjectField('year', reportParams.year);//year
            gen.writeObjectField('dealers',dealerList);//dealers

            if(reportParams.customer_Entered =='customer-entered'){
                gen.writeObjectField('user',reportParams.customer_Entered);//user   
            }
            gen.writeEndObject();
            
            // Get the JSON string.
            pretty = gen.getAsString();
        }
        return pretty;
    }
    
    @AuraEnabled
    public static OPCBranchDealerCodeReportResponseWrapper fetchAWSOPCBarnchReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            OPCBranchDealerCodeReportResponseWrapper awsReportResultData = new OPCBranchDealerCodeReportResponseWrapper();  
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            calloutDetails.put('endpoint','/OPC_Dealer_Sales_report/monthly');
            calloutDetails.put('method','POST'); 	
            calloutDetails.put('body',getEndPointParametersForBranch(reportParamsJson));
            calloutDetails.put('classname','eDealerOPCReportController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            if(jsonRes != null){
                awsReportResultData = (OPCBranchDealerCodeReportResponseWrapper) System.JSON.deserialize(jsonRes, OPCBranchDealerCodeReportResponseWrapper.class);
            }
            
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('OPC Report Branch');
            System.debug('awsReportResultData fetchAWSOPCBarnchReportData'+awsReportResultData);
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('eDealerOPCReportController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage()); 
        }
        
        
    }   
    
    private static String getEndPointParametersForBranch(String reportParamsJson){
        
        // converting json to Apex
        InternalWrapper reportParams = (InternalWrapper)JSON.deserialize(reportParamsJson, InternalWrapper.class);
        system.debug('\n--reportParams--'+reportParams);
        
        List<String> lstDealers = new List<String>();
        lstDealers.add(reportParams.dealer_Code);
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('country', reportParams.country);//country
        gen.writeObjectField('type', reportParams.branch_Type);//type
        gen.writeObjectField('year', reportParams.year);//year
        gen.writeObjectField('dealers',lstDealers);//dealers
        System.debug('reportParams.customer_Entered '+reportParams.customer_Entered);
        if(reportParams.customer_Entered == 'customer-entered'){
            gen.writeObjectField('user',reportParams.customer_Entered);//user   
        }        
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        System.debug('pretty'+pretty);
        return pretty;
    }
    
    public class OPCReportResponseWrapper {
        @AuraEnabled public List<InternalOPCReportWrapper> response{get;set;}
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error{get;set;}
    }
    
    public class InternalOPCReportWrapper {
        @AuraEnabled public String dealership_group_code;
        @AuraEnabled public String dealer_name;
        @AuraEnabled public Decimal jan;
        @AuraEnabled public Decimal feb;
        @AuraEnabled public Decimal mar;
        @AuraEnabled public Decimal apr;
        @AuraEnabled public Decimal may;
        @AuraEnabled public Decimal jun;
        @AuraEnabled public Decimal jul;
        @AuraEnabled public Decimal aug;
        @AuraEnabled public Decimal sept;
        @AuraEnabled public Decimal oct;
        @AuraEnabled public Decimal nov;
        @AuraEnabled public Decimal dece;
        @AuraEnabled public Decimal total;
    }
    
    public class OPCBranchDealerCodeReportResponseWrapper {
        @AuraEnabled public List<InternalOPCBranchDealerCodeReportWrapper> response{get;set;}
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error{get;set;}
    }
    
    public class InternalOPCBranchDealerCodeReportWrapper {
        @AuraEnabled public String branch_dealer_code;
        @AuraEnabled public String branch_name;
        @AuraEnabled public Decimal jan;
        @AuraEnabled public Decimal feb;
        @AuraEnabled public Decimal mar;
        @AuraEnabled public Decimal apr;
        @AuraEnabled public Decimal may;
        @AuraEnabled public Decimal jun;
        @AuraEnabled public Decimal jul;
        @AuraEnabled public Decimal aug;
        @AuraEnabled public Decimal sept;
        @AuraEnabled public Decimal oct;
        @AuraEnabled public Decimal nov;
        @AuraEnabled public Decimal dece;
        @AuraEnabled public Decimal total;
    }
    
    
    public class InternalWrapper{
        @AuraEnabled public String country;
        @AuraEnabled public String branch_Type;
        @AuraEnabled  public String year;
        @AuraEnabled public String dealer_Code;
        @AuraEnabled public String customer_Entered;
    }    
}