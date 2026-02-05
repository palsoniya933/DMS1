/****
 *  Name        :   EDealerLogUtils
 *  Description :   This is the apex class which will be used to created logs if any error in API / Any exception occurs / if
                    the API is hit for the first time in a day
***/

public with sharing class EDealerLogUtils{  

    /**
     *  This method should be called if the status of response is not OK / 200 
     *  and pass the rest and response what we are sending and receiving
     *  and it will create the log object
     **/
    public static void createAPIErrorLog(HTTPResponse response, HTTPRequest request, string APIName){
        
        // insert cache
        eDealer_Log__c logRec = makeAPLogInstance(response, request, APIName, EDealerConstants.APIERRORLOG,null,null);
        if(Schema.sObjectType.eDealer_Log__c.fields.API_Name__c.isCreateable() 
           && Schema.sObjectType.eDealer_Log__c.fields.API_Request__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Status_Code__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.API_Response__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Method_Name__c.isCreateable()){
               insert logRec;
           }
        
    }
    
    public static void createAPIErrorLog(HTTPResponse response, HTTPRequest request, string APIName, String logType){
        
        // insert cache
        eDealer_Log__c logRec = makeAPLogInstance(response, request, APIName, logType, null, null);
        if(Schema.sObjectType.eDealer_Log__c.fields.API_Name__c.isCreateable() 
           && Schema.sObjectType.eDealer_Log__c.fields.API_Request__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Status_Code__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.API_Response__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Method_Name__c.isCreateable()){
               insert logRec;
           }
    }
    
    public static void createExceptionLog(Exception ex, string apexClassName){
        // insert cache
        eDealer_Log__c logRec = new eDealer_Log__c();
        logRec.Apex_Exception_Message__c = ex.getMessage();
        logRec.Apex_Trace__c = ex.getStackTraceString();
        logRec.Class_Name__c = apexClassName;
        logRec.Log_Type__c = EDealerConstants.APIEXCEPTIONLOG;
        if(Schema.sObjectType.eDealer_Log__c.fields.Apex_Exception_Message__c.isCreateable() 
           && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()){
               insert logRec;
           }
    }
    
    @future
    public static void createExceptionLog(string apexClassName, String errorMessage, String stackTraceString){
        // insert cache
        eDealer_Log__c logRec = new eDealer_Log__c();
        logRec.Apex_Exception_Message__c = errorMessage;
        logRec.Apex_Trace__c = stackTraceString;
        logRec.Class_Name__c = apexClassName;
        logRec.Log_Type__c = EDealerConstants.APIEXCEPTIONLOG; 
        
        if(Schema.sObjectType.eDealer_Log__c.fields.Apex_Exception_Message__c.isCreateable() 
           && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()){
               insert logRec;
           }
    }
    
    
    /**
     *  This method should be called when ever an API is called and we get success response
     *  and this method will check if the API is called for the first time for the logged in user, 
     *  if yes then save the resonse for cache
     *  This should be called in case of success API response (staus code = 200 / OK )
     **/
    public static void createAPICacheLog(HTTPResponse response, HTTPRequest request, string APIName){
        
        // first checking if the same API cahce exist for today
        List<eDealer_Log__c> lstCacheLog = fetchCacheRecord(UserInfo.getUserId(), APIName);
        
        // if cache not found then do create the cache
        if(!lstCacheLog.isEmpty()){
            
            // insert cache
            eDealer_Log__c logRec = makeAPLogInstance(response, request, APIName, EDealerConstants.APICACHELOG,'','');
            if(Schema.sObjectType.eDealer_Log__c.fields.API_Name__c.isCreateable() 
           && Schema.sObjectType.eDealer_Log__c.fields.API_Request__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Status_Code__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.API_Response__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
           && Schema.sObjectType.eDealer_Log__c.fields.Method_Name__c.isCreateable()){
               insert logRec;
           }
        }       
    }
    
    // this will query the log object which is of type Cache API Response
    public static List<eDealer_Log__c> fetchCacheRecord(string UserId, string APIName){
        return [SELECT ID,
                        API_Request__c,
                        API_Response__c
                    FROM eDealer_Log__c
                    WHERE CreatedDate = TODAY
                    AND CreatedBy.Id =: UserId
                    AND API_Name__c =: APIName
                    AND Log_Type__c =: EDealerConstants.APICACHELOG
                    order by createddate desc LIMIT 1];
    }
    
    /***
     *  this is used for making log instance if we have the http request / response
     *  Mainly used to reusing code for mapping
     **/
    public static eDealer_Log__c makeAPLogInstance(HTTPResponse response, HTTPRequest request, string APIName, string logType, string className ,string methodName ){
        eDealer_Log__c logRec = new eDealer_Log__c();
        logRec.API_Name__c = APIName;
        logRec.API_Request__c = request.getBody();
        logRec.Status_Code__c = response.getStatusCode();
        logRec.API_Response__c = (String.isNotBlank(response.getBody()) ? response.getBody().left(131070) : null);
        logRec.Log_Type__c = logType;
        logRec.Apex_Trace__c = request.getendpoint();
        logRec.Class_Name__c = className;
        logRec.Method_Name__c = methodName;
        return logRec;
    }
}