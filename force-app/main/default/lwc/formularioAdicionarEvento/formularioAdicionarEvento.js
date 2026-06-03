import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FormularioAdicionarEvento extends NavigationMixin(LightningElement) {
    @track nomeEvento = '';
    @track statusEvento = 'Created';
    @track tipoEvento = 'In-Person';
    @track recorrenteEvento = false;
    @track frequenciaEvento = '';
    @track ativoEvento = false;
    @track idOrganizador = '';
    @track idLocalizacao = '';
    @track dataInicio = '';
    @track dataTermino = '';
    @track maximoAssentos = '';
    @track detalhesEvento = '';

    opcoesStatus = [
        { label: 'Criado', value: 'Created' },
        { label: 'Publicado', value: 'Published' },
        { label: 'Em Andamento', value: 'In Progress' },
        { label: 'Concluído', value: 'Completed' },
        { label: 'Adiado', value: 'Post Poned' },
        { label: 'Cancelado', value: 'Cancelled' }
    ];

    opcoesTipo = [
        { label: 'Presencial (In-Person)', value: 'In-Person' },
        { label: 'Virtual', value: 'Virtual' }
    ];

    opcoesFrequencia = [
        { label: 'Diário', value: 'Daily' },
        { label: 'Semanal', value: 'Weekly' }
    ];

    lidarComNome(event) { this.nomeEvento = event.target.value; }
    lidarComStatus(event) { this.statusEvento = event.target.value; }
    lidarComTipo(event) { this.tipoEvento = event.target.value; }
    lidarComAtivo(event) { this.ativoEvento = event.target.checked; }
    lidarComDataInicio(event) { this.dataInicio = event.target.value; }
    lidarComDataTermino(event) { this.dataTermino = event.target.value; }
    lidarComMaximoAssentos(event) { this.maximoAssentos = event.target.value; }
    lidarComDetalhes(event) { this.detalhesEvento = event.target.value; }
    lidarComFrequencia(event) { this.frequenciaEvento = event.target.value; }

    lidarComRecorrencia(event) { 
        this.recorrenteEvento = event.target.checked; 
        if (!this.recorrenteEvento) {
            this.frequenciaEvento = '';
        }
    }

    lidarComOrganizadorSelecionado(event) { this.idOrganizador = event.detail.id; }
    lidarComOrganizadorRemovido() { this.idOrganizador = ''; }

    lidarComLocalizacaoSelecionada(event) { this.idLocalizacao = event.detail.id; }
    lidarComLocalizacaoRemovida() { this.idLocalizacao = ''; }

    executarSalvamento() {
        const camposBancoDados = {};
        camposBancoDados['Name__c'] = this.nomeEvento;
        camposBancoDados['Status__c'] = this.statusEvento;
        camposBancoDados['Event_Type__c'] = this.tipoEvento;
        camposBancoDados['Recurring__c'] = this.recorrenteEvento;
        camposBancoDados['Frequency__c'] = this.frequenciaEvento;
        camposBancoDados['Live__c'] = this.ativoEvento;
        camposBancoDados['Organizer__c'] = this.idOrganizador;
        camposBancoDados['Location__c'] = this.idLocalizacao;
        camposBancoDados['Start__c'] = this.dataInicio;
        camposBancoDados['End__c'] = this.dataTermino;
        camposBancoDados['Max_Seats__c'] = this.maximoAssentos;
        camposBancoDados['Event_Detail__c'] = this.detalhesEvento;

        const configuracaoPayload = { apiName: 'Medical_Event__c', fields: camposBancoDados };

        createRecord(configuracaoPayload)
            .then((registroCriado) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Sucesso!',
                        message: 'O Evento Médico foi gravado com sucesso no ecossistema MedConnect.',
                        variant: 'success'
                    })
                );

                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: registroCriado.id,
                        objectApiName: 'Medical_Event__c',
                        actionName: 'view'
                    }
                });
            })
            .catch((erroProcessamento) => {
                // Captura erros de validação
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Falha na validação dos dados',
                        message: erroProcessamento.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}