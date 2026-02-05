/****
*  Name        :   EDealerOrderSearchController
*  Description :   This will be used to search the Orders
***/
public class EDealerOrderSearchController {
    
    @AuraEnabled
    public static  SearchOrderResponseWrapper searchOrders(String dealerCode, String searchText){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        SearchOrderResponseWrapper awsResultData = new SearchOrderResponseWrapper();        
        String urlParameters = dealerCode+'/edealer?order_no='+searchText;  
        calloutDetails.put('endpoint','/global-search-order/report/'+urlParameters);       
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerOrderSearchController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        //system.debug('\n--jsonRes--'+jsonRes);   
        
        // parsing the actual results
        if(jsonRes != null)
            awsResultData = (SearchOrderResponseWrapper)System.JSON.deserialize(jsonRes, SearchOrderResponseWrapper.class);
        
        
        awsResultData.languageTranslation = new map<string,string>();
        awsResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Search Dealer PO');
        System.debug('awsResultData.languageTranslation '+awsResultData.languageTranslation );
        system.debug('\n--awsResultData--'+awsResultData);
        
        
        //return data
        return awsResultData;        
    }
    
    
    public class SearchOrderResponseWrapper{
        @AuraEnabled public List<SearchOrderWrapper> response;
        @AuraEnabled public String error;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    
    public class SearchOrderWrapper {
        @AuraEnabled public String ordno;
        @AuraEnabled public String dealerpo;
        @AuraEnabled public String order_status;
        @AuraEnabled public String ordersource;
        @AuraEnabled public String createdby;
        @AuraEnabled public String created_date;
        @AuraEnabled public integer splitorder;
    }
    
}