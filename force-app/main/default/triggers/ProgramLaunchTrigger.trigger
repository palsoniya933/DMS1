/**
 * @author: Chito Bulahan - Luisito.Bulahan@paccar.com
 * @created date: 2020-11-17
 * @last modified: 2020-11-17
 * @version: 1.0
 * @description: This will trigger an update process from a Program Launch Record status change.
 */
trigger ProgramLaunchTrigger on Program_Launch__c (before insert, before update, after insert){
    if(Trigger.isBefore && Trigger.isInsert) {
        
        ProgramLaunchHandler.validateProgramLaunchClone(Trigger.New);
        ProgramLaunchHandler.validateUniqueProgramLaunch(Trigger.New);
    }
    if(trigger.isBefore && Trigger.isUpdate) {
        
        ProgramLaunchHandler.SubmittedByBeforeUpdate(Trigger.new, trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isInsert) {
        ProgramLaunchHandler.cloneProgramLaunchItems(Trigger.New);
    }
}