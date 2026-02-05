@isTest
public class EDealerLoginControllerTest {

    @isTest
    private static void testlogin(){       
        EDealerLoginController objEDealer=new EDealerLoginController();
        List<AuthProvider> authProviders = [SELECT Id,DeveloperName,FriendlyName,ProviderType FROM AuthProvider];
        objEDealer.login();
        objEDealer.loginAuth0();
       //objEDealer.getEncodedSiteUrl();
       //objEDealer.getEncodedStartUrl();       
    }  
}