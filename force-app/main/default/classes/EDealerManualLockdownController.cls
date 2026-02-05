/*** 
* Name        :   EDealerManualLockdownController
*  Description :   This is the apex class which is used for eDealerManualLockdown Tile/Report component
*/ 
public class EDealerManualLockdownController {
    
    @AuraEnabled
    public static ManualLockDownKPIResponseWrapper fetchAWSManualLockdownKPIData(list<String> dealerCodes, String division){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();       
        ManualLockDownKPIResponseWrapper awsMLKPIResultData = new ManualLockDownKPIResponseWrapper();
        calloutDetails.put('endpoint','/manual-lock-down-parts/kpi/dealer');        
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes));
                System.Debug('--getEndPointParameters(dealerCodes)----'+ getEndPointParameters(dealerCodes));

        calloutDetails.put('classname','EDealerManualLockdownController');        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes ------------ ' + jsonRes);
        
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null){
            awsMLKPIResultData = (ManualLockDownKPIResponseWrapper)System.JSON.deserialize(jsonRes, ManualLockDownKPIResponseWrapper.class);
        }
        
        
        
        return awsMLKPIResultData; 
    }
    
    private static String getEndPointParameters(List<String> dealerCodes){
    	//JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    @AuraEnabled
    public static ManualLockDownReportResponseWrapper fetchAWSManualLockDownRecordsData(String reportParamsJson){
        try{
        // saving the object to be returned
        ManualLockDownReportResponseWrapper mlReportData = new ManualLockDownReportResponseWrapper();
        
        // converting json to Apex
        ManualWrapper reportParams = (ManualWrapper) JSON.deserialize(reportParamsJson, ManualWrapper.class);
        
        // saving the http params
        map<string,object> calloutDetails = new map<string,object>();
        
        // checking if the filter values are selected 
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               calloutDetails.put('endpoint','/manual-parameter-report-filter/dealer');			
           }
        else{
            calloutDetails.put('endpoint','/manual-lock-down-parts/report/dealer?');      
        }
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(reportParams));	        
        calloutDetails.put('classname','EDealerManualLockdownController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            if(jsonRes != null){
                mlReportData = (ManualLockDownReportResponseWrapper) System.JSON.deserialize(jsonRes, ManualLockDownReportResponseWrapper.class);    
            }
        //RETURN
        mlReportData.dataJSON = JSON.serialize(mlReportData.response);
        mlReportData.languageTranslation = new map<string,string>();
        
        mlReportData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Manual Parameters Report');
        
        mlReportData.dataJSON = JSON.serialize(mlReportData.response);
        
        return mlReportData;
                 
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerManualLockdownController',ex.getMessage(),ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(ManualWrapper reportParams){
        
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
        
        if(reportParams.startDate == null){
            throw new AuraHandledException('No Start Date has Selected');
        }
        if(reportParams.endDate == null){
            throw new AuraHandledException('No End Date has Selected');
        }
        
        String strStartDate = String.valueOf((reportParams.startDate).year()) + '-' + String.valueOf((reportParams.startDate).month()) + '-' + String.valueOf((reportParams.startDate).day());
        String strEndDate = String.valueOf((reportParams.endDate).year()) + '-' + String.valueOf((reportParams.endDate).month()) + '-' + String.valueOf((reportParams.endDate).day());
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealerCodes);
        gen.writeStringField('dealer_division', reportParams.dealer_division);
        gen.writeStringField('StartDate', strStartDate);
        gen.writeStringField('EndDate', strEndDate);
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
    public class ManualLockDownReportResponseWrapper {
        @AuraEnabled public List<ManualLockDownRecordWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
public class ManualLockDownRecordWrapper {

        @AuraEnabled public String grp_nbr;

        @AuraEnabled public String division;

        @AuraEnabled public String loc;

        @AuraEnabled public String item;

        @AuraEnabled public String item_desc;

        @AuraEnabled public String sale_ind_cd;

        @AuraEnabled public String dnet;

        @AuraEnabled public String p_dlrsplrcode;

        @AuraEnabled public String vndr_id;

        @AuraEnabled public String p_stkclass;

        @AuraEnabled public String p_12monthhitcount;

        @AuraEnabled public String p_abc {get;set;} 

        @AuraEnabled public String oh;

        @AuraEnabled public String p_mtddemandqty;

        @AuraEnabled public String p_12monthdemandqty;

        @AuraEnabled public String p_commenttext ;

        @AuraEnabled public String actual_abc ;

        @AuraEnabled public String p_sunsetdate;

        @AuraEnabled public String minss;

        @AuraEnabled public String mpscovdur;

        @AuraEnabled public String sscov;

        @AuraEnabled public String p_distchan;

        @AuraEnabled public String p_dlrrslnumber;

        @AuraEnabled public Integer p_manualparameters;

        @AuraEnabled public String std_pkg_qty;

        @AuraEnabled public String p_pdc_spq;

        @AuraEnabled public String status;

         @AuraEnabled public String  dlrsplrcode; 

        @AuraEnabled public String  min_inc_qty; 

    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    /*** This class will use to parse the Manual Lockdown KPI JSON ***/
    public class ManualLockDownKPIResponseWrapper {
        @AuraEnabled public List<ManualLockdownWrapper> response;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public String error;
        
    }
    public class ManualLockdownWrapper{
        @AuraEnabled public String dealer_code;
        @AuraEnabled public Integer sum_parts;
        @AuraEnabled public Integer ex_parts;
    }
    
    public class ManualWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
        @AuraEnabled public Date StartDate;
        @AuraEnabled public Date EndDate;
        
    }
    
    /****
    * Manual Lockdown Listing api
    */ 
    @AuraEnabled
    public static ManualLockDownListingResponseWrapper manualLockdownListingApi(List<String> dealerCodes){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();       
        ManualLockDownListingResponseWrapper awsMLKPIResultData = new ManualLockDownListingResponseWrapper();
        
        HttpRequest req = new HttpRequest();        
        calloutDetails.put('endpoint','/manual-lock-down-parts/listing/dealers');        
        calloutDetails.put('method','POST');        
        calloutDetails.put('body', getLockdownListingEndPointParameters(dealerCodes,10000,0));
       
        calloutDetails.put('classname','EDealerManualLockdownController');        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null){
            awsMLKPIResultData = (ManualLockDownListingResponseWrapper)System.JSON.deserialize(jsonRes, ManualLockDownListingResponseWrapper.class);
        }
        
        awsMLKPIResultData.languageTranslation = new map<string,string>();
        awsMLKPIResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Manual Lockdown Listing');
        System.debug('awsMLKPIResultData.languageTranslation '+awsMLKPIResultData.languageTranslation );
        system.debug('awsMLKPIResultData.response::'+JSON.serializePretty(awsMLKPIResultData.response));
        
        return awsMLKPIResultData; 
    }
    private static String getLockdownListingEndPointParameters(List<String> dealerCodes, integer limits,integer offset){
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeNumberField('limit', limits);
        gen.writeNumberField('offset', offset);  
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        system.debug('req::'+pretty);
        return pretty;
    }                     
    public class ManualLockDownListingResponseWrapper {
        @AuraEnabled public List<ManualLockDownListingWrapper> response; 
        @AuraEnabled public String error;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    
    public class ManualLockDownListingWrapper {
        @AuraEnabled public String grp_nbr;
        @AuraEnabled public String loc;
        @AuraEnabled public String item;
        @AuraEnabled public String p_abc;
        @AuraEnabled public String sale_ind;
        @AuraEnabled public Decimal oh;
        @AuraEnabled public Decimal dnet;
        @AuraEnabled public Decimal p_12monthhitcount;
        @AuraEnabled public Decimal p_mtddemandqty;
        @AuraEnabled public Decimal p_12monthdemandqty;
        @AuraEnabled public String p_dlrsplrcode;
        @AuraEnabled public String p_stkclass;
        @AuraEnabled public String p_sunsetdate;
        @AuraEnabled public String p_dlrrslnumber;
        @AuraEnabled public Decimal p_pdc_spq;
        @AuraEnabled public Integer is_true;
        @AuraEnabled public String p_commenttext;
    }
}