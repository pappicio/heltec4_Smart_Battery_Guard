// Definizione variabili globali
unsigned int valore_adc;
unsigned long batteria_mv;    // Usiamo unsigned long per evitare overflow
unsigned char i;
unsigned int secondi_contatore;
short in_manutenzione;        // boolean in MikroC si esprime con short o bit

// --- PROCEDURA SEGNALE AVVIO ---
void Segnale_Avvio() {
    for (i = 1; i <= 3; i++) {
        GPIO.F5 = 1;
        Delay_ms(250);
        GPIO.F5 = 0;
        Delay_ms(250);
    }
}


void Salva_EEPROM() {
    // 1. Lettura pulita (Doppia lettura per 100k)
    ADC_Read(1);
    Delay_ms(5);
    valore_adc = ADC_Read(1);

    // Formula: (ADC * 5000) / 1024
    batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;

    // 2. Salvataggio ADC Grezzo (16 bit -> 2 byte)
    // Spostiamo i bit a destra di 8 per prendere la parte alta
    EEPROM_Write(0, (unsigned short)(valore_adc >> 8));
    Delay_ms(25);
    EEPROM_Write(1, (unsigned short)(valore_adc & 0xFF));
    Delay_ms(25);

    // 3. SEPARATORE
    EEPROM_Write(2, 0xFF);
    Delay_ms(25);

    // 4. Salvataggio Millivolt (32 bit -> 4 byte)
    // Estraiamo i 4 byte uno per uno shiftando di 24, 16, 8 e 0 bit
    EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // MSB (più significativo)
    Delay_ms(25);
    EEPROM_Write(4, (unsigned short)(batteria_mv >> 16));
    Delay_ms(25);
    EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));
    Delay_ms(25);
    EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF)); // LSB (meno significativo)
    Delay_ms(25);
}

// --- INIZIALIZZAZIONE HARDWARE ---
void Init_Hardware() {
    OSCCON = 0b01100000;    // 4MHz interno
    CMCON0 = 7;             // Comparatori OFF
    ANSEL  = 0b00000010;    // ANS1 (GP1) Analogico
    TRISIO = 0b00001011;    // RA0, RA1, RA3 Input | RA2, RA5 Output
    OPTION_REG.NOT_GPPU = 0; // Abilita Pull-ups (bit 7)
    WPU = 0b00000001;       // Pull-up su GP0 (Tasto)

    GPIO.F2 = 1;            // Heltec SPENTO al boot (Logica Inversa 2N2222 su RST)
    in_manutenzione = 0;    // False
    Segnale_Avvio();
}

void main() {
    Init_Hardware();
    secondi_contatore = 300; // Forza lettura immediata al boot

    while (1) {
        // --- GESTIONE TASTO (GP0) ---
        if (GPIO.F0 == 0) {
            i = 0;
            while ((GPIO.F0 == 0) && (i < 50)) {
                Delay_ms(100);
                i++;
                if (i >= 10) GPIO.F5 = 1; // Accendi LED dopo 1 sec
            }

            // CASO 1: RELEASE TRA 1 E 5 SECONDI (Salva e riavvia Heltec)
            if ((i >= 10) && (i < 50)) {
                Salva_EEPROM();
                GPIO.F2 = 1; // Forza reset (OFF)
                GPIO.F5 = 0;
                Delay_ms(1000);
                GPIO.F2 = 0; // Rilascia reset (ON)
                secondi_contatore = 0;
            }

            // CASO 2: PRESSIONE OLTRE 5 SECONDI (Manutenzione)
            if (i >= 50) {
                Salva_EEPROM();
                GPIO.F2 = 1; // Spegne Heltec
                for (i = 1; i <= 20; i++) {
                    GPIO.F5 = ~GPIO.F5; // Lampeggio rapido ingresso
                    Delay_ms(100);
                }
                GPIO.F5 = 0;
                in_manutenzione = 1; // True

                while (in_manutenzione) {
                    GPIO.F5 = 1;
                    Delay_ms(500);
                    GPIO.F5 = 0;
                    if (GPIO.F0 == 0) {
                        secondi_contatore = 0;
                        while ((GPIO.F0 == 0) && (secondi_contatore < 50)) {
                            Delay_ms(100);
                            secondi_contatore++;
                        }
                        if (secondi_contatore >= 50) {
                            Salva_EEPROM();
                            in_manutenzione = 0;
                            for (i = 1; i <= 20; i++) {
                                GPIO.F5 = ~GPIO.F5;
                                Delay_ms(100);
                            }
                            GPIO.F5 = 0;
                        }
                    } else {
                        Delay_ms(500);
                    }
                }
                Segnale_Avvio();
                GPIO.F2 = 0; // Riaccende Heltec usciti dalla manutenzione
                secondi_contatore = 0;
            }
            GPIO.F5 = 0;
        }

        // --- LOGICA ADC E CONTROLLO BATTERIA ---
        if (!in_manutenzione) {
            secondi_contatore++;
            if (secondi_contatore >= 300) {
                // Lettura ADC stabilizzata per 100k ohm
                valore_adc = ADC_Read(1);
                Delay_ms(5);
                valore_adc = ADC_Read(1);

                // Calcolo millivolt (Riferimento 5V Step-Up)
                batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;

                // LOGICA ISTERESI (3.3V OFF - 3.7V ON)
                if (batteria_mv <= 3300) {
                    GPIO.F2 = 1;  // RST a GND tramite transistor
                }
                if (batteria_mv >= 3700) {
                    GPIO.F2 = 0;  // RST Libero
                }

                secondi_contatore = 0;
            }
        }

        Delay_ms(100); // Base tempi del ciclo main
    }
}