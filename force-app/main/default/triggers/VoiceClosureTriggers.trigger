trigger VoiceClosureTriggers on Voice_Closure__c (after insert, after update, after delete) {

    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Voice_Closure__c closure : Trigger.new) {
            DbCrudFacade.InsertClosure(
                closure.Queue__c,
                String.valueOf(closure.Date__c), 
                closure.Prompt__c,
                Integer.valueOf(closure.Start_Hour__c),
                Integer.valueOf(closure.End_Hour__c)
            );
        }
    } else if (Trigger.isDelete) {
        for (Voice_Closure__c closure : Trigger.old) {
            DbCrudFacade.DeleteClosure(
                closure.Queue__c,
                String.valueOf(closure.Date__c)
            );
        }
    }
}