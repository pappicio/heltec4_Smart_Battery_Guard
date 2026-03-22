# heltec4_Smart_Battery_Guard

***AGGIUNTA VERSIONE MIKROBASIC/mikroc CON WATCHDOG E DEEP SLEEP, comsumo 10 v0lte di meno, essendo per lo piu in stato di deel sleep il pic micro e si sveflia solo ogni 30 secondi per verificare lo stato della batteria.***

all'avvio del pic micro e solo in quel caso, 3 lampeggi veloci del led indicano il normale funzionamento del software all' interno del pic micro stesso, tutto regolare, heltec viene avviato.

una breve spiegazione sulla funzione del tasto:
pressione tra 1 e 5 secondi, accende led e lo lascia cceso fino al rilascio del tasto, salva i dati del valore voltaggio negli offset 0X00 e 0X01, mentre dall'iffset 3 al 7 scrive  su 4 bytes i dati relativi al voltaggio attuale in chiaro, cioe 00002222, tradotto in decimale darà oò voltaggio in millivolt letti al momento,
cosi da poter verificare che siano coerenti con il voltaggio effettivo attualed ella batteria e riavvia heltec, 
Se premuto per piu di 5 secondi, tiene heltec in spegnimento, cosi potrete fare manutenzione, esempio, cambio antenna senzxa far soffrire la componentistica della radio in assenza del finale (l'antenna appunto), il led inizia a lampeggiare per 500ms ogni secondo, per idicare l'ingresso nello stato menutentivo, per tornare al funzionamento normale, tenere premuto il tasto per altri 5 secondi almeno, il led fara i 3 lampeggi classsici dell'avvio e si spegne, heltec si riavvia e torna a funzionare in modo regolare.
 
 
Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.3V e lo riattiva se poi risale oltre i 3.7V, 

lo stepup è un modulo che eroga 5V fissi al PIC MICRO, a prescindere dal voltaggio in ingresso, che sia 3V, che sia 4.3V.

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo step up porta sempre alimentazione al pic da 5V  (per avere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic/mikroc e schema elettrico (jpeg e pdf)

datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf

PER LA SIMULAZIONE scaricare SimulIDE: https://simulide.com/p/downloads/
il file per la simulazione da caricare si chiama: smimulazione.sim1, ovviamente dovrete caricare il file hex compilato, nel PIC, per eseguirlo


lo step up (come da link per visionare e poi prenderne eventualmente dove volete) consuma circa 4uA, in pratica anni con batteira gia scarica..... 

Col nuovo condice mikroBasic/mikroC, ottimizzato per STEP UP, si ragiona in millivolt, cosi basta cambiare le soglie (3300, 3700 mv) ai %v fissi (5000, se fossero in uscuta 5.1 volt, basta scrivere 5100 anziche 5000) e ricompilare

StepUP AMAZON 5V:

https://www.amazon.it/gp/product/B07ZDJPMPJ/ref=ox_sc_act_title_1?smid=AETO64PHCI4NL&psc=1

video per meglio comprendere le funzioni del tasto
https://github.com/pappicio/heltec4_Smart_Battery_Guard/blob/main/simulazione%20pic%20micro.mp4

