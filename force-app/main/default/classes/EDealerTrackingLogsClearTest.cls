@isTest
public class EDealerTrackingLogsClearTest {
    
    @isTest
    private static void testBatch(){
        
        //log
        EDealer_Tracking__c oldLog = new EDealer_Tracking__c();
        oldLog.Username__c = 'Testing';
        
        insert oldLog;
        
        Test.setCreatedDate(oldLog.id, Datetime.now().addDays(-396));
        
        Test.startTest();
        EDealerTrackingLogsClear objBatch=new EDealerTrackingLogsClear();
        Database.executeBatch(objBatch);
        String sch = '0 0 3 * * ?'; 
        system.schedule('Test edealer tracking logs delete batch', sch, objBatch); 
        Test.stopTest();
    }
    
}