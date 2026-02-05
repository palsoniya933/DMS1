/*
*  Name        :   EDealerOrderSummaryListingCtrl   
*/

public without sharing class EDealerOrderSummaryListingCtrl {
    @AuraEnabled
    public static ResponseWrapper orderSummaryData(List<String> dealerCode, String orderType, String timeFrame, Integer offSet, Integer recLimit){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        
        String JSONBody = getEndPointParameters(dealerCode,orderType, timeFrame, offSet, recLimit);
        
        ResponseWrapper awsResultData = new ResponseWrapper(); 
        HttpRequest req = new HttpRequest();
        
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
     
        
        calloutDetails.put(	'endpoint',
                           	'/dealerships/order-summary/listing/dealer'
                          );

        
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname','EDealerOrderSummaryListingCtrl'); 
        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
     
        System.debug('jsonRes EDealerOrderSummaryListingCtrl' + jsonRes);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);  
            awsResultData.dataJSON = JSON.serialize(awsResultData.response);
            
            awsResultData.languageTranslation = new map<string,string>();
            awsResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Order Summery Listing Table');
            System.debug('awsResultData.languageTranslation '+awsResultData.languageTranslation );

        
        //RETURN
        return awsResultData;
    }
    
        

    @AuraEnabled

    public static List<Map<String, String>> getFrequencyTranslations(){

        return eDealerDashboard.getFrequency();

    }

    

    @testvisible
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(List<String> dealerCodes, String orderType, String timeFrame, Integer offSet, Integer recLimit){
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
        
        // divison should not be blank
        if(dealerCodes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(dealerCodes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('ordstat', orderType);
        gen.writeStringField('timeFrame', timeFrame);
        gen.writeNumberField('offset_value', offSet);
        gen.writeNumberField('limit', recLimit);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
      
        return pretty;
    }
    
    public class ResponseWrapper{
        @AuraEnabled public List<MasterActiveOrderWrapper> response{get;set;}
        @AuraEnabled public String error{get;set;}
        @AuraEnabled public List<RowCountClass> RowCount{get;set;}
        @AuraEnabled public String dataJSON{get;set;}
        @AuraEnabled public map<string,object>languageTranslation{get;set;}
    }
    public class RowCountClass{
        @AuraEnabled public Integer rowcount{get;set;}
    }
    
    public class MasterActiveOrderWrapper{
        @AuraEnabled public String cstno{get;set;}
        @AuraEnabled public String cstsfx{get;set;}
        @AuraEnabled public String ordno{get;set;}
        @AuraEnabled public String dealerpo{get;set;}
        @AuraEnabled public String part{get;set;}
        @AuraEnabled public String partqtyordered{get;set;}
        @AuraEnabled public String orderdate{get;set;}
        @AuraEnabled public String ordertype{get;set;}
        @AuraEnabled public String orderstatus{get;set;}
        @AuraEnabled public String ordersource{get;set;}
        @AuraEnabled public String createdby{get;set;}
        @AuraEnabled public String extnet{get;set;}
    }
}