/*** 
 * Name        :   EDealerEmergencyOrderController
 *  Description :  this is the apex class which is used for eDealerEmergencyOrderTile component
 */ 
public without sharing class EDealerEmergencyOrderController {
    
    /****
     * Created on 29-10-2020
     * To call the Emergency Orders KPI/API 
     */ 
    @AuraEnabled
    public static EmergencyOrderWrapper fetchAWSEmergencyKPIData(List<String> dealerCodes){
    // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        EmergencyOrderResponseWrapper awsEmergencyKPIResultData = new EmergencyOrderResponseWrapper();
        
        calloutDetails.put('endpoint','/emergencyorder/dealer');            
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes));
        calloutDetails.put('classname','EDealerEmergencyOrderController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
        // parsing the actual results
        if(jsonRes != null){
            awsEmergencyKPIResultData = (EmergencyOrderResponseWrapper)System.JSON.deserialize(jsonRes, EmergencyOrderResponseWrapper.class);     
            
            if(awsEmergencyKPIResultData != null 
                && awsEmergencyKPIResultData.response != null){
                return awsEmergencyKPIResultData.response;
            }            
        }
        return new EmergencyOrderWrapper();
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
    
    /*** To save Emergency Lines Api result ***/
    public class EmergencyOrderResponseWrapper{
        @AuraEnabled public EmergencyOrderWrapper response;
        @AuraEnabled public String error;
    }
    
    /*** To save Emergency Lines Api result ***/
    public class EmergencyOrderWrapper{
        @AuraEnabled public OrderWrapper daily_order ;
        @AuraEnabled public OrderWrapper weekly_order ;
        @AuraEnabled public OrderWrapper monthly_order ;
        @AuraEnabled public OrderWrapper quaterly_order ;
        @AuraEnabled public OrderWrapper yearly_order ;
        @AuraEnabled public OrderWrapper two_yearly_order ;
    }
    
    /*** Emergency Lines Api JSON Parameters ***/
    public class OrderWrapper {
        @AuraEnabled public String cstno; 
        @AuraEnabled public String cstsfx ;
        @AuraEnabled public Integer emergency_order ;
        @AuraEnabled public Integer total_order ;
        @AuraEnabled public String percent_emr_order ;
    }
    
    public static EDealerEmergencyOrderController.EmergencyOrderWrapper parse(String json) {
        return (EDealerEmergencyOrderController.EmergencyOrderWrapper) System.JSON.deserialize(json, EDealerEmergencyOrderController.EmergencyOrderWrapper.class);
    }
}