/**
 * @author Bhupesh1.kumar@Birlasoft.com
 * @created date 2022-05-09
 * @version 2.0
 * @description Service trigger
 */
trigger DecisivServiceTrigger on Service__c (before insert, before update, after insert, after update) {

    if(trigger.IsAfter && trigger.IsInsert){
        if(DecisivServiceTriggerHelper.IS_AFTER_INSERT_TRIGGER){
            DecisivServiceTriggerHelper.IS_AFTER_INSERT_TRIGGER = false;
            DecisivServiceTriggerHelper.createDecisivCase(Trigger.new);
        }
    }
}