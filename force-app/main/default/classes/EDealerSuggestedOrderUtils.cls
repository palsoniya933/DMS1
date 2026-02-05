/**
 * @description This is the apex class which will be used to Perform SOQL operations.
*/ 
public without sharing class EDealerSuggestedOrderUtils {
    /**
     * @description to fetch list of field api names
     * @return retutn the list of field names which will used in dynamic query
    */
    public static List<String> getFieldsNames(){
        List<String> fieldsName = new List<String>();
        fieldsName.add('Dealer_Ineventory_Qty__c');
        fieldsName.add('Dealer_Location__r.Dealer_Code__c');
        fieldsName.add('Dealer_Supplier_Code__c');
        fieldsName.add('Part_Category_Type__c');
        fieldsName.add('Part_Description__c');
        fieldsName.add('Part_Name__c');
        fieldsName.add('Qty_on_Order__c');
        fieldsName.add('Qty_on_Order_Today__c');
        fieldsName.add('Serial_Number__c');
        fieldsName.add('Stocking_List_Type__c');
        fieldsName.add('Suggested_Qty__c');
        fieldsName.add('Total_Qty_In_Cart__c');
        fieldsName.add('Total_Qty_Ordered__c');
        fieldsName.add('Supersession_Indicator__c');
        fieldsName.add('Emergency_Indicator__c');
        fieldsName.add('Lead_Time__c');
        fieldsName.add('SOF_File_Date__c');
        fieldsName.add('Pricing_Detail__c'); 
        fieldsName.add('Original_Part_Type__c');
        fieldsName.add('Velocity_Code__c');
        fieldsName.add('SPQ__c');
        fieldsName.add('SOF_Comments__c');
        fieldsName.add('DBS_Type__c');
        fieldsName.add('SOF_Created_DT__c');
        fieldsName.add('SOF_Type__c');
        fieldsName.add('Is_Special_Order_Part__c');
        fieldsName.add('Stocking_Class__c');
        return fieldsName;
    }
    
    /**
     * @description this method will use to get the list of Suggested orders/parts for Set of dealerCodes where created date today
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersForToday(Set<String> setDealerLocs){
        return getSuggestedOrdersForToday(setDealerLocs, null);
    }
    
    /**
     * @description this method will use to get the list of Suggested orders/parts for Set of dealerCodes where created date today and is promo or not promo
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersForToday(Set<String> setDealerLocs, Boolean isPromo){
        return getSuggestedOrdersByDealerLocs(setDealerLocs, isPromo, true);
    }
    /**
     * @description this method will use to get the list of Suggested orders/parts for Set of dealerCodes where created date today or not and is promo or not promo
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersByDealerLocs(Set<String> setDealerLocs,Boolean isPromo, Boolean isCreatedToday){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM EDealer_Suggested_Order__c';
        query += ' WHERE Dealer_Location__r.Dealer_Code__c IN :setDealerLocs';
        if(isCreatedToday == true){
            query += ' AND CreatedDate = TODAY';
        }
        if(isPromo != null){
            query += ' AND Is_Special_Order_Part__c = :isPromo'; 
        }
        
        //SOQL
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = Database.query(query);
        
        return lstSuggestedOrders;
    }
    /**
     * @description this method will use to get the list of Suggested orders/parts for Set of suggested part salesfroce ids and where created date is today
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersForTodayByIds(Set<Id> setSuggestedPartsId){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM EDealer_Suggested_Order__c';
        query += ' WHERE Id IN :setSuggestedPartsId';
        query += ' AND CreatedDate = TODAY';
         
        //SOQL
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = Database.query(query);
        return lstSuggestedOrders;
    }
    /**
     * @description this method will use to get the today created suggested orders by order type
     * @return return the soql query response
    */
    public static List<SuggestedOrderWrapper> getSuggestedOrdersForToday(String dealerLocationId, string categoryType, String sofType){
        return getSuggestedOrdersForToday(dealerLocationId, categoryType, sofType, null);
        
    }
    
    /**
     * @description this method will use to get the today created suggested orders by order type with is special order (promo) or not
     * @return return the soql query response
    */
    public static List<SuggestedOrderWrapper> getSuggestedOrdersForToday(String dealerLocationId, string categoryType, String sofType, Boolean isSpecialOrders){
        List<SuggestedOrderWrapper> sowList = new List<SuggestedOrderWrapper>();
        
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM EDealer_Suggested_Order__c';
        query += ' WHERE CreatedDate = TODAY';
        
        if(isSpecialOrders != null){
            query += ' AND Is_Special_Order_Part__c = :isSpecialOrders';
        }
        
        if(String.isNotBlank(dealerLocationId)){
            query += ' AND Dealer_Location__c =:dealerLocationId';
        }
        if(String.isNotBlank(categoryType)){
            query += ' AND Part_Category_Type__c =:categoryType';
        }
        if(String.isNotBlank(sofType)){
            query += ' AND Type__c =:sofType';
        }
        
        //SOQL
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = Database.query(query);
        
        
        for(EDealer_Suggested_Order__c so : lstSuggestedOrders){
            SuggestedOrderWrapper soWrap = new SuggestedOrderWrapper(so);
            sowList.add(soWrap);
        }
        
        return sowList;
    }
    
    /**
     * @description this method will use to get the today created suggested orders based on sof type
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersForToday(String dealerLocation, String sofType){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM EDealer_Suggested_Order__c';
        query += ' WHERE CreatedDate = TODAY';
        
        if(String.isNotBlank(dealerLocation)){
            query += ' AND Dealer_Location__c =:dealerLocation';
        }
        if(String.isNotBlank(sofType)){
            query += ' AND Type__c =:sofType';
        }
        
        //SOQL
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = Database.query(query);
        
        return lstSuggestedOrders;
    }
    
    /**
     * @description this method will use to get the today created suggested orders
     * @return return the soql query response
    */
    public static List<EDealer_Suggested_Order__c> getSuggestedOrdersForToday(String dealerLocation, String sofType, Boolean isSpecialOrders){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM EDealer_Suggested_Order__c';
        query += ' WHERE CreatedDate = TODAY';
        
        if(isSpecialOrders != null){
            query += ' AND Is_Special_Order_Part__c = :isSpecialOrders';
        }
        
        if(String.isNotBlank(dealerLocation)){
            query += ' AND Dealer_Location__c =:dealerLocation';
        }
        if(String.isNotBlank(sofType)){
            query += ' AND Type__c =:sofType';
        }
        
        //SOQL
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = Database.query(query);
        
        return lstSuggestedOrders;
    }
     
    /**
     * @description this method used to call the SOF (suggested order file) Api this method will use to get the today created suggested orders
     * @return return the soql query response
    */
    public static SuggestedOrderFileWrapper callSuggestedOrdersApi(List<String> dealerCodes, String division, Boolean isPromo){
        SuggestedOrderFileWrapper awsSOFResult = new SuggestedOrderFileWrapper();
        
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint', '/suggested-order-file/parts-data/dealer');            
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getEndPointParameters(dealerCodes, division, isPromo));
        calloutDetails.put('classname','EDealerSuggestedOrderUtils');
        calloutDetails.put('methodname','callSuggestedOrdersApi');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        // parsing the actual results
        if(jsonRes != null){
            system.debug('JSON Response is '+jsonRes);
        	awsSOFResult = (SuggestedOrderFileWrapper)System.JSON.deserialize(jsonRes, SuggestedOrderFileWrapper.class);
            System.debug('awsSOFResult'+awsSOFResult);
        }
        
        return awsSOFResult;
    }
    
   /**
     * @description this is the method which will be used to make sure that we have params to be send to API
     * @return return the request body string
    */ 
    private static String getEndPointParameters(List<String> dealerCodes, String division, Boolean isPromo){
        // divison should not be blank
        if(dealerCodes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(dealerCodes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        } 
        // from location should not be blank
        if(String.isBlank(division)){
            throw new AuraHandledException('Division not available');
        }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('dealer_division', division);
        //sof_promo"
        if(isPromo){
           gen.writeStringField('sof_promo', 'Y'); 
        }else{
            gen.writeStringField('sof_promo', 'N');
        }
        
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        System.debug('pretty sof --> '+pretty);
        return pretty;
    }
    
    /**
     * @description to handle the suggested order file api main response body
    */ 
    public class SuggestedOrderFileWrapper{
        @AuraEnabled public List<OrderWrapper> response;//sof_data
        @AuraEnabled public String dealer_code;
        @AuraEnabled public String sof_file_time;
        @AuraEnabled public String Dbs;// use to know the dealer location belong to DSi or any other
       	@AuraEnabled public String error;
        @AuraEnabled public String message;
    }
    /**
     * @description to handle the each suggested part detail which present in sof api response
    */
    public class OrderWrapper {
        //@AuraEnabled public String sof_file_version {get;set;}
        @AuraEnabled public String dealer_supplier_code {get;set;}
        @AuraEnabled public String part_category_type {get;set;}
        @AuraEnabled public Integer serial_number {get;set;}
        @AuraEnabled public String part_name {get;set;}
        @AuraEnabled public String decription{get;set;} //part_description 
        @AuraEnabled public Integer inventory_on_hand {get;set;} // 
        @AuraEnabled public Decimal suggested_qty {get;set;}
        @AuraEnabled public String stocking_list_type {get;set;}
        @AuraEnabled public Decimal qty_on_order {get;set;}
        @AuraEnabled public String emergency_indicator {get;set;}
        @AuraEnabled public Integer lead_time {get;set;}
        @AuraEnabled public Integer qtyInTodayCart {get;set;}
        @AuraEnabled public string velocity_code {get;set;}
        @AuraEnabled public Decimal spq {get;set;}
        @AuraEnabled public String sof_comments {get;set;}
        @AuraEnabled public SuggestedPartPriceWrapper PriceDetail {get;set;}
         @AuraEnabled public String  Stocking_Class {get;Set;}
    }
    /**
     * @description Wrapper class used to save Save Suggested Order Data
    */
    public class SuggestedOrderWrapper {
        @AuraEnabled public Id suggestedOrderId {get;set;}
        @AuraEnabled public Id dealerLocationId {get;set;}
        @AuraEnabled public String dealer_code {get;set;}
        @AuraEnabled public String dealer_supplier_code {get;set;}
        @AuraEnabled public String Part_category_Type {get;set;}
        @AuraEnabled public Integer Serial_Number {get;set;}
        @AuraEnabled public String Part_Name {get;set;}
        @AuraEnabled public String Part_Description {get;set;}
        @AuraEnabled public Integer Dealer_Ineventory_Qty {get;set;}
        @AuraEnabled public Integer Suggested_Qty {get;set;}
        @AuraEnabled public String Stocking_list_Type {get;set;}
        @AuraEnabled public Integer Qty_on_Order {get;set;}
        @AuraEnabled public Integer qtyInTodayCart {get;set;}
        @AuraEnabled public Integer qtyOrdered {get;set;}
        @AuraEnabled public Integer qtyForOrder {get;set;}
        @AuraEnabled public Boolean Supersession_Indicator {get;set;}
        @AuraEnabled public Boolean Emergency_Indicator {get;set;}
        @AuraEnabled public Integer Lead_Time {get;set;}
        @AuraEnabled public DateTime sof_file_time {get;set;}
        @AuraEnabled public Boolean checked {get;set;}
        @AuraEnabled public Integer qtyForOrderPlaceHolder {get;set;}
        @AuraEnabled public SuggestedPartPriceWrapper PriceDetail {get;set;}
        @AuraEnabled public String PartOriginalType {get;set;}
        @AuraEnabled public String DualPartSelectedPriceType {get;set;}
        @AuraEnabled public string velocity_code {get;set;}
        @AuraEnabled public Decimal spq {get;set;}
        @AuraEnabled public String sof_comments {get;set;}
        @AuraEnabled public Boolean isPromo {get;set;}
        @AuraEnabled public Boolean isSOFCommentClickable {get;Set;}
        @AuraEnabled public String  Stocking_Class {get;Set;}
        /**
        * @description default constructor
        */
        public SuggestedOrderWrapper(){
            Emergency_Indicator = false;
        }
        /**
        * @description parameterized constructor
        */
        public SuggestedOrderWrapper(EDealer_Suggested_Order__c so){
            suggestedOrderId = so.Id;
            dealerLocationId = so.Dealer_Location__c;
            dealer_code = so.Dealer_Location__r.Dealer_Code__c;
            dealer_supplier_code = so.Dealer_Supplier_Code__c;
            Part_category_Type = so.Part_Category_Type__c;
            Serial_Number = (so.Serial_Number__c != null) ? Integer.valueOf(so.Serial_Number__c) : null;
            Part_Name = so.Part_Name__c;
            Stocking_Class = so.Stocking_Class__c;
            Part_Description = so.Part_Description__c;
            Dealer_Ineventory_Qty = (so.Dealer_Ineventory_Qty__c != null ? Integer.valueOf(so.Dealer_Ineventory_Qty__c) : 0 );
            Suggested_Qty = (so.Suggested_Qty__c != null ? Integer.valueOf(so.Suggested_Qty__c) : 0 );
            Stocking_list_Type = so.Stocking_List_Type__c;
            Qty_on_Order = (so.Qty_on_Order__c != null ? Integer.valueOf(so.Qty_on_Order__c) : 0 );
            qtyInTodayCart = (so.Total_Qty_In_Cart__c != null ? Integer.valueOf(so.Total_Qty_In_Cart__c) : 0 );
            qtyOrdered = (so.Total_Qty_Ordered__c != null ? Integer.valueOf(so.Total_Qty_Ordered__c) : 0 );
            //qtyInTodayCart = 0;// default for R 1.1 realease
            //qtyOrdered = 0;// default for R 1.1 realease 
            Supersession_Indicator = so.Supersession_Indicator__c;
            Emergency_Indicator = so.Emergency_Indicator__c;
            Lead_Time =  (so.Lead_Time__c == null) ? null : Integer.valueOf(so.Lead_Time__c);
            sof_file_time = so.SOF_File_Date__c;
            checked = false;//default
            velocity_code = so.Velocity_Code__c;
            
            qtyForOrderPlaceHolder = Suggested_Qty - (qtyInTodayCart + qtyOrdered);
            if(qtyForOrderPlaceHolder < 0){
                qtyForOrderPlaceHolder= 0; 
            } 
            
            if(String.isNotBlank(so.Pricing_Detail__c)){
                try{
                    PriceDetail = (SuggestedPartPriceWrapper) JSON.deserialize(so.Pricing_Detail__c, SuggestedPartPriceWrapper.class);
                }catch(Exception e){
                    system.debug('Error Message : '+e.getMessage());
                }
            }
            
            PartOriginalType = so.Original_Part_Type__c;
            //Default
            DualPartSelectedPriceType = PartOriginalType;
            
            //spq details
            spq = so.SPQ__c;
            //sof comments
            sof_comments = so.SOF_Comments__c;
            
            //on ui, comment which start with xs, only clickable
            if(String.isNotBlank(sof_comments) && sof_comments.startsWithIgnoreCase('xs')){
                isSOFCommentClickable = true;
            }
            
            // part is promo or normal sof part
            isPromo = so.Is_Special_Order_Part__c;
        }
        
        /**
        * @description parameterized constructor
        */
        public SuggestedOrderWrapper(OrderWrapper oWrap, String dealerCode){
            dealer_code = dealerCode;
            dealer_supplier_code = oWrap.dealer_supplier_code;
            Part_category_Type = oWrap.Part_category_Type;
            Serial_Number = oWrap.Serial_Number;
            Part_Name = oWrap.Part_Name;
            Stocking_Class = oWrap.Stocking_Class;
            Part_Description = oWrap.decription;//Part_Description
            Dealer_Ineventory_Qty = (oWrap.inventory_on_hand == null) ? 0 : oWrap.inventory_on_hand;
            Suggested_Qty = (oWrap.Suggested_Qty == null) ? 0 : Integer.valueOf(oWrap.Suggested_Qty);
            Stocking_list_Type = oWrap.Stocking_list_Type;
            Qty_on_Order = (oWrap.Qty_on_Order == null) ? 0 : Integer.valueOf(oWrap.Qty_on_Order);
            qtyInTodayCart = 0;
            qtyOrdered = 0;
            Lead_Time =  (oWrap.Lead_Time == null) ? 0 : Integer.valueOf(oWrap.Lead_Time);
            checked = false;//default
            qtyForOrderPlaceHolder = this.Suggested_Qty - (qtyInTodayCart + qtyOrdered);
            if(qtyForOrderPlaceHolder < 0){
                qtyForOrderPlaceHolder= 0;    
            }
            
            velocity_code = oWrap.velocity_code;
			//spq details
			spq = oWrap.spq;
            //////
            sof_comments = oWrap.sof_comments;
            //on ui, comment which start with xs, only clickable
            if(String.isNotBlank(sof_comments) && sof_comments.startsWithIgnoreCase('xs')){
                isSOFCommentClickable = true; 
            } 
        }
        
        
    }
    
    /**
    * @description Wrapper class for SOF POST request
    */ 
    public class SORequestWrapper {
        @AuraEnabled
        public String DealerID;
        @AuraEnabled
        public String UserID;
        @AuraEnabled
        public String OrderType;
        @AuraEnabled
        public String CustomerPO;
        @AuraEnabled
        public String FrightCarrier;
        @AuraEnabled
        public Double RequestShipDate;
        
    }
    /**
    * @description Wrapper class for price detail response body
    */
    public class SuggestedPartsPriceAPIResponseWrapper {
        @AuraEnabled public List<SuggestedPartPriceWrapper> response;
        @AuraEnabled public String error;
        @AuraEnabled public HTTPResponse httpRes {get;set;}
        @AuraEnabled public HTTPRequest httpReq {get;set;}
        @AuraEnabled public String APIName {get;set;}
    }
    /**
    * @description Wrapper class for price detail for each part
    */
    public class SuggestedPartPriceWrapper{
        @AuraEnabled public String CustomerNumber {get;set;}
        @AuraEnabled public String CustomerSuffix {get;set;}
        @AuraEnabled public String OpartNumber {get;set;}
        @AuraEnabled public Integer Quantity {get;set;}
        @AuraEnabled public Double ListPrice {get;set;}
        @AuraEnabled public Double ReSale {get;set;}
        @AuraEnabled public String WhsDspFlag {get;set;}
        @AuraEnabled public Double WhsStdNet {get;set;}
        @AuraEnabled public Double WhsFinalNet {get;set;}
        @AuraEnabled public Double DspStdNet {get;set;}
        @AuraEnabled public Double DspFinalNet {get;set;}
        @AuraEnabled public String LoyaltyCode {get;set;}
        @AuraEnabled public Double LoyaltyDiscount {get;set;}
        @AuraEnabled public Integer LoyaltyBegDate {get;set;}
        @AuraEnabled public Integer LoyaltyEndDate {get;set;}
        @AuraEnabled public String WqtypromoCode {get;set;}
        @AuraEnabled public String DqtypromoCode {get;set;}
        @AuraEnabled public List<QtyBreakWrapper> WhsQtyBreak {get;set;}
        @AuraEnabled public List<QtyBreakWrapper> DspQtyBreak {get;set;}
        @AuraEnabled public List<PolicyDataWrapper> PolicyData {get;set;}
        @AuraEnabled public String Core {get;set;}
        @AuraEnabled public Double CorePrice {get;set;}
        @AuraEnabled public List<CSRWrapper> WhsCsr {get;set;}
        @AuraEnabled public List<CSRWrapper> DspCsr {get;set;}
        @AuraEnabled public Integer dealer_quantity_per_day {get;set;}
        @AuraEnabled public String unit_of_measure {get;set;}
        @AuraEnabled public String cnr_effective_date {get;set;}
        @AuraEnabled public String cnr_end_date {get;set;}
        @AuraEnabled public String Saleableindicator {get;set;}
        @AuraEnabled public String loyalty_coupon {get;set;}
        @AuraEnabled public Double monthly_loyalty_coupon {get;set;}
        @AuraEnabled public Double yearly_loyalty_coupon {get;set;}
        @AuraEnabled public String loyalty_start_date {get;set;}
        @AuraEnabled public String loyalty_end_date {get;set;}
        @AuraEnabled public String RSV_Comment {get;Set;}
        // Added for Loyalty Coupon
        @AuraEnabled public String loyaltyflag {get;Set;}
        @AuraEnabled public Double discountamount {get;set;}
        @AuraEnabled public String couponcode {get;Set;} 
        @AuraEnabled public String printcode {get;Set;}         

    }
    /**
    * @description Wrapper class for csr detail
    */
    public class CSRWrapper {
        @AuraEnabled public Integer CsrNumber;
        @AuraEnabled public Integer CsrPhase;
        @AuraEnabled public Integer CsrLine;
        @AuraEnabled public Double CsrQty;
        @AuraEnabled public Double CsrBestNet;
        @AuraEnabled public String CsrEffectiveDate;
        @AuraEnabled public String CsrExpiryDate;
        @AuraEnabled public String DISChannel;
    }
    /**
    * @description Wrapper class for quantity break down
    */
    public class QtyBreakWrapper {
        @AuraEnabled public String QtyBreak;
        @AuraEnabled public Double QtyDiscPerc;
        @AuraEnabled public Double QtyPrice;
        @AuraEnabled public String DISChannel;
        @AuraEnabled public Double StdNet;
        @AuraEnabled public String BeatCode;
        @AuraEnabled public Double QtyFinal;
        @AuraEnabled public String CSR;
        @AuraEnabled public Double FNLNET;
        @AuraEnabled public Double INCENTIVE;
    }
    /**
    * @description Wrapper class for promo detail
    */
    public class PolicyDataWrapper {
        @AuraEnabled public String PromoNumber {get;set;}
        @AuraEnabled public String PromoValue {get;set;}
    }
}