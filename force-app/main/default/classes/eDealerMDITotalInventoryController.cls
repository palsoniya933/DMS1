public with sharing class eDealerMDITotalInventoryController {
    @AuraEnabled(cacheable=true)
    public static InventoryDataWrapper getInventoryData(List<String> dealerCodes, String category) {

        // Creating map for API Call
        Map<String, Object> calloutDetails = new Map<String, Object>();
        calloutDetails.put('endpoint', '/details-of-Healthy-inventory-Tab/dealers');         
        calloutDetails.put('method', 'POST');
        string requestBody=getEndPointParameters(dealerCodes,category);
        calloutDetails.put('body', requestBody);
        calloutDetails.put('classname', 'eDealerMDITotalInventory');        
   
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('jsonRes--' + jsonRes);
  
        // Parsing the response and return to the lightning component
        if (jsonRes == null) {
            throw new CalloutException('Failed to retrieve inventory data: JSON response is null');
        }

        InventoryDataWrapper result = new InventoryDataWrapper();             
        try {
            // Parse the JSON response
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
            System.debug('Response Data ' + responseData);

            // Parse total data
            if (responseData.containsKey('total')) {
                Map<String, Object> totalData = (Map<String, Object>) responseData.get('total');
                result.total = new TotalInventory();
                result.total.total_inventory = (Decimal) totalData.get('total_inventory');
                result.total.total_inventory_sugg = (Decimal) totalData.get('total_inventory_sugg');
                result.total.total_inventory_not_sugg = (Decimal) totalData.get('total_inventory_not_sugg');
                result.total.total_inventory_sugg_percentage = (Decimal) totalData.get('total_inventory_sugg_percentage'); 
                result.total.total_inventory_not_sugg_percentage = (Decimal) totalData.get('total_inventory_not_sugg_percentage');                
                result.total.total_percentage = (Decimal) totalData.get('total_percentage');                
                result.total.total_pdc_sugg = (Decimal) totalData.get('total_pdc_sugg');
                result.total.total_dsp_sugg = (Decimal) totalData.get('total_dsp_sugg');
                result.total.total_pdc_not_sugg = (Decimal) totalData.get('total_pdc_not_sugg');
                result.total.total_dsp_not_sugg = (Decimal) totalData.get('total_dsp_not_sugg');
                result.total.total_pdc = (Decimal) totalData.get('total_pdc');
                result.total.total_dsp = (Decimal) totalData.get('total_dsp');
            
                System.debug('Total Value ' + result.total);
            }

            // Parse dealer data
            result.dealers = new List<DealerInventory>();
            if (responseData.containsKey('dealers')) {
                List<Object> dealerDataList = (List<Object>) responseData.get('dealers');
                for (Object dealerObj : dealerDataList) {
                    Map<String, Object> dealerData = (Map<String, Object>) dealerObj;
                    
                    DealerInventory dealerInventory = new DealerInventory();
                	dealerInventory.total_inventory = (Decimal) dealerData.get('total_inventory');
                	dealerInventory.total_inventory_sugg = (Decimal) dealerData.get('total_inventory_sugg');
                	dealerInventory.total_inventory_not_sugg = (Decimal) dealerData.get('total_inventory_not_sugg');
                	dealerInventory.total_inventory_sugg_percentage = (Decimal) dealerData.get('total_inventory_sugg_percentage'); 
                	dealerInventory.total_inventory_not_sugg_percentage = (Decimal) dealerData.get('total_inventory_not_sugg_percentage');                
                	dealerInventory.total_percentage = (Decimal) dealerData.get('total_percentage');                
                	dealerInventory.total_pdc_sugg = (Decimal) dealerData.get('total_pdc_sugg');
                	dealerInventory.total_dsp_sugg = (Decimal) dealerData.get('total_dsp_sugg');
                	dealerInventory.total_pdc_not_sugg = (Decimal) dealerData.get('total_pdc_not_sugg');
                	dealerInventory.total_dsp_not_sugg = (Decimal) dealerData.get('total_dsp_not_sugg');
                	dealerInventory.total_pdc = (Decimal) dealerData.get('total_pdc');
                	dealerInventory.total_dsp = (Decimal) dealerData.get('total_dsp');   
                    dealerInventory.loc = (String) dealerData.get('loc');

                    result.dealers.add(dealerInventory);
                }
            }
        } catch (Exception e) {
            System.debug('Error parsing JSON response: ' + e.getMessage());
            throw new CalloutException('Error parsing JSON response: ' + e.getMessage());
        }

        return result;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String category){
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeObjectField('category', category);
        gen.writeEndObject();
        
        return gen.getAsString();
    }    

    // Wrapper classes to hold data
    public class InventoryDataWrapper {
        @AuraEnabled public List<DealerInventory> dealers;
        @AuraEnabled public TotalInventory total;
    }

    public class DealerInventory {
        @AuraEnabled public Decimal total_inventory;
        @AuraEnabled public Decimal total_inventory_sugg;
        @AuraEnabled public Decimal total_inventory_not_sugg;
        @AuraEnabled public Decimal total_inventory_sugg_percentage;
        @AuraEnabled public Decimal total_inventory_not_sugg_percentage;
        @AuraEnabled public Decimal total_percentage;
        @AuraEnabled public Decimal total_pdc_sugg;
        @AuraEnabled public Decimal total_dsp_sugg;
        @AuraEnabled public Decimal total_pdc_not_sugg;
        @AuraEnabled public Decimal total_dsp_not_sugg;
        @AuraEnabled public Decimal total_pdc;
        @AuraEnabled public Decimal total_dsp;
        @AuraEnabled public String loc; // Location
    }

    public class TotalInventory {
        @AuraEnabled public Decimal total_inventory;
        @AuraEnabled public Decimal total_inventory_sugg;
        @AuraEnabled public Decimal total_inventory_not_sugg;
        @AuraEnabled public Decimal total_inventory_sugg_percentage;
        @AuraEnabled public Decimal total_inventory_not_sugg_percentage;
        @AuraEnabled public Decimal total_percentage;
        @AuraEnabled public Decimal total_pdc_sugg;
        @AuraEnabled public Decimal total_dsp_sugg;
        @AuraEnabled public Decimal total_pdc_not_sugg;
        @AuraEnabled public Decimal total_dsp_not_sugg;
        @AuraEnabled public Decimal total_pdc;
        @AuraEnabled public Decimal total_dsp;
    }

    // Custom exception for callout errors
    public class CalloutException extends Exception {}
}