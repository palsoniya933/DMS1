/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-20
 * @version 1.0
 * @description MDTCaseNavigationDAO
 */

public with sharing class MDTCaseNavigationDAO {

    public static List<Case_Navigation__mdt> getByProfile(Set<Id> profileIds) {

        return [
            SELECT Title__c, Case_Category__c, Description__c, Image_Url__c, Sort_Order__c, Title_Custom_Label__c, Description_Custom_Label__c,
            (
                SELECT Title__c, RecordType_DeveloperName__c, Sort_Order_2__c, Title_Custom_Label__c
                FROM Case_Navigation_RecordTypes__r
                WHERE Id IN :profileIds
            )
            FROM Case_Navigation__mdt
            ORDER BY Sort_Order__c ASC
        ];
    }
}