public without sharing class EDealerEmergencyListingCtrl {
    @AuraEnabled
    public static ResponseWrapper getEmergencyData(list<String> dealerCodes, String timeFrame, integer limits,integer offset){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ResponseWrapper awsResultData = new ResponseWrapper();        
        calloutDetails.put('endpoint','/emergency-order/listing/dealer');         
        calloutDetails.put('method','POST');  
        calloutDetails.put('body',getEndPointParameters(dealerCodes,timeFrame,limits,offset));
        System.debug('calloutDetails'+calloutDetails);
        calloutDetails.put('classname','EDealerEmergencyListingCtrl');        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 
       system.debug('jsonRes::'+jsonRes);
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);   
        	awsResultData.dataJSON = JSON.serialize(awsResultData.response);
        system.debug('dataJSON::'+JSON.serialize(awsResultData.response));
        
        EDealerEmergencyOrderController.EmergencyOrderWrapper kpiDetails = 
            EDealerEmergencyOrderController.fetchAWSEmergencyKPIData(dealerCodes);
        
        // map KPI
        awsResultData.kpiDetails = kpiDetails;
        
        awsResultData.languageTranslation = new map<string,string>();
        awsResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Emergency Lines');
        System.debug('awsResultData.languageTranslation '+awsResultData.languageTranslation );
        
        //RETURN
        return awsResultData;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String timeFrame, integer limits,integer offset){
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeObjectField('timeFrame', timeFrame); 
        gen.writeNumberField('limit', limits);
        gen.writeNumberField('offset', offset);  
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        system.debug('req::'+pretty);
        return pretty;
    }                     
    
    
    
    public class ResponseWrapper{
        @AuraEnabled public List<MasterEmergencyWrapper> response;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
        @AuraEnabled public EDealerEmergencyOrderController.EmergencyOrderWrapper kpiDetails;  
        @AuraEnabled public map<string,object>languageTranslation;
        @AuraEnabled public List<RowCount> rowCount;
    }
    
    public class RowCount{
        @AuraEnabled public Integer emergency_order;
        @AuraEnabled public Integer total_order;//rowcount
    }
    
    public class MasterEmergencyWrapper{
        @AuraEnabled public string reqd_date;
        @AuraEnabled public String orderno;
        @AuraEnabled public String orderstatus;
        @AuraEnabled public string relno;
        @AuraEnabled public string dealerpo;
        @AuraEnabled public string item;
    }
}