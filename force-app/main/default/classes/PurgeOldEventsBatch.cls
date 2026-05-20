public class PurgeOldEventsBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date doisMesesPassados = Date.today().addMonths(-2);
        
        return Database.getQueryLocator([
            SELECT Id 
            FROM Medical_Event__c 
            WHERE Live__c = false 
            AND End__c < :doisMesesPassados
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Medical_Event__c> scope) {
        MedicalEventBatchHandler.deletarEventosAntigos(scope);
    }

    public void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {'sfdcpanther@gmail.com'});
        mail.setSubject('Execução do Batch Concluída: Exclusão de Eventos Médicos');
        mail.setPlainTextBody('Olá, \n\nO batch Apex para excluir registros antigos de Eventos Médicos foi concluído com sucesso.\n\nAtenciosamente, \nSistema OrganizaMed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}