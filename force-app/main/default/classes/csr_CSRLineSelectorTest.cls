@isTest
public class csr_CSRLineSelectorTest {

    // Create a test user with System Admin profile + CSR_Processor permission set
    private static User createTestUserWithPermissionSet() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            FirstName = 'Line',
            LastName = 'Tester',
            Email = 'linetester' + DateTime.now().getTime() + '@example.com',
            Username = 'linetester' + DateTime.now().getTime() + '@example.com',
            Alias = 'ltst',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert u;

        List<PermissionSet> psList = [SELECT Id FROM PermissionSet WHERE Name = 'CSR_Processor' LIMIT 1];
        if (!psList.isEmpty()) {
            insert new PermissionSetAssignment(
                AssigneeId = u.Id,
                PermissionSetId = psList[0].Id
            );
        }
        return u;
    }

    // Create CSR record
    private static CSR__c createTestCSR() {
        CSR__c csr = new CSR__c(
            CSR_Number__c = 'CSR0001',
            csr_Status__c = 'N'
        );
        insert csr;
        return csr;
    }

    // Create CSR line records
    private static List<CSR_Line__c> createTestLines(Id csrId) {
        List<CSR_Line__c> lines = new List<CSR_Line__c>{
            new CSR_Line__c(
                CSR__c = csrId,
                Name = 'Line-001',
                csr_Parts_Number__c = 'PN-1001',
                csr_Quantity__c = 2,
                Csr_Price__c = 50,
                csr_Status__c = 'N'
            ),
            new CSR_Line__c(
                CSR__c = csrId,
                Name = 'Line-002',
                csr_Parts_Number__c = 'PN-2002',
                csr_Quantity__c = 3,
                Csr_Price__c = 75,
                csr_Status__c = 'N'
            )
        };
        insert lines;
        return lines;
    }

    /**
     * Given: Valid CSR line Ids
     * When:  getCSRlinesByIds is called as a CSR user
     * Then:  Lines should be returned
     */
    @isTest
    static void whenGetCSRlinesByIds_thenReturnLines() {
        User testUser = createTestUserWithPermissionSet();
        System.runAs(testUser) {
            CSR__c csr = createTestCSR();
            List<CSR_Line__c> lines = createTestLines(csr.Id);

            Test.startTest();
            Map<Id, CSR_Line__c> result = csr_CSRLineSelector.getCSRlinesByIds(new Set<Id>{ lines[0].Id, lines[1].Id });
            Test.stopTest();

            System.assertEquals(2, result.size());
        }
    }

    /**
     * Given: A CSR Id
     * When:  getCSRlinesByCSRId is called as a CSR user
     * Then:  Related lines should be returned
     */
    @isTest
    static void whenGetCSRlinesByCSRId_thenReturnLines() {
        User testUser = createTestUserWithPermissionSet();
        System.runAs(testUser) {
            CSR__c csr = createTestCSR();
            createTestLines(csr.Id);

            Test.startTest();
            List<CSR_Line__c> result = csr_CSRLineSelector.getCSRlinesByCSRId(csr.Id);
            Test.stopTest();

            System.assertEquals(2, result.size());
        }
    }

    /**
     * Given: Valid CSR line Ids
     * When:  getForDelete is called as a CSR user
     * Then:  Lines with those Ids should be returned
     */
    @isTest
    static void whenGetForDelete_thenReturnLines() {
        User testUser = createTestUserWithPermissionSet();
        System.runAs(testUser) {
            CSR__c csr = createTestCSR();
            List<CSR_Line__c> lines = createTestLines(csr.Id);

            Test.startTest();
            List<CSR_Line__c> result = csr_CSRLineSelector.getForDelete(new List<Id>{ lines[0].Id });
            Test.stopTest();

            System.assertEquals(1, result.size());
            System.assertEquals(lines[0].Id, result[0].Id);
        }
    }
}