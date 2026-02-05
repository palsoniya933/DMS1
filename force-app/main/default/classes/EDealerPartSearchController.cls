/****
*  Name        :   EDealerPartSearchController
*  Description :   This will be used to search the parts
***/
public without sharing class EDealerPartSearchController {
    
    @AuraEnabled
    public static  EDealerMasterInventoryController.MasterInventoryResponseWrapper getPartAvailable(String dealerCode, String division, String searchText,String dealerType){
       String dealerGroup = 'False';
        String asiUserName = '';
        //creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        if(dealerType=='G'){
            dealerGroup='True';
        }
        User loggedinUser = EDealerUserUtils.fetchLoggedInUserdetails();        
        if(loggedinUser != null && loggedinUser.ASI_Username__c !=null){
            asiUserName = loggedinUser.ASI_Username__c;
        }
        EDealerMasterInventoryController.MasterInventoryResponseWrapper awsPartAvlResultData = new EDealerMasterInventoryController.MasterInventoryResponseWrapper();
        HttpRequest req = new HttpRequest();
        //system.debug('dealerCode'+dealerCode);             
        String urlParameters = dealerCode+'/inventory-data?dealer_division='+division+'&limit=2000&offset_value=0'+'&isGroup='+dealerGroup+'&asiuser='+asiUserName;
        if(String.isNotBlank(searchText)){
            urlParameters += '&search_pattern='+searchText;
        }   
        calloutDetails.put('endpoint','/master-inventory-report/'+urlParameters);       
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerPartSearchController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('\n--jsonRes-- part search:'+jsonRes);   
        
        // parsing the actual results
        if(jsonRes != null)
            awsPartAvlResultData = (EDealerMasterInventoryController.MasterInventoryResponseWrapper)System.JSON.deserialize(jsonRes, EDealerMasterInventoryController.MasterInventoryResponseWrapper.class);
            system.debug('\n--awsPartAvlResultData--'+awsPartAvlResultData);
        
        if(awsPartAvlResultData != null && awsPartAvlResultData.response != null){
            for(EDealerMasterInventoryController.MasterInventoryPartWrapper wrap :  awsPartAvlResultData.response ){
                if(wrap.PriceDetail != null && wrap.PriceDetail.DspQtyBreak != null && !wrap.PriceDetail.DspQtyBreak.isEmpty()){
                    wrap.DualPartSelectedPriceType = 'DSP';
                }else{
                    wrap.DualPartSelectedPriceType = 'PDC';
                }  
            }
        }
         awsPartAvlResultData.languageTranslation = new map<string,string>();
        awsPartAvlResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Master Inventory');
        System.debug('awsPartAvlResultData.languageTranslation '+awsPartAvlResultData.languageTranslation );
        System.debug('awsPartAvlResultData.response::'+JSON.serializePretty(awsPartAvlResultData.response));
        
        //return data
        return awsPartAvlResultData;        
    }  
}