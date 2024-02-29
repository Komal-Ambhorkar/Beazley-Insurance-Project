public with sharing class ContactController {

    @AuraEnabled( cacheable=true )
    public static List < Contact > fetchContacts(){    

        return [
            SELECT Id, Name, Account.Name FROM Contact LIMIT 100
        ];

    }

}
