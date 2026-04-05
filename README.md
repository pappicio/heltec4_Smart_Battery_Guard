# ☀️ ***Solar Power Manager - PIC12F683 & DS3231***

***Sistema intelligente di gestione energetica per nodi LoRa/Meshtastic (Heltec v3) con controllo carica batteria, reset programmato e sincronizzazione RTC manuale.***
---

IMPORTANTE: VERSIONE PILOTAGGIO ALIMENTAZIONE:
***IMPORTANTE: se si usa un heltec v4, nn sarò possibile usare lo sppnotto dedicato al pannello solare, ma un modulo esterno tipo: TP4056 altrimenti a heltec spento da mosfet, la batteria nn potra dicevere la ricarica avendo la corrente interrotta da heltec a batteria!!!!! Quindi: pannello, modulo ricarica a batteria, da batteria poi a modulo power saver e infine da modulo power saver a modulo lora, fine!***

---

progetto con RTC e sezna RTC, PILOTAGGIO (modulo lora) da: ALIMENTAZIONE/Pin RST, stesso codice sorgente, basta impostare la variabile rtc_presente a 1 (se lo montate) o  a 0 e compilare con mikrobasic versione demo che supporta la compilazione completa per questo progetto (piccolo!) per le versioni ALIMENTAZIONE/RST, basta impostare la variabile RSTPin a 0 (alimentazione) o a 1 (Pilotaggio heltec a mezzo pin RST).
---

### 🕒 **1. ***Gestione RTC (Real Time Clock) - Modello DS3231*****
Il sistema utilizza il modulo ***DS3231***, un orologio ad alta precisione con compensazione termica. Consente di definire cicli di riavvio o fasce orarie di funzionamento.

* ***Sincronizzazione Manuale:*** Per impostare l'orario (es. le 12:00), caricare il codice e, allo scoccare dell'ora esatta, alimentare il circuito tenendo premuto il pulsante all'avvio per almeno ***1,5 secondi***.
* ***Feedback di conferma:*** Il LED eseguirà ***10 lampeggi veloci*** per confermare l'avvenuta scrittura nell'orologio.
* ***Durata:*** Grazie alla batteria tampone, l'orario rimarrà in memoria per circa ***10 anni*** con uno scarto di pochi secondi annui.

---

### 📊 **2. ***Visualizzazione Diagnostica (Volt e Ora)*** [Pressione 2.5s - 5s]**
Interroga lo stato del sistema tramite una pressione prolungata. Al rilascio del tasto (dopo che il LED si è spento), inizierà la sequenza:

1.  ***Lettura Millivolt:*** Se la batteria è a 3860mV, il LED farà:
    * *3 lampi (migliaia)* -> pausa -> *8 lampi (centinaia)* -> pausa -> *6 lampi (decine)* -> pausa -> ***1 lampo brevissimo*** (indica lo **0**).
2.  ***Separazione:*** Pausa seguita da ***3 lampeggi veloci***.
3.  ***Lettura Ora RTC:*** Il LED indicherà l'ora corrente (es. 12:32):
    * *1 lampo, pausa, 2 lampi (ore 12)* -> pausa lunga -> *3 lampi, pausa, 2 lampi (minuti 32)*.

---

### 🔄 **3. ***Reset Programmato e Smart Battery Guard*****
* ***Reset Ciclico:*** Di default, ogni ***3 giorni*** (senza RTC, ***con RTC, programmazione timer ON/OFF oraria e girnsaliera, o a giorni prestabiliti***, da codice, come meglio rpeferite), l'alimentazione viene interrotta per 10 secondi per garantire la stabilità del modulo LoRa (personalizzabile da 1 a X giorni; 0 disabilita).
* ***Smart Battery Guard:*** Protezione totale della batteria. Spegne il carico sotto i ***3,3V*** e lo riattiva solo sopra i ***3,7V*** (isteresi di sicurezza).
* ***Stato all'Avvio:*** Il sistema esegue ***3 lampeggi iniziali***; se la batteria in zona gialla (tra i 3.3 e i 3.7 V) eseguira dopo una breve pausa, ***3 lampeggi veloci***: Se la batteria è scarica (<3.3V), seguiranno invece ***6 lampeggi veloci*** e il modulo Heltec rimarrà spento. 
Se invece la batteria è carica, nn ci saranno feedback visivi dal led ma solo i ***3 lampeggi iniziali***.

---

### 🔘 **4. ***Funzioni del Pulsante di Controllo*****
* ***Reset Rapido (1.0 - 2.5 sec):*** Il LED rimane acceso fisso fino al rilascio. Esegue il riavvio forzato del modulo Heltec.
    * Se voltaggio OK: ***Nessun lampeggio extra***.
    * Se zona gialla (3.7V - 3.3V): ***3 lampeggi veloci***.
    * Se batteria critica (<3.3V): ***6 lampeggi veloci*** e Heltec resta spento.
* ***Diagnostica Volt + Ora (2.5 - 5 sec):*** Visualizza in sequenza i millivolt della batteria e l'orario attuale dell'RTC (vedi punto 2).
* ***Modalità Manutenzione (> 5 sec):*** Al raggiungimento dei 5 secondi, il LED emette ***10 lampeggi veloci***. Il sistema spegne il carico e il LED lampeggia lentamente (500ms ON / 500ms OFF). 
    * ***Per uscire dalla modalità manutenzione:*** Premere nuovamente per almeno ***5 secondi*** fino ai ***10 lampeggi veloci*** seguiti dai ***3 lampi*** classici di riavvio.

---

### ⚡ **5. ***Hardware e Alimentazione*****
* ***Step-Up 5V:*** Componente fondamentale. Eroga ***5V fissi al PIC12F683*** indipendentemente dal calo della batteria (da 2V a 4.5V). Questo garantisce una ***tensione di riferimento costante*** per letture ADC precise al millivolt.
* ***Componenti Chiave:*** PIC12F683, Modulo RTC DS3231 (ZS-042), Step-Up 5V, Mosfet P-Channel ***AO3401*** (il piu adatto e il meno energivoro) per il controllo del carico.

---

***Nota tecnica:*** *Il modulo DS3231 è stato scelto per la sua stabilità termica, garantendo che i riavvii programmati avvengano sempre all'orario stabilito senza derive stagionali.*

---
datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf

12F683 su aliexpress:

https://it.aliexpress.com/item/1005006303166795.html?spm=a2g0o.productlist.main.5.495f191a2PDQ6i&algo_pvid=013a3ce0-3dd7-438d-965c-3a9212c8e3d9&algo_exp_id=013a3ce0-3dd7-438d-965c-3a9212c8e3d9-4&pdp_ext_f=%7B%22order%22%3A%2221%22%2C%22spu_best_type%22%3A%22price%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%215.56%212.72%21%21%2143.24%2121.19%21%402103835e17741799554178201e5bc6%2112000036684741958%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=A6kHPwAkb3Wv&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005006303166795%7C_p_origin_prod%3A

PROGRAMMATORE UNIVERSALE PER PIC MICRO Amazon:

https://www.amazon.it/Fasizi-Programmazione-Automatica-Sviluppare-Microcontroller/dp/B09Z2CTDTT/ref=sr_1_1?__mk_it_IT=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3QKSL4BEFA1YO&dib=eyJ2IjoiMSJ9.ncfiYanZGVHfD30cY9TJVX20GOHlCkoljsRNEqQUaDgEnacLlefaaG5qibXrZ5OpQ0sx-7MXb4tdgXYdp5UAVjJwC3IiFX7PHX69azvp27de1wwzx2yAA3c8k7yU_IzL0kNnNX6BoE3XagAdtfcjT_TOYmDWxgsnWVAq-F5AgGYmRkPf9b6XofKtOH4q1_wW-TLtBVMAwlVgyTAHvNQSdHLkf8PKMqLzE-hu42-xlixdOT4j4_NGce53di1ScNzdu5ERz6MPrao9vEnFwvqC0GKwCNFClN54xpbzd47iR4w.3V76QG7ceCVjaGCpT_dxdQ8orbFK8K5KvA3oz8X1mBI&dib_tag=se&keywords=programmatore+universale+pic+micro&qid=1774180075&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=programmatore+universale+pi+c+micro%2Caps%2C265&sr=8-1

PROGRAMMATORE UNIVERSALE Pic micro aliexpress:

https://it.aliexpress.com/item/1005007040116001.html?spm=a2g0o.productlist.main.16.7cc9E3P8E3P8WF&algo_pvid=cb95b140-ec96-4991-bb90-bb0f4bdae7dd&algo_exp_id=cb95b140-ec96-4991-bb90-bb0f4bdae7dd-15&pdp_ext_f=%7B%22order%22%3A%2246%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%218.71%218.71%21%21%2167.75%2167.75%21%402103856417741801591217437e2a95%2112000039183909561%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=4KNi9xiyAQu4&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005007040116001%7C_p_origin_prod%3A
 
lo stepup (come da link per visionare e poi prenderne eventualmente dove volete) consuma circa 4uA, in pratica anni con batteira gia scarica..... 

Col nuovo codice mikroBasic/mikroC, ottimizzato per STEP UP, si ragiona in millivolt, cosi basta cambiare le soglie (3300, 3700 mv) ai %v fissi (5000, se fossero in uscuta 5.1 volt, basta scrivere 5100 anziche 5000) e ricompilare
 
StepUP 5V AMAZON:

https://www.amazon.it/gp/product/B07ZDJPMPJ/ref=ox_sc_act_title_1?smid=AETO64PHCI4NL&psc=1


STEPUP 5V aliexpress:

https://it.aliexpress.com/item/1005009255021446.html?spm=a2g0o.productlist.main.8.1f24qtVhqtVhq5&algo_pvid=5bd1cad7-bcc6-4baf-a986-672726cc3a0c&aem_p4p_detail=202603220452265597336666603120001140618&algo_exp_id=5bd1cad7-bcc6-4baf-a986-672726cc3a0c-7&pdp_ext_f=%7B%22order%22%3A%2231%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%213.07%213.07%21%21%2123.84%2123.84%21%402103917f17741803466073161e10ae%2112000048492400941%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=bmBaLl1n6PPl&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005009255021446%7C_p_origin_prod%3A&search_p4p_id=202603220452265597336666603120001140618_2

MOSFET AO3401, ecco un link aliexpress dove comprarne

https://it.aliexpress.com/item/1005004617543846.html?spm=a2g0o.productlist.main.1.6c116d4fBYnexV&algo_pvid=19b502e1-456e-40da-8695-24b0417dce6d&algo_exp_id=19b502e1-456e-40da-8695-24b0417dce6d-0&pdp_ext_f=%7B%22order%22%3A%2297%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%211.90%211.90%21%21%2114.79%2114.79%21%402103919917745377270103884efef4%2112000029849827853%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=d0vViNrEpmAL&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005004617543846%7C_p_origin_prod%3A

ADATTATORE mosfet SMD (SOT23-3) per millefori (SIP3)

https://it.aliexpress.com/item/1005006626188055.html?spm=a2g0o.productlist.main.10.1f94Te9qTe9qfL&algo_pvid=a7fdd15a-6daa-4bc9-b32e-30f053d9a163&algo_exp_id=a7fdd15a-6daa-4bc9-b32e-30f053d9a163-9&pdp_ext_f=%7B%22order%22%3A%221297%22%2C%22spu_best_type%22%3A%22price%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%211.93%211.93%21%21%212.18%212.18%21%40211b819117747092144196460e3172%2112000037858523309%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=uQJpqORxMooQ&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005006626188055%7C_p_origin_prod%3A

MODULO RTC 3231 amazon

https://www.amazon.it/dp/B0FN3Z58LH?ref=ppx_yo2ov_dt_b_fed_asin_title
