public class EDealerUnConfirmedOrder {
    
    @AuraEnabled
    public static  MasterResponseWrapper getUnConfirmedOrders(list<String> dealerCodes){
        // creating map for API Call
        System.debug('BODY dealerCodes' + dealerCodes);
        
       System.debug('body--'+getEndPointParameters(dealerCodes));
        map<string,object> calloutDetails = new map<string,object>();
        MasterResponseWrapper awsResultData = new MasterResponseWrapper();
        calloutDetails.put('endpoint','/unconfirmed-order/kpi/dealer');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes));
        calloutDetails.put('classname','EDealerUnConfirmedOrder');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes UnConfirmedOrder' + jsonRes);

       // parsing the actual results
       if(jsonRes != null)
            awsResultData = (MasterResponseWrapper)System.JSON.deserialize(jsonRes, MasterResponseWrapper.class);
        
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
    
     public class MasterResponseWrapper{
        @AuraEnabled public List<MasterConfirmOrderWrapper> response;
        @AuraEnabled public String error;
    }
    
    public class MasterConfirmOrderWrapper{
        @AuraEnabled public String cstno;
        @AuraEnabled public String cstsfx;
        @AuraEnabled public Decimal total;
        @AuraEnabled public Decimal emergencyorders;
        @AuraEnabled public Decimal stockorders;
        @AuraEnabled public Decimal truckdownorders;
       @AuraEnabled public String frequency;
    }

    
    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('UnconfirmedOrderCmp');
        return options;
    }
}