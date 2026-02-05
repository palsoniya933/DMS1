@isTest
public class ToggleFeaturesControllerTest {
    
    @isTest static void testIsFeatureEnabled(){
        Boolean result=false;
        Test.startTest();
        try{
            result =  ToggleFeaturesController.isFeatureEnabled('test');
        }
        catch(Exception ex){
            result = ex.getMessage().containsIgnoreCase('List has no rows for assignment to SObject');
        }
        
        Test.stopTest();
        System.assertEquals(true, result);
    }
}