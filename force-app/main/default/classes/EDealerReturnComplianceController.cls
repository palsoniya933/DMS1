/*** 
 * Name        :   EDealerReturnComplianceController
 *  Description :   This is the apex class which is used for eDealerReturnComplianceTile component
 */ 
public class EDealerReturnComplianceController {
    
    /****
     * Created on 16-12-2020
     * To call Returns Compliance KPI
     */ 
    @AuraEnabled
    public static ReturnsComplianceKPIResponseWrapper fetchAWSReturnsComplianceKPIData(list<String> dealerCodes, String division){
        ReturnsComplianceKPIResponseWrapper awsRCKPIResultData = new ReturnsComplianceKPIResponseWrapper();
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint','/return-compliance-kpi/dealers');         
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes));
        calloutDetails.put('classname','EDealerReturnComplianceController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('json-----'+ jsonRes);
        
        //Call EDealerLogUtils class based on response status code.
        if(jsonRes != null){
            // parsing the actual results
            awsRCKPIResultData = (ReturnsComplianceKPIResponseWrapper)System.JSON.deserialize(jsonRes, ReturnsComplianceKPIResponseWrapper.class);
        }
        
        //RETURN
        return awsRCKPIResultData;
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
    
    /*@AuraEnabled
    public static ReturnsComplianceKPIResponseWrapper fetchAWSReturnsComplianceKPIData(String dealerCode, String division){
        ReturnsComplianceKPIResponseWrapper awsRCKPIResultData = new ReturnsComplianceKPIResponseWrapper();
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint','/return-compliance-kpi/'+dealerCode+'/dealer?dealer_division='+division);         
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerReturnComplianceController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        //Call EDealerLogUtils class based on response status code.
        if(jsonRes != null){
            // parsing the actual results
            awsRCKPIResultData = (ReturnsComplianceKPIResponseWrapper)System.JSON.deserialize(jsonRes, ReturnsComplianceKPIResponseWrapper.class);
        }
        
        //RETURN
        return awsRCKPIResultData;
    }*/
    
    public class ReturnsComplianceKPIResponseWrapper{
        @AuraEnabled public ReturnsComplianceWrapper response {get;set;}
        @AuraEnabled public String error {get;set;}
    }
    
    /*** This class will use to parse the Returns Compliance KPI JSON ***/
    public class ReturnsComplianceWrapper{
        @AuraEnabled public List<ReturnsWrapper> month_data {get;set;}
        @AuraEnabled public List<ReturnsWrapper> quarter_data {get;set;}
        @AuraEnabled public List<ReturnsWrapper> year_data {get;set;}
        @AuraEnabled public List<ReturnsWrapper> previous_year_data {get;set;}
        @AuraEnabled public List<ReturnsWrapper> current_year_data {get;set;}
    }
    
    /*** Returns Compliance KPI Result Parameters/attributes ***/
    public class ReturnsWrapper {
        @AuraEnabled public String dealer_code {get;set;}
        @AuraEnabled public Date suggested_month_create_date {get;set;} // month 
        @AuraEnabled public Date suggested_quarter_create_date {get;set;} //quarter
        @AuraEnabled public Integer suggested_year {get;set;}
        @AuraEnabled public Integer suggested_month {get;set;}// month
        @AuraEnabled public Integer suggested_quarter {get;set;}//quarter
        @AuraEnabled public Integer suggested_returns {get;set;}
        @AuraEnabled public Double sum_suggested_returns {get;set;}
        @AuraEnabled public Integer returned_quantity {get;set;}
        @AuraEnabled public Double sum_return_amount {get;set;}
        @AuraEnabled public Double suggested_compliance {get;set;}
        @AuraEnabled public Double suggested_items_percentage_change {get;set;}
        @AuraEnabled public Double suggested_items_amount_percentage_change {get;set;}
        @AuraEnabled public Double return_items_percentage_change {get;set;}
        @AuraEnabled public Double return_items_amount_percentage_change {get;set;}
        @AuraEnabled public Double compliance_percentage_change {get;set;}
    }

}