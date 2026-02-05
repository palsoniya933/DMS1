@IsTest
public class csr_CSRSelectorTest {

	private static CSR__c createMockCSR(String csrNumber, Decimal phase, Boolean expedite, String status) {
        CSR__c csr = new CSR__c(
            CSR_Number__c = csrNumber,
            csr_Phase__c = phase,
            CSR_Expedite__c = expedite,
            CSR_Status__c = status
        );
        insert csr;
        return csr;
    }

    @IsTest
    static void test_getCSRById() {
        CSR__c csr = createMockCSR('10001', 1, true, 'X');

        CSR__c result = csr_CSRSelector.getCSRById(csr.Id);

        System.assertNotEquals(null, result, 'CSR should be returned');
        System.assertEquals('10001', result.CSR_Number__c, 'CSR Number should match');
        System.assertEquals(1, result.csr_Phase__c, 'CSR Phase should match');
    }

    @IsTest
    static void test_getExistingCSRByNumberAndPhase() {
        CSR__c csr = createMockCSR('10002', 2, false, 'S');

        List<CSR__c> result = csr_CSRSelector.getExistingCSRByNumberAndPhase('10002', '2');

        System.assertEquals(1, result.size(), 'One CSR record should be returned');
        System.assertEquals('10002', result[0].CSR_Number__c, 'CSR Number should match');
        System.assertEquals(2, result[0].csr_Phase__c, 'CSR Phase should match');
    }

    @IsTest
    static void test_getCsrsByCsrNumberAndPhases() {
        CSR__c csr1 = createMockCSR('10003', 1, true, 'X');
        CSR__c csr2 = createMockCSR('10004', 2, false, 'S');

        Set<String> csrNumbers = new Set<String>{'10003', '10004'};
        Set<Decimal> csrPhases = new Set<Decimal>{1, 2};

        List<CSR__c> result = csr_CSRSelector.getCsrsByCsrNumberAndPhases(csrNumbers, csrPhases);

        System.assertEquals(2, result.size(), 'Two CSR records should be returned');
    }

    @IsTest
    static void test_getCsrIdByNumber() {
        CSR__c csr = createMockCSR('10005', 1, true, 'X');

        List<CSR__c> result = csr_CSRSelector.getCsrIdByNumber('10005');

        System.assertEquals(1, result.size(), 'One CSR record should be returned');
        System.assertEquals('10005', result[0].CSR_Number__c, 'CSR Number should match');
    }  
    
}