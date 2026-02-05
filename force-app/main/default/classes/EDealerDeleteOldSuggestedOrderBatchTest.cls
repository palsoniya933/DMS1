@isTest
private class EDealerDeleteOldSuggestedOrderBatchTest {
    
    @isTest
    private static void testBatch(){
        
        Account objAcc=new Account(Name='TestAccount',Dealer_Code__c='999990');
        insert objAcc; 
        System.assertEquals('TestAccount', [SELECT Name FROM Account LIMIT 1].Name, 'Unexpected Account.');
        
        EDealer_Suggested_Order__c objEDealer=new EDealer_Suggested_Order__c(Dealer_Location__c=objAcc.Id,Part_Category_Type__c='EM',Type__c='SOF');
        insert objEDealer;
        System.assertEquals('EM', [SELECT Part_Category_Type__c FROM EDealer_Suggested_Order__c LIMIT 1].Part_Category_Type__c, 'Unexpected EDealer Suggested Order found.');
        
        Test.setCreatedDate(objEDealer.id, Datetime.now().addDays(-1));
        
        Test.startTest();
        EDealerDeleteOldSuggestedOrderBatch objBatch=new EDealerDeleteOldSuggestedOrderBatch();
        Id jobId = Database.executeBatch(objBatch);
        String sch = '0 0 4 * * ?'; 
        system.schedule('Test Territory Check', sch, objBatch); 
        Test.stopTest();
        
        System.assert(jobid != null, 'Job execution is failed.');
        System.assert([SELECT Id FROM EDealer_Suggested_Order__c limit 10000].size() == 0, 'suggested orders not deleted');
    }
    
    
}