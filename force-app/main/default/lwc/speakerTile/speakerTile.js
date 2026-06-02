import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NOME_FIELD from '@salesforce/schema/Speaker__c.Name';
import FOTO_FIELD from '@salesforce/schema/Speaker__c.Profile_URL__c';
import BIO_FIELD from '@salesforce/schema/Speaker__c.About_Me_Specialisation__c';

export default class SpeakerTile extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: [NOME_FIELD, FOTO_FIELD, BIO_FIELD] })
    registroPalestrante;

    // Getters de isolamento de dados com tratamento para nulos
    get nomePalestrante() {
        return getFieldValue(this.registroPalestrante.data, NOME_FIELD);
    }

    get fotoUrl() {
        return getFieldValue(this.registroPalestrante.data, FOTO_FIELD);
    }

    get biografia() {
        return getFieldValue(this.registroPalestrante.data, BIO_FIELD) || 
               '<p class="slds-text-color_weak">Nenhum detalhe biográfico cadastrado para este profissional.</p>';
    }
}