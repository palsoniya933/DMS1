global without sharing class EDealerLoginController {
    
    global String username {get;set;}
    global String password {get; set;}
    //public Boolean isAuth0User {get; set;}
    /*public String orgId {get; set;}
    public String siteURL  {get; set;}
    public String startURL {get; set;}
    public List<AuthProvider> authProviders {get;set;}*/
    
    global eDealerLoginController () {
       /* orgId = UserInfo.getOrganizationId();
        siteURL  = Site.getBaseUrl();
        startURL = System.currentPageReference().getParameters().get('startURL');
        if (startURL == null) startURL = '/';
        authProviders = [SELECT Id,DeveloperName,FriendlyName,ProviderType FROM AuthProvider];
        isAuth0User = false;  */      
    }

  
    global PageReference login() {
        /*
        //again calling the method to check the user type
        checkAuth0User();
        
        // if auth flag is set open auth else login
        if(isAuth0User){
            return loginAuth0();
        }
        else{
            return Site.login(username, password, '/s/');
        }
        **/
        return Site.login(username, password, '/s/');
    }
    
    global PageReference loginAuth0() {//Paccar_Pass_Auth0
        return new pagereference(System.label.Paccar_Pass_Auth0);
    }
 /*   
    global void  checkAuth0User(){
    
        isAuth0User = false;
        if(String.isNotBlank(username)){
            List<User> userList = [SELECT Id, name,Username, ProfileId, Profile.Name FROM User WHERE Username =:username];
            
            if(!userList.isEmpty() 
                && userList[0].Profile.Name == 'Paccar Customer Community Plus Login'){
                isAuth0User = true;
            }
        
        }   
    }
*/
/*    
    global String getEncodedSiteUrl() {
        return EncodingUtil.urlEncode(siteURL, 'UTF-8');
    }
    
    global String getEncodedStartUrl() {
        return EncodingUtil.urlEncode(startURL, 'UTF-8');
    }
*/
}