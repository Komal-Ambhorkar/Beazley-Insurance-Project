public class ContactTriggerHandler implements ITriggerHandler{
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public void beforeInsert(List<sObject> newList) {
        
    }
        
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
        
    List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        for(sObject objSobject: newList){
            Contact objCon = (Contact) objSobject;
            if(objCon.Email!=null){
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					mail.setToAddresses(new String[] {objCon.Email});
					mail.setSenderDisplayName('Beazley Limited');
					mail.setSubject('Your New Contact Has Been Created');
					mail.setPlainTextBody('Hello ' +objCon.FirstName+' '+objCon.LastName+ '\n'+'Your Contact Record has Been Created...!!! \n Team Beazley Limited');
                	mailList.add(mail);
                }	
		}
        if(!mailList.isEmpty()){
    		Messaging.sendEmail(mailList,false);
    }
   }
    
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
        
    }
    
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
        
    }
    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
        
    }
}