public class EDealerTurnsController {
    
    /****
     * Created on 22-03-2021
     * To call Turns KPI
     */ 
    @AuraEnabled
    public static TurnsResponseWrapper fetchAWSTurnsData(list<String> dealerCodes, String division){
    // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        TurnsResponseWrapper awsRCResultData = new TurnsResponseWrapper();
        calloutDetails.put('endpoint','/turns/kpi/dealer');        
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes, division));
        calloutDetails.put('classname','EDealerTurnsController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null)
            awsRCResultData = (TurnsResponseWrapper)System.JSON.deserialize(jsonRes, TurnsResponseWrapper.class);
        
        //RETURN
        return awsRCResultData;
       
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String division){
    	//JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('dealer_division', division);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    public class TurnsResponseWrapper{
        @AuraEnabled public List<TurnsWrapper> response;
        @AuraEnabled public String error;
    }
    /*** Turns Result Parameters/attributes ***/
    public class TurnsWrapper {
        @AuraEnabled public String loc;
        @AuraEnabled public Decimal monthly_turns;
        @AuraEnabled public Decimal yearly_turns;
      
    }
}