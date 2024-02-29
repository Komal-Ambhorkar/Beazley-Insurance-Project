//There is a field “Total Amount” on Account Object. There is a field “Amount” on Contact Object. 
//Add contact Amount in Account’s Total Amount. (Child to Parent)

trigger AccountContactAmount on Contact (After Insert, After Update) {

    Decimal sumAmount;
    //1]
    Set<Id> accIdSet = new Set<Id>();
    if(trigger.isAfter){
        for(Contact objCon : trigger.new){
        if(trigger.isInsert || trigger.isUndelete) {
                accIdSet.add(objCon.AccountId);
                system.debug('#Account ID= '+objCon.AccountId ); 
        }
        if(trigger.isUpdate){
            if( objCon.AccountId != trigger.oldMap.get(objCon.Id).AccountId){
                accIdSet.add(objCon.AccountId);
            }
        }
    }
        if(trigger.isUpdate || trigger.isDelete){
            for(Contact objCon:trigger.old){
                accIdSet.add(objCon.AccountId);    
            }
        }
    }
    


    // 2]
    Map<Id,Account> accMap = new Map<Id,Account>();
    
    if(!accIdSet.isEmpty()){
        for(Account objAcc : [Select Id, Name,Total_Amount__c,(select Id,FirstName,LastName,Amount__c from Contacts) from Account Where Id IN :accIdSet]){
            accMap.put(objAcc.Id,objAcc);
        system.debug('map Value='+accMap);
        //System.debug('#Total Amount='+accMap.get(objAcc.Total_Amount__c));
        //system.debug('#Amount='+Amount__c);

            }
    }

    // 3]

    if(!accMap.isEmpty()){
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
            for(Contact objCon : trigger.new){
                if(accMap.containsKey(objCon.AccountId)){
                    System.debug(' #Amount in Map='+accMap.get(objCon.AccountId).Total_Amount__c);//600
                    System.debug('#Contact Amount='+objCon.Amount__c);//300
                    accMap.get(objCon.AccountId).Total_Amount__c = accMap.get(objCon.AccountId).Total_Amount__c + objCon.Amount__c;
                    System.debug('#Total Amount in Map='+accMap.get(objCon.AccountId).Total_Amount__c);
                }
                
           }
        }
        database.update(accMap.Values(),false);
    }

   }
