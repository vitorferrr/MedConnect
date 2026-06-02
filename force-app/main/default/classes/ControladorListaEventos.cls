public with sharing class ControladorListaEventos {
@AuraEnabled(cacheable=true)
    public static List<Medical_Event__c> obterEventosAtivos(String termoNome, String termoLocalizacao, Date dataBusca) {
        String filtroNome = String.isNotBlank(termoNome) ? '%' + String.escapeSingleQuotes(termoNome) + '%' : null;
        String filtroLoc = String.isNotBlank(termoLocalizacao) ? '%' + String.escapeSingleQuotes(termoLocalizacao) + '%' : null;
        
        String querySoql = 'SELECT Id, Name__c, Start__c, Location__r.Name ' +
                           'FROM Medical_Event__c ' +
                           'WHERE Live__c = true AND Start__c >= TODAY';
        
        if (filtroNome != null) {
            querySoql += ' AND Name__c LIKE :filtroNome';
        }
        if (filtroLoc != null) {
            querySoql += ' AND Location__r.Name LIKE :filtroLoc';
        }
        if (dataBusca != null) {
            querySoql += ' AND DAY_ONLY(Start__c) = :dataBusca';
        }
        
        // Ordena por ordem cronológica dos eventos
        querySoql += ' WITH USER_MODE ORDER BY Start__c ASC';
        
        return Database.query(querySoql);
    }
}