public class EDealerTotalPartsOrderedKPICtrl {
   
    @AuraEnabled
    public static  PartsOrderResponseWrapper getTotalPartsOrderes(list<String> dealerCodes,string orderStatus){
    // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        PartsOrderResponseWrapper awsResultData = new PartsOrderResponseWrapper();
        HttpRequest req = new HttpRequest();
        calloutDetails.put('endpoint','/dash-board-parts/total/dealer');
        calloutDetails.put('body',getEndPointParameters(dealerCodes,orderStatus));
        calloutDetails.put('method','POST');
        calloutDetails.put('classname','EDealerTotalPartsOrderedKPICtrl');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes getTotalPartsOrderes' + jsonRes);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (PartsOrderResponseWrapper)System.JSON.deserialize(jsonRes, PartsOrderResponseWrapper.class);
        
        //RETURN
        return awsResultData;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String orderStatus){
      //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('ordstat', orderStatus);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
     public class PartsOrderResponseWrapper{
        @AuraEnabled public List<PartsOrderWrapper> response;
        @AuraEnabled public String error;
    }
    public class PartsOrderWrapper{
        @AuraEnabled public String cstno;
        @AuraEnabled public String frequency;
        @AuraEnabled public Decimal doller_value;
        @AuraEnabled public Decimal doller_value_per;
        @AuraEnabled public String type;
        @AuraEnabled public Decimal part_count;
        @AuraEnabled public Decimal part_count_per;
    }

    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('TotalPartsCmp');
        return options;
    }
}