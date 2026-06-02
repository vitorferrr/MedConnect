import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import obterPalestrantesVinculados from '@salesforce/apex/ControladorDetalhesEvento.obterPalestrantesVinculados';
import obterParticipantesVinculados from '@salesforce/apex/ControladorDetalhesEvento.obterParticipantesVinculados';

// Importação do campo de relacionamento para capturar o ID da localização vinculada
import LOCALIZACAO_FIELD from '@salesforce/schema/Medical_Event__c.Location__c';

export default class DetalhesCompletosEvento extends LightningElement {
    @api recordId; // Captura automaticamente o ID do evento atual na página
    @api objectApiName;

    @track dadosPalestrantes = [];
    @track dadosParticipantes = [];
    idLocalizacao;

    colunasPalestrantes = [
        { label: 'Nome do Palestrante', fieldName: 'nome', type: 'text' },
        { label: 'E-mail de Contato', fieldName: 'email', type: 'email' },
        { label: 'Telefone', fieldName: 'telefone', type: 'phone' },
        { label: 'Especialidade Clínica', fieldName: 'especializacao', type: 'text' }
    ];

    colunasParticipantes = [
        { label: 'Nome do Participante', fieldName: 'nome', type: 'text' },
        { label: 'E-mail', fieldName: 'email', type: 'email' },
        { label: 'Telefone', fieldName: 'telefone', type: 'phone' },
        { label: 'Empresa / Instituição', fieldName: 'instituicao', type: 'text' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: [LOCALIZACAO_FIELD] })
    processarDadosEvento({ error, data }) {
        if (data) {
            this.idLocalizacao = getFieldValue(data, LOCALIZACAO_FIELD);
        } else if (error) {
            this.idLocalizacao = null;
        }
    }

    @wire(obterPalestrantesVinculados, { idEvent: '$recordId' })
    carregarPalestrantes({ error, data }) {
        if (data) {
            this.dadosPalestrantes = data;
        } else if (error) {
            this.dadosPalestrantes = [];
        }
    }

    @wire(obterParticipantesVinculados, { idEvent: '$recordId' })
    carregarParticipantes({ error, data }) {
        if (data) {
            this.dadosParticipantes = data;
        } else if (error) {
            this.dadosParticipantes = [];
        }
    }

    get haPalestrantes() {
        return this.dadosPalestrantes && this.dadosPalestrantes.length > 0;
    }

    get haParticipantes() {
        return this.dadosParticipantes && this.dadosParticipantes.length > 0;
    }
}