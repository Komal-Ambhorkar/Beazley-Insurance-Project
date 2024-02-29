trigger CaseEscalatedToContactEmailTrigger on Case (After insert, After Update) {
    
    List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
    SET<Id> contactIdSet = new SET<Id>();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        for(Case objCase : trigger.new){
            if(objCase.Status == 'Escalated' && objCase.ContactId != null){
               if(trigger.isInsert){
             		contactIdSet.add(objCase.ContactId);   
            	}
            if(trigger.isUpdate){
            	 if(objCase.Status!= trigger.oldMap.get(objCase.Id).Status) {
             		 contactIdSet.add(objCase.ContactId);  
            		}    
            	} 
            }    
        }   
    }
    Map<Id,Contact> contactMap = new Map<Id,Contact>();
    if(!contactIdSet.isEmpty()){
      for(Contact objCon : [Select Id, Email,Name,To_Addresses__c,cc_Addresses__c from Contact where Id IN : contactIdSet]){
        		contactMap.put(objCon.Id,objCon);
   		 }  
    }
      
    if(trigger.isAfter && trigger.isInsert){
        for(Case objCase : trigger.new){
            if(!contactMap.isEmpty()){
                if(contactMap.containsKey(objCase.ContactId)){
               			 Contact relatedParent = contactMap.get(objCase.ContactId);
                if(relatedParent !=null && string.isNotBlank(relatedParent.To_Addresses__c)){
                    	List<string> toAddresses = relatedParent.To_Addresses__c.split(';');
                    for(string emailAddresses : toAddresses){
                        emailAddresses = emailAddresses.trim();
                        if (Pattern.matches('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}', emailAddresses)){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new String[] {emailAddresses});
                            mail.setSenderDisplayName('Beazley Limited');
                            mail.setSubject('Your New Contact Has Been Escalated');
                            mail.setPlainTextBody('Your Case Status has been Escalated...!!! \n Team Beazley Limited');
                            mailList.add(mail);
                        }
                    }
                }
            }
        }
            
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList,false);
            }
        }   
    }  
}