@isTest
private class EventSpeakerTriggerHandlerTest {
    
    //Teste do Milestone 3
    @isTest
    static void testPreventDuplicateSpeaker() {
        Medical_Event__c event1 = TestDataFactory.createEvent('Congresso de Cardiologia', true);
        Medical_Event__c event2 = TestDataFactory.createEvent('Workshop de Pediatria', true);
        
        Speaker__c speaker = TestDataFactory.createSpeaker(true);
        
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

    //Teste do Milestone 4
    @isTest
    static void testSendConfirmationEmail() {
        Medical_Event__c event = TestDataFactory.createEvent('Simpósio de Inovação Médica', true);
        Speaker__c speaker = TestDataFactory.createSpeaker(true);
        
        Event_Speaker__c es = new Event_Speaker__c(
            Medical_Event__c = event.Id,
            Speaker__c = speaker.Id
        );

        Test.startTest();
        insert es;
        
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assertEquals(1, emailInvocations, 'O sistema deveria ter disparado exatamente 1 e-mail de confirmação.');
    }
}