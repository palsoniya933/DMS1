public class csr_CSRSelector {
    
    public static CSR__c getCSRById(Id csrId) {
        
        return [
            SELECT Id, CSR_Number__c, csr_Phase__c, csr_Type__c, csr_Competitive_Type__c,
            csr_Effective_Date__c, csr_Expiration_Date__c, csr_DealerCode__c, csr_DealerGroup__c, csr_Dealer_Type__c,
            csr_Dealer_Name__c, csr_DealerDivision__c, csr_Customer_Name__c, csr_Assigned_To__c,
            csr_Internal_Checkbox__c, csr_Status__c, CreatedDate, CreatedById, csr_AccountId__c,CreatedBy.Name,CreatedBy.FirstName,csr_Currency_Code__c,csr_District__c,csr_Region__c,
            csr_DPM_Name__c,csr_Exchange_Rate__c,csr_Country__c,csr_RSM_Name__c, csr_Expedite__c,csr_Dealer_Action__c
            FROM CSR__c
            WHERE Id = :csrId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
    public static List<CSR__c> getExistingCSRByNumberAndPhase(String csrNumber, String phase) {
        return [
            SELECT Id, CSR_Number__c, csr_Phase__c
            FROM CSR__c
            WHERE CSR_Number__c = :csrNumber
            AND csr_Phase__c = : (String.isNotBlank(phase) ? Decimal.valueOf(phase) : null)
            LIMIT 1
        ];
    }
    
    /**
* Fetch CSR__c records by CSR Numbers.
*/
    public static List<CSR__c> getCsrsByCsrNumberAndPhases(Set<String> csrNumbers, Set<Decimal> csrPhases) {
        return [
            SELECT Id,
            CSR_Number__c,
            CSR_Phase__c,
            CSR_Expedite__c,
            CSR_Status__c,
            CreatedDate
            FROM CSR__c
            WHERE CSR_Number__c IN :csrNumbers
            AND CSR_Phase__c IN : csrPhases
            WITH SECURITY_ENFORCED
        ];
    }
    
    /**
* Fetch a single CSR__c record Id by CSR Number.
*/
    public static List<CSR__c> getCsrIdByNumber(String csrNumber) {
        return [
            SELECT Id, CSR_Number__c
            FROM CSR__c
            WHERE CSR_Number__c = :csrNumber
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
    
    
    public static CSR__c getCSRByNumberAndPhase(String csrNumber, Integer phase) {
        return [
            SELECT Id, csr_Status__c
            FROM CSR__c
            WHERE CSR_Number__c = :csrNumber
            AND csr_Phase__c = :phase
            WITH SECURITY_ENFORCED
            LIMIT 1   
        ];
    }
}