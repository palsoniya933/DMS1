trigger ProductLaunchDetailTrigger on Product_Launch_Detail__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        ProductLaunchDetailHandler.beforeInsert(Trigger.new);
    }
}