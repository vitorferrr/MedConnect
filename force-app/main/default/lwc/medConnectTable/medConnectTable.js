import { LightningElement, track, wire, api } from 'lwc';
import getRecords from '@salesforce/apex/GenericTableController.getRecords';

export default class MedConnectTable extends LightningElement {
    @api tituloTabela;
    @api nomeObjetoAPI;

    @track allRecords = [];
    @track filteredRecords = [];
    @track currentTab = 'todos';
    @track searchName = '';

    @wire(getRecords, { objectName: '$nomeObjetoAPI' })
    wiredData({ error, data }) {
        if (data) {
            this.allRecords = data;
            this.filterData();
        } else if (error) {
            console.error('Erro ao buscar dados no MedConnect:', error);
        }
    }

    get isEvento() { return this.nomeObjetoAPI === 'Medical_Event__c'; }
    get isOrganizador() { return this.nomeObjetoAPI === 'Clinic_Organizer__c'; }
    get isPalestrante() { return this.nomeObjetoAPI === 'Speaker__c'; }
    get isParticipante() { return this.nomeObjetoAPI === 'Attendees__c'; }
    get isLocalizacao() { return this.nomeObjetoAPI === 'Location__c'; }

    get todosClass() { return this.currentTab === 'todos' ? 'active' : ''; }
    get meusClass() { return this.currentTab === 'meus' ? 'active' : ''; }

    handleSearchName(event) {
        this.searchName = event.target.value;
        this.filterData();
    }

    handleTabTodos() { this.currentTab = 'todos'; this.filterData(); }
    handleTabMeus() { this.currentTab = 'meus'; this.filterData(); }

    filterData() {
        this.filteredRecords = this.allRecords.filter(rec => {
            const targetName = this.isEvento ? rec.Name__c : rec.Name;
            const matchesName = targetName ? targetName.toLowerCase().includes(this.searchName.toLowerCase()) : true;
            return matchesName;
        });
    }
}