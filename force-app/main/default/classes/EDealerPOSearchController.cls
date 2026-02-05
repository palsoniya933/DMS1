/****
*  Name        		:   EDealerPOSearchController
*  Aura Component 	:	EDealerPOSearch
*  Description 		:	This will be used to search the PO Details
***/

public without sharing class EDealerPOSearchController {
    
    @AuraEnabled
    public static POSearchDetailResponseWrapper getPODetails(String dealerCode, string dealerPO){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        POSearchDetailResponseWrapper awsResultData = new POSearchDetailResponseWrapper();             
        calloutDetails.put('endpoint','/global-search-order/dealer-po/'+dealerCode+'?dealerPO_no='+dealerPO);        
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerPOSearchController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        system.debug('jsonRes::'+jsonRes);
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (POSearchDetailResponseWrapper)System.JSON.deserialize(jsonRes, POSearchDetailResponseWrapper.class);
        
        awsResultData.languageTranslation = new map<string,string>();
        awsResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Search Dealer PO');
        System.debug('awsResultData.languageTranslation '+awsResultData.languageTranslation );
        return awsResultData; 
    }
    public class POSearchDetailResponseWrapper{
        @AuraEnabled public List<POSearchDetailWrapper> response;
        @AuraEnabled public String error;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    
    public class POSearchDetailWrapper {
        @AuraEnabled public String dealerpo;//TD091021WS
        @AuraEnabled public String ordno;//TD41271
        @AuraEnabled public String order_status;//INVOICED
        @AuraEnabled public String ordersource;//Parts Online
        @AuraEnabled public String createdby;//WILL SKIRVIN
        @AuraEnabled public String created_date;//2021-09-10
        @AuraEnabled public integer splitorder;//1
    }  
}