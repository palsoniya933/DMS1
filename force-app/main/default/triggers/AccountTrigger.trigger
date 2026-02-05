/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-16
 * @version 1.0
 * @description AccountTrigger
 */
trigger AccountTrigger on Account (after update,before update) {
   if ( Trigger.isAfter) {
        if ( Trigger.isUpdate ) {
            AccountTriggerHelper.isAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if(Trigger.isBefore){
        for (Account obj : Trigger.new) {
            if (obj.Total_Employees__c != Trigger.oldMap.get(obj.Id).Total_Employees__c) {
                obj.Total_Employees_updated_Date__c = System.now();
            }
        }
    }

}