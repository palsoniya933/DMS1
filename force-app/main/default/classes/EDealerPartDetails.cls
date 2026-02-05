/****
*  This is the apex class which will be used to get details for parts
**/

public class EDealerPartDetails{
    
    
    /****
* This method return the Data which we will show on Part Availibility Section On U.I (parts details page)
*/ 
    @AuraEnabled
    public static PartAvailabilityWrapper fetchPartAvailabilityDetails(String dealerCode, String partNum, String userName){
    // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        PartAvailabilityWrapper awsReportResultData = new PartAvailabilityWrapper();
        HttpRequest req = new HttpRequest();        
        calloutDetails.put('endpoint','/parts-availibility/'+dealerCode+'?user_id='+userName+'&item_id='+partNum);        
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerPartDetails');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        //system.debug('\n--fetchPartAvailabilityDetails--'+jsonRes);
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null)
            awsReportResultData = (PartAvailabilityWrapper)System.JSON.deserialize(jsonRes, PartAvailabilityWrapper.class);
            //system.debug('\n--awsReportResultData--'+awsReportResultData);
            
            
         awsReportResultData.languageTranslation = new map<string,string>();
            awsReportResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Part Availability');
            System.debug('awsReportResultData.languageTranslation '+awsReportResultData.languageTranslation );
        return awsReportResultData;
    }
    
    /***
    * This method convert the string number to integer number
    * if this method fail to convert then it will return NULL
    */ 
    public static Integer stringToInteger(String strNum){
        try{
            Integer num = Integer.valueOf(strNum);
            return num;
        }catch(Exception e){
            return null;
        }
    }
    
    
    
    // this is the method which will be used to pull details on load of the Part details component
    // WIP
    @AuraEnabled
    public static PartDetailsResponseWrapper fetchOnloadDetails_apex(String partNum, String division){
        PartDetailsResponseWrapper partDetails = new PartDetailsResponseWrapper();
        map<string,object> calloutDetails = new map<string,object>(); 
        calloutDetails.put('endpoint','/parts-availibility/parts-image-url/part/'+partNum+'?dealer_division='+division+'&user_language=EN');        
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerPartDetails');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the response and return to the lightning component
        if(jsonRes != null)
            partDetails = (PartDetailsResponseWrapper) System.JSON.deserialize(jsonRes, PartDetailsResponseWrapper.class);
        
        return partDetails;
    }   
    
    
    /****
    * 24-02-2021
    * This Method will return the Part Details by get from SnowFlakes like : part description
    */ 
    @AuraEnabled
    public static PartDetailFromSnowFlakeResponseWrapper PartDetailFromSnowFlake(string partNum, string lan, String division, string dealecode){            
        PartDetailFromSnowFlakeResponseWrapper partDetails = new PartDetailFromSnowFlakeResponseWrapper();        
        system.debug('\n--dealecode--'+dealecode);        
        map<string,object> calloutDetails = new map<string,object>(); 
        calloutDetails.put('endpoint','/parts-availibility/part-details/dealer/'+dealecode+'?part_number='+partNum+'&dealer_division='+division+'&user_language=EN');        
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerPartDetails');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);             
        //system.debug('\n--getStatusCode--'+res.getStatusCode());
        //system.debug('\n--res--'+res.getBody());
        
        if(jsonRes != null){
            partDetails = (PartDetailFromSnowFlakeResponseWrapper) System.JSON.deserialize(jsonRes, PartDetailFromSnowFlakeResponseWrapper.class);
        }
        partDetails.languageTranslation = new map<string,string>();
            partDetails.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Alternative Parts');
            System.debug('partDetails.languageTranslation '+partDetails.languageTranslation );
        System.debug('partDetails 2==>> '+partDetails);
        
        return partDetails;
        
    }   
    
    
    public class PartDetailFromSnowFlakeResponseWrapper {
        @AuraEnabled public cls_response response {get;set;}
        @AuraEnabled public String error {get;set;}
        @AuraEnabled public map<string,object>languageTranslation;
       
    }
    public class cls_response {
        @AuraEnabled public String part_number;
        @AuraEnabled public String part_name;   
        @AuraEnabled public String full_description;   
        @AuraEnabled public String attribute_description;  
        @AuraEnabled public String part_description; 
        @AuraEnabled public String part_source; 
        @AuraEnabled public String saleable_indicator; 
        @AuraEnabled public String stocking_indicator;  
        @AuraEnabled public String unit_of_measure; 
        @AuraEnabled public String stocking_class;  
        @AuraEnabled public String weight;  
        @AuraEnabled public String core_indicator;  
        @AuraEnabled public String current_part_number; 
        @AuraEnabled public AlternativePartWrapper[] alternate_parts;
        @AuraEnabled public cls_recommended_parts[] recommended_parts;
        @AuraEnabled public PartDetailWrapper[] parts_details;
        @AuraEnabled public DealerDataWrapper[] dealers_data;
        @AuraEnabled public cls_parts_pricing[] parts_pricing;
    }
    
    public class cls_recommended_parts {
    }
    public class cls_parts_details {
        @AuraEnabled public String partid; 
        @AuraEnabled public String partnumber; 
        @AuraEnabled public String languagecode;   
        @AuraEnabled public String attributename; 
        @AuraEnabled public String value;   
    }
    public class cls_dealers_data {
        @AuraEnabled public String dealer_code; 
        @AuraEnabled public String dealer_name; 
        @AuraEnabled public String availibility;    
        @AuraEnabled public String phone_number;    
        @AuraEnabled public String location;    
    }
    public class cls_parts_pricing {
        @AuraEnabled public String part_number; 
        @AuraEnabled public String inventory_on_hand;  
        @AuraEnabled public String velocity_code;   
        @AuraEnabled public EDealerMasterInventoryController.PriceDetailWrapper PriceDetail;
    }
    public class cls_PriceDetail {
        @AuraEnabled public String supplier;    
        @AuraEnabled public String ListPrice;   
        @AuraEnabled public String CsrPhase;    
        @AuraEnabled public String curent_list; 
        @AuraEnabled public String ReSale;  
        @AuraEnabled public String WhsSupplier; 
        @AuraEnabled public String WhsStdNet;   
        @AuraEnabled public String WhsBestNet;  
        @AuraEnabled public cls_WhsQtyBreak[] WhsQtyBreak;
        @AuraEnabled public cls_WhsQtyBreak[] DspQtyBreak;
        @AuraEnabled public String WhsFinalNet; 
        @AuraEnabled public String WqtypromoCode;  
        @AuraEnabled public String best_net;    
        @AuraEnabled public String CsrNumber;         
        @AuraEnabled public String CsrLine; 
        @AuraEnabled public String CsrQty; 
        @AuraEnabled public String CsrBestNet; 
        @AuraEnabled public String CsrEffectiveDate;  
        @AuraEnabled public String CsrExpiryDate;  
        @AuraEnabled public String EffectiveDate;  
        @AuraEnabled public String pdcfrz;  
        @AuraEnabled public String DSPFRZ;  
        @AuraEnabled public String Core;   
        @AuraEnabled public String CorePrice;  
        @AuraEnabled public String CoreGroup;  
        @AuraEnabled public String CoreClass;   
        @AuraEnabled public String WhsFlag;
        @AuraEnabled public String DspFlag;
        @AuraEnabled public String DspSupplier;
        @AuraEnabled public String DspStdNet;
        @AuraEnabled public String DspFinalNet;
        @AuraEnabled public String DspBestNet;
    }
    public class cls_WhsQtyBreak {
        @AuraEnabled public String QtyBreak;   
        @AuraEnabled public String QtyPrice;    
        @AuraEnabled public String QtyDiscPerc; 
    }
    
   
    
    public class DealerDataWrapper{
        @AuraEnabled public String availibility {get;set;}
        @AuraEnabled public String dealer_code {get;set;}
        @AuraEnabled public String dealer_name {get;set;}
        @AuraEnabled public String location {get;set;} 
        @AuraEnabled public String phone_number {get;set;}
    }
    public class PartDetailWrapper{
        @AuraEnabled public decimal partid {get;set;}
        @AuraEnabled public String partnumber {get;set;}
        @AuraEnabled public String languagecode {get;set;}
        @AuraEnabled public String attributename {get;set;} 
        @AuraEnabled public String value {get;set;}
    }
    
    public class AlternativePartWrapper{
        @AuraEnabled public String part_number {get;set;}
        @AuraEnabled public String description {get;set;}
        @AuraEnabled public String saleableindicator {get;set;}
        //@AuraEnabled public Integer sort {get;set;} // can not use SORT because it is a keyword in salesforce
        @AuraEnabled public String relationship_type {get;set;}
    }
    
    public class PartDetailsResponseWrapper{
        //@AuraEnabled public string part_id {get;set;}
        @AuraEnabled public PartDetailsWrapper response {get;set;}
        @AuraEnabled public String error {get;set;}
    }
    public class PartDetailsWrapper{
        //@AuraEnabled public string part_id {get;set;}
        @AuraEnabled public string part_Num {get;set;}
        @AuraEnabled public List<string> cdn_path {get;set;}
        @AuraEnabled public List<string> document {get;set;}
        @AuraEnabled public List<string> video {get;set;}
    }
    
    
    public class PartAvailabilityWrapper{
        @AuraEnabled public string ErrorMSG {get;set;}
        @AuraEnabled public Integer NoOfRecords {get;set;}
        @AuraEnabled public List<PartAvailabilityItemWrapper> PartAvl {get;set;}
        @AuraEnabled public string DspStdDays {get;set;}
        @AuraEnabled public string DspEmDays {get;set;}
        @AuraEnabled public string SuppLeadTm {get;set;}
        @AuraEnabled public string TrukLeadTm {get;set;}
         @AuraEnabled public map<string,object>languageTranslation;
        
    }
    
    public class PartAvailabilityItemWrapper{
        @AuraEnabled public string PdcCode {get;set;}
        @AuraEnabled public string AvailQty {get;set;}
        //For Available Qty. (Integer)
        @AuraEnabled public Integer AvailQtyInt {get;set;}
        @AuraEnabled public string IntranQty {get;set;}
        //For In Transit Qty. (Integer)
        @AuraEnabled public Integer IntranQtyInt {get;set;}
        @AuraEnabled public string EstDate {get;set;}
        @AuraEnabled public string OrderQty {get;set;}
        //For Order Qty. (Integer)
        @AuraEnabled public Integer OrderQtyInt {get;set;}
        @AuraEnabled public string EstAvail {get;set;}
        @AuraEnabled public string PdcLeadTm {get;set;}
        
        //For qty for cart
        @AuraEnabled public Integer qtyForOrder {get;set;}
        
        //for U.I Checkbox
        @AuraEnabled public Boolean checked {get;set;}
    }
    
    
}