trigger PromotionTrigger on Promotion__c (after insert, after update) {
    if (Trigger.isAfter) 
    {
        if (Trigger.isInsert) {
            PromotionTriggerHandler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            PromotionTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}