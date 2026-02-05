/**
 * @author navita.anand@slalom.com
 * @created date 2019-01-24
 * @last modified 2019-05-09
 * @version 1.2
 * @description Case trigger
 */
trigger caseTrigger on Case (before insert, before update, after insert, after update) {
    //check for after and insert update in the trigger and call the relevant method in helper class
    if(trigger.isAfter){
        if(trigger.isInsert){
            caseTriggerHelper.isAfterInsert(trigger.new, trigger.newMap);
        }
        if(trigger.isUpdate){
            caseTriggerHelper.isAfterUpdate(trigger.new, trigger.newMap, trigger.oldMap);
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            caseTriggerHelper.isBeforeInsert(trigger.new, trigger.newMap);
        }
        if(trigger.isUpdate){
            caseTriggerHelper.isBeforeUpdate(trigger.new, trigger.newMap, trigger.oldMap);
        }
    }
}