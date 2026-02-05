@isTest
public class CaseCommunityCategoryNavControllerTest {
	
    @isTest static void getLoggingPermissionSetTest(){
        Test.startTest();
        CaseCommunityCategoryNavController.getLoggingPermissionSet();
        Test.stopTest();
    }
    
    @isTest static void getVSTileToggleTest(){
        Test.startTest();
        CaseCommunityCategoryNavController.getVSTileToggle();
        Test.stopTest();
    }
    
    @isTest static void getCaseNavigationTest(){
        Test.startTest();
        CaseCommunityCategoryNavController.getCaseNavigation();
        Test.stopTest();
    }
}