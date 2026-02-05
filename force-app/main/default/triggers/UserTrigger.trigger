/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-16
 * @version 1.0
 * @description UserTrigger
 */
trigger UserTrigger on User (after insert, after update, before insert) {
    if ( Trigger.isAfter ) {
        if ( Trigger.isInsert ) {
            UserTriggerHelper.isAfterInsert(Trigger.new, Trigger.newMap);
        }
 
        if ( Trigger.isUpdate ) {
            UserTriggerHelper.isAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if ( Trigger.isBefore ) {
        if ( Trigger.isInsert ) {
            UserTriggerHelper.isBeforeInsert(Trigger.new);
        }

    }
}