import { LightningElement, api, wire, track } from 'lwc';
import obterEventosFuturos from '@salesforce/apex/ControladorEventosParticipante.obterEventosFuturos';
import obterEventosPassados from '@salesforce/apex/ControladorEventosParticipante.obterEventosPassados';

export default class EventosDoParticipante extends LightningElement {
    @api recordId;

    @track listaFuturos = [];
    @track listaPassados = [];

    // para alimentar a Seção de Eventos Futuros
    @wire(obterEventosFuturos, { idParticipante: '$recordId' })
    processarFuturos({ error, data }) {
        if (data) {
            this.listaFuturos = data.map(vinculo => {
                return {
                    Id: vinculo.Id,
                    linkEvento: `/lightning/r/Medical_Event__c/${vinculo.Medical_Event__r.Id}/view`,
                    nomeEvento: vinculo.Medical_Event__r.Name__c,
                    dataInicio: vinculo.Medical_Event__r.Start__c,
                    localizacao: vinculo.Medical_Event__r.Location__r ? vinculo.Medical_Event__r.Location__r.Name : 'Virtual',
                    badgeClass: 'badge-base badge-future'
                };
            });
        } else if (error) {
            this.listaFuturos = [];
        }
    }

    // para alimentar a Seção de Eventos Passados
    @wire(obterEventosPassados, { idParticipante: '$recordId' })
    processarPassados({ error, data }) {
        if (data) {
            this.listaPassados = data.map(vinculo => {
                return {
                    Id: vinculo.Id,
                    linkEvento: `/lightning/r/Medical_Event__c/${vinculo.Medical_Event__r.Id}/view`,
                    nomeEvento: vinculo.Medical_Event__r.Name__c,
                    dataFim: vinculo.Medical_Event__r.End__c,
                    localizacao: vinculo.Medical_Event__r.Location__r ? vinculo.Medical_Event__r.Location__r.Name : 'Virtual',
                    badgeClass: 'badge-base badge-past'
                };
            });
        } else if (error) {
            this.listaPassados = [];
        }
    }

    get haFuturos() {
        return this.listaFuturos.length > 0;
    }

    get haPassados() {
        return this.listaPassados.length > 0;
    }

    get rotuloFuturos() {
        return `Próximos Eventos (${this.listaFuturos.length})`;
    }

    get rotuloPassados() {
        return `Eventos Passados / Histórico (${this.listaPassados.length})`;
    }
}