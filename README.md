# heltec4_Smart_Battery_Guard

Smart Battery Guard, consente di spegnere e riaccendere il disposiotivo meshtastic se la batteria scende oltre la soglia di 3.2V e lo riattiva se poi risale oltre i 3.7V, 

lo tepdown è un modulo che ha i ponticelli con varie tensioni, basta chiudere il ponticello, io ho scelto 3.3V, che eroga in realta 3.0V, 

cosi anche se la batteria al momento eroga 4.5V oppure 3,4V, lo step down porta sempre alimentazione al pic da 3.0V (per acvere la costante del comparatore che misura il voltaggio della batteria)

gli altri componenti sono pochi e molto comuni

pic micro 12F683, sorgenti mikrobasic.
