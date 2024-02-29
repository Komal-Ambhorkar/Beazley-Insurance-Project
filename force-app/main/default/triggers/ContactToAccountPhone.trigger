//Whenever a new contact is created for account, 
//update the corresponding account phone with the new contact phone field.
//Contact Phone  Account Phone


trigger ContactToAccountPhone on Contact (After insert,After update) {

    Set<Id> accIDSet =  new Set<Id>();
    if(trigger.isAfter &&(trigger.isInsert || trigger.isUpdate)){
            for(Contact objCon : trigger.new){
                    if(trigger.isInsert)
                            accIDSet.add(objCon.AccountId);

                    if(trigger.isUpdate){
                        if(objCon.AccountId != trigger.oldMap.get(objCon.Id).AccountId){
                            accIDSet.add(objCon.AccountId);
                        }
                    } 
            }
    }
    Map<Id, Account> accMap = new Map<Id, Account>();
    if(!accIDSet.isEmpty()){
        for(Account objAcc : [Select Id, Phone from Account where Id IN : accIDSet]){
            accMap.put(objAcc.Id, objAcc);
        }
       }
    if(trigger.isAfter &&(trigger.isInsert || trigger.isUpdate)){
        for(Contact objCon : trigger.new){
               if(accMap.containsKey(objCon.AccountId)){
                  accMap.get(objCon.AccountId).Phone = objCon.Phone;       
               } 
        } 
     } 
Database.update(accMap.values(),false);    
}