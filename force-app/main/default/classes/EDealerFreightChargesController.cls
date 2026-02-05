public without sharing class EDealerFreightChargesController {
    
    @AuraEnabled
    public static  ResponseWrapper getFreightChargeDetails(list<String> dealerCodes){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ResponseWrapper awsResultData = new ResponseWrapper();             
        calloutDetails.put('endpoint','/freight-charges/data/dealer');        
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes));
        calloutDetails.put('classname','EDealerFreightChargesController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);
        
        //RETURN
        return awsResultData;
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
    
    public class ResponseWrapper{
        @AuraEnabled public List<FreightChargesWrapper> response;
        @AuraEnabled public String error;
    }
    public class FreightChargesWrapper{
        @AuraEnabled public Decimal all;
        @AuraEnabled public String cstno;
        @AuraEnabled public Decimal dsp_freightcharges;
        @AuraEnabled public Decimal em_freightcharges;
        @AuraEnabled public String frequency;
        @AuraEnabled public Decimal monthly_returns;
        @AuraEnabled public Decimal other_freightcharges;      
        @AuraEnabled public Decimal td_freightcharges;  
        
    }
    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('FreightChargeCmp');
        return options;
    }
}