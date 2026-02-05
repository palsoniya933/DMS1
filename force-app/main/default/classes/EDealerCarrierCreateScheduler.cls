global class EDealerCarrierCreateScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc) {   
        deleteOldCarrierCreateNewCarrier();
    }
    
    //to delete the all old carriers and inserting new carriers from edealer 
    @future(callout=true)
    public static void deleteOldCarrierCreateNewCarrier(){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint','/carrier-select/data/edealer');            
        calloutDetails.put('method','GET');  
        calloutDetails.put('classname','EDealerCarrierCreateScheduler');
        
        ResponseWrapper awsResultData = new ResponseWrapper();          
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        system.debug('\n--jsonRes--'+jsonRes);   
        
        // if we have response
        if(jsonRes != null){
            // parsing the actual results
            awsResultData = (ResponseWrapper)System.JSON.deserialize(jsonRes, ResponseWrapper.class);
            //system.debug('\n--awsResultData--'+awsResultData);
            
            List<eDealer_Carrier__c> lstCarrier = new List<eDealer_Carrier__c>();
            for(Response resp : awsResultData.response){
                eDealer_Carrier__c carrier = new eDealer_Carrier__c();
                carrier.Name = resp.carr_nm;
                carrier.Carrier_Code__c = resp.frt_carr;
                lstCarrier.add(carrier);
            }
            //deleting all carrier old records
            List<eDealer_Carrier__c> existingRecords;
            
            if(Schema.sObjectType.eDealer_Carrier__c.fields.id.isAccessible()){
                existingRecords = [select id from eDealer_Carrier__c limit 10000];
            }
            
            if(!existingRecords.isEmpty()){
                if(eDealer_Carrier__c.sObjectType.getDescribe().isDeletable()){
                    delete existingRecords;
                }
                
            }
            
            // inserting the new records
            if(Schema.sObjectType.eDealer_Carrier__c.fields.Name.isCreateable()
              && Schema.sObjectType.eDealer_Carrier__c.fields.Carrier_Code__c.isCreateable()
              ){ 
                insert lstCarrier;
            }
        }     
    }
    
    public class ResponseWrapper{
        @AuraEnabled public List<Response> response {get;set;}
        @AuraEnabled public String error {get;set;}
    }
    
    public class Response {
        public String frt_carr;
        public String carr_nm;
        public String rtg_instr;
        public String frt_carr_desc_p;
    }
    
    public List<Response> response;
}