@IsTest
public class FeatureToggleServiceTest {
    @IsTest
    static void testUserNotEnabled() {
        
        Boolean result=false;
        Test.startTest();
        try{
            FeatureToggleService featureService = new FeatureToggleService('Test');
            result = featureService.isFeaturedEnabled;
        }
        catch(Exception ex){
            result = ex.getMessage().containsIgnoreCase('List has no rows for assignment to SObject');
        }
        
        Test.stopTest();
        System.assertEquals(true, result);
    }
}