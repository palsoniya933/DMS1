public class EDealerToggleNOFReportController {
    @AuraEnabled
    public static toggleNOFReportResponseWrapper fetchToggleNOFRecordsData(String reportParamsJson){
        try{
            // saving the object to be returned
            toggleNOFReportResponseWrapper nYSReportData = new toggleNOFReportResponseWrapper();
            
            // converting json to Apex
            toggleWrapper reportParams = (toggleWrapper) JSON.deserialize(reportParamsJson, toggleWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();            
            calloutDetails.put('endpoint','/Toggle_NOF_ReportFilter/dealers'); 
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerToggleNOFReportController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            System.Debug('--getEndPointParameters(reportParams)----' +calloutDetails);
            System.Debug('--JSON----'+ jsonRes);
            if(jsonRes != null){
                nYSReportData = (toggleNOFReportResponseWrapper) System.JSON.deserialize(jsonRes, toggleNOFReportResponseWrapper.class);    
            }
            //RETURN
            nYSReportData.dataJSON = JSON.serialize(nYSReportData.response);
            nYSReportData.languageTranslation = new map<string,string>();
            
            nYSReportData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('toggleNOF_Report');
            
            nYSReportData.dataJSON = JSON.serialize(nYSReportData.response);
            
            return nYSReportData;
            
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('eDealerToggleNOFReport',ex.getMessage(),ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(toggleWrapper reportParams){
        
        // divison should not be blank
        if(reportParams.dealerCodes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(reportParams.dealerCodes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        
        // from location should not be blank
        if(String.isBlank(reportParams.dealer_division)){
            throw new AuraHandledException('Division not available');
        }
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealerCodes);
        gen.writeStringField('dealer_division', reportParams.dealer_division);
        gen.writeNumberField('offset', reportParams.offSet);
        gen.writeNumberField('limit', reportParams.recLimit);
        
        /** setting the filter params ***/
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){           
               
               gen.writeStringField('field',reportParams.field);
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        else
        {
            
            gen.writeStringField('field','');
            gen.writeStringField('operator','');
            gen.writeStringField('value',''); 
        }
        
        
        
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();        
        
        //RETURN
        return pretty;
    }
    
    
    /*** This class will use to parse the Manual Lockdown Report JSON ***/
    public class toggleNOFReportResponseWrapper {
        @AuraEnabled public List<toggleNOFReportWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
    public class toggleNOFReportWrapper {
        @AuraEnabled  public String grp_nbr;
        @AuraEnabled public String dealer ;
        @AuraEnabled   public String pdc_saleableind;
        @AuraEnabled public String pdc_abc ;
        @AuraEnabled public String pdc_item_add_to_dif ;
        @AuraEnabled public String pdc_stk_class; 
        @AuraEnabled  public String dist_abc ;
        @AuraEnabled  public String dist_item ;
        @AuraEnabled  public Integer dist_12mth_hits;
        @AuraEnabled public Decimal dist_mtd_dmd ;
        @AuraEnabled  public Decimal dist_12mth_dmd;
        @AuraEnabled  public Integer dist_abc_tots ;
        
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    public class toggleWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
        
        
    }
}