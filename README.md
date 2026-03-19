# heltec4_Smart_Battery_Guard

all'avvio del pic micro e solo in quel caso, 3 lampeggi veloci del led indicano il normale funzionamento del software all' interno del pic micro stesso, tutto regolare, heltec viene avviato.

una breve spiegazione sulla funzione del tasto:
pressione tra 1 e 5 secondi, accende led e lo lascia cceso fino al rilascio del tasto, salva i dati del valore voltaggio negli offset 0X00 e 0X01 cosi da poter verificare che siano coerenti con il voltaggio effettivo attualed ella batteria e riavvia heltec, 
Se premuto per piu di 5 secondi, tiene heltec in spegnimento, cosi potrete fare manutenzione, esempio, cambio antenna senzxa far soffrire la componentistica della radio in assenza del finale (l'antenna appunto), il led inizia a lampeggiare per 500ms ogni secondo, per idicare l'ingresso nello stato menutentivo, per tornare al funzionamento normale, tenere premuto il tasto per altri 5 secondi almeno, il led fara i 3 lampeggi classsici dell'avvio e si spegne, heltec si riavvia e torna a funzionare in modo regolare.


Agiunto piccolo script batch per calcolare precise soglie da inserire nel codice a seconda del voltaggio in uscita (con pic collegato su) dello stepup o LDO

Va precisato che valori sotto i 2.4V e sopra i 3.1V, potrebbero rendere il sistem stesso instabile, quindi i valori ottimali sono dai 2.5 ai 2.8V, (PRECISANDO CHE UN VALORE VERAMENTE OTTIMO SI AGGIRA INTORNO AI 2.5/2.6V) anche se da 2.4 a 3.0, vanno bene uguale, usate lo script per calcolare i valori dopo aver misurato la tensione in uscita, inseritele nel progetto mikrobasi /mikroc e compilate hex dea caricare sul pic micro!

Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.3V e lo riattiva se poi risale oltre i 3.7V, 

lo stepup è un modulo che eroga 5V fissi al PIC MICRO, a prescindere dal voltaggio in ingresso, che sia 3V, che sia 4.3V.

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo step up porta sempre alimentazione al pic da 5V  (per avere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic e schema elettrico (jpeg e pdf)

datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf

PER LA SIMULAZIONE scaricare SimulIDE: https://simulide.com/p/downloads/
il file per la simulazione da caricare si chiama: smimulazione.sim1, ovviamente dovrete caricare il file hex compilato, nel PIC, per eseguirlo




l'LDO e lo step up come da link consumano circa 4uA, in pratica anni con batteira gia scarica..... 

StepUP AMAZON 5V:

https://www.amazon.it/gp/product/B07ZDJPMPJ/ref=ox_sc_act_title_1?smid=AETO64PHCI4NL&psc=1

ldo da 2.5V (o da 3.0V), che trovate su aliexpress

https://it.aliexpress.com/item/1005004789258458.html?spm=a2g0o.productlist.main.13.bfb6UybJUybJP0&algo_pvid=b6bdde25-6901-49c2-9dc7-6fe755df9e97&algo_exp_id=b6bdde25-6901-49c2-9dc7-6fe755df9e97-12&pdp_ext_f=%7B%22order%22%3A%2251%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%212.02%210.88%21%21%212.27%210.99%21%40210390c917737370809014252ee6d6%2112000030494325303%21sea%21IT%210%21ABX%211%210%21n_tag%3A-29910%3Bd%3A63d35bfc%3Bm03_new_user%3A-29895%3BpisId%3A5000000197840834&curPageLogUid=x5MpdVa0tD1p&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005004789258458%7C_p_origin_prod%3A

o dove volete, sigla:HT7325 oppure da 3.0V HT7330, sarebbe anche preferibile, perche assorbe ancora meno corrente dello step UP, ma siamo sempre nell'ordine dei microAmpere.

video per meglio comprendere le funzioni del tasto
https://github.com/pappicio/heltec4_Smart_Battery_Guard/blob/main/simulazione%20pic%20micro.mp4

