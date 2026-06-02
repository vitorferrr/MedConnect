public with sharing class ControladorDetalhesEvento {
@AuraEnabled(cacheable=true)
    public static List<FiltroPalestrante> obterPalestrantesVinculados(Id idEvento) {
        List<FiltroPalestrante> listaPalestrantes = new List<FiltroPalestrante>();
        
        for (Event_Speaker__c vinculo : [
            SELECT Speaker__r.Id, Speaker__r.Name, Speaker__r.Email__c, Speaker__r.Phone__c, Speaker__r.Specialisation__c 
            FROM Event_Speaker__c 
            WHERE Medical_Event__c = :idEvento
            WITH USER_MODE
        ]) {
            listaPalestrantes.add(new FiltroPalestrante(vinculo.Speaker__r));
        }
        
        return listaPalestrantes;
    }

    @AuraEnabled(cacheable=true)
    public static List<FiltroParticipante> obterParticipantesVinculados(Id idEvento) {
        List<FiltroParticipante> listaParticipantes = new List<FiltroParticipante>();
        
        for (Event_Attendee__c vinculo : [
            SELECT Attendees__r.Id, Attendees__r.Name, Attendees__r.Email__c, Attendees__r.Phone__c, Attendees__r.Company_Instituition_Name__c 
            FROM Event_Attendee__c 
            WHERE Medical_Event__c = :idEvento
            WITH USER_MODE
        ]) {
            listaParticipantes.add(new FiltroParticipante(vinculo.Attendees__r));
        }
        
        return listaParticipantes;
    }

    public class FiltroPalestrante {
        @AuraEnabled public String idReg {get;set;}
        @AuraEnabled public String nome {get;set;}
        @AuraEnabled public String email {get;set;}
        @AuraEnabled public String telefone {get;set;}
        @AuraEnabled public String especializacao {get;set;}

        public FiltroPalestrante(Speaker__c palestrante) {
            this.idReg = palestrante.Id;
            this.nome = palestrante.Name;
            this.email = palestrante.Email__c;
            this.telefone = palestrante.Phone__c;
            this.especializacao = palestrante.Specialisation__c;
        }
    }

    public class FiltroParticipante {
        @AuraEnabled public String idReg {get;set;}
        @AuraEnabled public String nome {get;set;}
        @AuraEnabled public String email {get;set;}
        @AuraEnabled public String telefone {get;set;}
        @AuraEnabled public String instituicao {get;set;}

        public FiltroParticipante(Attendees__c participante) {
            this.idReg = participante.Id;
            this.nome = participante.Name;
            this.email = participante.Email__c;
            this.telefone = participante.Phone__c;
            this.instituicao = participante.Company_Instituition_Name__c;
        }
    }
}