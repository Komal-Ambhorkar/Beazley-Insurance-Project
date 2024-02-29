trigger ContactAmountAccountAggregateResult on Contact (After Insert, After Update, After Delete) {

    Set<Id> accIdSet = new Set<Id>();

    if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.new != null) {
        for (Contact objCon : Trigger.new) {
            if (objCon.AccountId != null) {
                accIdSet.add(objCon.AccountId);
            }
        }
    }

    if (Trigger.isDelete && Trigger.old != null) {
        for (Contact objCon : Trigger.old) {
            if (objCon.AccountId != null) {
                accIdSet.add(objCon.AccountId);
            }
        }
    }

    if (!accIdSet.isEmpty()) {
        List<Account> accountsToUpdate = new List<Account>();

        for (AggregateResult aggResult : [SELECT AccountId, SUM(Amount__c) totalAmount FROM Contact WHERE AccountId IN :accIdSet GROUP BY AccountId]) {
            Id accountId = (Id)aggResult.get('AccountId');
            Decimal totalAmount = (Decimal)aggResult.get('totalAmount');
            accountsToUpdate.add(new Account(Id = accountId, Total_Amount__c = totalAmount));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}