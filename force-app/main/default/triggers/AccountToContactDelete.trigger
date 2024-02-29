//Whenever a new record is created into account object, before this new record is inserted into Account, 
//delete all the contacts records with this account name also delete old Account Name.(PARENT TO CHILD SELF)

trigger AccountToContactDelete on Account (before insert, before delete) {

    Set<String> accNameSet = new Set<String>();
   /* if(trigger.isBefore && (trigger.isInsert || trigger.isDelete)){
        if(trigger.isInsert){
            for(Account objAcc : trigger.new){
                accNameSet.add(objAcc.Name);
            }  
        }
        else{
            if(trigger.isDelete){
                for(Account objAcc : trigger.old){
                    accNameSet.add(objAcc.Name);
                }   
            } 
        }
    } */       
 
    // Collect names of accounts for both insert and delete triggers
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            for (Account objAcc : Trigger.new) {
                accNameSet.add(objAcc.Name);
            }
        }
        else if (Trigger.isDelete) {
            for (Account objAcc : Trigger.old) {
                accNameSet.add(objAcc.Name);
            }
        }
    }

    Map<String, Account> accMap = new Map<String, Account>();

    // Query for existing accounts with the same name
    if (!accNameSet.isEmpty()) {
        for (Account objExistingAcc : [SELECT Id, Name, (SELECT Id, Name, AccountId FROM Contacts) FROM Account WHERE Name IN :accNameSet]) {
            accMap.put(objExistingAcc.Name, objExistingAcc);
        }
    }
List<Contact> conList = new List<Contact>();
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account objNewAcc : Trigger.new) {
            if (accMap.containsKey(objNewAcc.Name)) {
                Account objExistingAcc = accMap.get(objNewAcc.Name);
               conList = objExistingAcc.Contacts;
                delete objExistingAcc;
            }
        }
        Database.delete(conList,false); // Perform your logic here for deleting contacts
        
    }
}