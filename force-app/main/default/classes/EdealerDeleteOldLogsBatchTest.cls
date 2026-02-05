@isTest
public class EdealerDeleteOldLogsBatchTest {
    
    @isTest
    private static void testBatch(){
        
        //log
        eDealer_Log__c oldLog = new eDealer_Log__c();
        oldLog.Log_Type__c = 'API Error';
        oldLog.Apex_Exception_Message__c = 'error';
        
        insert oldLog;
        System.assertEquals('API Error', [SELECT Log_Type__c FROM eDealer_Log__c LIMIT 1].Log_Type__c, 'Unexpected Dealer logs.');
        
        Test.setCreatedDate(oldLog.id, Datetime.now().addDays(-16));
        
        Test.startTest();
        EdealerDeleteOldLogsBatch objBatch=new EdealerDeleteOldLogsBatch();
        Id jobid = Database.executeBatch(objBatch);
        String sch = '0 0 3 * * ?';
        system.schedule('Test edealer logs delete batch', sch, objBatch); 
        Test.stopTest();
        
        System.assert(jobid != null, 'Job execution is failed.');
    }

}