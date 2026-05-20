public class LocationTriggerHandler {

    public static void aposInserir(List<Location__c> novasLocalizacoes) {
        List<Id> idsParaProcessar = new List<Id>();
        
        for (Location__c localizacao : novasLocalizacoes) {
            if (localizacao.Name != null || localizacao.City__c != null || localizacao.State__c != null || localizacao.Postal_Code__c != null) {
                idsParaProcessar.add(localizacao.Id);
            }
        }
        
        if (!idsParaProcessar.isEmpty()) {
            SmartyStreetsService.verificarEnderecos(idsParaProcessar);
        }
    }

    public static void aposAtualizar(List<Location__c> novasLocalizacoes, Map<Id, Location__c> mapaAntigoLocalizacoes) {
        List<Id> idsParaProcessar = new List<Id>();
        
        for (Location__c localizacaoNova : novasLocalizacoes) {
            Location__c localizacaoAntiga = mapaAntigoLocalizacoes.get(localizacaoNova.Id);
            
            // Monitoriza alterações, comparando o campo 'Name' (Street)
            if (localizacaoNova.Name != localizacaoAntiga.Name || 
                localizacaoNova.City__c != localizacaoAntiga.City__c || 
                localizacaoNova.State__c != localizacaoAntiga.State__c || 
                localizacaoNova.Postal_Code__c != localizacaoAntiga.Postal_Code__c) {
                
                idsParaProcessar.add(localizacaoNova.Id);
            }
        }
        
        if (!idsParaProcessar.isEmpty()) {
            SmartyStreetsService.verificarEnderecos(idsParaProcessar);
        }
    }
}