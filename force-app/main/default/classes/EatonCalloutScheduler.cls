/**
 * @author navita.anand@slalom.com
 * @created date 2019-07-05
 * @last modified 2019-07-19
 * @version 1.0
 * @description class to get the records for case comments and files scheduling
 */
public class EatonCalloutScheduler {
	 public static void scheduleMethod(){
        Set<Id> commentIds = new Set<Id>();
        Set<Id> fileIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        Map<String, Set<Id>> returnFileLists = new Map<String, Set<Id>>();
        List<Eaton_Callout_Scheduler__c> filteredRecords = new  List<Eaton_Callout_Scheduler__c>();
        List<Eaton_Callout_Scheduler__c> records = [SELECT Record_Id__c, Type__c FROM Eaton_Callout_Scheduler__c ORDER BY createddate ASC];
        Set<Id> fileDecisionList = new Set<Id>();
        Set<Id> fileOverflowList = new Set<Id>();
        for(Eaton_Callout_Scheduler__c c : records){
            if(c.Type__c =='Comment'){
                commentIds.add(c.Record_Id__c);
            }
            else if(c.Type__c =='File'){
                fileIds.add(c.Record_Id__c);
            }
            else if(c.Type__c =='Case'){
                caseIds.add(c.Record_Id__c);
            }      
        }
        if(fileIds.size()>0){ /* check if the total file size per case and total batch files size is <4MB */
            returnFileLists = eatonCaseDomain.checkCaseTotalFileSize(fileIds);
        }
        if(returnFileLists.size()>0){
            fileDecisionList = returnFileLists.get('send'); /**list of files that will be processed in the current batch */
            fileOverflowList = returnFileLists.get('overflow');/**list of files that will be processed in subsequent batches */
        }          
        
        filteredRecords = [SELECT Record_Id__c, Type__c FROM Eaton_Callout_Scheduler__c where Record_Id__c NOT in: fileOverflowList]; 

        
        if(!commentIds.isEmpty() || !fileDecisionList.isEmpty() || !caseIds.isEmpty()){/* Schedule the callout when either of the list is not empty */
            eatonCaseDomain.scheduleCaseCallout(caseIds, commentIds, fileDecisionList);           
        }

        if(!filteredRecords.isEmpty()){
            system.debug('deleted : |'+ filteredRecords);
            delete filteredRecords;
        }
    }
}