# lora (meshtastic) modules Smart_Battery_Guard
Documentazione Tecnica: Solar Power Manager (PIC12F683)
1. Gestione RTC (Real Time Clock) - Modello DS3231
Il sistema utilizza il modulo DS3231, un orologio in tempo reale estremamente preciso grazie al suo oscillatore con compensazione termica. Consente di programmare cicli di riavvio del modulo LoRa o di definire fasce orarie di accensione/spegnimento per il risparmio energetico.

Programmazione orario: Da codice, impostare Giorno della settimana (1=Lunedì... 7=Domenica), Giorno, Mese, Anno, Ore e Minuti.

Procedura di sincronizzazione: Se desiderate impostare, ad esempio, le ore 12:00 precise, caricate il codice e, allo scoccare delle 12:00, alimentate il circuito tenendo premuto il pulsante per almeno 1,5 secondi.

Conferma: 10 lampeggi veloci del LED confermeranno l'avvenuta scrittura nell'RTC. Grazie alla batteria tampone integrata, il modulo manterrà l'orario per circa 10 anni con uno scarto minimo di pochi secondi l'anno.

2. Visualizzazione Diagnostica (Volt e Ora)
Durante il normale funzionamento, è possibile interrogare il sistema:

Pressione tra 2,5 e 5 secondi: Al rilascio del tasto (il LED si spegne per indicare il superamento della soglia temporale), il sistema comunica i dati tramite lampeggi.

Lettura Millivolt: Se la batteria misura 3860mV, il LED eseguirà:

3 lampeggi (migliaia) -> pausa;

8 lampeggi (centinaia) -> pausa;

6 lampeggi (decine) -> pausa;

1 lampeggio brevissimo (indica lo 0 per le unità).

Lettura Ora (dopo i Volt): Dopo una breve pausa e 2 lampeggi rapidi di separazione, il LED indicherà l'ora corrente (es. 12:32) con la stessa logica (1 lampo, pausa, 2 lampi per le ore 12; pausa lunga; 3 lampi, pausa, 2 lampi per i minuti 32).

3. Reset Programmato e Smart Battery Guard
Reset Ciclico: Di default, ogni 3 giorni l'alimentazione viene interrotta per 10 secondi per garantire la stabilità del modulo LoRa. Questa funzione è personalizzabile da 1 a X giorni (impostando 0 si disabilita).

Smart Battery Guard: Protegge la batteria spegnendo il dispositivo se la tensione scende sotto i 3,3V e riattivandolo solo quando risale sopra i 3,7V (isteresi di sicurezza).

Stato all'avvio: 3 lampeggi rapidi indicano il corretto avvio del firmware. Seguiti da:

Nessun lampeggio: Batteria carica.

3 lampeggi veloci: Batteria in "zona gialla" (tra soglia OFF e soglia ON).

6 lampeggi veloci: Batteria scarica (il modulo Heltec resta spento).

4. Funzioni del Pulsante
Reset Rapido (1-5 sec): Accende il LED fisso fino al rilascio. Salva i dati della tensione negli offset EEPROM (0x00, 0x01 e in chiaro dai 0x03 al 0x07 per verifica) e riavvia il modulo Heltec.

Modalità Manutenzione (>5 sec): Utile per operazioni tecniche (es. cambio antenna). Il sistema spegne il carico e il LED lampeggia ogni secondo (500ms ON / 500ms OFF). Per uscire, tenere premuto nuovamente per oltre 5 secondi; il sistema eseguirà i lampeggi di avvio e tornerà operativo.

5. Hardware e Alimentazione
Step-Up 5V: Il circuito utilizza un modulo step-up che eroga 5V costanti al PIC12F683 indipendentemente dalla tensione della batteria (anche se scende a 2V o sale a 4,3V). Questo è fondamentale per mantenere stabile il riferimento del comparatore ADC e garantire letture precise della batteria.

Componenti: PIC12F683, modulo RTC DS3231, step-up 5V, mosfet P-Channel per il distacco carico e componentistica passiva comune.

Nota sul Modello RTC
Il modello consigliato è il DS3231 (spesso venduto come modulo "ZS-042" o "DS3231SN"). È preferibile al vecchio DS1307 perché:

Integra un cristallo di quarzo interno (meno sensibile all'umidità e ai disturbi).

Possiede un sensore di temperatura interno per correggere la frequenza del clock, evitando che l'orologio "corra" o "ritardi" al cambiare delle stagioni.
 
Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.3V e lo riattiva se poi risale oltre i 3.7V, 

lo stepup è un modulo che eroga 5V fissi al PIC MICRO, a prescindere dal voltaggio in ingresso, che sia 3V, 2V o che sia 4.3V.

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo stepup porta sempre alimentazione al pic da 5V  (per avere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic/mikroc e schema elettrico (jpeg e pdf)

datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf

12F683 su aliexpress:

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

Per la versione con MOSFET AO3401, ecco un link aliexpress dove comprarne

https://it.aliexpress.com/item/1005004617543846.html?spm=a2g0o.productlist.main.1.6c116d4fBYnexV&algo_pvid=19b502e1-456e-40da-8695-24b0417dce6d&algo_exp_id=19b502e1-456e-40da-8695-24b0417dce6d-0&pdp_ext_f=%7B%22order%22%3A%2297%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%211.90%211.90%21%21%2114.79%2114.79%21%402103919917745377270103884efef4%2112000029849827853%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=d0vViNrEpmAL&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005004617543846%7C_p_origin_prod%3A

ADATTATORE mosfet SMD (SOT23-3) per millefori (SIP3)

https://it.aliexpress.com/item/1005006626188055.html?spm=a2g0o.productlist.main.10.1f94Te9qTe9qfL&algo_pvid=a7fdd15a-6daa-4bc9-b32e-30f053d9a163&algo_exp_id=a7fdd15a-6daa-4bc9-b32e-30f053d9a163-9&pdp_ext_f=%7B%22order%22%3A%221297%22%2C%22spu_best_type%22%3A%22price%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%211.93%211.93%21%21%212.18%212.18%21%40211b819117747092144196460e3172%2112000037858523309%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=uQJpqORxMooQ&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005006626188055%7C_p_origin_prod%3A
