/****
 *  Name        :   EDealerConfirmOrder
***/
public without sharing class EDealerConfirmOrder {
   
     @AuraEnabled
    public static  MasterResponseWrapper getConfirmOrders(list<String> dealerCodes,String ordstatus){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        MasterResponseWrapper awsResultData = new MasterResponseWrapper();        
        System.debug('Body EDealerConfirmOrder::'+getEndPointParameters(dealerCodes,ordstatus));
        calloutDetails.put('endpoint','/confirm-order/kpi/dealer');        
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(dealerCodes,ordstatus));
        calloutDetails.put('classname','EDealerConfirmOrder');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes EDealerConfirmOrder::'+jsonRes);
       // parsing the actual results
       if(jsonRes != null)
            awsResultData = (MasterResponseWrapper)System.JSON.deserialize(jsonRes, MasterResponseWrapper.class);
        
        //RETURN
        return awsResultData;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes,String ordstatus){
    	//JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
         gen.writeObjectField('ordstat', ordstatus);
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
        @AuraEnabled public String frequency;
       // @AuraEnabled public String date_month_quarter;
        @AuraEnabled public Decimal ordercount;
        @AuraEnabled public Decimal invoiceordercount;
        @AuraEnabled public Decimal cancleordercount;
    }
    
    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('ClosedOrdersCmp');
        return options;
    }
}