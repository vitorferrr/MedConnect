//Trigger que trabalha na validação dos dados de localização na API SmartyStreets

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