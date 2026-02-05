@isTest
public class eDealerAddCompetitorControllerTest {
    @isTest
    static void testGetStateOption() {
        // Test when getStateOption returns null
        Test.startTest();
        List<Map<String, String>> result1 = eDealerAddCompetitorController.getStateOption();
        Test.stopTest();
        System.assert(result1 == null, 'Expected null result when getStateOption returns null');
        
        // Add test data or mock behavior to test other scenarios if needed
    }
    
    @isTest
    static void testGetAffiliationOption() {
        // Test when getAffiliationOption returns null
        Test.startTest();
        List<Map<String, String>> result1 = eDealerAddCompetitorController.getAffiliationOption();
        Test.stopTest();
        System.assert(result1 != null, 'Expected non-null result when getAffiliationOption returns not null');
        
        // Add test data or mock behavior to test other scenarios if needed
    }
}