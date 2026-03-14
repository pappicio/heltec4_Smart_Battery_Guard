# heltec4_Smart_Battery_Guard

REV 2 del progetto: eliminata resistenza 10k sul pin CLR del pic micro e inserita gestione interna da codice mikrobasic.

Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.2V e lo riattiva se poi risale oltre i 3.7V, 

lo stepdown è un modulo che ha i ponticelli con varie tensioni, basta chiudere il ponticello, io ho scelto 3.3V, che eroga in realta 3.0V, 

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo step down porta sempre alimentazione al pic da 3.0V (per acvere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic e schema elettrico (jpeg e pdf)

lo stepdown che vi consiglio è questo modello cpon ponticelli pee voltaggi fixed (3.3 è quello che ho usato io) e il PIN "EN" nn va utilizzato, saldare il ponticello che indica 3.3V

https://www.amazon.it/ZkeeShop-alimentazione-step-down-convertitore-regolabile/dp/B08CVF4BFW/ref=sr_1_12?crid=2L7YJ98YYK6QC&dib=eyJ2IjoiMSJ9.GKlv5DQszLgq_LK5n0crl-LZyzy14A9M2XRjKJi2xWCCqLwgWRo3srD0MooDTUEBpFbBTtOVE-AWWb74bsnG_XGg4wq2QGu4Y_BDJ2Xh671aMHy8wx1NEpU3IyhLT3BEzHco6UVeIriE3vpc91ElZu10hsVv657xwLbnRsnYQlt8BdA-fc1P7dgbHocSt4mavAwtESl5kJ_vQQBW5VQocvimQmC5j3ZutorXpWckRHpvCHWcvV_RHlC2DihOXUO3SbHPs1Ebx8yQo_GZcRv0D8_E41QN40DCS_Tff98F7YE.Aslo3HLAKDHMFaejLaiD0FafWqjTtJy69g64mXzOSEg&dib_tag=se&keywords=step+down+5v&qid=1773518897&refinements=p_85%3A20930965031&rnid=20930964031&rps=1&sprefix=step+down+%2Caps%2C262&sr=8-12
