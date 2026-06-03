@RestResource(urlMapping='/EventosMedicos/*')
global with sharing class ServicoRestEventosMedicos {

    @HttpGet
    global static List<FormatoEventoSaida> obterEventosFuturosRest() {
        List<FormatoEventoSaida> listaResultado = new List<FormatoEventoSaida>();

        List<Medical_Event__c> eventos = [
            SELECT Id, Name__c, Status__c, Start__c, End__c, Max_Seats__c, Remaining_Seats__c, Event_Detail__c, Location__r.Name
            FROM Medical_Event__c
            WHERE Live__c = true 
              AND Start__c > TODAY
            WITH USER_MODE
            ORDER BY Start__c ASC
        ];

        for (Medical_Event__c ev : eventos) {
            listaResultado.add(new FormatoEventoSaida(ev));
        }

        return listaResultado;
    }
    global class FormatoEventoSaida {
        global String idEvento {get;set;}
        global String nome {get;set;}
        global String status {get;set;}
        global DateTime dataInicio {get;set;}
        global DateTime dataFim {get;set;}
        global Decimal vagasMaximas {get;set;}
        global Decimal vagasRestantes {get;set;}
        global String detalhes {get;set;}
        global String localizacao {get;set;}

        global FormatoEventoSaida(Medical_Event__c ev) {
            this.idEvento = ev.Id;
            this.nome = ev.Name__c;
            this.status = ev.Status__c;
            this.dataInicio = ev.Start__c;
            this.dataFim = ev.End__c;
            this.vagasMaximas = ev.Max_Seats__c;
            this.vagasRestantes = ev.Remaining_Seats__c;
            this.detalhes = ev.Event_Detail__c;
            this.localizacao = ev.Location__r != null ? ev.Location__r.Name : 'Evento Virtual / Não Informado';
        }
    }
}