/*** 
* 	Name        :   EDealerBackOrdersController
*  	Description :  	This is the apex class which is used for EDealerBackOrdersReport component
*/ 
public class EDealerBackOrdersController {
    @AuraEnabled
    public static BackOrderResponseWrapper fetchAWSBackOrdersReportData(String reportParamsJson){
        try{
            // saving the object to be returned
            BackOrderResponseWrapper awsReportResultData = new BackOrderResponseWrapper();
            
            // converting json to Apex
            backOrderFilterWrapper reportParams = (backOrderFilterWrapper) 
                JSON.deserialize(reportParamsJson, backOrderFilterWrapper.class);
            
            // saving the http params
            map<string,object> calloutDetails = new map<string,object>();
            
            // checking if the filter values are selected 
            if(!String.isBlank(reportParams.field)
               && !String.isBlank(reportParams.operator)
               && !String.isBlank(reportParams.value)){
                   calloutDetails.put('endpoint','/back-orders-report-filter/dealer/');			
               }
            else{
                calloutDetails.put('endpoint','/back-orders-report/dealer?');      
            }
            calloutDetails.put('method','POST'); 
            calloutDetails.put('body',getEndPointParameters(reportParams));	        
            calloutDetails.put('classname','EDealerBackOrdersController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            // Call EDealerLogUtils class based on response status code        					
            if(jsonRes != null){
                awsReportResultData = (BackOrderResponseWrapper) System.JSON.deserialize(jsonRes, BackOrderResponseWrapper.class);
            }
            //RETURN
            awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
            awsReportResultData.languageTranslation = new map<string,string>();
            //End value transalation language data
            awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Back Order');
            return awsReportResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerBackOrdersController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(backOrderFilterWrapper reportParams){
        
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
    
    public class BackOrderResponseWrapper {
        @AuraEnabled public List<BackOrderWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    public class BackOrderWrapper{
        @AuraEnabled public String grp_nbr {get;set;}
        @AuraEnabled public String loc {get;set;}
        @AuraEnabled public String item {get;set;}
        @AuraEnabled public String order_date {get;set;}
        @AuraEnabled public String order_type {get;set;}
        @AuraEnabled public String order_number {get;set;}
        @AuraEnabled public String po_number {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String status_descr {get;set;}
        @AuraEnabled public Double qty_order {get;set;}
        @AuraEnabled public Double ext_net {get;set;}
        @AuraEnabled public String vendor_id {get;set;}
        @AuraEnabled public String vendor_name {get;set;}
        @AuraEnabled public String saleable_ind {get;set;}
        @AuraEnabled public Double oh {get;set;}
        @AuraEnabled public String distchan {get;set;}
        @AuraEnabled public String abc {get;set;}
        @AuraEnabled public String dlrrslnumber {get;set;}     
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class backOrderFilterWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;        
    }
}