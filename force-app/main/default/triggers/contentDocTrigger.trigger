/**
 * @author navita.anand@slalom.com
 * @created date 2019-05-02
 * @last modified 2019-05-09
 * @version 1.2
 * @description Case comment trigger for Eaton Integration
 */
trigger contentDocTrigger on ContentDocumentLink (after insert, before insert) {
        if(trigger.isAfter){
            if(trigger.isInsert){
                contentDocLinkTriggerHelper.isAfterInsert(trigger.new, trigger.newMap);
            }
        }
        if(trigger.isBefore){
            if(trigger.isInsert){
                contentDocLinkTriggerHelper.isBeforeInsert(trigger.new, trigger.newMap);
            }
        }
}