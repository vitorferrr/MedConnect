import { LightningElement, track, wire } from 'lwc';
import obterEventosAtivos from '@salesforce/apex/ControladorListaEventos.obterEventosAtivos';

export default class ListaEventosMedicos extends LightningElement {
    @track termoNome = '';
    @track termoLocalizacao = '';
    @track dataBusca = '';
    @track dadosProcessados = [];

    colunas = [
        { 
            label: 'Nome do Evento', 
            fieldName: 'urlLink',
            type: 'url', 
            typeAttributes: { 
                label: { fieldName: 'Name__c' },
                target: '_self'
            } 
        },
        { 
            label: 'Data/Hora de Início', 
            fieldName: 'Start__c', 
            type: 'date', 
            typeAttributes: { 
                day: 'numeric', 
                month: 'long', 
                year: 'numeric', 
                hour: '2-digit', 
                minute: '2-digit' 
            } 
        },
        { 
            label: 'Localização / Unidade', 
            fieldName: 'nomeLocalizacao', 
            type: 'text' 
        }
    ];

    @wire(obterEventosAtivos, { termoNome: '$termoNome', termoLocalizacao: '$termoLocalizacao', dataBusca: '$dataBusca' })
    processarRegistros({ error, data }) {
        if (data) {
            this.dadosProcessados = data.map(registro => {
                return {
                    ...registro,
                    urlLink: `/lightning/r/Medical_Event__c/${registro.Id}/view`, // Link padrão de redirecionamento
                    nomeLocalizacao: registro.Location__r ? registro.Location__r.Name : 'Evento Virtual / Não Informado'
                };
            });
        } else if (error) {
            this.dadosProcessados = [];
        }
    }

    // Captura em tempo real das alterações feitas pelo usuário na barra de buscas
    lidarComBuscaNome(event) {
        this.termoNome = event.target.value;
    }

    lidarComBuscaLocalizacao(event) {
        this.termoLocalizacao = event.target.value;
    }

    lidarComBuscaData(event) {
        this.dataBusca = event.target.value;
    }

    // Validador de exibição
    get haEventos() {
        return this.dadosProcessados && this.dadosProcessados.length > 0;
    }
}