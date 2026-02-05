trigger CaseOrderLineTrigger on Case_Order_Line__c (before insert, before update, after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert){  
             System.debug(trigger.new);
             caseOrderLineTriggerHelper.isAfterInsert(trigger.new, trigger.newMap);        
        }
        if(trigger.isUpdate){          
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
        }
        if(trigger.isUpdate){           
        }
    }

}