/*** 
* Name        :   EDealerExcessInventoryController
*  Description :   This is the apex class which is used for eDealerExcessInventoryReport component
*/ 
public class EDealerExcessInventoryController {
    @AuraEnabled
    public static EDealerMDIExcessInventoryWrapper fetchAWSMdiExcessInventoryReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            EDealerMDIExcessInventoryWrapper awsReportResultData = new EDealerMDIExcessInventoryWrapper();
            
            // converting json to Apex
            MDIInventoryWrapper reportParams = (MDIInventoryWrapper) 
                JSON.deserialize(reportParamsJson, MDIInventoryWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/mdi-excess-inventory-report-filter/dealer');			
               }
            else{
                calloutDetails.put('endpoint','/mdi-access-inventory/report/dealer?');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerExcessInventoryController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);           
            
            // Call EDealerLogUtils class based on response status code        					
            if(jsonRes != null){
                awsReportResultData = (EDealerMDIExcessInventoryWrapper) System.JSON.deserialize(jsonRes, EDealerMDIExcessInventoryWrapper.class);
            }
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            //End value transalation language data
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('MDI Excess');
            return awsReportResultData; 
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getLineNumber());
            EDealerLogUtils.createExceptionLog('EDealerExcessInventoryController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(MDIInventoryWrapper reportParams){
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
    
    /*********************** Wrapper Class Section ************************/    
    
    public class EDealerMDIExcessInventoryWrapper {
        @AuraEnabled public List<MDIExcessInventoryWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public String error; 
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    public class MDIExcessInventoryWrapper {
        @AuraEnabled public String dlrcode; 
        @AuraEnabled public String trnsdate;
        @AuraEnabled public String part;
        @AuraEnabled public String descr;
        @AuraEnabled public String abcdecode;
        @AuraEnabled public String dist_chnl;
        @AuraEnabled public String prim_sup_code;
        @AuraEnabled public String alt_sup_comde;
        @AuraEnabled public String bin_loc;
        @AuraEnabled public String rsl;
        @AuraEnabled public Integer rbq;
        @AuraEnabled public Integer spq;
        @AuraEnabled public String rtnrmaind;
        @AuraEnabled public String natstkind;
        @AuraEnabled public Decimal est_ext_net;
        @AuraEnabled public Decimal est_dnet;
        @AuraEnabled public Decimal stddlrnet;
        @AuraEnabled public String refcode;
        @AuraEnabled public String refcmnt;
        @AuraEnabled public String reason_comment;
        @AuraEnabled public String excessqty;
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class MDIInventoryWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
    
    
    /****
    * To call the MDI Excess Inventroy KPI 
    */ 
    @AuraEnabled
    public static MDIExcessInventoryKPIResponseWrapper fetchAWSMdiExcessInventoryKPIData(String dealerCode){
        try{
            // creating map for API Call
            map<string,object> calloutDetails = new map<string,object>();
            MDIExcessInventoryKPIResponseWrapper awsResultData = new MDIExcessInventoryKPIResponseWrapper();
            
            calloutDetails.put('endpoint','/mdi-excess-inventory/kpi/'+dealerCode+'/dealer');            
            calloutDetails.put('method','GET');
            calloutDetails.put('classname','EDealerExcessInventoryController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            // parsing the actual results
            if(jsonRes != null){
                awsResultData = (MDIExcessInventoryKPIResponseWrapper)System.JSON.deserialize(jsonRes, MDIExcessInventoryKPIResponseWrapper.class);
            }
            if(awsResultData != null && awsResultData.response != null && !awsResultData.response.isEmpty()){
                for(MDIExcessInventoryKPIWrapper wrp : awsResultData.response){
                    wrp.total_value = String.isNotBlank(wrp.total_value) ? wrp.total_value.remove('$') : wrp.total_value;
                }
            }
            return awsResultData;
        }
        catch(exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerDaysOnhandController');            
        }
        return new MDIExcessInventoryKPIResponseWrapper();
    }
    
    public class MDIExcessInventoryKPIResponseWrapper {
        @AuraEnabled public List<MDIExcessInventoryKPIWrapper> response;
        @AuraEnabled public String error;
    }
    
    public class MDIExcessInventoryKPIWrapper {
        @AuraEnabled public String dlrcode;
        @AuraEnabled public String abcdecode;
        @AuraEnabled public String parts_type;
        @AuraEnabled public Integer total_parts;
        @AuraEnabled public String total_value;
    }
}