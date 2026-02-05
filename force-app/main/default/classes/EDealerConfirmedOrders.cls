/*** 
* Name        :   EDealerConfirmedOrders
*  Description :   This is the apex class which is used for EDealerConfirmedOrders component
*/ 
public class EDealerConfirmedOrders {
    /****
    * Created on 21-06-2021
    * To call Confirmed Orders Report
    */ 
    @AuraEnabled
    public static ConfirmedOrderWrapper fetchEDealerConfirmedOrders(String dealerCode, String division){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ConfirmedOrderWrapper awsRCResultData = new ConfirmedOrderWrapper();
        
        try{
            //HttpRequest req = new HttpRequest();
            calloutDetails.put('endpoint','/cof-confirm-order/report/'+dealerCode+'/edealer?dealer_division='+division);
            calloutDetails.put('method','GET');
            calloutDetails.put('classname','EDealerConfirmedOrders');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            system.debug('\n--jsonRes--'+jsonRes);
            
            // parsing the actual results
            if(jsonRes != null)
                awsRCResultData = (ConfirmedOrderWrapper)System.JSON.deserialize(jsonRes, ConfirmedOrderWrapper.class);
            for(ConfirmedOrderSummary confirmedDt : awsRCResultData.summary){                
                DateTime dt = DateTime.valueOfGmt(confirmedDt.confirmedon);
                String format = dt.formatGMT('MMMMM dd, yyyy hh:mm:ss a');
                confirmedDt.confirmedon = format;
                
            }
            system.debug('\n--awsRCResultData--'+awsRCResultData);
            
              awsRCResultData.languageTranslation = new map<string,string>();
            awsRCResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Confirmed Order File');
            System.debug('awsRCResultData.languageTranslation '+awsRCResultData.languageTranslation );
        }
        catch(Exception Ex){
            system.debug('\n--error--'+Ex.getMessage());
        }
        
        //RETURN
        return awsRCResultData;
    }
    
    /*** Confirmed Orders Result Parameters/attributes ***/
    public class ConfirmedOrderWrapper {
        @AuraEnabled public List<ConfirmedOrderResponse> response;
        @AuraEnabled public List<ConfirmedOrderSummary> summary;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    public class ConfirmedOrderResponse {
        @AuraEnabled public String loc;
        @AuraEnabled public String confirmedon;//CONFIRMEDON
        @AuraEnabled public Double confirmed_qty;
        @AuraEnabled public Double dlr_inv_qty;
        @AuraEnabled public String item;
        @AuraEnabled public String item_description;
		@AuraEnabled public String p_dlrsplrcode;
        @AuraEnabled public Double p_dlrnet;
        @AuraEnabled public Double extended_dnet;
    }
    
    public class ConfirmedOrderSummary {
        @AuraEnabled public String loc;
        @AuraEnabled public String confirmedon;
        @AuraEnabled public Double confirmed_parts;
        @AuraEnabled public Double total_confirmed_parts_qty;
        @AuraEnabled public Double grandtotal;
    }
}