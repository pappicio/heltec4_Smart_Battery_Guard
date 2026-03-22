/*
 * Programma: Solar_Power_Manager_683_Final_WDT
 * Conversione paro paro da MikroBasic a MikroC
 */

// --- DICHIARAZIONE VARIABILI GLOBALI ---
unsigned int valore_adc;
unsigned long batteria_mv;     // LongWord in Basic = unsigned long in C
unsigned char i;
unsigned int sveglie_wdt;
short in_manutenzione;         // boolean
unsigned char dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;

// --- RITARDO SICURO CON PULIZIA WATCHDOG ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 1; k <= n; k++) {
        Delay_ms(1);
        asm clrwdt;
    }
}

// --- FUNZIONE LETTURA E CALCOLO ---
void Leggi_Batteria_mV() {
    valore_adc = ADC_Read(1);      // Prima lettura (scarto per stabilizzare l'ADC)
    Delay_Safe_ms(5);
    valore_adc = ADC_Read(1);      // Seconda lettura reale

    // Calcolo millivolt (Tarato su variabile taratura_vcc)
    // Spostamento a destra di 10 equivale a dividere per 1024
    batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}

// --- SEGNALE LUMINOSO DI AVVIO ---
void Segnale_Avvio() {
    for (i = 1; i <= 3; i++) {
        GPIO.F5 = 1;
        Delay_Safe_ms(250);
        GPIO.F5 = 0;
        Delay_Safe_ms(250);
    }
}

// --- INIZIALIZZAZIONE HARDWARE ---
void Init_Hardware() {
    OSCCON = 0b01100111;    // 4MHz interno
    CMCON0 = 7;             // Comparatori OFF
    ANSEL  = 0b00010010;    // RA1 Analogico
    TRISIO = 0b00001011;    // RA0, RA1, RA3 Input | RA2, RA5 Output

    OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
    WPU = 0b00000001;        // Pull-up su GP0

    INTCON.GPIE = 1;         // Abilita interrupt GPIO
    IOC.B0 = 1;              // Sveglia su GP0 (IOC0)

    // --- CONFIGURAZIONE SOGLIE E TARATURA ---

    // a questa soglia precisa, si spegne, SOPRA questa soglia resta acceso!!!!!
    soglia_off   = 3330;   // 3340 è il 10% Batteria stiamo sotto cosi sotto i 10% si spegne!!!!!
    soglia_on    = 3700;   // 50% Batteria
    taratura_vcc = 5000;   // 5080 = 5.08V

    GPIO.F2 = 1;
    GPIO.F2 = 0;

    // --- CONTROLLO BATTERIA IMMEDIATO AL BOOT ---
    Leggi_Batteria_mV();   // Leggiamo subito lo stato della batteria

    if (batteria_mv > soglia_off) {
        GPIO.F2 = 0;        // ACCENDI Heltec subito se la batteria è OK
    } else {
        GPIO.F2 = 1;        // Resta SPENTO se troppo scarica
    }

    in_manutenzione = 0;    // false
    asm clrwdt;
    Segnale_Avvio();        // Il LED segnala che il PIC è partito
}

// --- SALVATAGGIO DATI IN EEPROM ---
void Salva_EEPROM() {
    Leggi_Batteria_mV();    // Aggiorna i valori prima di scrivere

    EEPROM_Write(0, (valore_adc >> 8));    // Hi(valore_adc)
    Delay_Safe_ms(20);
    EEPROM_Write(1, (valore_adc & 0xFF));  // Lo(valore_adc)
    Delay_Safe_ms(20);
    EEPROM_Write(2, 0xFF);
    Delay_Safe_ms(20);
    EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // Highest
    Delay_Safe_ms(20);
    EEPROM_Write(4, (unsigned short)(batteria_mv >> 16)); // Higher
    Delay_Safe_ms(20);
    EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));  // Hi
    Delay_Safe_ms(20);
    EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF)); // Lo
    Delay_Safe_ms(20);
}

// --- MAIN PROGRAM ---
void main() {
    Init_Hardware();
    sveglie_wdt = 15;

    while (1) {
        // Reset Mismatch Interrupt
        if (INTCON.GPIF == 1) {
            dummy = GPIO;
            INTCON.GPIF = 0;
        }

        // --- GESTIONE TASTO ---
        if (GPIO.F0 == 0) {
            i = 0;
            while ((GPIO.F0 == 0) && (i < 50)) {
                Delay_Safe_ms(100);
                i = i + 1;
                if (i >= 10) { GPIO.F5 = 1; }
            }

            // PRESSIONE MEDIA (1-5s): Reset + Feedback Stato Batteria
            if ((i >= 10) && (i < 50)) {
                Salva_EEPROM(); // Aggiorna batteria_mv e valore_adc

                // --- 1. FEEDBACK FASCIA GIALLA (3.34V - 3.77V) ---
                if ((batteria_mv > soglia_off) && (batteria_mv < soglia_on)) {
                    for (i = 1; i <= 3; i++) {
                        GPIO.F5 = 1;
                        Delay_ms(100);
                        GPIO.F5 = 0;
                        Delay_ms(100);
                        asm clrwdt;
                    }
                }

                // --- 2. FEEDBACK BATTERIA CRITICA (Sotto soglia_off) ---
                if (batteria_mv <= soglia_off) {
                    for (i = 1; i <= 6; i++) {
                        GPIO.F5 = 1;
                        Delay_ms(100);
                        GPIO.F5 = 0;
                        Delay_ms(100);
                        asm clrwdt;
                    }
                }

                // --- 3. ESECUZIONE RESET / SPEGNIMENTO ---
                GPIO.F2 = 1;      // Spegni l'Heltec
                GPIO.F5 = 0;
                Delay_Safe_ms(1000);

                // Riaccendi solo se la batteria è sopra la soglia minima
                if (batteria_mv > soglia_off) {
                    GPIO.F2 = 0;
                } else {
                    GPIO.F2 = 1;  // Conferma spegnimento se scarica
                }

                sveglie_wdt = 0;
            }

            // PRESSIONE LUNGA (>5s): Manutenzione
            if (i >= 50) {
                GPIO.F2 = 1;
                for (i = 1; i <= 20; i++) {
                    GPIO.F5 = !GPIO.F5;
                    Delay_Safe_ms(100);
                }
                GPIO.F5 = 0;
                in_manutenzione = 1; // true

                while (in_manutenzione == 1) {
                    GPIO.F5 = 1;
                    Delay_Safe_ms(500);
                    GPIO.F5 = 0;
                    if (GPIO.F0 == 0) {
                        i = 0;
                        while ((GPIO.F0 == 0) && (i < 50)) {
                            Delay_Safe_ms(100);
                            i = i + 1;
                        }
                        if (i >= 50) {
                            in_manutenzione = 0; // false
                            for (i = 1; i <= 20; i++) {
                                GPIO.F5 = !GPIO.F5;
                                Delay_Safe_ms(100);
                            }
                            GPIO.F5 = 0;
                        }
                    } else {
                        Delay_Safe_ms(500);
                    }
                }
                Segnale_Avvio();
                GPIO.F2 = 0;
                sveglie_wdt = 0;
            }
        }

        // --- LOGICA CONTROLLO BATTERIA (Ogni ~30s) ---
        if (in_manutenzione == 0) {
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();

                if (batteria_mv <= soglia_off) {
                    GPIO.F2 = 1;  // SPEGNI
                }

                if (batteria_mv >= soglia_on) {
                    GPIO.F2 = 0;  // ACCENDI
                }

                sveglie_wdt = 0;
            }
        }

        // --- RISPARMIO ENERGETICO ---
        if (in_manutenzione == 0) {
            sveglie_wdt = sveglie_wdt + 1;
            asm clrwdt;
            asm sleep;
            asm nop;
        } else {
            Delay_Safe_ms(100);
        }
    }
}