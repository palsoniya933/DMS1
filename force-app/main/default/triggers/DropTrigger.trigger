trigger DropTrigger on Drop__c (before insert,before delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
          DropTriggerHandler.isbeforeMethod(Trigger.old);  
        }
        if(Trigger.isInsert){
          DropTriggerHandler.isBeforeInsertMethod(Trigger.new);  
        }
    }

}