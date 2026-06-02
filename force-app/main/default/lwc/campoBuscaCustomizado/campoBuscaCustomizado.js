import { LightningElement, api, track, wire } from 'lwc';
import buscarRegistros from '@salesforce/apex/ControladorBuscaCustomizada.buscarRegistros';

export default class CampoBuscaCustomizado extends LightningElement {
    @api etiqueta = 'Pesquisar';
    @api nomeObjeto = 'Location__c';
    @api textoSubstituto = 'Digite para pesquisar...';

    @track termoBusca = '';
    @track opcoesEncontradas = [];
    @track registroSelecionado = false;
    @track nomeSelecionado = '';
    @track idSelecionado = '';

    @wire(buscarRegistros, { termoBusca: '$termoBusca', nomeObjeto: '$nomeObjeto' })
    carregarRegistros({ error, data }) {
        if (data) {
            this.opcoesEncontradas = data;
        } else if (error) {
            this.opcoesEncontradas = [];
        }
    }

    get exibirResultados() {
        return this.opcoesEncontradas.length > 0 && !this.registroSelecionado;
    }

    lidarComMudancaInput(event) {
        this.termoBusca = event.target.value;
    }

    selecionarOpcao(event) {
        this.idSelecionado = event.currentTarget.dataset.id;
        this.nomeSelecionado = event.currentTarget.dataset.name;
        this.registroSelecionado = true;

        const eventoSelecao = new CustomEvent('registroselecionado', {
            detail: { id: this.idSelecionado }
        });
        this.dispatchEvent(eventoSelecao);
    }

    removerSelecao() {
        this.registroSelecionado = false;
        this.termoBusca = '';
        this.nomeSelecionado = '';
        this.idSelecionado = '';
        this.opcoesEncontradas = [];

        const eventoRemocao = new CustomEvent('registroremovido');
        this.dispatchEvent(eventoRemocao);
    }
}