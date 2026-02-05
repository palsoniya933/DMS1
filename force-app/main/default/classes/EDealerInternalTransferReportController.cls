/***
* Name         :   EDealerInternalTransferReportController
* Description  :   This method will be used in the internal transfer report component
***/

public without sharing class EDealerInternalTransferReportController { 
       
    @AuraEnabled
    public static InternalTransferResponseWrapper fetchAWSInternalTransferReportData(String reportParamsJson){
        try{ 
            // saving the object to be returned
            InternalTransferResponseWrapper awsReportResultData = new InternalTransferResponseWrapper();
            
            // converting json to Apex
            InternalWrapper reportParams = (InternalWrapper)JSON.deserialize(reportParamsJson, InternalWrapper.class);
            system.debug('\n--reportParams--'+reportParams);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/internal-transfer-report-filter/dealer');			
               }
            else{
                calloutDetails.put('endpoint','/internal-transfer-report/dealer');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerInternalTransferReportController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            if(jsonRes != null){
                awsReportResultData = (InternalTransferResponseWrapper) System.JSON.deserialize(jsonRes, InternalTransferResponseWrapper.class);
            }
            
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Internal Transfer Report');
            //End value transalation language data
            system.debug('languageTranslation::'+awsReportResultData.languageTranslation);
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerInternalTransferReportController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
        
    }
    
    @AuraEnabled
    public static InternalTransferResponseWrapper fetchFilteredData(String division, string groupCode, List<string> lstFromLocation, List<string> lstToLocation, Integer offSet, Integer recLimit, String filterString){
		List<FilterWrapper> filters = (List<FilterWrapper>) JSON.deserialize(filterString, List<FilterWrapper>.class);
        InternalTransferResponseWrapper awsReportResultData = new InternalTransferResponseWrapper();
        return awsReportResultData;
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(InternalWrapper reportParams){
        
        // divison should not be blank
        if(String.isBlank(reportParams.dealer_division)){
            throw new AuraHandledException('Division not provided');
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('from_loc', reportParams.from_loc);
        gen.writeObjectField('to_loc', reportParams.to_loc);
        gen.writeStringField('dealer_division', reportParams.dealer_division);
        
        /** setting the filter params ***/
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){           
               
               gen.writeStringField('field',reportParams.field.toUpperCase());
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
/*****
*  This classes will use to parse the Internal Transfer API JSON Data
**/
    public class InternalTransferResponseWrapper {
        @AuraEnabled public List<InternalTransferWrapper> response{get;set;}
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error{get;set;}
    }
    public class InternalTransferWrapper {
        
        @AuraEnabled public String from_distchan{get;set;}
        @AuraEnabled public String to_loc{get;set;}
        @AuraEnabled public Double from_dealernet{get;set;}
        @AuraEnabled public String to_distchan{get;set;}
        @AuraEnabled public Integer from_ohoo{get;set;}
        @AuraEnabled public String to_abc{get;set;}
        @AuraEnabled public Integer oh{get;set;}
        @AuraEnabled public Integer TO_12_Mth_Dmd{get;set;}
        @AuraEnabled public Integer FROM_12_Mth_Hits{get;set;}
        @AuraEnabled public Integer TO_12_Mth_Hits{get;set;}
        @AuraEnabled public Integer FROM_12_Mth_Dmd{get;set;}
        @AuraEnabled public Integer to_ohoo{get;set;}
        @AuraEnabled public String from_abc{get;set;}
        @AuraEnabled public Integer Opportunity_Qty{get;set;}
        @AuraEnabled public String from_loc{get;set;}
        @AuraEnabled public Integer Transfer_Qty{get;set;}
        @AuraEnabled public String Part_Number{get;set;}
        @AuraEnabled public Double Transfer_Value{get;set;}
        @AuraEnabled public String grp_nbr{get;set;}
    }
    
    public class FilterWrapper{
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled
        public String fieldOperator {get;set;}
        @AuraEnabled
        public String fieldValue {get;set;}
    }
    
    public class InternalWrapper{
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
        @AuraEnabled public List<String> from_loc;
        @AuraEnabled public List<String> to_loc;
    }
}