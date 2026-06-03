public inherited sharing class EventSpeakerTriggerHandler {
    
    //Verifica se o palestrante já está inserido em outro evento
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

    //Milestone 4: envia o email de confirmação
    public static void sendConfirmationEmail(List<Event_Speaker__c> newList) {
        try {
            Set<Id> esIds = new Set<Id>();
            
            for (Event_Speaker__c es : newList) {
                if (es.Id != null) {
                    esIds.add(es.Id);
                }
            }

            if (esIds.isEmpty()) return;

            List<Event_Speaker__c> recordsWithData = [
                SELECT Id, Speaker__r.Name, Speaker__r.Email__c, Medical_Event__r.Name__c, Medical_Event__r.Start__c
                FROM Event_Speaker__c
                WHERE Id IN :esIds
            ];

            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

            for (Event_Speaker__c es : recordsWithData) {
                if (es.Speaker__r.Email__c != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    mail.setToAddresses(new String[] { es.Speaker__r.Email__c });
                    mail.setSubject('Confirmação de Palestra: ' + es.Medical_Event__r.Name__c);
                    
                    String body = 'Olá ' + es.Speaker__r.Name + ',\n\n' +
                                  'Sua participação no evento "' + es.Medical_Event__r.Name__c + '" foi confirmada!\n' +
                                  'Data de Início: ' + es.Medical_Event__r.Start__c + '\n\n' +
                                  'Obrigado,\nEquipe OrganizaMed';
                                  
                    mail.setPlainTextBody(body);
                    emailsToSend.add(mail);
                }
            }

            if (!emailsToSend.isEmpty()) {
                Messaging.sendEmail(emailsToSend);
            }

        } catch (Exception ex) {
            ErrorLogService.createErrorLog(Datetime.now(), ex.getStackTraceString(), 'EventSpeakerTriggerHandler.sendConfirmationEmail');
        }
    }
}