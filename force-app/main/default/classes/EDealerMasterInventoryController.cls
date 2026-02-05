/****
 *  Name        :   EDealerMasterInventoryController  //add the code changes in comment  //add tag serach 
***/
public without sharing class EDealerMasterInventoryController {  
   

    
     @AuraEnabled
    public static  MasterInventoryResponseWrapper getMasterInvParts(String dealerCode, String division, Integer offSet,String recordLimit, String searchText){
         // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        MasterInventoryResponseWrapper awsSalesCostResultData = new MasterInventoryResponseWrapper();
        HttpRequest req = new HttpRequest();
        String urlParameters = dealerCode+'/inventory-data?dealer_division='+division+'&limit='+recordLimit+'&offset_value='+offSet;
        if(String.isNotBlank(searchText)){
            urlParameters += '&search_pattern='+searchText;
        }        
        
        calloutDetails.put('endpoint','/master-inventory-report/'+urlParameters);        
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerMasterInventoryController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);          
        // parsing the actual results
        if(jsonRes != null)
            awsSalesCostResultData = (MasterInventoryResponseWrapper)System.JSON.deserialize(jsonRes, MasterInventoryResponseWrapper.class);
        system.debug('\n--awsSalesCostResultData--'+awsSalesCostResultData);
        
        if(awsSalesCostResultData != null && awsSalesCostResultData.response != null){
            for(MasterInventoryPartWrapper wrap :  awsSalesCostResultData.response ){
                if(wrap.PriceDetail != null && wrap.PriceDetail.DspQtyBreak != null && !wrap.PriceDetail.DspQtyBreak.isEmpty()){
                    wrap.DualPartSelectedPriceType = 'DSP';
                }else{
                    wrap.DualPartSelectedPriceType = 'PDC';
                }
                
            }
        }
        //03-08
        awsSalesCostResultData.languageTranslation = new map<string,string>();
        awsSalesCostResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Master Inventory');
        System.debug('awsSalesCostResultData.languageTranslation '+awsSalesCostResultData.languageTranslation );
        system.debug('awsSalesCostResultData.response::'+JSON.serializePretty(awsSalesCostResultData.response));
        //RETURN
        return awsSalesCostResultData;
        
    }   
    
    
    
    
      public class MasterInventoryResponseWrapper{
        @AuraEnabled public List<MasterInventoryPartWrapper> response;
        @AuraEnabled public Integer offset_value; 
        @AuraEnabled public Integer record_count; 
        @AuraEnabled public String refresh_date; 
        @AuraEnabled public String error;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    public class MasterInventoryPartWrapper {
        @AuraEnabled public string part_number;
        @AuraEnabled public string OpartNumber;
        @AuraEnabled public string decription;
        @AuraEnabled public Integer inventory;
        @AuraEnabled public Integer min_sfty_Stk;
        @AuraEnabled public string stkcls; 
        @AuraEnabled public string distchan; 
        @AuraEnabled public string velocity_code;
        @AuraEnabled public Decimal inventory_on_hand;     
        @AuraEnabled public PriceDetailWrapper PriceDetail;
        @AuraEnabled public Boolean zero_price_flag_message;
        
        @AuraEnabled public String DualPartSelectedPriceType;
        
      /*  @AuraEnabled
       public Boolean checked  {get;set;}*/
         
        public MasterInventoryPartWrapper(){
          //checked = false;
          DualPartSelectedPriceType = 'PDC';
       }
    }
    
    public class PriceDetailWrapper{
        @AuraEnabled public String supplier;
        @AuraEnabled public Double curent_list;
        @AuraEnabled public Double resale_price;
        @AuraEnabled public Double ListPrice;
        @AuraEnabled public Double ReSale;
        @AuraEnabled public String WhsFlag;
        @AuraEnabled public String DspFlag;
        @AuraEnabled public Double WhsStdNet;
        @AuraEnabled public Double WhsFinalNet;
        @AuraEnabled public String WhsSupplier;
        @AuraEnabled public Double WhsBestNet;
        @AuraEnabled public Double DspStdNet;
        @AuraEnabled public Double DspFinalNet;
        @AuraEnabled public String DspSupplier;
        @AuraEnabled public Double DspBestNet;
        @AuraEnabled public String WqtypromoCode;
        @AuraEnabled public String DqtypromoCode;
        @AuraEnabled public List<QtyBreakWrapper> WhsQtyBreak;
        @AuraEnabled public List<QtyBreakWrapper> DspQtyBreak;
        @AuraEnabled public List<PolicyDataWrapper> PolicyData;
        @AuraEnabled public String Core;
        @AuraEnabled public Double CorePrice;
        @AuraEnabled public Double best_net;
        @AuraEnabled public String EffectiveDate;
        @AuraEnabled public String pdcfrz;
        @AuraEnabled public String DSPFRZ;
        @AuraEnabled public Double FinalNet;
        @AuraEnabled public String CoreFlag;
        @AuraEnabled public String CoreGroup;
        @AuraEnabled public String CoreClass;
        @AuraEnabled public Integer dealer_quantity_per_day;
        @AuraEnabled public String unit_of_measure;
        @AuraEnabled public String cnr_effective_date;
        @AuraEnabled public String cnr_end_date;
        @AuraEnabled public List<CSRWrapper> WhsCsr;
        @AuraEnabled public List<CSRWrapper> DspCsr;
        @AuraEnabled public String loyalty_coupon;
		@AuraEnabled public Double monthly_loyalty_coupon;
        @AuraEnabled public Double yearly_loyalty_coupon;
        @AuraEnabled public String loyalty_start_date;
        @AuraEnabled public String loyalty_end_date;
    }
    
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
    
    public class PolicyDataWrapper {
        @AuraEnabled public String PromoNumber;
        @AuraEnabled public String PromoValue;
    }
    
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

}