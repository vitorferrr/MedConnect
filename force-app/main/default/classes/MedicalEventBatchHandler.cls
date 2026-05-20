public class MedicalEventBatchHandler {
    
    //Método receber registros de lote e vai deletar os eventos após 2 meses de ocorridos
    public static void deleteOldEvents(List<Medical_Event__c> eventsToDelete) {
        if (eventsToDelete != null && !eventsToDelete.isEmpty()) {
            delete eventsToDelete;
        }
    }
}