public class eDealerToggle {
    static String className='';
    
    //static String className='';  
    @AuraEnabled (cacheable=true)
    public static Boolean csrToggle(){
        Boolean displayCSRMenu = false;
        User user=EDealerUserUtils.fetchLoggedInUserdetails();
        if(user !=null && user.Pass_Group_Permissions__c !=null && user.Pass_Group_Permissions__c.containsIgnoreCase('Purchasing')){
            displayCSRMenu=true;
        }
        return displayCSRMenu;
    }
    @AuraEnabled (cacheable=true)
    public static Boolean pricingToggle(){
        Boolean displayPricingMenu = false;
        User user=EDealerUserUtils.fetchLoggedInUserdetails();
        System.debug('user'+user);
        System.debug('user.Pass_Group_Permissions__c'+user.Pass_Group_Permissions__c);
        List<String> userPassPemissions = user.Pass_Group_Permissions__c != null ? user.Pass_Group_Permissions__c.split(';') : null;
        List<String> pricingPassPemissions = System.Label.Edealer_Pricing_Pass_Perms != null ? System.Label.Edealer_Pricing_Pass_Perms.split(',') : null;
        List<String> excludedCountries = System.Label.Edealer_Pricing_Excluded_Countries != null ? System.Label.Edealer_Pricing_Excluded_Countries.split(',') : null;
        if(user !=null && user.Pass_Group_Permissions__c !=null && 
           (ListUtils.hasIntersectionIgnoreCase(userPassPemissions, pricingPassPemissions)) && 
           (!ListUtils.hasIntersectionIgnoreCase(excludedCountries, new List<String>{user.Contact.Account.ShippingCountry}))){
            displayPricingMenu=true;
        }
        return displayPricingMenu;
    }
    
    @AuraEnabled (cacheable=true)
    public static Boolean tcs365Toggle(){
        try{
            Boolean displayTCS365Menu = false;
            User user=EDealerUserUtils.fetchLoggedInUserdetails();
            System.debug('user'+user);
            System.debug('user.Pass_Group_Permissions__c'+user.Pass_Group_Permissions__c);
            if(user !=null && user.Pass_Group_Permissions__c !=null && (user.Pass_Group_Permissions__c.containsIgnoreCase('General Plus'))){
                displayTCS365Menu=true;
            }
            return displayTCS365Menu;
        }
        catch(Exception err){
            System.debug('Message'+err.getMessage());
            EDealerLogUtils.createExceptionLog(err,(String.isNotBlank(className) ? className : 'eDealerToggle'));
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static Boolean isLoyaltyMenuVisible(){
        try{
            Boolean displayLoyaltyMenu = false;
            String passGroupPermission = System.Label.Loyalty_Pass_Group_Permission; 
            User user=EDealerUserUtils.fetchLoggedInUserdetails();
            if(user !=null && !String.isEmpty(passGroupPermission)
               && user.Pass_Group_Permissions__c !=null 
               && user.Pass_Group_Permissions__c.containsIgnoreCase(passGroupPermission)){
                   displayLoyaltyMenu=true;
               }
            return displayLoyaltyMenu;
        }
        catch(Exception err){
            System.debug('Message'+err.getMessage());
            EDealerLogUtils.createExceptionLog(err,(String.isNotBlank(className) ? className : 'eDealerToggle'));
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    @AuraEnabled
    public static Boolean isRPMScoreCardMenuVisible(){
        try{
            Boolean displayRpmScoreCardMenu = false;
            String passGroupPermission = System.Label.RPM_Pass_Group_Permission;
            User user=EDealerUserUtils.fetchLoggedInUserdetails();
            if(user !=null && !String.isEmpty(passGroupPermission)
               && user.Pass_Group_Permissions__c !=null
               && user.Pass_Group_Permissions__c.containsIgnoreCase(passGroupPermission)
               ){
                   displayRpmScoreCardMenu=true;
               }
            return displayRpmScoreCardMenu;
        }
        catch(Exception err){
            System.debug('Message'+err.getMessage());
            EDealerLogUtils.createExceptionLog(err,(String.isNotBlank(className) ? className : 'eDealerToggle'));
            throw new AuraHandledException(err.getMessage());
        }
    }
}