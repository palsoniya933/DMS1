/**
* @description This class used to get the sof summary details via api call
*/ 
public class EDealerSOFSummary {
    
    /**
    * @description Parse the sof summary data into salesforce summary object
    * @return retun the list of Sof summary objects
    */
    public static List<EDealer_SOF_Summary__c> sofSummaryParse(List<SOFSummaryDataWrapper> wrapList){
        List<EDealer_SOF_Summary__c> lstSOFSummary = new List<EDealer_SOF_Summary__c>();
        
        if(wrapList != null){
            for(SOFSummaryDataWrapper wrap : wrapList){
                EDealer_SOF_Summary__c summary = new EDealer_SOF_Summary__c();
                summary.Dealer_Code__c = wrap.dealer_code;
                summary.Dealer_Divison__c = wrap.dealer_divison;
                summary.SOF_Count__c = wrap.sof_count;
                if(String.isNotBlank(wrap.sof_time)){
                    summary.SOF_Date_Time__c = Datetime.valueOf(wrap.sof_time);
                }
                summary.Time_of_Day__c = wrap.time_of_day;
                
                lstSOFSummary.add(summary);
            }
        }
        
        return lstSOFSummary;
    }
    
    /**
    * @description call api to get sof summary data
    * @return retutn the api response in wrapper object
    */
    public static SOFSummaryResponseWrapper fetchSOFSummary(String gmtDTStr){
        SOFSummaryResponseWrapper awsResultData = new SOFSummaryResponseWrapper();
        
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint', '/suggested-order-file/summary-data/data');            
        calloutDetails.put('method','POST');
        calloutDetails.put('body','{"start_time":"'+gmtDTStr+'"}');
        calloutDetails.put('classname','EDealerSOFSummary');
        calloutDetails.put('methodname','fetchSOFSummary');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
        if(jsonRes != null){
            try{
                awsResultData = (SOFSummaryResponseWrapper)System.JSON.deserialize(jsonRes, SOFSummaryResponseWrapper.class);
            }catch(Exception ex){
                EDealerLogUtils.createExceptionLog(ex, 'EDealerSOFSummary');
            }
            
        }
        //return
        return awsResultData;
    }
    
    
    /**
    * @description to handle the sof summary api response body
    */
    public class SOFSummaryResponseWrapper{
        @AuraEnabled public List<SOFSummaryDataWrapper> response {get;set;}
        @AuraEnabled public String error  {get;set;}
    }
    /**
    * @description to handle each summary object present in api response body
    */
    public class SOFSummaryDataWrapper{
        @AuraEnabled public String dealer_code {get;set;}
        @AuraEnabled public String dealer_suffix {get;set;}
        @AuraEnabled public String dealer_divison {get;set;}
        @AuraEnabled public String sof_date {get;set;}
        @AuraEnabled public String sof_time {get;set;}
        @AuraEnabled public String time_of_day {get;set;}
        @AuraEnabled public Integer sof_count {get;set;}
    }

}