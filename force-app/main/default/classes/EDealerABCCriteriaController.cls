/*** 
* Name        :   EDealerABCCriteriaController
*  Description :   This is the apex class which is used for eDealerABCCriteriaReport component
*/ 
public class EDealerABCCriteriaController {
    
    @AuraEnabled
    public static ABCCriteriaReportResponseWrapper fetchAWSABCCriteriaReportData(string reportParamsJson){
        try{
            // saving the object to be returned
            ABCCriteriaReportResponseWrapper awsReportResultData = new ABCCriteriaReportResponseWrapper();
            
            // converting json to Apex
            ABCWrapper reportParams = (ABCWrapper) 
                JSON.deserialize(reportParamsJson, ABCWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/abc-criteria-report-filter/dealer');			
               }
            else{
                calloutDetails.put('endpoint','/abc-criteria-report/dealer?');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerABCCriteriaController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            system.debug('jsonRes1:::'+jsonRes);  
            
            // parsing the actual results
            if(jsonRes != null){
                awsReportResultData = (ABCCriteriaReportResponseWrapper) System.JSON.deserialize(jsonRes, ABCCriteriaReportResponseWrapper.class);
            }
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            //End value transalation language data
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('ABC Criteria');
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerABCCriteriaController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(ABCWrapper reportParams){
        
        // divison should not be blank
        if(String.isBlank(reportParams.dealer_division)){
            throw new AuraHandledException('Division not provided');
        }        
        // should not be null
        if(reportParams.dealer_codes == null){
            throw new AuraHandledException('Please select atleast one Dealer Location.');
        }
        //should not be blank
        if(reportParams.dealer_codes.isEmpty()){
            throw new AuraHandledException('Please select atleast one Dealer Location.');
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealer_codes);
        gen.writeStringField('dealer_division', reportParams.dealer_division);
        gen.writeNumberField('offset', reportParams.offset);
        gen.writeNumberField('limit', reportParams.recLimit);
        
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
    
    public class ABCCriteriaReportResponseWrapper {
        @AuraEnabled public List<ABCCriteriaWrapper> response {get;set;}
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error {get;set;}
    }
    
    public class ABCCriteriaWrapper {
        @AuraEnabled public String loc {get;set;}
        @AuraEnabled public String distchan {get;set;}
        @AuraEnabled public String dlrsplrcd {get;set;}
        @AuraEnabled public String stkclass {get;set;}
        @AuraEnabled public String abc {get;set;}
        @AuraEnabled public Double abc_level {get;set;}
        @AuraEnabled public Decimal abccriteriaminqty {get;set;}
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class ABCWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offset;
        @AuraEnabled public List<String> dealer_codes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}