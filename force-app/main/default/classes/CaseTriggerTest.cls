@isTest
public with sharing class CaseTriggerTest {
    
    @isTest
    public static void testTrigger(){
        List<Contact> testContactList = TestDataFactory.createContact();
        List<Case> testCaseList = TestDataFactory.createCase(testContactList);
    }
}