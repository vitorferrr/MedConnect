@isTest
private class PurgeOldEventsBatchTest {

    @testSetup
    static void configuracaoDadosTeste() {
        List<Medical_Event__c> eventosParaInserir = new List<Medical_Event__c>();
        
        for (Integer i = 0; i < 200; i++) {
            Medical_Event__c eventoAntigo = new Medical_Event__c();
            eventoAntigo.Name__c = 'Evento Antigo ' + i;
            eventoAntigo.Live__c = false;
            
            eventoAntigo.Start__c = Datetime.now().addMonths(-3);
            eventoAntigo.End__c = Datetime.now().addMonths(-3).addDays(1);
            eventoAntigo.Max_Seats__c = 50;
            
            eventosParaInserir.add(eventoAntigo);
        }
        
        Medical_Event__c eventoRecente = new Medical_Event__c();
        eventoRecente.Name__c = 'Evento Recente Ativo';
        eventoRecente.Live__c = true;
        eventoRecente.Start__c = Datetime.now().addDays(1);
        eventoRecente.End__c = Datetime.now().addDays(2);
        eventoRecente.Max_Seats__c = 100;
        eventosParaInserir.add(eventoRecente);
        
        insert eventosParaInserir;
    }

    @isTest
    static void testeExecucaoBatchExclusao() {
        System.assertEquals(201, [SELECT COUNT() FROM Medical_Event__c], 'A quantia de dados inicial deveria ter 201 registros.');

        Test.startTest();
        // Instancia e executa o lote criado no Milestone 6
        PurgeOldEventsBatch instanciaBatch = new PurgeOldEventsBatch();
        Database.executeBatch(instanciaBatch, 200);
        Test.stopTest(); 

        Integer eventosRestantes = [SELECT COUNT() FROM Medical_Event__c];
        System.assertEquals(1, eventosRestantes, 'Apenas o evento recente e ativo deveria ter restado no banco de dados.');
        
        Medical_Event__c eventoRestante = [SELECT Name__c FROM Medical_Event__c LIMIT 1];
        System.assertEquals('Evento Recente Ativo', eventoRestante.Name__c, 'O evento que restou deve ser o evento recente.');
    }
}