trigger LocationTrigger on Location__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LocationTriggerHandler.aposInserir(Trigger.new);
        }
        if (Trigger.isUpdate) {
            LocationTriggerHandler.aposAtualizar(Trigger.new, Trigger.oldMap);
        }
    }
}