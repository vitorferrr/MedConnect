//Classe teste unitário da classe organizadora de eventoss

@isTest
private class EventSpeakerTriggerHandlerTest {
    
    @testSetup
    static void setupTestData() {
        TestDataFactory.createEvent('Congresso de Cardiologia', true);
        TestDataFactory.createEvent('Workshop de Pediatria', true);
        TestDataFactory.createSpeaker(true);
    }
    // Teste Milestone 3
    @isTest
    static void testPreventDuplicateSpeaker() {
        Medical_Event__c event1 = [SELECT Id FROM Medical_Event__c WHERE Name__c = 'Congresso de Cardiologia' LIMIT 1];
        Medical_Event__c event2 = [SELECT Id FROM Medical_Event__c WHERE Name__c = 'Workshop de Pediatria' LIMIT 1];
        Speaker__c speaker = [SELECT Id FROM Speaker__c LIMIT 1];

        Event_Speaker__c es1 = new Event_Speaker__c(
            Medical_Event__c = event1.Id, 
            Speaker__c = speaker.Id
        );
        insert es1;
        
        Event_Speaker__c es2 = new Event_Speaker__c(
            Medical_Event__c = event2.Id, 
            Speaker__c = speaker.Id
        );
        
        Test.startTest();
        Boolean errorThrown = false;
        try {
            insert es2; 
        } catch (Exception ex) {
            errorThrown = true;
            System.assert(ex.getMessage().contains('Este palestrante já possui um evento ativo agendado'), 'A mensagem de erro foi diferente da esperada.');
        }
        Test.stopTest();

        System.assert(errorThrown, 'O teste falhou: O sistema permitiu agendar o palestrante em dois eventos simultâneos.');
    }

    // Teste Milestone 4
    @isTest
    static void testSendConfirmationEmail() {
        Medical_Event__c event1 = [SELECT Id FROM Medical_Event__c WHERE Name__c = 'Congresso de Cardiologia' LIMIT 1];
        Speaker__c speaker = [SELECT Id FROM Speaker__c LIMIT 1];
        
        Event_Speaker__c es = new Event_Speaker__c(
            Medical_Event__c = event1.Id,
            Speaker__c = speaker.Id
        );

        Test.startTest();
        insert es;
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assertEquals(1, emailInvocations, 'O sistema deveria ter disparado exatamente 1 e-mail de confirmação.');
    }
}