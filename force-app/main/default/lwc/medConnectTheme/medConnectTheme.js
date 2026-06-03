import { LightningElement, api, track } from 'lwc';

export default class MedConnectTheme extends LightningElement {
    @api recordId;
    @api tituloCard = 'Painel de Eventos';
    @api textoBadge = 'Ativo';
    @api mostrarCabecalho = false;
    @api mostrarBadge = false;

    @track termoBusca = '';
    @track contadorEventos    = 0;
    @track contadorMedicos    = 0;
    @track contadorPalestrantes = 0;

   
    _metaEventos       = 248;
    _metaMedicos       = 1340;
    _metaPalestrantes  = 92;

    connectedCallback() {
        this._animarContadores();
    }

    handleBusca(evento) {
        this.termoBusca = evento.target.value;
    }

    handleBuscaKeydown(evento) {
        if (evento.key === 'Enter') {
            this.executarBusca();
        }
    }

    executarBusca() {
        const termo = this.termoBusca.trim();
        if (!termo) return;

        this.dispatchEvent(new CustomEvent('medicobusca', {
            detail: { termo },
            bubbles: true,
            composed: true
        }));
    }

    handleTagClick(evento) {
        const termo = evento.currentTarget.dataset.termo;
        this.termoBusca = termo;
        this.executarBusca();
    }


    _animarContadores() {
        const DURACAO_MS = 1800; // Duração total da animação
        const inicio = performance.now();

        const easeOut = (t) => 1 - Math.pow(1 - t, 3);

        const animar = (agora) => {
            const progresso = easeOut(
                Math.min((agora - inicio) / DURACAO_MS, 1)
            );

            this.contadorEventos       = Math.round(this._metaEventos       * progresso);
            this.contadorMedicos       = Math.round(this._metaMedicos       * progresso);
            this.contadorPalestrantes  = Math.round(this._metaPalestrantes  * progresso);

            if (progresso < 1) {
                requestAnimationFrame(animar);
            }
        };

        requestAnimationFrame(animar);
    }
}
