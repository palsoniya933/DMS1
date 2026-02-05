/*****
 *  This is the common apex class which will be used to make the API Call and return the 
 *  response and if any error in API then create the logs
 ***/
public with sharing class EDealerHttpHandler{
    
    /**
     *  This is the apex method which will have the param name and its value example 
     *  Endpoint
     *  Body 
     *  Headers
     *  create logs if any error
    **/
    public Static String callout(Map<String,Object> params){
        String apiError;
        String className;
        String methodName;
        System.debug(JSON.serializePretty(Params));
        
        HttpRequest req = new HttpRequest();        
        
        //we need to pass into 'headers' from each class
        //req.setHeader('x-api-key', '{!$Credential.Password}');  commented out due to interference to Gateway AWS Callout
        
        // setting headers
        if(params.containsKey('headers')){
            Map<String,String> headerMap = (Map<String,String>) params.get('headers');
            for(String headerKey : headerMap.keyset()){
                req.setHeader(headerKey, headerMap.get(headerKey));
            }
        }
        
        // setting Endpoints
        if(params.containsKey('endpoint')){
            if(!params.containsKey('namedCredentials')){
                if(params.get('classname') == 'eDealerCSRViewFilesController'){
                    req.setEndpoint((String) params.get('endpoint'));     
                }
                else{
                    req.setHeader('x-api-key', '{!$Credential.Password}');
                    req.setEndpoint('callout:AWS_EDealer'+(String) params.get('endpoint'));//prod 
                    //req.setEndpoint('callout:edealerDev'+(String) params.get('endpoint'));  // dev
                }
            }
            else{
                req.setEndpoint((String) params.get('namedCredentials') + (String) params.get('endpoint'));
            }
        }

        //Setting Method ( GET / POST )
        if(params.containsKey('method')){
            req.setMethod((String) params.get('method'));
        }

        // setting max time out
        req.setTimeout(120000);
        
        if(params.containsKey('body')){
            req.setBody((String) params.get('body'));
        }

        if(params.containsKey('classname')){
            className = (String) params.get('classname');
        }
        
        if(params.containsKey('methodname')){
            methodName = (String) params.get('methodname');
        }

        // making callout
        Http http = new Http();
        System.debug('res------'+req);
         System.debug('http------'+http);
        HTTPResponse res = http.send(req);           
        String jsonRes = res.getBody();
        /**
         * below code will check if the class named passed in the parameter 
         * and we have to track logs for the apex class every time, then we create logs
        **/
        eDealer_Config__mdt classNamesLogs = eDealer_Config__mdt.getInstance('Class_Name_For_Logs');
        if(classNamesLogs!=null 
            && classNamesLogs.Long_Value__c !=null
            && !String.isBlank(className)){
                List<string> classNames = eDealer_Config__mdt.getInstance('Class_Name_For_Logs').Long_Value__c.split(';');
                if(classNames.contains(className)){
                   eDealer_Log__c dealerLog = EDealerLogUtils.makeAPLogInstance(res,req,(String) params.get('endpoint'),'API Log', className, methodName);
                    if(Schema.sObjectType.eDealer_Log__c.fields.API_Name__c.isCreateable() 
                        && Schema.sObjectType.eDealer_Log__c.fields.API_Request__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.Status_Code__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.API_Response__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.Log_Type__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.Apex_Trace__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.Class_Name__c.isCreateable()
                        && Schema.sObjectType.eDealer_Log__c.fields.Method_Name__c.isCreateable()){

                        insert dealerLog;
                }                   
            }               
        }
        /**
         * Call EDealerLogUtils class based on response status code. 
         * if the OK then return else log error
        **/        
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){  
            return jsonRes;            
        }else if(res.getStatusCode() > 300){
            EDealerLogUtils.createAPIErrorLog(res, req,(String.isNotBlank(className) ? className : 'EDealerHttpHandler'));

        //errorByName.put('apiError',res.getStatus());
        apiError='{"apiError":"'+jsonRes+'"}';
        return apiError;
        }        
        return null;
    }
}