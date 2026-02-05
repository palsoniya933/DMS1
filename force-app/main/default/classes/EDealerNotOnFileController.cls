/*** 
* Name        :   EDealerNotOnFileController
*  Description :   This is the apex class which is used for eDealerNotOnFileReport component
*/ 
public class EDealerNotOnFileController {
    
    @AuraEnabled
    public static NotOnFileAPIResponseWrapper fetchAWSNotOnFileReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            NotOnFileAPIResponseWrapper awsReportResultData = new NotOnFileAPIResponseWrapper();
            
            // converting json to Apex
            NotOnWrapper reportParams = (NotOnWrapper) 
                JSON.deserialize(reportParamsJson, NotOnWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/not-on-file-report-filter/dealership');			
               }
            else{
                calloutDetails.put('endpoint','/not-on-report-file/dealer');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerNotOnFileController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            if(jsonRes != null){
                awsReportResultData = (NotOnFileAPIResponseWrapper)System.JSON.deserialize(jsonRes, NotOnFileAPIResponseWrapper.class);
            }
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            //End value transalation language data
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Not on File');            
            return awsReportResultData;
        }
        catch(Exception ex){
            system.debug('ex::'+ex.getLineNumber());
            EDealerLogUtils.createExceptionLog('EDealerNotOnFileController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage()+'Line Number '+ex.getLineNumber());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(NotOnWrapper reportParams){
        // divison should not be blank
        if(reportParams.dealer_codes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(reportParams.dealer_codes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        
        // from location should not be blank
        if(String.isBlank(reportParams.dealer_division)){
            throw new AuraHandledException('Division not available');
        }
        
        //JSON Generator
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
    
    public class NotOnFileAPIResponseWrapper{
        @AuraEnabled public List<NotOnFileWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error;
    }
    
    public class NotOnFileWrapper {
        
        @AuraEnabled public String grp_nbr; 
        @AuraEnabled public String dealer;
        @AuraEnabled public String saleable_ind;
        @AuraEnabled public String abc;
        @AuraEnabled public String item;
        @AuraEnabled public String item_desc;
        @AuraEnabled public String stock_class;
        @AuraEnabled public String program;
        @AuraEnabled public String initialdate;
        @AuraEnabled public String enddate;
        @AuraEnabled public String program_status;
       
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class NotOnWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offset;
        @AuraEnabled public List<String> dealer_codes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
    
}