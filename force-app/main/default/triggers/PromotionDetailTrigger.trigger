trigger PromotionDetailTrigger on Promotion_Detail__c(before delete, after insert, after update) 
{
    if (Trigger.isBefore && Trigger.isDelete)
    {
        PromotionDetailTriggerHandler.handleBeforeDelete(Trigger.old);
    } 
    if (Trigger.isAfter) 
    {
        if (Trigger.isInsert) {
            PromotionDetailTriggerHandler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            PromotionDetailTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            PromotionDetailTriggerHandler.handleAfterDelete(Trigger.oldMap);
        }
        if (Trigger.isUndelete) {
            PromotionDetailTriggerHandler.handleAfterUndelete(Trigger.new);
        }
    }
}