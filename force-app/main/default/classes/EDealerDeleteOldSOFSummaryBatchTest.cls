@isTest
public class EDealerDeleteOldSOFSummaryBatchTest {
    
    @isTest
    private static void testBatch(){
        
        //Sof Summary 
        EDealer_SOF_Summary__c summary = new EDealer_SOF_Summary__c();
        summary.Dealer_Code__c = 'I080';
        summary.Dealer_Divison__c = 'K';
        summary.SOF_Count__c = 2;
        summary.SOF_Date_Time__c = DateTime.now();
        summary.Time_of_Day__c = 'Day';
        
        insert summary;
        System.assertEquals('I080', [SELECT Dealer_Code__c FROM EDealer_SOF_Summary__c LIMIT 1].Dealer_Code__c, 'Invalid EDealer SOF Summary found.');
        
        Test.setCreatedDate(summary.id, Datetime.now().addDays(-8));
        
        Test.startTest();
        EDealerDeleteOldSOFSummaryBatch objBatch=new EDealerDeleteOldSOFSummaryBatch();
        Id jobid = Database.executeBatch(objBatch);
        String sch = '0 0 3 * * ?'; 
        system.schedule('Test SOF summary delete batch', sch, objBatch); 
        Test.stopTest();
        
        System.assert(jobid != null, 'Job execution is failed.');
    }

}