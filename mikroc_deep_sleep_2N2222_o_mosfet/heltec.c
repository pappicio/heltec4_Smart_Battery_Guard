// --- VARIABILI GLOBALI ---
unsigned long batteria_mv;
unsigned char i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned char dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;

// --- VARIABILI PER LETTURA CIFRE ---
unsigned long temp_mv;
unsigned char cifra;

// --- VARIABILI TIMER RIAVVIO ---
unsigned char giorni_riavvio;
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
        GP5_bit = 1;
        Delay_Safe_ms(250);
        GP5_bit = 0;
        Delay_Safe_ms(250);
    }
}

// --- SUBROUTINE LAMPEGGIO CIFRA ---
void Lampeggia_Cifra(unsigned char c) {
    unsigned char l;
    if (c == 0) {
        // Zero: lampeggio brevissimo
        GP5_bit = 1;
        Delay_ms(50);
        GP5_bit = 0;
    } else {
        for (l = 1; l <= c; l++) {
            GP5_bit = 1;
            Delay_ms(250);
            GP5_bit = 0;
            Delay_ms(250);
            asm clrwdt;
        }
    }
    Delay_Safe_ms(1000);
}

void Leggi_Batteria_mV() {
    unsigned char i_adc;
    unsigned int somma;
    unsigned int media_pulita;

    somma = 0;

    // 1. Ciclo di 64 campioni (2ms l'uno = 128ms totali)
    for (i_adc = 1; i_adc <= 64; i_adc++) {
        somma = somma + ADC_Read(1);
        Delay_ms(1);
    }

    // 2. Media per 64 campioni (Shift 6)
    media_pulita = somma >> 6;

    // 3. Conversione finale in Millivolt
    batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
}

void soglia_batteria() {
    if (batteria_mv <= soglia_off) {
        GP5_bit = 0;
        Delay_Safe_ms(500);
        // Batteria CRITICA (Sotto 3.33V): 6 lampi rapidi
        for (j = 1; j <= 6; j++) {
            GP5_bit = 1;
            Delay_Safe_ms(100);
            GP5_bit = 0;
            Delay_Safe_ms(100);
            asm clrwdt;
        }
    } else {
        if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
            // Batteria MEDIA (Zona Gialla): 3 lampi rapidi
            Delay_Safe_ms(500);
            for (j = 1; j <= 3; j++) {
                GP5_bit = 1;
                Delay_Safe_ms(100);
                GP5_bit = 0;
                Delay_Safe_ms(100);
                asm clrwdt;
            }
        }
    }
}

// --- INIZIALIZZAZIONE ---
void Init_Hardware() {
    OSCCON = 0b01100111;
    CMCON0 = 7;
    ANSEL  = 0b00010010;
    TRISIO = 0b00001011;
    OPTION_REG = 0b00001111;
    WPU = 0b00000001;
    INTCON.GPIE = 1;
    IOC.B0 = 1;

    // SOGLIE DA MODIFICARE SECONDO LE MISURAZIONI CON MULTIMETRO!!!
    soglia_off   = 3300;  // 3300 mV
    soglia_on    = 3600;  // (45%)
    taratura_vcc = 5050;  // 5050 mV
    giorni_riavvio = 3;
    
    //////////////////////////////////////////////////////////////////
    conteggio_cicli = 0;
    cicli_per_giorno = 2883;

    GP2_bit = 1;
    GP5_bit = 0;
    Delay_Safe_ms(500);
    Segnale_Triplo();
    Delay_Safe_ms(500);
    Leggi_Batteria_mV();

    if (batteria_mv > soglia_off) {
        GP2_bit = 0;
    }

    in_manutenzione = 0;
    asm clrwdt;

    soglia_batteria();
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

        if (GP0_bit == 0) {
            i = 0;
            while (GP0_bit == 0 && i < 50) {
                Delay_Safe_ms(100);
                i = i + 1;
                if (i == 10) GP5_bit = 1;
                if (i == 25) GP5_bit = 0;
            }

            // 1. RESET RAPIDO (1-2s)
            if (i >= 10 && i < 25) {
                GP5_bit = 0;
                Leggi_Batteria_mV();

                if (batteria_mv < soglia_on) {
                    soglia_batteria();
                }

                GP2_bit = 1;
                Delay_Safe_ms(2000);

                if (batteria_mv > soglia_off) {
                    GP2_bit = 0;
                }

                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }

            // 2. VISUALIZZAZIONE VOLT (2-5s)
            if (i >= 25 && i < 50) {
                GP5_bit = 0;
                Leggi_Batteria_mV();
                Delay_Safe_ms(1000);

                temp_mv = batteria_mv;
                cifra = temp_mv / 1000;
                Lampeggia_Cifra(cifra);
                temp_mv = temp_mv % 1000;

                cifra = temp_mv / 100;
                Lampeggia_Cifra(cifra);
                temp_mv = temp_mv % 100;

                cifra = temp_mv / 10;
                Lampeggia_Cifra(cifra);

                cifra = 0; // forza sempre a 0 quarto valore
                Lampeggia_Cifra(cifra);

                Delay_Safe_ms(1000);
            }

            // 3. MANUTENZIONE (>5s)
            if (i >= 50) {
                GP2_bit = 1;
                for (j = 1; j <= 20; j++) {
                    GP5_bit = !GP5_bit;
                    Delay_Safe_ms(100);
                }
                GP5_bit = 0;
                in_manutenzione = 1;
                while (in_manutenzione == 1) {
                    GP5_bit = 1;
                    Delay_Safe_ms(500);
                    GP5_bit = 0;
                    if (GP0_bit == 0) {
                        i = 0;
                        while (GP0_bit == 0 && i < 50) {
                            Delay_Safe_ms(100);
                            i = i + 1;
                        }
                        if (i >= 50) {
                            in_manutenzione = 0;
                            for (j = 1; j <= 20; j++) {
                                GP5_bit = !GP5_bit;
                                Delay_Safe_ms(100);
                            }
                        }
                    } else {
                        Delay_Safe_ms(500);
                    }
                }
                GP2_bit = 0;
                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }
        }

        if (in_manutenzione == 0) {
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();
                if (batteria_mv <= soglia_off) {
                    GP2_bit = 1;
                }
                if (batteria_mv >= soglia_on) {
                    GP2_bit = 0;
                }

                if (giorni_riavvio > 0) {
                    conteggio_cicli = conteggio_cicli + 1;
                    if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
                        GP2_bit = 1;
                        Delay_Safe_ms(2000);
                        if (batteria_mv > soglia_off) {
                            GP2_bit = 0;
                        }
                        conteggio_cicli = 0;
                    }
                }
                sveglie_wdt = 0;
            }
            sveglie_wdt = sveglie_wdt + 1;
            asm clrwdt;
            asm sleep;
            asm nop;
        } else {
            Delay_Safe_ms(100);
        }
    }
}