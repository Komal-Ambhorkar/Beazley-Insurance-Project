public with sharing class OpportunityController {
    
    @AuraEnabled(Cacheable = true)
    public static List<Opportunity> getOpportunityrecord( Id accId){
        try {
            return [Select Name, StageName,CloseDate from Opportunity where AccountId =: accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}