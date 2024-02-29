public class CaseTriggerHandler implements ITriggerHandler {
    // Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    // Check if the trigger is disabled from the transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public void beforeInsert(List<sObject> newList) {
        
    }
    
    public void afterInsert(List<sObject> newList, Map<Id, sObject> newMap) {
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Set<Id> contactIdSet = new Set<Id>();
        
        for (sObject sObj : newList) {
            Case objCase = (Case) sObj;
            if (objCase.Status == 'Escalated' && objCase.ContactId != null) {
                contactIdSet.add(objCase.ContactId);
            }
        }
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        if (!contactIdSet.isEmpty()) {
            for (Contact objCon : [SELECT Id, Email, Name, To_Addresses__c, cc_Addresses__c FROM Contact WHERE Id IN :contactIdSet]) {
                contactMap.put(objCon.Id, objCon);
            }
        }
        if (!contactMap.isEmpty()) {
            for (sObject sObj : newList) {
                Case objCase = (Case) sObj;
                if (contactMap.containsKey(objCase.ContactId)) {
                    if (String.isNotBlank(contactMap.get(objCase.ContactId).To_Addresses__c)) {
                        List<String> toAddresses = contactMap.get(objCase.ContactId).To_Addresses__c.split(';');
                        List<String> ccAddresses = contactMap.get(objCase.ContactId).cc_Addresses__c.split(';');
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(ccAddresses);
                        mail.setSenderDisplayName('Beazley Limited');
                        mail.setSubject('Your New Contact Has Been Escalated');
                        mail.setPlainTextBody('Your Case Status has been Escalated...!!! \n Team Beazley Limited');
                        mailList.add(mail);
                    }
                }
            }
        }       
        if(!mailList.isEmpty()) {
            Messaging.sendEmail(mailList, false);
        } 
    }
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Set<Id> contactIdSet = new Set<Id>();
        
        for (sObject sObj : newList) {
            Case objCase = (Case)sObj;
            Case oldCase = (Case)oldMap.get(objCase.Id);
            if (objCase.Status != oldCase.Status) {
                contactIdSet.add(objCase.ContactId);
            }
        }
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        if (!contactIdSet.isEmpty()) {
            for (Contact objCon : [SELECT Id, Email, Name, To_Addresses__c, cc_Addresses__c  FROM Contact WHERE Id IN :contactIdSet]) {
                contactMap.put(objCon.Id, objCon);
            }
        }
        if (!contactMap.isEmpty()){
            for (sObject sObj : newList) {
                Case objCase = (Case) sObj;
                if(contactMap.containsKey(objCase.ContactId)){
                    if (String.isNotBlank(contactMap.get(objCase.ContactId).To_Addresses__c)) {
                        List<String> toAddresses = contactMap.get(objCase.ContactId).To_Addresses__c.split(';');
                        List<String> ccAddresses = contactMap.get(objCase.ContactId).cc_Addresses__c.split(';');
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                        mail.setToAddresses( toAddresses );
                                        mail.setCcAddresses(ccAddresses);
                                        mail.setSenderDisplayName('Beazley Limited');
                                        mail.setSubject('Your New Contact Has Been Escalated');
                                        mail.setPlainTextBody('Your Case Status has been Escalated...!!! \n Team Beazley Limited');
                                        mailList.add(mail);
                                    }
                            }
                        }   
                    }
        if (!mailList.isEmpty()) {
            Messaging.sendEmail(mailList, false);
        }
    }   
    
    public void beforeDelete(List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void afterDelete(List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
        
    } 
}