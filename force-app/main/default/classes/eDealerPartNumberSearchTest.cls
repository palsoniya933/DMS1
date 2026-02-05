@isTest
private class eDealerPartNumberSearchTest {

    @isTest
    static void testGetPartNumberbySearchKey() {
        List<String> dealerCodes = new List<String>{'D001'};
        List<String> status = new List<String>{'Active'};
        String searchText = 'PART123';
        Integer download = 0;
        String frequency = 'weekly';
        List<String> csrType = new List<String>{'CSR1'};

        Test.startTest();
        String result = eDealerPartNumberSearch.getPartNumberbySearchKey(dealerCodes, status, searchText, download, frequency, csrType);
        Test.stopTest();

        System.debug('Result: ' + result);
        System.assert(result.contains('error'), 'Should return an error in test context');
    }

    @isTest
    static void testGetPartsColumnHeaders() {
        // Simple test call
        Test.startTest();
        List<Map<String, String>> result = eDealerPartNumberSearch.getPartsColumnHeaders();
        Test.stopTest();

        System.debug('Headers: ' + result);
        System.assertNotEquals(null, result, 'Headers should not be null');
    }
}