trigger CaseTrigger on Case (before insert, after insert, before update, after update, before Delete, after delete, after unDelete) {
    TriggerDispatcher.run(new CaseTriggerHandler(), 'CaseTrigger');
}