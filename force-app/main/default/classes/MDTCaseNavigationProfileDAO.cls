/**
 * Created by anthony.beran on 10/23/19.
 */

public with sharing class MDTCaseNavigationProfileDAO {

    public static List<Case_Navigation_Profile__mdt> getByProfile(Set<String> profileNames) {
        return [
            SELECT Case_Navigation_RecordType__c
            FROM Case_Navigation_Profile__mdt
            WHERE Profile__c IN :profileNames
        ];
    }

}