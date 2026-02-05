/*** 
* Name        :   EDealerMSL_CSL_RSL_cntrl
*  Description :   This is the apex class which is used for eDealerManualLockdown Report component
*/ 
public class EDealerMSL_CSL_RSL_cntrl {
    
    @AuraEnabled
    public static MSL_CSL_RSLResponseWrapper fetchAWSMSL_CSL_RSLReport(String reportParamsJson){
        try{
            // saving the object to be returned
            MSL_CSL_RSLResponseWrapper ReportResultData = new MSL_CSL_RSLResponseWrapper();
            
            // creating map for API Call
            system.debug('objCSLRSLWrapper::'+reportParamsJson);
            
            // converting json to Apex
            CSLRSLReportWrapper reportParams = (CSLRSLReportWrapper) 
                JSON.deserialize(reportParamsJson, CSLRSLReportWrapper.class);
            system.debug('\n--reportParams--'+reportParams);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/csl-rsl-report-filter/dealer/');			
               }
            else{
                calloutDetails.put('endpoint','/csl-rsl/report/report');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerMSL_CSL_RSL_cntrl');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            // Call EDealerLogUtils class based on response status code        					
            if(jsonRes != null)
                ReportResultData = (MSL_CSL_RSLResponseWrapper) System.JSON.deserialize(jsonRes, MSL_CSL_RSLResponseWrapper.class);
            
            
            //RETURN
            ReportResultData.dataJSON = JSON.serialize(ReportResultData.response);
            ReportResultData.languageTranslation = new map<string,string>();
           
            ReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('CSL RSL Report');
            
            //End value transalation language data
            system.debug('languageTranslation::'+ReportResultData.languageTranslation);
            return ReportResultData;
        }
        catch(Exception ex){
            system.debug('ex'+ex.getLineNumber());
            EDealerLogUtils.createExceptionLog('EDealerMSL_CSL_RSL_cntrl'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(CSLRSLReportWrapper reportParams){
        
        // divison should not be blank
        if(reportParams.dealerCodes == null
           || reportParams.dealerCodes.isEmpty()){
               throw new AuraHandledException('No Dealer code selected.');
           }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealerCodes);
        gen.writeNumberField('offset', reportParams.offSet);
        gen.writeNumberField('limit', reportParams.recLimit);
        gen.writeStringField('dealer_division',reportParams.dealer_division);
        
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
        String requestBody = gen.getAsString();        
        system.debug('\n--requestBody--'+requestBody);        
        return requestBody;
    }
    
    
    /*** This class will use to parse the MSL_CSL_RSL Report JSON ***/
    public class MSL_CSL_RSLResponseWrapper{
        @AuraEnabled public List<MSL_CSL_RSLRecordWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public String error;
        @AuraEnabled public integer RowCount;
        @AuraEnabled public string dataJSON;
    }
    public class MSL_CSL_RSLRecordWrapper {
        @AuraEnabled public String extended_yes_no;
        @AuraEnabled public String grp_nbr;
        @AuraEnabled public String dealer;
        //@AuraEnabled public String pod;
        @AuraEnabled public String program;
        @AuraEnabled public String type;
        @AuraEnabled public String initialdate;
        @AuraEnabled public String enddate;
        @AuraEnabled public String renewable;
        @AuraEnabled public String item {get;set;}
        @AuraEnabled public Integer rbq;
        @AuraEnabled public Integer minss;
        @AuraEnabled public String abc;
        @AuraEnabled public Decimal oh;
        @AuraEnabled public Integer month_12_hits;
        @AuraEnabled public Integer month_12_demand;
        @AuraEnabled public String dnet;
        @AuraEnabled public String ext_dnet;
        @AuraEnabled public String Estimated_ABC_Once_Expired;
        @AuraEnabled public String dealer_supplier_code;
        @AuraEnabled public String stock_class;
        @AuraEnabled public String stock_class_description;
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class CSLRSLReportWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}