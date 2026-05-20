public class SmartyStreetsService {

    @future(callout=true)
    public static void verificarEnderecos(List<Id> idsLocalizacao) {
        List<Location__c> localizacoesParaAtualizar = new List<Location__c>();
        
        // utiliza o campo 'Name' que armazena a rua
        List<Location__c> listaLocalizacoes = [
            SELECT Id, Name, City__c, State__c, Postal_Code__c, Verified__c 
            FROM Location__c 
            WHERE Id IN :idsLocalizacao
        ];
        
        for (Location__c localizacaoAtual : listaLocalizacoes) {
            try {
                Http clienteHttp = new Http();
                HttpRequest requisicaoHttp = new HttpRequest();
                
                // rua vem do campo localizacaoAtual.Name
                String ruaCodificada = EncodingUtil.urlEncode(localizacaoAtual.Name != null ? localizacaoAtual.Name : '', 'UTF-8');
                String cidadeCodificada = EncodingUtil.urlEncode(localizacaoAtual.City__c != null ? localizacaoAtual.City__c : '', 'UTF-8');
                String estadoCodificado = EncodingUtil.urlEncode(localizacaoAtual.State__c != null ? localizacaoAtual.State__c : '', 'UTF-8');
                String cepCodificado = EncodingUtil.urlEncode(localizacaoAtual.Postal_Code__c != null ? localizacaoAtual.Postal_Code__c : '', 'UTF-8');
                
                // Montagem da URL
                String enderecoUrl = 'https://us-street.api.smartystreets.com/street-address'
                    + '?auth-id=SEU_AUTH_ID_AQUI'
                    + '&auth-token=SEU_AUTH_TOKEN_AQUI'
                    + '&street=' + ruaCodificada
                    + '&city=' + cidadeCodificada
                    + '&state=' + estadoCodificado
                    + '&zipcode=' + cepCodificado;
                    
                requisicaoHttp.setEndpoint(enderecoUrl);
                requisicaoHttp.setMethod('GET');
                requisicaoHttp.setHeader('Content-Type', 'application/json');
                
                HttpResponse respostaHttp = clienteHttp.send(requisicaoHttp);
                
                if (respostaHttp.getStatusCode() == 200) {
                    List<Object> resultadoDadosJson = (List<Object>) JSON.deserializeUntyped(respostaHttp.getBody());
                    
                    if (!resultadoDadosJson.isEmpty()) {
                        localizacaoAtual.Verified__c = true;
                    } else {
                        localizacaoAtual.Verified__c = false;
                    }
                } else {
                    localizacaoAtual.Verified__c = false;
                }
                
                localizacoesParaAtualizar.add(localizacaoAtual);
                
            } catch (Exception erroInesperado) {
                ErrorLogService.createErrorLog(
                    Datetime.now(), 
                    erroInesperado.getStackTraceString(), 
                    'SmartyStreetsService.verificarEnderecos'
                );
            }
        }
        
        if (!localizacoesParaAtualizar.isEmpty()) {
            update localizacoesParaAtualizar;
        }
    }
}