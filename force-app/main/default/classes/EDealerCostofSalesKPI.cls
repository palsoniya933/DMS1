public class EDealerCostofSalesKPI {

    /****
     * Created on 16-03-2021
     * To call Dealer Sales Cost Report 
     */ 
    @AuraEnabled
    public static CostOfSalesKPIResponseWrapper fetchCostOfSalesKPIData(list<String> dealerCodes, String division){
    // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        CostOfSalesKPIResponseWrapper awsSalesCostResultData = new CostOfSalesKPIResponseWrapper();
        calloutDetails.put('endpoint','/cost-of-sales/kpi/dealer');       
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes, division));
        calloutDetails.put('classname','EDealerCostofSalesKPI');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);  

        // parsing the actual results
        if(jsonRes != null)
            awsSalesCostResultData = (CostOfSalesKPIResponseWrapper)System.JSON.deserialize(jsonRes, CostOfSalesKPIResponseWrapper.class);
        
        //RETURN
        return awsSalesCostResultData;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String division){
    	//JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('dealer_division', division);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    public class CostOfSalesKPIResponseWrapper{
        @AuraEnabled public List<CostOfSalesKPIWrapper> response;
        @AuraEnabled public String error;
    }
   
    /*** Returns Dealer Supplier Result Parameters/attributes ***/
    public class CostOfSalesKPIWrapper {
        @AuraEnabled public String loc;
        @AuraEnabled public String frequency;
        @AuraEnabled public String cost_of_sales;
        @AuraEnabled public String cost_of_sales_pre;
        @AuraEnabled public Double cost_percentage;
      
    }

}