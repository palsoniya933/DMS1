/***
 * Name         :   EdealerDeleteOldLogsBatch
 * Description  :   This Batch will be used to delete the 15 Days Old Logs data from salesforce
 * This Batch will run every Day.
 * Run this batch with Batch Size 2000.
 ***/
global class EdealerDeleteOldLogsBatch implements Database.Batchable<sObject>, Schedulable {

    global void execute(SchedulableContext SC) {
      //execute batch
      database.executeBatch(new EdealerDeleteOldLogsBatch(), 2000);
   }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date fifteenDaysBeforeDate = Date.today().addDays(-15);
        String query = 'SELECT Id FROM eDealer_Log__c WHERE CreatedDate < :fifteenDaysBeforeDate';
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<eDealer_Log__c> lstOldLogs){
        try{
            //delete edealer Old logs
            if(eDealer_Log__c.sObjectType.getDescribe().isDeletable()){
            delete lstOldLogs;
            }
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EdealerDeleteOldLogsBatch');
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
       System.debug('batch finish method called');
   }
    
}