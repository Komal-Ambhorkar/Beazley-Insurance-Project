public with sharing class CaseStatusRecord {
    @AuraEnabled(cacheable=true)
    public static String getCaseStatus(Id caseId) {
        Case record =[Select Status from Case where Id =: caseId limit 1];
        return record.Status;
    }

    @AuraEnabled
    public static void escalateCase(Id caseId, String reason) {

        Case recordToUpdate =[Select Id, Status, Reason_for_Escalation__c,Contact.Name, Contact.Email from Case where Id =: caseId limit 1];
        
        if (recordToUpdate != null && recordToUpdate.Status != 'Escalated') {
            recordToUpdate.Status = 'Escalated';
            recordToUpdate.Reason_for_Escalation__c = reason; 
            update recordToUpdate;
           /* Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {recordToUpdate.Contact.Email});
            mail.setSenderDisplayName('Beazley Insurance Limited');
            mail.setSubject('Case Has Been Escalated');
            mail.setPlainTextBody('Hi ' + recordToUpdate.Contact.Name + ',\nCase Status has been changed to Escalated');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/

        }
    }
    @AuraEnabled
    public static void reopenCase(Id caseId, String reason) {
       Case recordToUpdate =[Select Id, Status, Reason_for_Escalation__c,Contact.Name, Contact.Email from Case where Id =: caseId limit 1];
       
        if (recordToUpdate != null && recordToUpdate.Status != 'New') {
            recordToUpdate.Status = 'New';
            recordToUpdate.Reason_for_Escalation__c = null; 
            update recordToUpdate;
            /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {recordToUpdate.Contact.Email});
            mail.setSenderDisplayName('Beazley Insurance Limited');
            mail.setSubject('Case Has Been Reopen');
            mail.setPlainTextBody('Hi ' + recordToUpdate.Contact.Name + ',\nCase Status has been Reopen');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        }
    }

    }