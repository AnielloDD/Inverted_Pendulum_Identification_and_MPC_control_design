# Identificazione e Controllo MPC del Pendolo Inverso su Carrello

## Descrizione del Progetto

Questo progetto riguarda l'identificazione di un sistema dinamico utilizzando i modelli ARX e ARMAX, seguita dalla progettazione di un controllo MPC (Model Predictive Control) per stabilizzare un pendolo inverso montato su un carrello.
Il controllo MPC è stato implementato con il toolbox "MPC Designer" e successivamente implementato manualmente.


##  La spiegazione del progetto è riportata nel file "presentation.pdf"

La presentazione allegata illustra:

- **Modellizzazione ARX e ARMAX**: Identificazione del sistema a partire dai dati sperimentali.
- **Analisi delle Prestazioni**: Confronto tra modelli identificati.
- **Progetto del Controllore MPC**: Sviluppo di un controllore predittivo per la regolazione del pendolo inverso.
- **Simulazioni e Risultati**: Verifica delle prestazioni del controllo attraverso simulazioni.

## Tecnologie e Strumenti Utilizzati

- **Matlab/Simulink**: Per l'identificazione del modello e la progettazione del controllo.
- **Metodi ARX e ARMAX**: Per la stima del modello del sistema.
- **MPC Toolbox**: Per la progettazione e simulazione del controllore MPC.

## Obiettivi del Progetto

- Dimostrare la capacità dei modelli ARX e ARMAX di rappresentare accuratamente la dinamica del pendolo inverso.
- Progettare un controllo MPC che garantisca la stabilizzazione del sistema con prestazioni ottimali.


## Autori e Contatti

- Email: aniello.didonato2@studenti.unicampania.it
- LinkedIn: Aniello Di Donato
  
## Istruzioni per l'Uso
1. Il file "system_configuration.m" serve per inizializzare il sistema.
3. Il file "closed_loop.slx" contiene il sistema stabilizzato tramite LQG per effettuare l'identificazione intorno al punto di equilibrio
4. Il file "sys_identified.m" contiene i modelli polinomiali che identificano il sistema.
5. I file Simulink "MPC_implemented_constrained.slx" e "MPC_implemented_wout_constr.slx" contengono il sistema con MPC progettato manualmente.
6. Il file "MPC_controller.m" contiene il controllo MPC progettato con il toolbox MPC Designer

