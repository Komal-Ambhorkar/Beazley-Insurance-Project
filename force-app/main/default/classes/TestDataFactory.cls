@isTest
public with sharing class TestDataFactory {
    
    public static List<Contact> createContact(){
        List<Contact> conList = new List<Contact>();
        for(Integer i=1; i<=200; i++){
            Contact objCon = new Contact(FirstName = 'Test'+i,LastName = 'Contact'+i,Email ='komal'+i+'sfdc@gmail.com');
            conList.add(objCon);
        }
        Database.Insert(conList, false); 
        return conList;
    }
    
    public static List<Case> createCase( List<Contact> conList){
        List<Case> caseList = new List<Case>();
        for(Contact objCon : conList){
            Case objCase = new Case(Status='Escalated', ContactId = objCon.Id);
            caseList.add(objCase);
        }
        Database.insert(caseList, false);
        return caseList ;
    }
    
}