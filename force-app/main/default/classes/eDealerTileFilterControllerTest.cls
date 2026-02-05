@isTest
public with sharing class eDealerTileFilterControllerTest {
    @isTest
    public static void eDealerTileFilterControllerTest() {

       List<Object> getfilter = eDealerTileFilterController.getCmpFilters('ActiveOrderCmp');
       system.assert(getfilter != null);
    }
}