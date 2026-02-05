public class EDealerCNRRSVPartsTileController {
    
    /****
    * Created on 26-03-2021
    * To call Dealer CNRRSV Part Report 
    */ 
    @AuraEnabled
    public static CNRRSVKPIResponseWrapper fetchDealerCNRRSVKPIData(list<String> dealerCodes, String division){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        
        CNRRSVKPIResponseWrapper awsTotalResultData = new CNRRSVKPIResponseWrapper();
        HttpRequest req = new HttpRequest();
        calloutDetails.put('endpoint','/cnr/kpi/dealer');
        calloutDetails.put('body',getEndPointParameters(dealerCodes, division));
        calloutDetails.put('method','POST');
        calloutDetails.put('classname','EDealerCNRRSVPartsTileController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
        if(jsonRes != null)
            awsTotalResultData = (CNRRSVKPIResponseWrapper)System.JSON.deserialize(jsonRes, CNRRSVKPIResponseWrapper.class);
                
        //RETURN
        return awsTotalResultData;
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
    
    public class CNRRSVKPIResponseWrapper{
        @AuraEnabled public List<CNRRSVKPIWrapper> response;
        @AuraEnabled public String error;
    }
    
    /*** Returns Dealer  Result Parameters/attributes ***/
    public class CNRRSVKPIWrapper {
        @AuraEnabled public String dealer_code;
        @AuraEnabled public Decimal cnr_count;
    }
}