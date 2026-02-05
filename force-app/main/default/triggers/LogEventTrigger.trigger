/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-25
 * @version 1.0
 * @description LogEventTrigger
 */
trigger LogEventTrigger on Log_Event__e (after insert) {
    if ( Trigger.isAfter ) {
        if ( Trigger.isInsert ) {
            LogEventTriggerHelper.isAfterInsert(Trigger.new);
        }
    }
 }