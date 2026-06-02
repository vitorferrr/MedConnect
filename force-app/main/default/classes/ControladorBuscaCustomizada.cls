public with sharing class ControladorBuscaCustomizada {
    
    /**
     * @description Executa uma busca SOSL baseada no termo digitado pelo usuário.
     * @param termoBusca Texto digitado no input do componente.
     * @param nomeObjeto Nome da API do objeto onde a busca será feita.
     * @return Lista de sObjects contendo o Id e o Name dos registros localizados.
     */

    @AuraEnabled(cacheable=true)
    public static List<sObject> buscarRegistros(String termoBusca, String nomeObjeto) {
        List<sObject> listaResultados = new List<sObject>();
        
        // pra evitar buscas vazias / buscas muito curtas
        if (String.isBlank(termoBusca) || termoBusca.length() < 2) {
            return listaResultados;
        }
        
        // Limpa o termo e adiciona * para busca parcial
        String termoLimpo = String.escapeSingleQuotes(termoBusca) + '*';
        
        // Monta a query SOSL dinâmica para retornar os campos básicos de identificação
        String querySosl = 'FIND \'' + termoLimpo + '\' IN ALL FIELDS RETURNING ' + nomeObjeto + '(Id, Name)';
        
        List<List<sObject>> resultadoPesquisa = Search.query(querySosl);
        
        if (!resultadoPesquisa.isEmpty()) {
            listaResultados = resultadoPesquisa[0];
        }
        
        return listaResultados;
    }
}