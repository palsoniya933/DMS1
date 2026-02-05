/*** 
* Name          :   EDealerStockingTemplateReportCntrl
*  Description  :   This is the apex class which is used for EDealerStockingTemplateReportReport component
*/ 
public class EDealerStockingTemplateReportCntrl {
    
    @AuraEnabled
    public static StockingTemplateReportResponseWrapper fetchStockingTemplateReport(String reportParamsJson){
        try{
        // saving the object to be returned
        StockingTemplateReportResponseWrapper stockingReportData = new StockingTemplateReportResponseWrapper();
        
        // creating map for API Call
        system.debug('objMDIStockingWrapper::'+reportParamsJson);
        
        // converting json to Apex
        MDIStockingWrapper reportParams = (MDIStockingWrapper) 
            JSON.deserialize(reportParamsJson, MDIStockingWrapper.class);
        system.debug('\n--reportParams--'+reportParams);
        
        // saving the http params
        map<string,object> calloutDetails = new map<string,object>();
        
        // checking if the filter values are selected 
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               calloutDetails.put('endpoint','/stocking-template-report-filter/dealer');			
           }
        else{
            calloutDetails.put('endpoint','/stocking-template/report/dealer?');      
        }
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(reportParams));	        
        calloutDetails.put('classname','EDealerStockingTemplateReportCntrl');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        system.debug('jsonRes1:::'+jsonRes);
        
        if(jsonRes != null)
            stockingReportData = (StockingTemplateReportResponseWrapper) System.JSON.deserialize(jsonRes, StockingTemplateReportResponseWrapper.class);    
        //system.debug('\n--stockingReportData--'+stockingReportData);
        
        //RETURN
        stockingReportData.dataJSON = JSON.serialize(stockingReportData.response);
        stockingReportData.languageTranslation = new map<string,string>();
                
        stockingReportData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('MDI Stocking Template');
        
        //End value transalation language data
        system.debug('languageTranslation::'+stockingReportData.languageTranslation);
        
        stockingReportData.dataJSON = JSON.serialize(stockingReportData.response);
        return stockingReportData;
        
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerStockingTemplateReportCntrl'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(MDIStockingWrapper reportParams){
        
        // divison should not be blank
        if(String.isBlank(reportParams.dealer_division)){
            throw new AuraHandledException('Division not provided');
        }        
        // should not be blank
        if(reportParams.dealer_codes == null){
            throw new AuraHandledException('Please select atleast one Dealer Location.');
        }
        
        //should not be blank
        if(reportParams.dealer_codes.isEmpty()){
            throw new AuraHandledException('Please select  atleast one Dealer Location.');
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealer_codes);
        gen.writeStringField('dealer_division', reportParams.dealer_division);
        gen.writeNumberField('offset', reportParams.offset);
        gen.writeNumberField('limit', reportParams.recLimit);
        
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
        String pretty = gen.getAsString();
        
        //system.debug('pretty ==>> '+pretty);
        
        return pretty;
    }
    
    
    /*** This class will use to parse the Stocking Template Report JSON ***/
    public class StockingTemplateReportResponseWrapper {
        @AuraEnabled public List<StockingTemplateWrapper> response {get;set;}
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public String error {get;set;}
        @AuraEnabled public List<RowCountClass> RowCount;
        @AuraEnabled public string dataJSON;
    }
    
    public class RowCountClass{
        @AuraEnabled public Integer rowcount;
    }
    
    public class StockingTemplateWrapper{
        @AuraEnabled public String loc{get;set;}
        @AuraEnabled public String distchan {get;set;}
        @AuraEnabled public String division{get;set;}
        @AuraEnabled public String dlrsplrcd{get;set;}
        @AuraEnabled public String stkclass{get;set;} 
        @AuraEnabled public String abc{get;set;}
        @AuraEnabled public Double abc_level {get;set;}
        @AuraEnabled public Integer starlevel{get;set;}
        @AuraEnabled public Integer cost{get;set;}
        @AuraEnabled public Integer mpscovdur{get;set;}
        @AuraEnabled public Integer ssrule{get;set;}
        @AuraEnabled public Decimal minss{get;set;}
        @AuraEnabled public Integer sscov{get;set;}      
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class MDIStockingWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offset;
        @AuraEnabled public List<String> dealer_codes;
        @AuraEnabled public String dealer_division;
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}