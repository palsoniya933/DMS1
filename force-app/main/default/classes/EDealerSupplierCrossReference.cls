/*** 
* Name        :   EDealerSupplierCrossReference
*  Description :   This is the apex class which is used for eDealerSupplier Report component
*/ 
public class EDealerSupplierCrossReference {
    
    @AuraEnabled
    public static DealerSupplierResponseWrapper fetchAWSDealerSupplierReportData(String reportParamsJson){
        try{
        // saving the object to be returned
        DealerSupplierResponseWrapper awsDSRResultData = new DealerSupplierResponseWrapper();
        
        // creating map for API Call
        system.debug('objSupplierCrossWrapper::'+reportParamsJson);
        
        // converting json to Apex
        SupplierCrossWrapper reportParams = (SupplierCrossWrapper)JSON.deserialize(reportParamsJson, SupplierCrossWrapper.class);
        system.debug('\n--reportParams--'+reportParams);
        
        // saving the http params
        map<string,object> calloutDetails = new map<string,object>();
        
        // checking if the filter values are selected 
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               calloutDetails.put('endpoint','/supplier-cross-ref-report-filter/dealer');			
           }
        else{
            calloutDetails.put('endpoint','/supplier-cross-reference/report/dealer');      
        }
       String requestBody=getEndPointParameters(reportParams);
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',requestBody);	        
        calloutDetails.put('classname','EDealerSupplierCrossReference');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
             system.debug('body::'+requestBody);
            system.debug('jsonRes::'+jsonRes);
        // Call EDealerLogUtils class based on response status code        					
        if(jsonRes != null)
            awsDSRResultData = (DealerSupplierResponseWrapper)System.JSON.deserialize(jsonRes, DealerSupplierResponseWrapper.class);
        
        //RETURN
        awsDSRResultData.dataJSON = JSON.serialize(awsDSRResultData.response);
        awsDSRResultData.languageTranslation = new map<string,string>();
     
        awsDSRResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Supplier Cross Reference');
        
        //End value transalation language data
        system.debug('languageTranslation::'+awsDSRResultData.languageTranslation);
        
        //RETURN
        return awsDSRResultData;
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerSupplierCrossReference'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(SupplierCrossWrapper reportParams){
        
        // divison should not be blank
        if(reportParams.dealerCodes == null
           || reportParams.dealerCodes.isEmpty()){
               throw new AuraHandledException('No Dealer code selected.');
           }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealerCodes);
        gen.writeNumberField('offset', reportParams.offSet);
        gen.writeNumberField('limit', reportParams.recLimit);
        gen.writeStringField('dealer_division',reportParams.dealer_division);
        /** setting the filter params ***/
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){           
               
               gen.writeStringField('field',reportParams.field.toUpperCase());
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        gen.writeEndObject();
        
        // Get the JSON string.
        String requestBody = gen.getAsString();        
        system.debug('\n--requestBody--'+requestBody);        
        return requestBody;
    }
    
    
    public class DealerSupplierResponseWrapper{
        @AuraEnabled public List<DealerSupplierWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public String dataJSON;
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public String error;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    /*** Returns Dealer Supplier Result Parameters/attributes ***/
    public class DealerSupplierWrapper {
         @AuraEnabled public String grp;
        @AuraEnabled public String loc;
        @AuraEnabled public String division;
        @AuraEnabled public String dlrsplrcd;
        @AuraEnabled public String splrname;
        @AuraEnabled public String dmdgroup;
        @AuraEnabled public String distchan;
        @AuraEnabled public Double leadtime;
        @AuraEnabled public Double transittime;
        @AuraEnabled public String minimumname;
        @AuraEnabled public String managedsw;
        @AuraEnabled public String monday;
        @AuraEnabled public String tuesday;
        @AuraEnabled public String wednesday;
        @AuraEnabled public String thursday;
        @AuraEnabled public String friday;
        @AuraEnabled public String saturday;
        @AuraEnabled public String sunday;
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class SupplierCrossWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offSet;
        @AuraEnabled public List<String> dealerCodes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}