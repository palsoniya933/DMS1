/*
*  Name        :   EDealerCNRListingCtrl   
*/

public without sharing class EDealerCNRListingCtrl {
    @AuraEnabled
    public static ResponseWrapper getCNRListingData(List<String> dealerCode, String dealerDivision) {
        // Creating map for API Call
        //string aa='{ "dealer_codes": [ "K855", "I080", "B400" ], "dealer_division": "K" }';
       String JSONBody = getEndPointParameters(dealercode, dealerDivision);
        Map<String, Object> calloutDetails = new Map<String, Object>();
        calloutDetails.put('namedCredentials', 'callout:GatewayAWSConnection');
        calloutDetails.put('endpoint', '/dealerships/cnr/listing/dealer');
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname', 'EDealerCNRListingCtrl');
        system.debug('Body'+ JSONBody);
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes :::' + jsonRes);
          ResponseWrapper awsResultData;
        if (jsonRes != null) {
            awsResultData = (ResponseWrapper) System.JSON.deserialize(jsonRes, ResponseWrapper.class);
            awsResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeadersVersion2('CNR RSV');
            
        }
            // Return the response
            return awsResultData;
        
    }

    private static String getEndPointParameters(List<String> dealerCode, String dealerDivision) {
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('dealer_codes',dealerCode);
        jsonMap.put('dealer_division',dealerDivision);
        String jsonString = JSON.serialize(jsonMap);
        System.debug('CNR body: ' + jsonString);
        return jsonString;
    }

    public class ResponseWrapper {
        @AuraEnabled public List<MasterCNRListingWrapper> response;
        @AuraEnabled public String error;
        @AuraEnabled public Map<String, Object> languageTranslation;
    }

    public class MasterCNRListingWrapper {
        @AuraEnabled public String dealer_code;
        @AuraEnabled public String part;
        @AuraEnabled public String partdescription;
        @AuraEnabled public Integer limitqty;
        @AuraEnabled public String saleableindicator;
    }
}