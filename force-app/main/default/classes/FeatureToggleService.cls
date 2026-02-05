public without sharing class FeatureToggleService {
    private String featureName;

    public FeatureToggleService(String featureName) {
        this.featureName = featureName;
    }
    
    public Boolean isFeaturedEnabled {
        get {
            if (isFeaturedEnabled == null) {
               FeatureToggle__mdt featureToggle = FeatureToggleSelector.getFeatureToggleByFeatureName(featureName);
                if (featureToggle == null || !featureToggle.isEnabled__c) {
                    isFeaturedEnabled = false;
                } else if (featureToggle.isEnabled__c && featureToggle.Enabled_For_Users__c.toLowerCase() == 'all') {
                    isFeaturedEnabled = true;
                } else {
                    String currentUserEmail = UserInfo.getUserEmail();
                    isFeaturedEnabled = featureToggle.Enabled_For_Users__c.containsIgnoreCase(currentUserEmail);
                }
            }
            return isFeaturedEnabled;
        }
        private set;
    }
}