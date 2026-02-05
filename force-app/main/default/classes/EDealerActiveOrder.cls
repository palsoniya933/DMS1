/****
*  Name        :   eDealerActiveOrder
***/
public without sharing class EDealerActiveOrder {
    
    @AuraEnabled
    public static  MasterResponseWrapper getActiveOrders(list<String> dealerCodes,String orderType){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        System.debug('body--'+getEndPointParameters(dealerCodes,orderType));
        // HttpRequest req = new HttpRequest();
        MasterResponseWrapper awsResultData = new MasterResponseWrapper(); 
        calloutDetails.put('endpoint','/active-order-data/kpi/dealers');  
        
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes,orderType));
        calloutDetails.put('classname','EDealerActiveOrder');
        
        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('jsonRes--'+jsonRes);
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (MasterResponseWrapper)System.JSON.deserialize(jsonRes, MasterResponseWrapper.class);        
        
        //RETURN
        
        return awsResultData;
    }
    
    
    private static String getEndPointParameters(List<String> dealerCodes,String orderType){
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeObjectField('orderType', orderType);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    public class MasterResponseWrapper{
        @AuraEnabled public List<MasterActiveOrderWrapper> response;
        @AuraEnabled public String error; 
    }
    public class MasterActiveOrderWrapper{
        @AuraEnabled public String frequency;
        @AuraEnabled public String cstno;        
        @AuraEnabled public Integer td;
        @AuraEnabled public Integer em;        
        @AuraEnabled public Integer st;       
        @AuraEnabled public Decimal total;      
        
    }
    
    
    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('ActiveOrderCmp');
        return options;
    }
}