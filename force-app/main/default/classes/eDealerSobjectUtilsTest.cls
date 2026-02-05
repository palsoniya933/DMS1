@isTest
public class eDealerSobjectUtilsTest {
    @isTest
    static void testGetPicklistByObjectAndField() {
        // Test with existing object and field
       Test.startTest();
        List<Map<String, String>> options1 = eDealerSobjectUtils.getPicklistByObjectAndField('Account', 'Type');
        Test.stopTest();

        
    }
}