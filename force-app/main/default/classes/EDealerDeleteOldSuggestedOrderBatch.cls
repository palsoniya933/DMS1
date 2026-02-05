/***
 * Name         :   EDealerDeleteOldSuggestedOrderBatch
 * Description  :   This Batch will be used to delete the Old Suggested Orders/Parts details from salesforce
 * This Batch will run every Day.
 * Run this batch with Batch Size 2000.
 ***/
global class EDealerDeleteOldSuggestedOrderBatch implements Database.Batchable<sObject>, Schedulable  {
    
    global void execute(SchedulableContext SC) {
      database.executeBatch(new EDealerDeleteOldSuggestedOrderBatch(), 2000);
   }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name FROM EDealer_Suggested_Order__c WHERE CreatedDate < Today';
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<EDealer_Suggested_Order__c> lstSugOrders){
        try{
            //delete sof old Suggested Parts records
            if(EDealer_Suggested_Order__c.sObjectType.getDescribe().isDeletable()){
                delete lstSugOrders;
            }
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerDeleteOldSuggestedOrderBatch');
        }
    }
    
    global void finish(Database.BatchableContext BC){
       System.debug('batch finish method called');
   }

}