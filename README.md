# heltec4_Smart_Battery_Guard

***AGGIUNTA VERSIONE MIKROBASIC/mikroc CON WATCHDOG E DEEP SLEEP, comsumo 10 volte di meno, essendo per lo piu in stato di deep sleep il pic micro e si sveglia solo ogni 30 secondi (ogni 2.5 secondi solo per fare un check veloce al suo contatore...) per verificare lo stato della batteria.***

all'avvio del pic micro e solo in quel caso, 3 lampeggi veloci del led indicano il normale funzionamento del software all' interno del pic micro stesso, tutto regolare, heltec viene avviato.

una breve spiegazione sulla funzione del tasto:
pressione tra 1 e 5 secondi, accende led e lo lascia acceso fino al rilascio del tasto, salva i dati del valore voltaggio negli offset 0X00 e 0X01, mentre dall'iffset 3 al 7 scrive  su 4 bytes i dati relativi al voltaggio attuale in chiaro, cioe 00002222, tradotto in decimale darà oò voltaggio in millivolt letti al momento,
cosi da poter verificare che siano coerenti con il voltaggio effettivo attualed ella batteria e riavvia heltec, 
Tocca precisare che dopo il rilascio del tasto il led: nn si accende se la carica batteria è ok, fa tre lampeggi veloci se la carica è tra valore_on e valore_off, fa sei lampeggi velici se la carica è sotto il valore_off e nn accende heltec, ma lo lascia spento, visto che la carica è al di sotto del valore minimo!!!

Se premuto per piu di 5 secondi, tiene heltec in spegnimento, cosi potrete fare manutenzione, esempio, cambio antenna senza far soffrire la componentistica della radio in assenza del finale (l'antenna appunto), il led inizia a lampeggiare per 500ms ogni secondo, per idicare l'ingresso nello stato menutentivo, per tornare al funzionamento normale, tenere premuto il tasto per almeno altri 5 secondi almeno, il led fara i 3 lampeggi classsici dell'avvio e si spegne, heltec si riavvia e torna a funzionare in modo regolare.
 
 
Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.3V e lo riattiva se poi risale oltre i 3.7V, 

lo stepup è un modulo che eroga 5V fissi al PIC MICRO, a prescindere dal voltaggio in ingresso, che sia 3V, 2V o che sia 4.3V.

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo stepup porta sempre alimentazione al pic da 5V  (per avere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic/mikroc e schema elettrico (jpeg e pdf)

datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf

12F693 su aliexpress:

https://it.aliexpress.com/item/1005006303166795.html?spm=a2g0o.productlist.main.5.495f191a2PDQ6i&algo_pvid=013a3ce0-3dd7-438d-965c-3a9212c8e3d9&algo_exp_id=013a3ce0-3dd7-438d-965c-3a9212c8e3d9-4&pdp_ext_f=%7B%22order%22%3A%2221%22%2C%22spu_best_type%22%3A%22price%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%215.56%212.72%21%21%2143.24%2121.19%21%402103835e17741799554178201e5bc6%2112000036684741958%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=A6kHPwAkb3Wv&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005006303166795%7C_p_origin_prod%3A

PROGRAMMATORE UNIVERSALE PER PIC MICRO Amazon:

https://www.amazon.it/Fasizi-Programmazione-Automatica-Sviluppare-Microcontroller/dp/B09Z2CTDTT/ref=sr_1_1?__mk_it_IT=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3QKSL4BEFA1YO&dib=eyJ2IjoiMSJ9.ncfiYanZGVHfD30cY9TJVX20GOHlCkoljsRNEqQUaDgEnacLlefaaG5qibXrZ5OpQ0sx-7MXb4tdgXYdp5UAVjJwC3IiFX7PHX69azvp27de1wwzx2yAA3c8k7yU_IzL0kNnNX6BoE3XagAdtfcjT_TOYmDWxgsnWVAq-F5AgGYmRkPf9b6XofKtOH4q1_wW-TLtBVMAwlVgyTAHvNQSdHLkf8PKMqLzE-hu42-xlixdOT4j4_NGce53di1ScNzdu5ERz6MPrao9vEnFwvqC0GKwCNFClN54xpbzd47iR4w.3V76QG7ceCVjaGCpT_dxdQ8orbFK8K5KvA3oz8X1mBI&dib_tag=se&keywords=programmatore+universale+pic+micro&qid=1774180075&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=programmatore+universale+pi+c+micro%2Caps%2C265&sr=8-1

PROGRAMMATORE UNIVERSALE Pic micro aliexpress:

https://it.aliexpress.com/item/1005007040116001.html?spm=a2g0o.productlist.main.16.7cc9E3P8E3P8WF&algo_pvid=cb95b140-ec96-4991-bb90-bb0f4bdae7dd&algo_exp_id=cb95b140-ec96-4991-bb90-bb0f4bdae7dd-15&pdp_ext_f=%7B%22order%22%3A%2246%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%218.71%218.71%21%21%2167.75%2167.75%21%402103856417741801591217437e2a95%2112000039183909561%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=4KNi9xiyAQu4&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005007040116001%7C_p_origin_prod%3A


PER LA SIMULAZIONE scaricare SimulIDE: https://simulide.com/p/downloads/
il file per la simulazione da caricare si chiama: smimulazione.sim1, ovviamente dovrete caricare il file hex compilato, nel PIC, per eseguirlo


lo stepup (come da link per visionare e poi prenderne eventualmente dove volete) consuma circa 4uA, in pratica anni con batteira gia scarica..... 

Col nuovo condice mikroBasic/mikroC, ottimizzato per STEP UP, si ragiona in millivolt, cosi basta cambiare le soglie (3300, 3700 mv) ai %v fissi (5000, se fossero in uscuta 5.1 volt, basta scrivere 5100 anziche 5000) e ricompilare
 
StepUP 5V AMAZON:

https://www.amazon.it/gp/product/B07ZDJPMPJ/ref=ox_sc_act_title_1?smid=AETO64PHCI4NL&psc=1


STEPUP 5V aliexpress:

https://it.aliexpress.com/item/1005009255021446.html?spm=a2g0o.productlist.main.8.1f24qtVhqtVhq5&algo_pvid=5bd1cad7-bcc6-4baf-a986-672726cc3a0c&aem_p4p_detail=202603220452265597336666603120001140618&algo_exp_id=5bd1cad7-bcc6-4baf-a986-672726cc3a0c-7&pdp_ext_f=%7B%22order%22%3A%2231%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%213.07%213.07%21%21%2123.84%2123.84%21%402103917f17741803466073161e10ae%2112000048492400941%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=bmBaLl1n6PPl&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005009255021446%7C_p_origin_prod%3A&search_p4p_id=202603220452265597336666603120001140618_2


video per meglio comprendere le funzioni del tasto
https://github.com/pappicio/heltec4_Smart_Battery_Guard/blob/main/simulazione%20pic%20micro.mp4

