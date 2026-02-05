/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class eDealerAddCompetitorController {

    // get state option from salesforce to show on add competitor tab for state picklist
    @AuraEnabled(cacheable=true)
    public static List <Map<String, String >> getStateOption(){
       // return eDealerSobjectUtils.getPicklistByObjectAndField('eDealerCompetitor__c', 'State_Province__c');
        return null;
    }
    
    // get affiliation option from salesforce to show on add competitor tab for affiliation picklist
    @AuraEnabled(cacheable=true)
    public static List <Map<String, String >> getAffiliationOption(){
       return EDealerMetadataUtility.tableColumnHeaderTranslations('Add_Competitor_Affiliation'); 
       
    }
}