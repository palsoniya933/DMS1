/**
* @File Name : eDealerExcess90Days.cls
* @Description : View Drill Down / Details of Excess 90 Days Tab
* @Author : Deepak Sachdeva
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 31, 2025 |   | Initial Version
**/

public class eDealerExcess90Days {
    
    @AuraEnabled
    public static excess90DaysResponseWrapper getExcess90DaysData(List<String> dealerCodes, String category){
        excess90DaysResponseWrapper excess90DaysResponse = new excess90DaysResponseWrapper();
        
        // Creating map for API Call
        Map<String, Object> calloutDetails = new Map<String, Object>();
        calloutDetails.put('endpoint', '/details-of-Healthy-inventory-Tab/dealers');         
        calloutDetails.put('method', 'POST');
        string requestBody=getEndPointParameters(dealerCodes,category);
        calloutDetails.put('body', requestBody);
        calloutDetails.put('classname', 'eDealerExcess90Days');
        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes >>> ' + jsonRes);
        System.debug('body >>> ' + getEndPointParameters(dealerCodes,category));
        
        if(jsonRes != null){
            excess90DaysResponse = (excess90DaysResponseWrapper)System.JSON.deserialize(jsonRes, excess90DaysResponseWrapper.class);
        }
        
        return excess90DaysResponse;
    }
    
    private static String getEndPointParameters(List<String> dealerCodes, String category){
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeObjectField('category', category);
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    /*** Response Wrapper ***/
    public class excess90DaysResponseWrapper {
        @AuraEnabled    public List<DealerInventoryData> dealers;
        @AuraEnabled    public TotalInventoryData total;
    }
    
    public class DealerInventoryData {
        @AuraEnabled   public String loc;
        @AuraEnabled   public Decimal total_inventory;
        @AuraEnabled   public Decimal total_inventory_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_inventory_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Double  total_inventory_mdi_90_day_excess_sugg_percentage;
        @AuraEnabled   public Double  total_inventory_not_mdi_90_day_excess_sugg_percentage;
        @AuraEnabled   public Decimal total_percentage;
        @AuraEnabled   public Decimal total_pdc_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_dsp_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_pdc_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_dsp_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_pdc;
        @AuraEnabled   public Decimal total_dsp;
    }
    
    public class TotalInventoryData {
        @AuraEnabled   public Decimal total_inventory;
        @AuraEnabled   public Decimal total_inventory_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_inventory_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Double total_inventory_mdi_90_day_excess_sugg_percentage;
        @AuraEnabled   public Double total_inventory_not_mdi_90_day_excess_sugg_percentage;
        @AuraEnabled   public Decimal total_percentage;
        @AuraEnabled   public Decimal total_pdc_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_dsp_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_pdc_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_dsp_not_mdi_90_day_excess_sugg;
        @AuraEnabled   public Decimal total_pdc;
        @AuraEnabled   public Decimal total_dsp;
    }
}