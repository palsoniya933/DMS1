/****
* Created on 16-03-2021
* To call Dealer Inventory KPI
*/
public class EDealerTotalInventoryKPI {
    
    @AuraEnabled
    public static TotalInventoryKPIResponseWrapper fetchDealerTotalInventoryKPIData(list<String> dealerCodes){
        try{
            map<string,object> calloutDetails = new map<string,object>();        
            TotalInventoryKPIResponseWrapper awsTotalResultData = new TotalInventoryKPIResponseWrapper();     
            calloutDetails.put('endpoint','/total-healthy-inventory-data/kpi/dealers');        
            calloutDetails.put('method','POST');
            calloutDetails.put('body',getEndPointParameters(dealerCodes));
            calloutDetails.put('classname','EDealerTotalInventoryKPI');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            // parsing the actual results
            if(jsonRes != null)
                awsTotalResultData = (TotalInventoryKPIResponseWrapper) 
                System.JSON.deserialize(jsonRes, TotalInventoryKPIResponseWrapper.class);
            
            return awsTotalResultData;
        }
        catch(exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerTotalInventoryKPI');            
        }
        return new TotalInventoryKPIResponseWrapper(); 
    }
    
    private static String getEndPointParameters(List<String> dealerCodes){
    	//JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
   
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    public class TotalInventoryKPIResponseWrapper{
        @AuraEnabled public List<TotalInventoryKPIWrapper> response;
        @AuraEnabled public String error;
    }
    
    
    public class TotalInventoryKPIWrapper {
        
        @AuraEnabled public String report;
        @AuraEnabled public Decimal total;
        
        
        
    }
    
}