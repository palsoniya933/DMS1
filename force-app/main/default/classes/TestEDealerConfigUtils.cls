@isTest
public class TestEDealerConfigUtils {
  @isTest
    static void testGetConfigByDeveloperName_NotFound() {
        // Call the method being tested with non-existing developer name
        Test.startTest();
         EDealerConfigUtils.getConfigByDeveloperName('CSR_Dealer_Status');
        Test.stopTest();
       
    }
}