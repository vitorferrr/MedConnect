/**
 * @description Trigger for the Event_Speaker__c object
 * @author      Vitor Ferreira
 */
trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update, after insert) {

    
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            EventSpeakerTriggerHandler.checkDuplicateBookings(Trigger.new, Trigger.oldMap);
        }
    }
    

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            EventSpeakerTriggerHandler.sendConfirmationEmail(Trigger.new);
        }
    }
}