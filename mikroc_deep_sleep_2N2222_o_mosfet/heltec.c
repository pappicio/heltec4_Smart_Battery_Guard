// --- VARIABILI GLOBALI ---
unsigned int valore_adc;
unsigned long batteria_mv;
unsigned short i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned short dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;

// --- VARIABILI PER LETTURA CIFRE ---
unsigned long temp_mv;
unsigned short cifra;

// --- VARIABILI TIMER RIAVVIO ---
unsigned short giorni_riavvio;
unsigned long conteggio_cicli;
unsigned long cicli_per_giorno;

// --- RITARDO SICURO ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 1; k <= n; k++) {
        Delay_ms(1);
        asm clrwdt;
    }
}

// --- SEGNALE TRIPLO (AVVIO / AVVISO) ---
void Segnale_Triplo() {
    for (j = 1; j <= 3; j++) {
        GPIO.F5 = 1;
        Delay_Safe_ms(250);
        GPIO.F5 = 0;
        Delay_Safe_ms(250);
    }
}

// --- SUBROUTINE LAMPEGGIO CIFRA ---
void Lampeggia_Cifra(unsigned short c) {
    unsigned short l;
    if (c == 0) {
        // Zero: lampeggio brevissimo
        GPIO.F5 = 1;
        Delay_ms(50);
        GPIO.F5 = 0;
    } else {
        for (l = 1; l <= c; l++) {
            GPIO.F5 = 1;
            Delay_ms(250);
            GPIO.F5 = 0;
            Delay_ms(250);
            asm clrwdt;
        }
    }
    Delay_Safe_ms(1000);
}

// --- LETTURA ADC ---
void Leggi_Batteria_mV() {
    valore_adc = ADC_Read(1);
    Delay_Safe_ms(5);
    valore_adc = ADC_Read(1);

    // Calcolo millivolt
    batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}

// --- SALVATAGGIO EEPROM ---
void Salva_EEPROM() {
    // Salvataggio valore_adc (16 bit)
    EEPROM_Write(0, (unsigned short)(valore_adc >> 8));   // Byte alto
    Delay_Safe_ms(20);
    EEPROM_Write(1, (unsigned short)(valore_adc));        // Byte basso
    Delay_Safe_ms(20);

    // Salvataggio batteria_mv (32 bit)
    EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // Byte 3 (Highest)
    Delay_Safe_ms(20);
    EEPROM_Write(4, (unsigned short)(batteria_mv >> 16)); // Byte 2 (Higher)
    Delay_Safe_ms(20);
    EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));  // Byte 1 (Hi)
    Delay_Safe_ms(20);
    EEPROM_Write(6, (unsigned short)(batteria_mv));       // Byte 0 (Lo)
    Delay_Safe_ms(20);
}

// --- INIZIALIZZAZIONE ---
void Init_Hardware() {
    OSCCON = 0b01100111;    // 4MHz
    CMCON0 = 7;             // No comparatori
    ANSEL  = 0b00010010;    // GP1 Analogico
    TRISIO = 0b00001011;    // GP0, GP1, GP3 Input

    OPTION_REG = 0b00001111; // WDT ~2.3s
    WPU = 0b00000001;        // Pull-up GP0
    INTCON.GPIE = 1;
    IOC.B0 = 1;

    // SOGLIE DA MODIFICARE SECONDO LE MISURAZIONI CON MULTIMETRO!!!
    soglia_off   = 3330;
    soglia_on    = 3700;
    taratura_vcc = 5030;
    giorni_riavvio = 3;

    conteggio_cicli = 0;
    cicli_per_giorno = 2880;

    GPIO.F2 = 1; // MOSFET OFF
    Leggi_Batteria_mV();
    if (batteria_mv > soglia_off) {
        GPIO.F2 = 0; // MOSFET ON
    }

    in_manutenzione = 0;
    asm clrwdt;
    Segnale_Triplo();
}

// --- MAIN ---
void main() {
    Init_Hardware();
    sveglie_wdt = 15;

    while (1) {
        if (INTCON.GPIF == 1) {
            dummy = GPIO;
            INTCON.GPIF = 0;
        }

        // --- GESTIONE TASTO ---
        if (GPIO.F0 == 0) {
            i = 0;
            while (GPIO.F0 == 0 && i < 50) {
                Delay_Safe_ms(100);
                i++;
                if (i == 10) GPIO.F5 = 1;
                if (i == 25) GPIO.F5 = 0;
            }

            // --- 1. RESET RAPIDO CON DIAGNOSTICA (1-2.5s) ---
            if (i >= 10 && i < 25) {
                GPIO.F5 = 0;
                Leggi_Batteria_mV();

                // Controllo soglie per Feedback LED
                if (batteria_mv >= soglia_on) {
                    // Batteria OK (Sopra 3.7V): 1 lampo lungo
                    GPIO.F5 = 1;
                    Delay_Safe_ms(1000);
                    GPIO.F5 = 0;
                } else {
                    if (batteria_mv <= soglia_off) {
                        GPIO.F5 = 0;
                        Delay_Safe_ms(500);
                        // Batteria CRITICA (Sotto 3.33V): 6 lampi rapidi
                        for (j = 1; j <= 6; j++) {
                            GPIO.F5 = 1;
                            Delay_Safe_ms(100);
                            GPIO.F5 = 0;
                            Delay_Safe_ms(100);
                            asm clrwdt;
                        }
                    } else {
                        // Batteria MEDIA (Zona Gialla): 3 lampi rapidi
                        Delay_Safe_ms(500);
                        for (j = 1; j <= 3; j++) {
                            GPIO.F5 = 1;
                            Delay_Safe_ms(100);
                            GPIO.F5 = 0;
                            Delay_Safe_ms(100);
                            asm clrwdt;
                        }
                    }
                }

                // Esecuzione Reset Fisico Heltec
                GPIO.F2 = 1;
                Delay_Safe_ms(2000);

                // Riaccende solo se non siamo sotto soglia critica
                if (batteria_mv > soglia_off) {
                    GPIO.F2 = 0;
                }

                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }

            // --- 2. VISUALIZZAZIONE VOLT (2.5-5s) ---
            if (i >= 25 && i < 50) {
                GPIO.F5 = 0;
                Leggi_Batteria_mV();
                Salva_EEPROM();
                Delay_Safe_ms(1000);

                temp_mv = batteria_mv;
                cifra = temp_mv / 1000;
                Lampeggia_Cifra(cifra);
                temp_mv %= 1000;

                cifra = temp_mv / 100;
                Lampeggia_Cifra(cifra);
                temp_mv %= 100;

                cifra = temp_mv / 10;
                Lampeggia_Cifra(cifra);

                cifra = temp_mv % 10;
                Lampeggia_Cifra(cifra);

                Delay_Safe_ms(1000);
            }

            // --- 3. MANUTENZIONE (>5s) ---
            if (i >= 50) {
                GPIO.F2 = 1;
                for (j = 1; j <= 20; j++) {
                    GPIO.F5 = ~GPIO.F5;
                    Delay_Safe_ms(100);
                }
                GPIO.F5 = 0;
                in_manutenzione = 1;

                while (in_manutenzione) {
                    GPIO.F5 = 1;
                    Delay_Safe_ms(500);
                    GPIO.F5 = 0;
                    if (GPIO.F0 == 0) {
                        i = 0;
                        while (GPIO.F0 == 0 && i < 50) {
                            Delay_Safe_ms(100);
                            i++;
                        }
                        if (i >= 50) {
                            in_manutenzione = 0;
                            Segnale_Triplo();
                        }
                    } else {
                        Delay_Safe_ms(500);
                    }
                }
                GPIO.F2 = 0;
                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }
        }

        // --- CONTROLLO AUTOMATICO ---
        if (!in_manutenzione) {
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();
                if (batteria_mv <= soglia_off) GPIO.F2 = 1;
                if (batteria_mv >= soglia_on)  GPIO.F2 = 0;

                if (giorni_riavvio > 0) {
                    conteggio_cicli++;
                    if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
                        GPIO.F2 = 1;
                        Delay_Safe_ms(2000);
                        if (batteria_mv > soglia_off) GPIO.F2 = 0;
                        conteggio_cicli = 0;
                    }
                }
                sveglie_wdt = 0;
            }
            sveglie_wdt++;
            asm clrwdt;
            asm sleep;
            asm nop;
        } else {
            Delay_Safe_ms(100);
        }
    }
}