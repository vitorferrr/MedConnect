public with sharing class ControladorEventosParticipante {

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> obterEventosFuturos(Id idParticipante) {
        return [
            SELECT Id, 
                   Medical_Event__r.Id, 
                   Medical_Event__r.Name__c, 
                   Medical_Event__r.Start__c, 
                   Medical_Event__r.Location__r.Name 
            FROM Event_Attendee__c 
            WHERE Attendees__c = :idParticipante 
              AND Medical_Event__r.Start__c >= TODAY
            WITH USER_MODE 
            ORDER BY Medical_Event__r.Start__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> obterEventosPassados(Id idParticipante) {
        return [
            SELECT Id, 
                   Medical_Event__r.Id, 
                   Medical_Event__r.Name__c, 
                   Medical_Event__r.End__c, 
                   Medical_Event__r.Location__r.Name 
            FROM Event_Attendee__c 
            WHERE Attendees__c = :idParticipante 
              AND Medical_Event__r.End__c < TODAY
            WITH USER_MODE 
            ORDER BY Medical_Event__r.End__c DESC
        ];
    }
}