public with sharing class test {
    
    /**
     * Query total account records
     * @return Integer - Total number of account records
     */
    public static Integer getTotalAccountRecords() {
        return [SELECT COUNT() FROM Account];
    }
    
    /**
     * Query all account records with details
     * @return List<Account> - List of all account record
     */
    public static List<Account> getAllAccounts() {
        return [SELECT Id, Name, BillingCity, BillingState FROM Account];
    }

    //create a method to insert a new account record
    public static void insertAccount(Account acc) {
        //insert 10 account random name 
        for(Integer i = 0; i < 10; i++) {
            acc.Name = 'Account ' + i;//choose another standard name
            acc.BillingCity = 'City ' + i;
            acc.BillingState = 'State ' + i;
        insert acc;
    }
}