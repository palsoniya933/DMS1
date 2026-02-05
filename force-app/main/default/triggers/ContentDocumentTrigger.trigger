trigger ContentDocumentTrigger on ContentDocument (before delete) {
    if(trigger.isDelete){
        if(trigger.isBefore){
            VSContentDocumentTriggerHandler.checkCaseStatus(trigger.old);
        }
    }
}