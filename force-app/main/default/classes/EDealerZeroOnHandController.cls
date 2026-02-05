/*** 
* 	Name        :   EDealerZeroOnHandController
*  	Description :  	This is the apex class which is used for EDealerZeroOnHandController component
*/ 
public class EDealerZeroOnHandController {
    @AuraEnabled
    public static ZeroOnHandReportResponseWrapper fetchAWSZeroOnHandReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            ZeroOnHandReportResponseWrapper awsReportResultData = new ZeroOnHandReportResponseWrapper();
            
            // converting json to Apex
            ZeroOnHandWrapper reportParams = (ZeroOnHandWrapper) JSON.deserialize(reportParamsJson, ZeroOnHandWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/zero-on-hand-report-filter/dealer');			
               }
            else{
                calloutDetails.put('endpoint','/zero-on-hand-report/dealer');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));
            calloutDetails.put('classname','EDealerZeroOnHandController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            System.debug('--getEndPointParameters(reportParams)--' + getEndPointParameters(reportParams));
            // Call EDealerLogUtils class based on response status code  
            System.debug('--jsonRes--' + jsonRes );      					
            if(jsonRes != null){
                awsReportResultData = (ZeroOnHandReportResponseWrapper) System.JSON.deserialize(jsonRes, ZeroOnHandReportResponseWrapper.class);
            }
            
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            //End value transalation language data
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Zero On-Hand');
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerZeroOnHandController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(ZeroOnHandWrapper reportParams){
        
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
        
        /** setting the filter params ***/
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               
               gen.writeStringField('dealer_division',reportParams.dealer_division);
               gen.writeStringField('field',reportParams.field.toUpperCase());
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        gen.writeEndObject();
        
        // Get the JSON string.
        String requestBody = gen.getAsString();               
        return requestBody;
    }
    
    @AuraEnabled
    public static map<string,string> getTranslateColumnHeaders(){
        return EDealerMetadataUtility.translateColumnHeaders('Zero On-Hand');
    }
    
    /*********************** Wrapper Class Section ************************/    
    
    public class ZeroOnHandReportResponseWrapper {
        @AuraEnabled public List<ZeroOnHandReportWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
     //  @AuraEnabled public List<RowCountClass> RowCount;
       @AuraEnabled public  Integer RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer RowCount;
    }
    
    public class ZeroOnHandReportWrapper{
       
        @AuraEnabled public String mdi_comment;
        @AuraEnabled  public String dealer_response;
        @AuraEnabled  public String grp_nbr;
        @AuraEnabled  public String loc;
        @AuraEnabled public String abc;
        @AuraEnabled  public String item;
        @AuraEnabled public String dlrsplrcode;
        @AuraEnabled   public String dist_chan;
        @AuraEnabled   public Integer consecutive_days_stocked_out;
        @AuraEnabled    public Decimal oh;
        @AuraEnabled  public Decimal dif_on_order;
        @AuraEnabled   public Decimal distrb_on_order;
        @AuraEnabled   public String recent_stock_po;
        @AuraEnabled   public String recent_order;
        @AuraEnabled  public String ship_chan;
        @AuraEnabled  public String order_status;
        @AuraEnabled   public Date order_date;
        @AuraEnabled  public Date ship_date;
        @AuraEnabled  public Integer days_since_ship;
        @AuraEnabled   public String minimum_name;
        @AuraEnabled  public String rsl_csl_msl;
        @AuraEnabled  public String manual_lock;
        @AuraEnabled  public String comment;
        @AuraEnabled  public Date sunset_date;
        @AuraEnabled  public Decimal mtd_dmd;
        @AuraEnabled   public Integer hits_12m;
        @AuraEnabled   public Integer abc_tots;
        @AuraEnabled  public Decimal dmd_12m;
        @AuraEnabled  public Decimal minss;
        @AuraEnabled public Decimal std_pkg_qty;
        @AuraEnabled  public String distchan;
        @AuraEnabled  public String stk_cls;
        @AuraEnabled  public String stk_cls_desc;
        @AuraEnabled  public Integer est_lead_time_days;
        @AuraEnabled  public String item_desc;
        @AuraEnabled  public String sale_ind;
        @AuraEnabled  public String ssd_to;
        @AuraEnabled  public Decimal dlrnet;
    
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class ZeroOnHandWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}