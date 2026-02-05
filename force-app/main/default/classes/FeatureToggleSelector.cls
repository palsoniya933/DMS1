public without sharing class FeatureToggleSelector {
    public static FeatureToggle__mdt getFeatureToggleByFeatureName(String featureName) {
    FeatureToggle__mdt featureToggle = new FeatureToggle__mdt();
        if( Schema.sObjectType.FeatureToggle__mdt.fields.isEnabled__c.isAccessible()
        && Schema.sObjectType.FeatureToggle__mdt.fields.Enabled_For_Users__c.isAccessible()
           && Schema.sObjectType.FeatureToggle__mdt.fields.DeveloperName.isAccessible()
          ){
              featureToggle = [SELECT Id, DeveloperName, isEnabled__c, Enabled_For_Users__c
                FROM FeatureToggle__mdt
                WHERE DeveloperName = :featureName
                LIMIT 1];
          }       
        return featureToggle;
}
}