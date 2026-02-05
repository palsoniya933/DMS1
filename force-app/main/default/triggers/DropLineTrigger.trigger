trigger DropLineTrigger on Drop_Line__c  (before insert,before delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
          DropLineTriggerHandler.isbeforeMethod(Trigger.old);  
        }
    }
}