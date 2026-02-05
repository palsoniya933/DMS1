/*
*  Name        :   EDealerActiveListing   
*/
public without sharing class EDealerActiveListing {
    @AuraEnabled
    public static ResponseWrapper fetchListingData(List<String> dealerCode, String orderType, String timeFrame,Integer offset_value,Integer reclimit){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        
          String JSONBody = getEndPointParameters(dealerCode,orderType, timeFrame,offset_value,reclimit);
        ResponseWrapper awsResultData = new ResponseWrapper();
        HttpRequest req = new HttpRequest();        
         calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put(
            'endpoint',
            '/dealerships/active-orders/listing/edealer'
        );
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname','EDealerActiveListing');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes :::'+jsonRes);
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);
        
        // return
        return awsResultData;
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
        System.debug( 'Active order Body'+jsonString);
        return jsonString;
    }
    public class ResponseWrapper{
        @AuraEnabled public List<MasterActiveOrderWrapper> response {get;set;}
        @AuraEnabled public String error {get;set;}
        @AuraEnabled public  Integer rowcount;

    }
    
    public class MasterActiveOrderWrapper{
        @AuraEnabled public String cstno {get;set;}
        @AuraEnabled public String paccar_po {get;set;}
        @AuraEnabled public String ordno {get;set;}
        @AuraEnabled public String orderdate {get;set;}
        @AuraEnabled public String ordertype {get;set;}
        @AuraEnabled public String orderstatus {get;set;}
        @AuraEnabled public String ordersource {get;set;}  
        @AuraEnabled public String createdby {get;set;}
        @AuraEnabled public String dealerpo {get;set;}
    }
    
}