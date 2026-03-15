# heltec4_Smart_Battery_Guard

all'avvio del pic micro e solo in quel caso, 3 lampeggi veloci del led indicano il normale funzionamento del software all' interno del pic micro stesso, tutto regolare, heltec viene avviato.

una breve spiegazione sulla funzione del tasto:
pressione tra 1 e 5 secondi, accende led e lo lascia cceso fino al rilascio del tasto, salva i dati del valore voltaggio negli offset 0X00 e 0X01 cosi da poter verificare che siano coerenti con il voltaggio effettivo attualed ella batteria e riavvia heltec, 
Se premuto per piu di 5 secondi, tiene heltec in spegnimento, cosi potrete fare manutenzione, esempio, cambio antenna senzxa far soffrire la componentistica della radio in assenza del finale (l'antenna appunto), il led inizia a lampeggiare per 500ms ogni secondo, per idicare l'ingresso nello stato menutentivo, per tornare al funzionamento normale, tenere premuto il tasto per altri 5 secondi almeno, il led fara i 3 lampeggi classsici dell'avvio e si spegne, heltec si riavvia e torna a funzionare in modo regolare.

REV 2 del progetto: eliminata resistenza 10k sul pin CLR del pic micro e inserita gestione interna da codice mikrobasic.

Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.2V e lo riattiva se poi risale oltre i 3.7V, 

lo stepdown è un modulo che ha i ponticelli con varie tensioni, basta chiudere il ponticello, io ho scelto 3.3V, che eroga in realta 3.0V, 

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo step down porta sempre alimentazione al pic da 3.0V (per acvere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic e schema elettrico (jpeg e pdf)

datasheet del pic micro (12F683)

https://ww1.microchip.com/downloads/en/devicedoc/41211d_.pdf


lo stepdown che vi consiglio è questo modello con ponticelli per voltaggi fixed (il ponticello che ho utilizzato il è "3.3V", testati 3 differenti ed erogavano tutti 3.0V, piu che sufficienti per tenere in vita il microchip) e il PIN "EN" nn va utilizzato, saldare il ponticello che indica 3.3V

Stepdown AMAZON:

https://www.amazon.it/ZkeeShop-alimentazione-step-down-convertitore-regolabile/dp/B08CVF4BFW/ref=sr_1_7?__mk_it_IT=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=N1SLOMA5LF3I&dib=eyJ2IjoiMSJ9.8ZtXDAlO3VK2ulB89hvLEjJbZV0p17iI6EgBNkm07jBPCPImC8iUzt14zG7SRKC72vcbnWuG5cQie3uPIaRyR3PSDr_5jlyRlnRcfemen-3AUhZWDkw0tx7txaroJX_-V62dGf-YfEvoHz1N8iDmh6sykg9g5BLjycWzhPHcuq449isC9lP65doqCcr3htcpQZTEbVDBQqsdseSg9x-MP1qXPbboixB-2QkRMB3KOHzMFEsBx51YoMcS8C55Um90V37M3eynqJfQ4armlwzquP0uNo-XTc0GIRdDftFi_NE.vC7hGAhZHr_c_VgrPgHh-3B4FmkrDjSvVU3k-cWhbVY&dib_tag=se&keywords=step+down+5v&qid=1773526052&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=step+down+5v%2Caps%2C268&sr=8-7

OPPURE:


[https://www.amazon.it/ZkeeShop-alimentazione-step-down-convertitore-regolabile/dp/B08CVF4BFW/ref=sr_1_12?crid=2L7YJ98YYK6QC&dib=eyJ2IjoiMSJ9.GKlv5DQszLgq_LK5n0crl-LZyzy14A9M2XRjKJi2xWCCqLwgWRo3srD0MooDTUEBpFbBTtOVE-AWWb74bsnG_XGg4wq2QGu4Y_BDJ2Xh671aMHy8wx1NEpU3IyhLT3BEzHco6UVeIriE3vpc91ElZu10hsVv657xwLbnRsnYQlt8BdA-fc1P7dgbHocSt4mavAwtESl5kJ_vQQBW5VQocvimQmC5j3ZutorXpWckRHpvCHWcvV_RHlC2DihOXUO3SbHPs1Ebx8yQo_GZcRv0D8_E41QN40DCS_Tff98F7YE.Aslo3HLAKDHMFaejLaiD0FafWqjTtJy69g64mXzOSEg&dib_tag=se&keywords=step+down+5v&qid=1773518897&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=step+down+%2Caps%2C262&sr=8-12](https://www.amazon.it/YOUMILE-alimentazione-Step-Down-Convertitore-Regolabile/dp/B07TTH6C3J/ref=sr_1_44?__mk_it_IT=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2AVQOBKTC3YLV&dib=eyJ2IjoiMSJ9.8ZtXDAlO3VK2ulB89hvLEjJbZV0p17iI6EgBNkm07jBPCPImC8iUzt14zG7SRKC72vcbnWuG5cQie3uPIaRyR3PSDr_5jlyRlnRcfemen-0b7kCvnYHTPYE9V3eD2f9LJW3MbRvXrumTVjQQx-KPSLZ8s9ulRtxv-vJTlkux3BmaVsBOgTwM2ATijHAF6souJ0suZ_HVVLLN1le6lglwfOFxtBy217uuWHk0-P4w0_EbqDA-nObAqEOh93xQo8M6rdU5Y11PKANHTvJIUz_-kYj-8XdPPEdF9MWvquT9Epk.OTKnxP7nI7OAwsdC4ggAixrs4tpA47INyWjbYX36Jo8&dib_tag=se&keywords=step+down+5v&qid=1773525953&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=step+down+5v%2Caps%2C255&sr=8-44)

Step down aliexpress:

https://it.aliexpress.com/item/1005009490217801.html?spm=a2g0o.productlist.main.32.1ae5ef03EnD1ij&algo_pvid=58bdf994-9b7f-4d37-94b6-dd1a7387e2f5&aem_p4p_detail=2026031415023310395111494988990000630418&algo_exp_id=58bdf994-9b7f-4d37-94b6-dd1a7387e2f5-31&pdp_ext_f=%7B%22order%22%3A%22140%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%218.69%218.69%21%21%2167.26%2167.26%21%402103835e17735257538684047e832e%2112000049267392533%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=ka70ZRbwq3h8&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005009490217801%7C_p_origin_prod%3A&search_p4p_id=2026031415023310395111494988990000630418_9

OPPURE:

https://it.aliexpress.com/item/1005006151233979.html?spm=a2g0o.productlist.main.11.1ae5ef03EnD1ij&algo_pvid=a4c9e735-574e-42d4-9ae0-882bc106503d&algo_exp_id=a4c9e735-574e-42d4-9ae0-882bc106503d-10&pdp_ext_f=%7B%22order%22%3A%221058%22%2C%22eval%22%3A%221%22%2C%22fromPage%22%3A%22search%22%7D&pdp_npi=6%40dis%21EUR%211.65%211.64%21%21%2112.75%2112.71%21%40210391a017735263044668235eb964%2112000038896346008%21sea%21IT%211910279782%21X%211%210%21n_tag%3A-29919%3Bd%3Af1c9b8e%3Bm03_new_user%3A-29895&curPageLogUid=WsLfBXwRgoxe&utparam-url=scene%3Asearch%7Cquery_from%3A%7Cx_object_id%3A1005006151233979%7C_p_origin_prod%3A
