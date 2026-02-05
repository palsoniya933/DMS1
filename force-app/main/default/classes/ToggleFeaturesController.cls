public without sharing class ToggleFeaturesController {
    @AuraEnabled(cacheable=true)
    public static Boolean isFeatureEnabled(String featureName) {   
        return new FeatureToggleService(featureName).isFeaturedEnabled;
    }
}