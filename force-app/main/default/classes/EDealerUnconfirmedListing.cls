public without sharing class EDealerUnconfirmedListing {
    
    @AuraEnabled
    public static ResponseWrapper unConfirmOrdersListingData(List<String> dealerCode, String orderType,String timeFrame,Integer offset_value,Integer reclimit){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        String JSONBody = getEndPointParameters(dealerCode,orderType,timeFrame,offset_value,reclimit);
        
        ResponseWrapper awsResultData = new ResponseWrapper(); 
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put(
            'endpoint',
            '/dealerships/unconfirmed-order/listing/edealer'
        );
        //calloutDetails.put('endpoint','/unconfirmed-order/listing/'+dealerCode+'/dealer?orderType='+orderType);         
        calloutDetails.put('method','POST');  
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname','EDealerUnconfirmedListing');        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);   
        System.debug('jsonRes UnconfirmedListing' + jsonRes);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);       
        
        //RETURN
        return awsResultData;
    }
    
    public class ResponseWrapper{
        @AuraEnabled public List<UnConfirmedOrderWrapper> response;
        @AuraEnabled public String error;
        @AuraEnabled public  Integer rowcount;
        
    }
    private static String getEndPointParameters(List<String> dealercode,String orderType, String timeFrame,Integer offset_value,Integer reclimit) {
        String frequency='';
        if(timeFrame == 'Day'){
            frequency='day';
        }else if(timeFrame == 'Week' || timeFrame == 'Weekly'){
            frequency='week';
        }else if(timeFrame == 'Month' || timeFrame == 'Monthly'){
            frequency='month';
        }else if(timeFrame == 'Quarter' || timeFrame == 'Quarterly'){
            frequency='quarter';
        }else if(timeFrame == 'Year' || timeFrame == 'Annually'){
            frequency='year';
        }else if(timeFrame == 'All'){
            frequency='all';
        }
        Map<String, Object> jsonMap = new Map<String, Object>(); 
        jsonMap.put('dealer_codes', dealercode); 
        jsonMap.put('orderType', orderType); 
        jsonMap.put('timeFrame', frequency);
        jsonMap.put('offset_value', offset_value); 
        jsonMap.put('limit', reclimit); 
        String jsonString = JSON.serialize(jsonMap);
        System.debug( 'Unconfirmed order Body'+jsonString);
        return jsonString;
    }
    public class UnConfirmedOrderWrapper{
        @AuraEnabled public String cstno;
        @AuraEnabled public String cstsfx;
        @AuraEnabled public String ordno;
        @AuraEnabled public String dealerpo;
        @AuraEnabled public String orderdate;
        @AuraEnabled public String ordertype;
        @AuraEnabled public String orderstatus;
        @AuraEnabled public String ordersource;
        @AuraEnabled public String createdby;
        @AuraEnabled public Integer splitorder;
    }
    
}