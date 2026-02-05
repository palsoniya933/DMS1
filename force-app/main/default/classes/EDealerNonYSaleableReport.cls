public class EDealerNonYSaleableReport {
   @AuraEnabled
    public static NonYSaleableReportResponseWrapper fetchAWSNonYSaleableRecordsData(String reportParamsJson){
        try{
        // saving the object to be returned
        NonYSaleableReportResponseWrapper nYSReportData = new NonYSaleableReportResponseWrapper();
        
        // converting json to Apex
        NonYWrapper reportParams = (NonYWrapper) JSON.deserialize(reportParamsJson, NonYWrapper.class);
        
        // saving the http params
        map<string,object> calloutDetails = new map<string,object>();
        
        // checking if the filter values are selected 
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               calloutDetails.put('endpoint','/non-y-saleableReport-filter/dealer');			
           }
        else{
            calloutDetails.put('endpoint','/non-y-saleableReport/dealer');      
        }
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(reportParams));	        
        calloutDetails.put('classname','EDealerNonYSaleableReport');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
       System.Debug('--getEndPointParameters(reportParams)----'+ getEndPointParameters(reportParams));
          System.Debug('--JSON----'+ jsonRes);
            if(jsonRes != null){
                nYSReportData = (NonYSaleableReportResponseWrapper) System.JSON.deserialize(jsonRes, NonYSaleableReportResponseWrapper.class);    
            }
        //RETURN
        nYSReportData.dataJSON = JSON.serialize(nYSReportData.response);
        nYSReportData.languageTranslation = new map<string,string>();
        
        nYSReportData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Non-Y Saleable Report');
        
        nYSReportData.dataJSON = JSON.serialize(nYSReportData.response);
        
        return nYSReportData;
                 
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerNonYSaleableReport',ex.getMessage(),ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(NonYWrapper reportParams){
        
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
               
               gen.writeStringField('field',reportParams.field.toUpperCase());
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();        
        
        //RETURN
        return pretty;
    }
    
    
    /*** This class will use to parse the Manual Lockdown Report JSON ***/
    public class NonYSaleableReportResponseWrapper {
        @AuraEnabled public List<NonYSaleableReportWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
    public class NonYSaleableReportWrapper {
        @AuraEnabled   public String grp_nbr;
        @AuraEnabled public String loc;
        @AuraEnabled public String si;
        @AuraEnabled  public String abc;
        @AuraEnabled public String item;
        @AuraEnabled  public String descr;
        @AuraEnabled public Decimal dnet;
        @AuraEnabled public Decimal on_hand;
        @AuraEnabled public String dlrsplrcode;
       @AuraEnabled  public Decimal demand_12m;
        @AuraEnabled public Integer hits_12m;
        @AuraEnabled public Decimal mtd_qty;
         @AuraEnabled public String chassis_req;
        @AuraEnabled  public Decimal std_pkg_qty;
        @AuraEnabled  public String op_comment;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    public class NonYWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
       
        
    }
}