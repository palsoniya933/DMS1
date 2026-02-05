/***
 * Name         :   EDealerDeleteOldSOFSummaryBatch
 * Description  :   This Batch will be used to delete the & Days Old SOF Summary details from salesforce
 * This Batch will run every Day.
 * Run this batch with Batch Size 2000.
 ***/
global class EDealerDeleteOldSOFSummaryBatch implements Database.Batchable<sObject>, Schedulable {

    global void execute(SchedulableContext SC) {
      //execute batch
      database.executeBatch(new EDealerDeleteOldSOFSummaryBatch(), 2000);
   }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date sevenDaysBeforeDate = Date.today().addDays(-7);
        String query = 'SELECT Id, Name FROM EDealer_SOF_Summary__c WHERE CreatedDate < :sevenDaysBeforeDate';
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<EDealer_SOF_Summary__c> lstSOFSummaries){
        try{
            //delete sof summary records
            if(EDealer_SOF_Summary__c.sObjectType.getDescribe().isDeletable()){
                delete lstSOFSummaries;
            }
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerDeleteOldSOFSummaryBatch');
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
       System.debug('batch finish method called');
   }
    
}