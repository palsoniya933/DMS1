/****
*  Name        :   EDealerPendingOrderController
***/
public without sharing class EDealerPendingOrderController {
    
    @AuraEnabled
    public static  MasterResponseWrapper getPendingOrders(list<String> dealerCodes,String orderType){
        // creating map for API Call
        System.debug('body-Back-'+getEndPointParameters(dealerCodes,orderType));
        map<string,object> calloutDetails = new map<string,object>();
        MasterResponseWrapper awsSalesCostResultData = new MasterResponseWrapper();
        
        calloutDetails.put('endpoint','/pending-order/kpi/dealer');        
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes,orderType));
        calloutDetails.put('classname','EDealerPendingOrderController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('jsonResBack--'+jsonRes);
        
        // parsing the actual results
        if(jsonRes != null)
            awsSalesCostResultData = (MasterResponseWrapper) System.JSON.deserialize(jsonRes, MasterResponseWrapper.class);
        
        //RETURN
        return awsSalesCostResultData;
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
        @AuraEnabled public List<MasterPendingOrderWrapper> response;
        @AuraEnabled public String error;
    }
    public class MasterPendingOrderWrapper{
        @AuraEnabled public String frequency;
        @AuraEnabled public String cstno;
        @AuraEnabled public String cstsfx;
        @AuraEnabled public Decimal emergencyorders;       
        @AuraEnabled public Decimal ordercount;
        @AuraEnabled public Decimal stockorders;
        @AuraEnabled public Decimal truckdownorders;
        
        
    }
    
    
    @AuraEnabled
    public static List<Object> getFilters(){
        List<Object> options = eDealerTileFilterController.getCmpFilters('PendingOrderCmp');
        return options;
    }
}