global class EDealerTrackingLogsClear implements Database.Batchable<sObject>, Schedulable {
   global void execute(SchedulableContext SC) {
      //execute batch
      database.executeBatch(new EDealerTrackingLogsClear(), 2000);
   }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date daysBeforeDate = Date.today().addDays(-395);
        String query = 'SELECT Id FROM EDealer_Tracking__c WHERE CreatedDate < :daysBeforeDate';
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<EDealer_Tracking__c> lstTracking){
        try{
            //delete eDealer Tracking records
            if(EDealer_Tracking__c.sObjectType.getDescribe().isDeletable()){
                delete lstTracking;
            }
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerTrackingLogsClear');
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
       System.debug('batch finish method called!');
   }
}