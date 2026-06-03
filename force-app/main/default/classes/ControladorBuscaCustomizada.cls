public with sharing class ControladorBuscaCustomizada {
    

    @AuraEnabled(cacheable=true)
    public static List<sObject> buscarRegistros(String termoBusca, String nomeObjeto) {
        List<sObject> listaResultados = new List<sObject>();
        
        if (String.isBlank(termoBusca) || termoBusca.length() < 2) {
            return listaResultados;
        }
        
        String termoLimpo = String.escapeSingleQuotes(termoBusca) + '*';
        
        String querySosl = 'FIND \'' + termoLimpo + '\' IN ALL FIELDS RETURNING ' + nomeObjeto + '(Id, Name)';
        
        List<List<sObject>> resultadoPesquisa = Search.query(querySosl);
        
        if (!resultadoPesquisa.isEmpty()) {
            listaResultados = resultadoPesquisa[0];
        }
        
        return listaResultados;
    }
}