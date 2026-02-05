public class EDealerGlobalMDIController {
    
    /****
* Created on 04-01-2021
* To call the Global MDI Report API 
*/ 
    @AuraEnabled
    public static GlobalMDIResponseWrapper fetchAWSGlobalMDIReportData(String dealerCode, String division, Integer offSet, Integer recLimit){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        GlobalMDIResponseWrapper awsReportResultData = new GlobalMDIResponseWrapper();
        
        HttpRequest req = new HttpRequest();
        calloutDetails.put('endpoint','/global-mdi/report/'+dealerCode+'/dealer?dealer_division='+division);
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerGlobalMDIController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);            
        // parsing the actual results
        if(jsonRes != null){
            awsReportResultData = (GlobalMDIResponseWrapper)System.JSON.deserialize(jsonRes, GlobalMDIResponseWrapper.class);
        }
        
        List<GlobalMDIWrapper> newResponse = new List<GlobalMDIWrapper>();
        if(awsReportResultData != null
           && awsReportResultData.response != null){            
               awsReportResultData.languageTranslation = new map<string,string>();
                         
               awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Global Report');
               
               //End value transalation language data
               system.debug('languageTranslation::'+awsReportResultData.languageTranslation);            
               awsReportResultData.languageTransFirstColumn = EDealerMetadataUtility.translateColumnHeaders('Global Report Column');
               
               //End value transalation language data
               system.debug('languageTransFirstColumn::'+awsReportResultData.languageTransFirstColumn);
               
               for(Integer i=0;i<awsReportResultData.response.size();i++){
                   system.debug('--contains--::'+awsReportResultData.languageTransFirstColumn.containsKey(awsReportResultData.response[i].descr));
                   system.debug('--awsReportResultData.response[i].descr--'+awsReportResultData.response[i].descr.trim()); 
                   if(awsReportResultData.languageTransFirstColumn.containsKey(awsReportResultData.response[i].descr.trim())){
                       awsReportResultData.response[i].descr = awsReportResultData.languageTransFirstColumn.get(awsReportResultData.response[i].descr.trim());
                   } 
                   if(i != 0){                    
                       newResponse.add(awsReportResultData.response[i]);
                   }
               }
               awsReportResultData.dataJSON = JSON.serialize(newResponse);
           }
        return awsReportResultData;
    }
    
    
    public class GlobalMDIResponseWrapper {
        @AuraEnabled public List<GlobalMDIWrapper> response;
        @AuraEnabled public map<string,string> languageTranslation;
        @AuraEnabled public map<string,string> languageTransFirstColumn;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public String error;
    }
    
    public class GlobalMDIWrapper {
        @AuraEnabled public String descr;
        @AuraEnabled public String rn;
        @AuraEnabled public String dlr;
        @AuraEnabled public String div;      
        @AuraEnabled public String col01;
        @AuraEnabled public String col02;
        @AuraEnabled public String col03; 
        @AuraEnabled public String col04;
        @AuraEnabled public String col05;
        @AuraEnabled public String col06;
        @AuraEnabled public String col07;
        @AuraEnabled public String col08;
        @AuraEnabled public String col09;
        @AuraEnabled public String col10;
        @AuraEnabled public String col11;
        @AuraEnabled public String col12;
        @AuraEnabled public String col13;
    }
    
}