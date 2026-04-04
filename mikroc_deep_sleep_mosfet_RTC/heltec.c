/*
 * Program: Solar_Power_Manager_683_Final_V12_RTC
 * Tradotto in mikroC
 */

// --- CONFIGURAZIONE PIN I2C SOFTWARE ---
// Scambiati pin per I2C su GP0 e GP2
sbit Soft_I2C_Scl           at GP0_bit;
sbit Soft_I2C_Sda           at GP2_bit;
sbit Soft_I2C_Scl_Direction at TRISIO0_bit;
sbit Soft_I2C_Sda_Direction at TRISIO2_bit;

bit RTC_presente;
bit finestra_oraria;
bit spento;

// --- VARIABILI GLOBALI ---
unsigned int batteria_mv;       // Memorizza la tensione batteria in millivolt
unsigned short i, j;            // Variabili di utilità per cicli e conteggi
unsigned int sveglie_wdt;       // Conta quante volte il Watchdog ha svegliato il chip
bit in_manutenzione;            // Flag per lo stato di blocco manutenzione
unsigned short dummy;           // Variabile di appoggio per lettura GPIO
unsigned int soglia_off, soglia_on; // Limiti di tensione per distacco/riattacco
unsigned int taratura_vcc;      // Valore di riferimento per calibrazione ADC

unsigned int val_da_lampeggiare;

// --- VARIABILI RTC E CONVERSIONE ---
unsigned short ore, minuti, giorno; // AGGIUNTO giorno_mese
bit reset_fatto;
unsigned short minuti_count;        // Contatore per arrivare a 10 minuti

// --- VARIABILI PER TIMER RIAVVIO ---
unsigned short giorni_riavvio;      // Impostazione giorni tra un reset e l'altro
unsigned long conteggio_cicli;      // Contatore cicli WDT trascorsi
unsigned int cicli_per_giorno;      // Numero di cicli WDT calcolati per 24 ore

// --- RITARDO SICURO (Mantiene il Watchdog pulito durante le pause) ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 1; k <= n; k++) {
        Delay_us(978); // Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni...
        asm clrwdt;    // Reset del Watchdog ad ogni millisecondo
    }
}

// --- SUBROUTINE LAMPEGGIO CIFRA (Traduce numeri in impulsi luminosi) ---
void Lampeggia_Cifra(unsigned short c) {
    unsigned short l;
    if (c == 0) {
        // Zero: lampeggio brevissimo per distinguerlo
        GP5_bit = 1; // LED su GP5
        Delay_Safe_ms(50);
        GP5_bit = 0;
    } else {
        for (l = 1; l <= c; l++) {
            GP5_bit = 1;        // Accende LED su GP5
            Delay_Safe_ms(250); // Pausa accensione
            GP5_bit = 0;        // Spegne LED
            Delay_Safe_ms(250); // Pausa tra lampi
            asm clrwdt;         // Mantiene il sistema attivo
        }
    }
    Delay_Safe_ms(1000); // Pausa lunga tra una cifra e l'altra
}

// Questa funzione estrae le cifre sottraendo. Occupa molta meno ROM.
void Estrai_e_Lampeggia(unsigned int divisore) {
    unsigned short contatore = 0;
    while (val_da_lampeggiare >= divisore) {
        val_da_lampeggiare -= divisore;
        contatore++;
    }
    Lampeggia_Cifra(contatore);
}

// --- LETTURA ORA RTC (CORRETTA) ---
void Leggi_Ora_RTC() {
    unsigned short bcd_temp;

    GP5_bit = 1;         // Accende tutto (LED su GP5)
    Delay_Safe_ms(100);  // Tempo di sveglia

    // Reset Bus
    Soft_I2C_Start();
    Soft_I2C_Stop();
    Delay_Safe_ms(10);

    // --- LETTURA MINUTI ---
    Soft_I2C_Start();
    Soft_I2C_Write(0xD0);
    Soft_I2C_Write(0x01);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);
    bcd_temp = Soft_I2C_Read(0);
    Soft_I2C_Stop();
    // Conversione BCD -> DEC
    minuti = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

    Delay_Safe_ms(10);

    // --- LETTURA ORE ---
    Soft_I2C_Start();
    Soft_I2C_Write(0xD0);
    Soft_I2C_Write(0x02);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);
    bcd_temp = Soft_I2C_Read(0);
    Soft_I2C_Stop();
    // Pulisce bit 12/24h e converte BCD -> DEC
    bcd_temp &= 0x3F;
    ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

    GP5_bit = 0; // Spegne tutto
}

// --- LETTURA ANALOGICA E MEDIA ---
void Leggi_Batteria_mV() {
    unsigned short i_adc;
    unsigned long somma = 0;
    unsigned int media_pulita;

    // 1. Ciclo di 64 campioni (2ms l'uno = 128ms totali)
    for (i_adc = 1; i_adc <= 64; i_adc++) {
        somma += ADC_Read(1); // Legge il valore analogico su AN1
        Delay_Safe_ms(1);     // Pausa tra letture
    }

    // 2. Media per 64 campioni (Shift 6 equivale a dividere per 64)
    media_pulita = (unsigned int)(somma >> 6);

    // 3. Conversione finale in Millivolt (Normalizzazione a 10 bit)
    batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
}

// Unifica tutti i segnali visivi in una sola sub
void Lampi(unsigned short n, unsigned int t_on) {
    for (j = 1; j <= n; j++) {
        GP5_bit = 1; // LED su GP5
        Delay_Safe_ms(t_on);
        GP5_bit = 0;
        Delay_Safe_ms(t_on);
    }
}

// --- FEEDBACK VISIVO STATO BATTERIA ---
void soglia_batteria() {
    if (batteria_mv <= soglia_off) {
        GP5_bit = 0; // Spegne LED su GP5
        Delay_Safe_ms(500);
        // Batteria CRITICA (Sotto 3.33V): 6 lampi rapidi
        Lampi(6, 100);
    } else {
        if ((batteria_mv > soglia_off) && (batteria_mv <= soglia_on)) {
            // Batteria MEDIA (Zona Gialla): 3 lampi rapidi
            Delay_Safe_ms(500);
            Lampi(3, 100);
        }
    }
}

// Parametri attesi in formato BCD (es. per il giorno 30 scrivi 0x30)
void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
    GP5_bit = 1; // LED su GP5
    Delay_Safe_ms(100);
    Soft_I2C_Init(); // Inizializza
    Delay_Safe_ms(100);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD0); // Indirizzo DS3231 (Scrittura)
    Soft_I2C_Write(0x00); // Inizia dal registro 0 (Secondi)
    Soft_I2C_Write(0x00); // Secondi (sempre 00)
    Soft_I2C_Write(s_min); // Minuti (es. 0x05)
    Soft_I2C_Write(s_ore); // Ore (es. 0x04)
    Soft_I2C_Write(s_g_sett); // Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
    Soft_I2C_Write(s_g);   // Giorno Mese (es. 0x30)
    Soft_I2C_Write(s_m);   // Mese (es. 0x03)
    Soft_I2C_Write(s_a);   // Anno (es. 0x26)
    Soft_I2C_Stop();
    Delay_Safe_ms(800);
    GP5_bit = 0;
    Delay_Safe_ms(500);
}

// --- INIZIALIZZAZIONE ---
void Init_Hardware() {
    // Imposta l'oscillatore interno a 4MHz e lo stabilizza
    RTC_presente = 0;
    OSCCON = 0b01100111;

    // Disabilita i comparatori analogici per usare i pin come I/O digitali
    CMCON0 = 7;

    // Configura GP1 come ingresso analogico (AN1) e imposta il clock ADC
    ANSEL = 0b00010010;

    // Configura la direzione: GP1, GP3 Input; GP0, GP2, GP4, GP5 Output
    TRISIO = 0b00001010;

    // Abilita Pull-up e assegna il Prescaler 1:128 al Watchdog (~2.3s)
    OPTION_REG = 0b00001111;

    // Pull-up interna non disponibile su GP3 (MCLR)
    WPU = 0b00000000;

    // Abilita l'interrupt generale per il cambiamento di stato dei pin
    INTCON.GPIE = 1;

    // Specifica il pin GP3 come sorgente dell'interrupt on change
    IOC.B3 = 1;

    // Azzera il contatore dei cicli all'avvio
    conteggio_cicli = 0;

    // Imposta il numero di cicli per coprire 24h reali (correzione 29.9s)
    cicli_per_giorno = 2883;

    spento = 0;

    // SOGLIE DA MODIFICARE SECONDO LE MISURAZIONI CON MULTIMETRO!!!
    soglia_off   = 3300;
    soglia_on    = 3600;
    taratura_vcc = 5050;
    giorni_riavvio = 0;

    // Forza GP4 alto: spegne il carico (Mosfet P-channel) all'accensione
    GP4_bit = 1;

    // Assicura che il LED (GP5) sia spento
    GP5_bit = 0;

    RTC_presente = 0;
    finestra_oraria = 0;
    giorni_riavvio = 3;

    // --- LOGICA DI SINCRONIZZAZIONE MANUALE RTC ---
    if (RTC_presente == 1) {
        TRISIO.B0 = 0; // SDA come Uscita
        TRISIO.B2 = 0; // SCL come Uscita
        GP0_bit = 1;   // SDA Alto (Idle)
        GP2_bit = 1;   // SCL Alto (Idle)

        giorni_riavvio = 0;
        i = 0;
        while ((GP3_bit == 0) && (i < 15)) {
            GP5_bit = 1;
            Delay_Safe_ms(100);
            i++;
        }

        if (i == 15) {
            GP5_bit = 0;
            // Chiamata: GiornoSettimana, Giorno, Mese, Anno, Ore, Minuti
            Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
            GP5_bit = 0;
            Delay_Safe_ms(500);
            Lampi(10, 100);
            Delay_Safe_ms(500);
        }
    } else {
        TRISIO.B0 = 1; // SDA in Alta Impedenza
        TRISIO.B2 = 1; // SCL in Alta Impedenza
        GP0_bit = 0;
        GP2_bit = 0;
    }

    GP5_bit = 0;
    Delay_Safe_ms(500);
    Lampi(3, 250);
    Delay_Safe_ms(500);
    Leggi_Batteria_mV();

    if (batteria_mv > soglia_off) {
        GP4_bit = 0;
        spento = 0;
    } else {
        spento = 1;
    }

    in_manutenzione = 0;
    reset_fatto = 0;
    sveglie_wdt = 0;

    soglia_batteria();
}

// --- MAIN ---
void main() {
    Init_Hardware();

    while (1) {
        // Gestione del flag interrupt: pulisce il cambio stato pin
        if (INTCON.GPIF == 1) {
            dummy = GPIO;
            INTCON.GPIF = 0;
        }

        // --- GESTIONE PRESSIONE PULSANTE (GP3) ---
        if (GP3_bit == 0) {
            i = 0;
            while ((GP3_bit == 0) && (i < 50)) {
                Delay_Safe_ms(100);
                i++;
                if (i == 10) GP5_bit = 1;
                if (i == 25) GP5_bit = 0;
            }

            // --- 1. RESET RAPIDO CON DIAGNOSTICA (1-2s) ---
            if ((i >= 10) && (i < 25)) {
                GP5_bit = 0;
                Leggi_Batteria_mV();
                GP4_bit = 1;
                Delay_Safe_ms(2000);

                if (batteria_mv > soglia_off) {
                    GP4_bit = 0;
                    spento = 0;
                } else {
                    spento = 1;
                }
                GP5_bit = 0;
                if (batteria_mv < soglia_on) soglia_batteria();
                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }

            // --- 2. VISUALIZZAZIONE VOLT (2-5s) ---
            if ((i >= 25) && (i < 50)) {
                GP5_bit = 0;
                Leggi_Batteria_mV();
                Delay_Safe_ms(1000);

                val_da_lampeggiare = batteria_mv;
                Estrai_e_Lampeggia(1000);
                Estrai_e_Lampeggia(100);
                Estrai_e_Lampeggia(10);
                Lampeggia_Cifra(0);

                if (RTC_presente == 1) {
                    Delay_Safe_ms(1000);
                    Lampi(2, 100);
                    Leggi_Ora_RTC();
                    GP5_bit = 1;
                    Delay_Safe_ms(100);
                    GP5_bit = 0;
                    Delay_Safe_ms(1000);
                    val_da_lampeggiare = ore;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
                    Delay_Safe_ms(1000);
                    val_da_lampeggiare = minuti;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
                }
            }

            // --- 3. MANUTENZIONE (>5s) ---
            if (i >= 50) {
                GP4_bit = 1;
                for (j = 1; j <= 20; j++) {
                    GP5_bit = !GP5_bit;
                    Delay_Safe_ms(100);
                }
                GP5_bit = 0;
                in_manutenzione = 1;
                while (in_manutenzione) {
                    GP5_bit = 1;
                    Delay_Safe_ms(500);
                    GP5_bit = 0;
                    if (GP3_bit == 0) {
                        i = 0;
                        while ((GP3_bit == 0) && (i < 50)) {
                            Delay_Safe_ms(100);
                            i++;
                        }
                        if (i >= 50) {
                            in_manutenzione = 0;
                            for (j = 1; j <= 20; j++) {
                                GP5_bit = !GP5_bit;
                                Delay_Safe_ms(100);
                            }
                            GP5_bit = 0;
                        }
                    } else {
                        Delay_Safe_ms(500);
                    }
                    asm clrwdt;
                }
                Leggi_Batteria_mV();
                if (batteria_mv > soglia_off) {
                    GP4_bit = 0;
                    spento = 0;
                } else {
                    spento = 1;
                }
                if (batteria_mv < soglia_on) soglia_batteria();
                sveglie_wdt = 13;
                conteggio_cicli = 0;
                minuti_count = 0;
                asm clrwdt;
            }
        }

        // --- GESTIONE RISPARMIO ENERGETICO E CONTROLLI ---
        if (!in_manutenzione) {
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();
                if (batteria_mv <= soglia_off) {
                    GP4_bit = 1;
                    spento = 1;
                }
                if (batteria_mv >= soglia_on) {
                    GP4_bit = 0;
                    spento = 0;
                }

                sveglie_wdt = 0;

                if (RTC_presente == 1) {
                    giorni_riavvio = 0;
                    minuti_count++;
                } else {
                    minuti_count = 0;
                    finestra_oraria = 0;
                }

                if (giorni_riavvio > 0) {
                    conteggio_cicli++;
                    if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
                        GP4_bit = 1;
                        Delay_Safe_ms(2000);
                        if (batteria_mv > soglia_off) {
                            GP4_bit = 0;
                            spento = 0;
                        } else {
                            spento = 1;
                        }
                        conteggio_cicli = 0;
                    }
                }

                if (minuti_count >= 20) {
                    Leggi_Ora_RTC();
                    if (finestra_oraria == 0) {
                        if (ore == 4) {
                            if (reset_fatto == 0) {
                                if ((giorno == 1) || (giorno == 4)) {
                                    GP4_bit = 1;
                                    Delay_Safe_ms(10000);
                                    if ((batteria_mv > soglia_off) && (spento == 0)) GP4_bit = 0;
                                    reset_fatto = 1;
                                }
                            }
                        } else {
                            reset_fatto = 0;
                        }
                    } else {
                        if ((ore >= 7) && (ore < 13)) {
                            if ((batteria_mv > soglia_off) && (spento == 0)) {
                                GP4_bit = 0;
                            } else {
                                GP4_bit = 1;
                            }
                        } else {
                            GP4_bit = 1;
                        }
                    }
                    minuti_count = 0;
                }
            }

            sveglie_wdt++;
            asm clrwdt;
            asm sleep;
            asm nop;

        } else {
            Delay_Safe_ms(100);
            asm clrwdt;
        }
    }
}