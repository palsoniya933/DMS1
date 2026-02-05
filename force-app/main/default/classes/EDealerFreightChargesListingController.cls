public without sharing class EDealerFreightChargesListingController {
    
    @AuraEnabled
    public Static ResponseWrapper fetchFreightChargesListingData(String dealerCode, String orderType,String timeFrame, Integer offSet, Integer recLimit){
        // creating map for API Call
        map<String,Object> calloutDetails = new map<string,object>();
        ResponseWrapper awsResultData = new ResponseWrapper();
        HttpRequest req = new HttpRequest();        
        calloutDetails.put(	'endpoint',
                           '/freight-charges/listing/'+ dealerCode +
                           '?&orderType='+orderType +
                           '&timeFrame='+  timeFrame
                          );
        
        calloutDetails.put('method','GET');
        System.debug('calloutDetails'+calloutDetails);
        calloutDetails.put('classname','EDealerFreightChargesListingController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);
        
        awsResultData.dataJSON = JSON.serialize(awsResultData.response);
        awsResultData.languageTranslation = new map<string,string>();
        awsResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Freight Charges');
        System.debug('awsResultData'+awsResultData);
        System.debug('awsResultData'+awsResultData.languageTranslation);
        // return
        return awsResultData;
    }
    
    @testvisible
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(List<String> dealerCodes, Integer offSet, Integer recLimit, String orderType, String timeFrame){
        
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
        gen.writeNumberField('offset', offSet);
        gen.writeNumberField('limit', recLimit);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        
        return pretty;
    }
    
    public class ResponseWrapper{
        @AuraEnabled public List<MasterFreightChargesListingWrapper> response ;
        @AuraEnabled public String error ;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public String dataJSON;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    public class MasterFreightChargesListingWrapper{
        @AuraEnabled public String paccarorder ;
        @AuraEnabled public String paccar_po ;
        @AuraEnabled public String dealerpo ;
        @AuraEnabled public String orderdate ;
        @AuraEnabled public Double freighttotal ;
    }
}