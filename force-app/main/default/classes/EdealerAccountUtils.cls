public with sharing class EdealerAccountUtils {
    
    public static List<String> getFieldsNames(){
        List<String> fieldsName = new List<String>();
        fieldsName.add('Name');
        fieldsName.add('Dealer_Code__c');
        fieldsName.add('Dealer_Group_Name__c');
        fieldsName.add('Group_Code__c');
        fieldsName.add('PACCARDivision__c');
        return fieldsName;
    }
    
    
    public static List<Account> getDealersAccount(Set<String> setDealerLocs){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM Account';
        query += ' WHERE Dealer_Code__c IN :setDealerLocs';
        
        //SOQL
        List<Account> lstDealerAccounts = Database.query(query);
        
        return lstDealerAccounts;
    }
    
    public static List<Account> getDealersAccountByGroup(Set<String> setDealerGroupName){
        String query = 'SELECT Id, ';
        query += String.join( getFieldsNames(), ', ');
        query += ' FROM Account';
        query += ' WHERE Group_Code__c IN :setDealerGroupName';
        
        //SOQL
        List<Account> lstDealerAccounts = Database.query(query);
        
        return lstDealerAccounts;
    }

}