public with sharing class AccountController {
    @AuraEnabled
    public static List<Account> getAccountsAndContacts() {
        try {
            List<Account> accountList = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account where Id != null];
            return accountList;
        } catch (Exception e) {
                        return null;
        }
    }
}
