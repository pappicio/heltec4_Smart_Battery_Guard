/*
 * Program: Solar_Power_Manager_683_Final_WDT
 * Porting: MikroC PRO for PIC
 */

// --- DICHIARAZIONE VARIABILI GLOBALI ---
unsigned int valore_adc;
unsigned long batteria_mv;
unsigned char i;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned char dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;
unsigned char acceso, spento;

// --- VARIABILI GESTIONE TEMPO E RESET ---
unsigned int giorni_per_reset;      // <--- ORA VARIABILE GLOBALE (0 a 730+)
unsigned long conteggio_giorni;    // Contatore risvegli totali
unsigned long soglia_reset_giorni;
const unsigned long RISVEGLI_AL_GIORNO = 37565; // Calcolati su WDT ~2.3s

// --- RITARDO SICURO CON PULIZIA WATCHDOG ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 1; k <= n; k++) {
        Delay_ms(1);
        asm clrwdt;
    }
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

// --- FUNZIONE LETTURA E CALCOLO ---
void Leggi_Batteria_mV() {
    valore_adc = ADC_Read(1);       // Prima lettura (scarto)
    Delay_Safe_ms(5);
    valore_adc = ADC_Read(1);       // Seconda lettura reale
    batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}

// --- SUBROUTINE GESTIONE COMPLETA: BATTERIA + RESET ---
void Gestione_Stato_Sistema() {
    // 1. LETTURA VOLTAGGIO EFFETTIVO
    Leggi_Batteria_mV();

    // 2. CONTROLLO LIMITI BATTERIA (Protezione)
    if (batteria_mv <= soglia_off) {
        GPIO.F2 = spento;
    }

    if (batteria_mv >= soglia_on) {
        GPIO.F2 = acceso;
    }

    // 3. CONTROLLO RIAVVIO PROGRAMMATO (Solo se abilitato e acceso)
    if (giorni_per_reset > 0) {
        // Calcoliamo la soglia dinamicamente
        soglia_reset_giorni = (unsigned long)giorni_per_reset * RISVEGLI_AL_GIORNO;

        if (conteggio_giorni >= soglia_reset_giorni) {
            // Reset Hardware solo se l'Heltec non è già spento
            if (GPIO.F2 == acceso) {
                GPIO.F2 = spento;        // Forza OFF
                Delay_Safe_ms(10000);   // 10 secondi scarica
                GPIO.F2 = acceso;        // Riavvio
            }
            conteggio_giorni = 0;       // Azzera il ciclo giorni
        }
    } else {
        // Se il reset è disabilitato (0), azzeriamo il contatore ogni giorno
        if (conteggio_giorni > RISVEGLI_AL_GIORNO) {
            conteggio_giorni = 0;
        }
    }
}

void Init_Hardware() {
    OSCCON = 0b01100111;    // 4MHz interno
    CMCON0 = 7;             // Comparatori OFF
    ANSEL  = 0b00010010;    // RA1 Analogico

    acceso = 0;
    spento = 1;

    // --- IMPOSTAZIONE INIZIALE E VARIABILI, SOGLIE ECC ---
    giorni_per_reset = 7;   // Reset ogni 7 gg (0 disabilita)
    conteggio_giorni = 0;
    soglia_off   = 3330;
    soglia_on    = 3700;
    taratura_vcc = 5070;

    GPIO.F2 = acceso;
    TRISIO = 0b00001011;

    OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
    WPU = 0b00000001;        // Pull-up su GP0
    INTCON.GPIE = 1;         // Abilita interrupt GPIO
    IOC.B0 = 1;              // Sveglia su GP0

    GPIO.F2 = spento;
    Leggi_Batteria_mV();

    if (batteria_mv > soglia_off) {
        GPIO.F2 = acceso;
    } else {
        GPIO.F2 = spento;
    }

    in_manutenzione = 0;
    asm clrwdt;
    Segnale_Avvio();
}

// --- SALVATAGGIO DATI IN EEPROM ---
// --- SALVATAGGIO DATI IN EEPROM (Versione Standard C) ---
void Salva_EEPROM() {
    Leggi_Batteria_mV();

    // Salvataggio valore_adc (16 bit)
    EEPROM_Write(0, (unsigned char)(valore_adc >> 8));   // Parte Alta (Hi)
    Delay_Safe_ms(20);
    EEPROM_Write(1, (unsigned char)(valore_adc));        // Parte Bassa (Lo)
    Delay_Safe_ms(20);

    EEPROM_Write(2, 0xFF); // Separatore
    Delay_Safe_ms(20);

    // Salvataggio batteria_mv (32 bit)
    EEPROM_Write(3, (unsigned char)(batteria_mv >> 24)); // Highest
    Delay_Safe_ms(20);
    EEPROM_Write(4, (unsigned char)(batteria_mv >> 16)); // Higher
    Delay_Safe_ms(20);
    EEPROM_Write(5, (unsigned char)(batteria_mv >> 8));  // Hi
    Delay_Safe_ms(20);
    EEPROM_Write(6, (unsigned char)(batteria_mv));       // Lo
    Delay_Safe_ms(20);
}

// --- MAIN PROGRAM ---
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
                if (i >= 10) GPIO.F5 = 1;
            }

            if (i >= 10 && i < 50) {
                Salva_EEPROM();
                // Feedback LED batterie
                if (batteria_mv > soglia_off && batteria_mv < soglia_on) {
                    for (i = 1; i <= 3; i++) {
                        GPIO.F5 = 1; Delay_ms(100);
                        GPIO.F5 = 0; Delay_ms(100);
                        asm clrwdt;
                    }
                }
                if (batteria_mv <= soglia_off) {
                    for (i = 1; i <= 6; i++) {
                        GPIO.F5 = 1; Delay_ms(100);
                        GPIO.F5 = 0; Delay_ms(100);
                        asm clrwdt;
                    }
                }

                GPIO.F2 = spento;
                GPIO.F5 = 0;
                Delay_Safe_ms(1000);

                if (batteria_mv > soglia_off) GPIO.F2 = acceso;
                else GPIO.F2 = spento;

                sveglie_wdt = 0;
                conteggio_giorni = 0;
            }

            if (i >= 50) {
                in_manutenzione = 1;
                GPIO.F2 = spento;
                for (i = 1; i <= 20; i++) {
                    GPIO.F5 = !GPIO.F5;
                    Delay_Safe_ms(100);
                }
                GPIO.F5 = 0;

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
                GPIO.F2 = acceso;
                sveglie_wdt = 0;
                conteggio_giorni = 0;
            }
        }

        // --- LOGICA PRINCIPALE (Ogni ~30s) ---
        if (!in_manutenzione) {
            if (sveglie_wdt >= 13) {
                Gestione_Stato_Sistema();
                sveglie_wdt = 0;
            }
        }

        // --- RISPARMIO ENERGETICO ---
        if (!in_manutenzione) {
            sveglie_wdt++;
            conteggio_giorni++;
            asm clrwdt;
            asm sleep;
            asm nop;
        } else {
            Delay_Safe_ms(100);
        }
    }
}