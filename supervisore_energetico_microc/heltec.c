                                           // --- Dichiarazione Variabili ---
unsigned int valore_adc;
unsigned char i;
unsigned int secondi_contatore;
bit in_manutenzione; // In mikroC 'bit' è un tipo speciale per flag

// --- Procedure ---
void Segnale_Avvio() {
    unsigned char j;
    for (j = 1; j <= 3; j++) {
        GPIO.F5 = 1;
        Delay_ms(250);
        GPIO.F5 = 0;
        Delay_ms(250);
    }
}

void Salva_EEPROM() {
    valore_adc = ADC_Read(1);

    // Al posto di Hi(valore_adc) spostiamo i bit a destra di 8 posizioni
    EEPROM_Write(0, (unsigned char)(valore_adc >> 8));
    Delay_ms(20);

    // Al posto di Lo(valore_adc) prendiamo solo l'ultimo byte (maschera 0xFF)
    EEPROM_Write(1, (unsigned char)(valore_adc & 0xFF));
    Delay_ms(20);
}

void Init_Hardware() {
    // 1. Disabilita i comparatori prima di tutto (fondamentale per GP0/GP1/GP2)
    CMCON0 = 7;

    // 2. Configura Analogico/Digitale
    ANSEL  = 0x02;     // Solo AN1 (GP1) è analogico, gli altri digitali

    // 3. Configura Direzione (TRISIO)
    TRISIO.F0 = 1;     // GP0 Input (Tasto)
    TRISIO.F1 = 1;     // GP1 Input (ADC)
    TRISIO.F2 = 0;     // GP2 Output (Heltec)
    TRISIO.F3 = 1;     // GP3 è solo Input (MCLR)
    TRISIO.F4 = 0;     // GP4 Output
    TRISIO.F5 = 0;     // GP5 Output (LED)

    // 4. Attiva i PULL-UP (L'ordine qui è vitale)
    OPTION_REG.F7 = 0; // 0 = Abilita i pull-up globali
    WPU = 0x01;        // Attiva pull-up specifico solo su GP0 (00000001)

    // 5. Stato iniziale delle uscite
    GPIO.F2 = 1;       // Heltec spento al boot
    GPIO.F5 = 0;       // LED spento

    in_manutenzione = 0;

    // Aspetta un istante che i livelli logici si stabilizzino
    Delay_ms(100);

    Segnale_Avvio();
}

void main() {
    Init_Hardware();
    secondi_contatore = 300;

    while (1) {
        // --- GESTIONE TASTO ---
        if (GPIO.F0 == 0) {
            i = 0;
            // Finché tieni premuto (max 5 secondi)
            while (GPIO.F0 == 0 && i < 50) {
                Delay_ms(100);
                i++;
                if (i >= 10) GPIO.F5 = 1; // Accende LED dopo 1 secondo
            }

            // CASO 1: RELEASE TRA 1 E 5 SECONDI (Salva e riavvia)
            if (i >= 10 && i < 50) {
                Salva_EEPROM();
                GPIO.F2 = 1;  // Spegne Heltec
                GPIO.F5 = 0;  // Spegne LED
                Delay_ms(1000);
                GPIO.F2 = 0;  // Riaccende Heltec
                secondi_contatore = 0;
            }

            // CASO 2: PRESSIONE OLTRE 5 SECONDI (Manutenzione)
            if (i >= 50) {
                Salva_EEPROM();
                GPIO.F2 = 1; // Spegne Heltec per manutenzione

                // Lampeggio veloce 10 volte
                for (i = 1; i <= 20; i++) {
                    GPIO.F5 = ~GPIO.F5; // Inverte stato LED
                    Delay_ms(100);
                }
                GPIO.F5 = 0;
                in_manutenzione = 1;

                // --- LOOP MANUTENZIONE ---
                while (in_manutenzione) {
                    GPIO.F5 = 1; Delay_ms(500);
                    GPIO.F5 = 0;

                    if (GPIO.F0 == 0) {
                        i = 0;
                        while (GPIO.F0 == 0 && i < 50) {
                            Delay_ms(100);
                            i++;
                        }
                        if (i >= 50) {
                            Salva_EEPROM();
                            in_manutenzione = 0;
                            // Conferma uscita
                            for (i = 1; i <= 20; i++) {
                                GPIO.F5 = ~GPIO.F5; Delay_ms(100);
                            }
                            GPIO.F5 = 0;
                        }
                    } else {
                        Delay_ms(500);
                    }
                }
                // USCITA MANUTENZIONE
                Segnale_Avvio();
                GPIO.F2 = 0;
                secondi_contatore = 300;
            }
            GPIO.F5 = 0;
        }

        // --- LOGICA ADC STANDARD ---
        if (!in_manutenzione) {
            secondi_contatore++;
            if (secondi_contatore >= 300) {
                valore_adc = ADC_Read(1);
                if (valore_adc < 582) GPIO.F2 = 1; // Spegne
                if (valore_adc > 651) GPIO.F2 = 0; // Accende
                secondi_contatore = 0;
            }
        }
        Delay_ms(100);
    }
}