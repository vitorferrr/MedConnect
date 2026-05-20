/**
 * @description Handler class for Event_Speaker__c Trigger
 * @author      Vitor Ferreira
 */
public inherited sharing class EventSpeakerTriggerHandler {
    
    public static void checkDuplicateBookings(List<Event_Speaker__c> newList, Map<Id, Event_Speaker__c> oldMap) {
        try {
            Set<Id> speakerIds = new Set<Id>();
            Set<Id> currentRecordIds = new Set<Id>();

            for (Event_Speaker__c es : newList) {
                if (es.Speaker__c != null) {
                    speakerIds.add(es.Speaker__c);
                }
                if (es.Id != null) {
                    currentRecordIds.add(es.Id);
                }
            }

            if (speakerIds.isEmpty()) return;

            List<Event_Speaker__c> existingBookings = [
                SELECT Speaker__c, Medical_Event__c 
                FROM Event_Speaker__c
                WHERE Speaker__c IN :speakerIds
                AND Id NOT IN :currentRecordIds
                AND Medical_Event__r.Live__c = true
                AND Medical_Event__r.End__c >= :Datetime.now()
            ];

            Set<Id> busySpeakers = new Set<Id>();
            for (Event_Speaker__c booking : existingBookings) {
                busySpeakers.add(booking.Speaker__c);
            }

            for (Event_Speaker__c es : newList) {
                if (busySpeakers.contains(es.Speaker__c)) {
                    es.addError('Este palestrante já possui um evento ativo agendado.');
                }
            }
            
        } catch (Exception ex) {
            ErrorLogService.createErrorLog(Datetime.now(), ex.getStackTraceString(), 'EventSpeakerTriggerHandler');
        }
    }
}