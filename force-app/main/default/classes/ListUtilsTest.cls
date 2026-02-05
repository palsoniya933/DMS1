@istest
public class ListUtilsTest {
	
    @istest static void hasIntersectionIgnoreCaseForNullInput(){
        Boolean result;
        Test.startTest();
        result = ListUtils.hasIntersectionIgnoreCase(null,null);
        Test.stopTest();
        System.assertEquals(result,false);
    }
    
    @istest static void hasIntersectionIgnoreCaseWhenCommonExists(){
        Boolean result;
        Test.startTest();
        result = ListUtils.hasIntersectionIgnoreCase(new List<String>{'a','B','c'},new List<String>{'A'});
        Test.stopTest();
        System.assertEquals(result,true);
    }
    
        @istest static void hasIntersectionIgnoreCaseWhenCommonDontExist(){
        Boolean result;
        Test.startTest();
        result = ListUtils.hasIntersectionIgnoreCase(new List<String>{'a','B','c'},new List<String>{'D'});
        Test.stopTest();
        System.assertEquals(result,false);
    }
}