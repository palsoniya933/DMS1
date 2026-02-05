trigger VoiceBlockedNumberTriggers on VoiceBlockedNumber__c (after insert, after update, after delete) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (VoiceBlockedNumber__c blockedNumber : Trigger.new) {
            DbCrudFacade.InsertBlockedNumber(
                    blockedNumber.PhoneNumber__c
            );
        }
    } else if (Trigger.isDelete) {
        for (VoiceBlockedNumber__c blockedNumber : Trigger.old) {
            DbCrudFacade.DeleteBlockedNumber(
                    blockedNumber.PhoneNumber__c
            );
        }
    }
}