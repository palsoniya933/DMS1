/**
 * @author navita.anand@slalom.com
 * @created date 2019-05-01
 * @last modified 2019-05-09
 * @version 1.2
 * @description Case comment trigger for Eaton Integration
/**
* @author Rodolfo Garcia, rodolfo.garcia@PACCAR.com(Globant)
* @ modified date 2023-10-19
* @project Salesforce DSG ITD Enhancements Project
* @description caseCommentsTriggerTest - added isBeforeInsert context method to display an error to the user if the case is Closed 
or Customer Closed so that closed cases don't get reopened.
*/

trigger caseCommentsTrigger on CaseComment (before insert, after insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            caseCommentsTriggerHelper.isBeforeInsert(trigger.new);
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            caseCommentsTriggerHelper.isAfterInsert(trigger.new, trigger.newMap);
        }
    }
}