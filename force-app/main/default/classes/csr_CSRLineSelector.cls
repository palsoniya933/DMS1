public with sharing class csr_CSRLineSelector{
    
    /**
* Get CSR Lines by Ids
*/
    public static Map<Id, CSR_Line__c> getCSRlinesByIds(Set<Id> lineIds) {        
        
        return new Map<Id, CSR_Line__c>([
            SELECT Id, Name, csr_Part_Type__c, csr_Part_Description__c, csr_Discount__c, 
            Csr_Price__c, csr_Competitor_Price__c, csr_Competitor_P_N__c, csr_Competitor_Brand__c, 
            csr_Competitor__c, csr_Best_Net__c, csr_W_D__c, csr_Stock_Class__c, csr_Requested_Discount__c, 
            csr_Quantity__c, csr_Parts_Number__c, csr_PPD_MRG__c, csr_Landing_Cost__c, 
            csr_STDDLERNET__c, csr_Part_Type_Description__c, csr_Status__c,CSR__c,csr_Cancel_Reason__c,csr_Marketing_Review__c,
            csr_Exception_Comment__c,csr_Pricing_Alert__c
 
            FROM CSR_Line__c
            WHERE Id IN :lineIds
            WITH SECURITY_ENFORCED
        ]);
    }
    
    /**
* Get CSR Lines by CSR Case Id
*/
    public static List<CSR_Line__c> getCSRlinesByCSRId(Id csrId) {
        
        
        return [
            SELECT Id, Name, csr_Part_Type__c, csr_Part_Description__c, csr_Discount__c, Csr_Price__c, 
            csr_Competitor_Price__c, csr_Competitor_P_N__c, csr_Competitor_Brand__c, csr_Competitor__c, 
            csr_Best_Net__c, csr_W_D__c, csr_Stock_Class__c, csr_Requested_Discount__c, csr_Quantity__c, 
            csr_Parts_Number__c, csr_PPD_MRG__c, csr_Landing_Cost__c, csr_STDDLERNET__c, 
            csr_Part_Type_Description__c, csr_Status__c,CSR__c,csr_Marketing_Review__c,csr_Cancel_Reason__c,
            csr_Exception_Comment__c,csr_Pricing_Alert__c
            FROM CSR_Line__c
            WHERE CSR__c = :csrId
            WITH SECURITY_ENFORCED
            ORDER BY Createddate ASC
        ];
    }
    
    /**
* Get CSR Lines to delete
*/
    public static List<CSR_Line__c> getForDelete(List<Id> recordIds) {        
        
        return [
            SELECT Id 
            FROM CSR_Line__c 
            WHERE Id IN :recordIds
            WITH SECURITY_ENFORCED
        ];
    }

  public static List<CSR_Line__c> getCSRLinesWherePartNumberChannelAndQuantityIsNotNull(Id csrId) {
        return [
            SELECT Id, csr_Parts_Number__c, csr_W_D__c, csr_Quantity__c
            FROM CSR_Line__c
            WHERE CSR__c = :csrId
            AND csr_Parts_Number__c != null
            AND csr_W_D__c != null
            AND csr_Quantity__c!=null
        ];
    }
public static List<CSR_Line__c> getCSRLinesByCSRIdAndLineNumbers(Id csrId, List<String> lineNumbers) {
        return [
            SELECT Id, csr_Status__c
            FROM CSR_Line__c
            WHERE CSR__c = :csrId
            AND Name IN :lineNumbers
            WITH SECURITY_ENFORCED
        ];
    }


    public static Integer countActiveLinesByCSRId(Id csrId) {
        return [
            SELECT COUNT()
            FROM CSR_Line__c
            WHERE CSR__c = :csrId
            AND csr_Status__c != 'T'
            WITH SECURITY_ENFORCED
        ];
    }

}