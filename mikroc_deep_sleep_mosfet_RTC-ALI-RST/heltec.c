/*
 * Program: Solar_Power_Manager_683_Final_V12_RTC
 * Porting da mikroBasic a mikroC
 */

// --- CONFIGURAZIONE PIN I2C SOFTWARE ---
// Scambiati pin per I2C su GP0 e GP2
sbit Soft_I2C_Scl           at GP0_bit;
sbit Soft_I2C_Sda           at GP2_bit;
sbit Soft_I2C_Scl_Direction at TRISIO0_bit;
sbit Soft_I2C_Sda_Direction at TRISIO2_bit;

bit RSTpin;
bit attivo;

bit RTC_presente;
bit finestra_oraria;
bit spento;

// --- VARIABILI GLOBALI ---
unsigned int batteria_mv;         // Memorizza la tensione batteria in millivolt
unsigned char i, j;               // Variabili di utilità per cicli e conteggi
unsigned int sveglie_wdt;         // Conta quante volte il Watchdog ha svegliato il chip
bit in_manutenzione;              // Flag per lo stato di blocco manutenzione
unsigned char dummy;              // Variabile di appoggio per lettura GPIO
unsigned int soglia_off, soglia_on; // Limiti di tensione per distacco/riattacco
unsigned int taratura_vcc;        // Valore di riferimento per calibrazione ADC

unsigned int val_da_lampeggiare;

// --- VARIABILI RTC E CONVERSIONE ---
unsigned char ore, minuti, giorno; // AGGIUNTO giorno_mese
unsigned char bcd_val, dec_val;
bit reset_fatto;
unsigned char minuti_count;        // Contatore per arrivare a 10 minuti

// --- VARIABILI TIMER RIAVVIO ---
unsigned char giorni_riavvio;      // Impostazione giorni tra un reset e l'altro
unsigned long conteggio_cicli;     // Contatore cicli WDT trascorsi
unsigned int cicli_per_giorno;     // Numero di cicli WDT calcolati per 24 ore

// --- RITARDO SICURO (Mantiene il Watchdog pulito durante le pause) ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 1; k <= n; k++) {
        Delay_us(978);             // Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
        asm clrwdt;                // Reset del Watchdog ad ogni millisecondo
    }
}

// --- SUBROUTINE LAMPEGGIO CIFRA (Traduce numeri in impulsi luminosi) ---
void Lampeggia_Cifra(unsigned char c) {
    unsigned char l;
    if (c == 0) {
        // Zero: lampeggio brevissimo per distinguerlo
        GPIO.F5 = 1; // LED su GP5
        Delay_Safe_ms(50);
        GPIO.F5 = 0;
    } else {
        for (l = 1; l <= c; l++) {
            GPIO.F5 = 1;           // Accende LED su GP5
            Delay_Safe_ms(250);    // Pausa accensione
            GPIO.F5 = 0;           // Spegne LED
            Delay_Safe_ms(250);    // Pausa tra lampi
            asm clrwdt;            // Mantiene il sistema attivo
        }
    }
    Delay_Safe_ms(1000);           // Pausa lunga tra una cifra e l'altra
}

// Questa funzione estrae le cifre sottraendo. Occupa molta meno ROM.
void Estrai_e_Lampeggia(unsigned int divisore) {
    unsigned char contatore;
    contatore = 0;
    while (val_da_lampeggiare >= divisore) {
        val_da_lampeggiare = val_da_lampeggiare - divisore;
        contatore = contatore + 1;
    }
    Lampeggia_Cifra(contatore);
}

// --- LETTURA ORA RTC ---
// --- LETTURA ORA RTC (CORRETTA) ---
void Leggi_Ora_RTC() {
    unsigned char bcd_temp;

    GPIO.F5 = 1;          // Accende tutto (LED su GP5)
    Delay_Safe_ms(100);   // Tempo di sveglia

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
    bcd_temp = bcd_temp & 0x3F;
    ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

    GPIO.F5 = 0;          // Spegne tutto
}

// --- LETTURA ANALOGICA E MEDIA ---
void Leggi_Batteria_mV() {
    unsigned char i_idx;
    unsigned long somma;
    unsigned int media_pulita;

    somma = 0;
    // 1. Ciclo di 64 campioni (2ms l'uno = 128ms totali)
    for (i_idx = 1; i_idx <= 64; i_idx++) {
        somma = somma + ADC_Read(1); // Legge il valore analogico su AN1
        Delay_Safe_ms(1);            // Pausa tra letture
    }

    // 2. Media per 64 campioni (Shift 6 equivale a dividere per 64)
    media_pulita = (unsigned int)(somma >> 6);

    // 3. Conversione finale in Millivolt (Normalizzazione a 10 bit)
    batteria_mv = (unsigned int)(((unsigned long)media_pulita * taratura_vcc) >> 10);
}

// Unifica tutti i segnali visivi in una sola sub
void Lampi(unsigned char n, unsigned int t_on) {
    for (j = 1; j <= n; j++) {
        GPIO.F5 = 1; // LED su GP5
        Delay_Safe_ms(t_on);
        GPIO.F5 = 0;
        Delay_Safe_ms(t_on);
    }
}

// --- FEEDBACK VISIVO STATO BATTERIA ---
void soglia_batteria() {
    if (batteria_mv <= soglia_off) {
        GPIO.F5 = 0;                   // Spegne LED su GP5
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
void Scrivi_Ora_RTC(unsigned char s_g_sett, unsigned char s_g, unsigned char s_m, unsigned char s_a, unsigned char s_ore, unsigned char s_min) {
    GPIO.F5 = 1; // LED su GP5
    Delay_Safe_ms(100);
    Soft_I2C_Init();     // Inizializza
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
    GPIO.F5 = 0;
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

    // Pull-up interna non disponibile su GP3 (MCLR), ma necessaria su GP0 se usato
    WPU = 0b00000000;

    // Abilita l'interrupt generale per il cambiamento di stato dei pin
    INTCON.GPIE = 1;

    // Specifica il pin GP3 come sorgente dell'interrupt on change
    IOC.F3 = 1;

    // Azzera il contatore dei cicli all'avvio
    conteggio_cicli = 0;

    // Imposta il numero di cicli per coprire 24h reali (correzione 29.9s)
    cicli_per_giorno = 2883;

    spento = 0;
    attivo = 1;

    //SOGLIE DA MODIFICARE SECONDO LE MISURAZIONI CON MULTIMETRO!!!
    RSTpin = 1; // true

////////////////////////////////////////////////////////////////////////////////////////////////////////////
    RTC_presente = 1; //se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
////////////////////////////////////////////////////////////////////////////////////////////////////////////

    finestra_oraria = 0;
    giorni_riavvio = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

    soglia_off   = 3300;  //300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
    soglia_on    = 3600;  //(45%), va piu che bene
    taratura_vcc = 5010;  //segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
    giorni_riavvio = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (RSTpin == 1) {
        attivo = 0;
    }

    // Forza GP4 alto: spegne il carico (Mosfet P-channel) all'accensione (Nuovo PIN)
    GPIO.F4 = attivo;

    // Assicura che il LED (GP5) sia spento
    GPIO.F5 = 0;

    // --- LOGICA DI SINCRONIZZAZIONE MANUALE RTC ---
    // Controlliamo se il tasto (GP3) è premuto all'avvio
    // Aspettiamo circa 1 secondo per confermare l'intenzione
    if (RTC_presente == 1) {
        // --- CONFIGURAZIONE PER RTC PRESENTE ---
        TRISIO.F0 = 0;    // SDA come Uscita (GP0)
        TRISIO.F2 = 0;    // SCL come Uscita (GP2)
        GPIO.F0 = 1;      // SDA Alto (Idle I2C)
        GPIO.F2 = 1;      // SCL Alto (Idle I2C)

        giorni_riavvio = 0;
        i = 0;
        while ((GPIO.F3 == 0) && (i < 15)) {
            GPIO.F5 = 1; // LED su GP5
            Delay_Safe_ms(100);
            i = i + 1;
        }

        // Se il tasto è stato tenuto premuto per 1.5 secondi (15 * 100ms)
        if (i == 15) {
            GPIO.F5 = 0;
            // COMMENTO DATI PER RTC (Formato BCD):
            // Giorno: 30 Marzo 2026 -> 0x30, 0x03, 0x26
            // Ora:   04:05:00        -> 0x04, 0x05
            // Giorno Settimana: 1    -> 0x01 (Lunedì)  , 0=domenica, 6= sabato
            // Chiamata: GiornoSettimana, Giorno, Mese, Anno, Ore, Minuti
            //esempio; data: Lunedì, 30.03.2026 , ore: 04.05
            Scrivi_Ora_RTC(0x06, 0x04, 0x04, 0x26, 0x20, 0x55);
            GPIO.F5 = 0;
            Delay_Safe_ms(500);
            // Feedback: 10 lampeggi rapidi (100ms)
            Lampi(10, 100);
            Delay_Safe_ms(500);
        }
    } else {
        // --- CONFIGURAZIONE PER RTC ASSENTE (BYPASS) ---
        TRISIO.F0 = 1;    // SDA in Alta Impedenza (Input)
        TRISIO.F2 = 1;    // SCL in Alta Impedenza (Input)
        GPIO.F0 = 0;
        GPIO.F2 = 0;
    }
    GPIO.F5 = 0;

    // Attesa di mezzo secondo per stabilizzare le tensioni
    Delay_Safe_ms(500);

    // Esegue tre lampeggi per confermare l'avvio del firmware
    Lampi(3, 250);

    // Altra piccola pausa di sicurezza prima della lettura ADC
    Delay_Safe_ms(500);

    // Esegue la prima scansione della tensione batteria
    Leggi_Batteria_mV();

    // Se la tensione letta è sicura, porta GP4 a massa per alimentare l'Heltec (Nuovo PIN Mosfet)
    if (batteria_mv > soglia_off) {
        GPIO.F4 = !attivo;
        spento = 0;
    } else {
        spento = 1;
    }

    // Inizializza la variabile di stato manutenzione come falsa
    in_manutenzione = 0;
    reset_fatto = 0;
    sveglie_wdt = 0;  // Forza lettura batteria al primo giro

    // Esegue il feedback LED basato sul voltaggio appena letto
    soglia_batteria();
}

// --- MAIN ---
void main() {
    Init_Hardware();                // Configura il chip

    while (1) {
        // Gestione del flag interrupt: pulisce il cambio stato pin
        if (INTCON.GPIF == 1) {
            dummy = GPIO;
            INTCON.GPIF = 0;
        }

        // --- GESTIONE PRESSIONE PULSANTE (GP3) ---
        if (GPIO.F3 == 0) {
            i = 0;
            while ((GPIO.F3 == 0) && (i < 50)) {
                Delay_Safe_ms(100); // Campionamento pressione (100ms * 50 = 5s max)
                i = i + 1;
                if (i == 10) {
                    GPIO.F5 = 1;     // Accende LED dopo 1 secondo di pressione (GP5)
                }
                if (i == 25) {
                    GPIO.F5 = 0;     // Spegne LED dopo 2.5 secondi (cambio modalità)
                }
            }

            // --- 1. RESET RAPIDO CON DIAGNOSTICA (1-2s) ---
            if ((i >= 10) && (i < 25)) {
                GPIO.F5 = 0;
                Leggi_Batteria_mV();

                // Esecuzione Reset Fisico Heltec (Spegne/Pausa/Riaccende) su GP4
                GPIO.F4 = attivo;
                Delay_Safe_ms(2000);

                // Riaccende solo se non siamo sotto soglia critica
                if (batteria_mv > soglia_off) {
                    GPIO.F4 = !attivo;
                    spento = 0;
                } else {
                    spento = 1;
                }
                GPIO.F5 = 0;
                if (batteria_mv < soglia_on) {
                    soglia_batteria();
                }
                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }

            // --- 2. VISUALIZZAZIONE VOLT (2-5s) ---
            if ((i >= 25) && (i < 50)) {
                GPIO.F5 = 0;
                Leggi_Batteria_mV();
                Delay_Safe_ms(1000);

                // Prepariamo il valore (es. 3650)
                val_da_lampeggiare = batteria_mv;

                Estrai_e_Lampeggia(1000); // Migliaia
                Estrai_e_Lampeggia(100);  // Centinaia
                Estrai_e_Lampeggia(10);   // Decine
                Lampeggia_Cifra(0);       // Unità fisse

                // --- VISUALIZZAZIONE ORA ---
                if (RTC_presente == 1) {
                    Delay_Safe_ms(1000);
                    Lampi(2, 100);
                    Leggi_Ora_RTC();
                    GPIO.F5 = 1;
                    Delay_Safe_ms(100);
                    GPIO.F5 = 0;
                    Delay_Safe_ms(1000);
                    // Ore
                    val_da_lampeggiare = (unsigned int)ore;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra((unsigned char)val_da_lampeggiare); // Il resto sono le unità

                    Delay_Safe_ms(1000);

                    // Minuti
                    val_da_lampeggiare = (unsigned int)minuti;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra((unsigned char)val_da_lampeggiare);
                }
            }

            // --- 3. MANUTENZIONE (>5s) ---
            if (i >= 50) {
                GPIO.F4 = attivo;                       // Distacca il carico (Heltec OFF) su GP4
                // Lampeggio veloce di conferma ingresso (10 cicli ON/OFF = 20 passaggi)
                for (j = 1; j <= 20; j++) {
                    GPIO.F5 = !GPIO.F5;         // Lampeggio veloce di conferma
                    Delay_Safe_ms(100);
                }
                GPIO.F5 = 0;
                in_manutenzione = 1;          // Entra nel loop di blocco
                while (in_manutenzione == 1) {
                    // Segnale visivo di stato: LED attivo 500ms / spento 500ms
                    GPIO.F5 = 1;
                    Delay_Safe_ms(500);
                    GPIO.F5 = 0;
                    if (GPIO.F3 == 0) {        // Controlla se si preme di nuovo per uscire
                        i = 0;
                        while ((GPIO.F3 == 0) && (i < 50)) {
                            Delay_Safe_ms(100);
                            i = i + 1;
                        }
                        if (i >= 50) {       // Uscita dopo altri 5 secondi
                            in_manutenzione = 0;
                            // Lampeggio veloce di conferma uscita
                            for (j = 1; j <= 20; j++) {
                                GPIO.F5 = !GPIO.F5;
                                Delay_Safe_ms(100);
                            }
                            GPIO.F5 = 0;
                        }
                    } else {
                        Delay_Safe_ms(500);
                    }
                    asm clrwdt;
                }
                // Uscita dalla manutenzione: reset contatori e riaccensione
                Leggi_Batteria_mV();
                if (batteria_mv > soglia_off) {
                   GPIO.F4 = !attivo; // Carico ON
                   spento = 0;
                } else {
                   spento = 1;
                }
                if (batteria_mv < soglia_on) {
                    soglia_batteria();
                }
                sveglie_wdt = 13; // Forza controllo batteria subito
                conteggio_cicli = 0;
                minuti_count = 0;
                asm clrwdt;
            }
        }

        // --- GESTIONE RISPARMIO ENERGETICO E CONTROLLI ---
        if (in_manutenzione == 0) {
            // Controllo batteria ogni ~30 secondi (13 risvegli WDT)
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();
                // Protezione batteria scarica
                if (batteria_mv <= soglia_off) {
                    GPIO.F4 = attivo; // Spegne Heltec su GP4
                    spento = 1;
                }
                // Isteresi: riaccende solo se carica
                if (batteria_mv >= soglia_on) {
                    GPIO.F4 = !attivo; // Accende Heltec
                    spento = 0;
                }

                sveglie_wdt = 0; // Reset qui dopo il controllo batteria

                if (RTC_presente == 1) {
                    giorni_riavvio = 0;
                    minuti_count = minuti_count + 1;
                } else {
                    minuti_count = 0;
                    finestra_oraria = 0;
                }

                // Gestione Timer Riavvio Automatico
                if (giorni_riavvio > 0) {
                    conteggio_cicli = conteggio_cicli + 1;
                    // Verifica se sono passati i giorni impostati
                    if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
                        GPIO.F4 = attivo;           // Ciclo di spegnimento GP4
                        Delay_Safe_ms(2000);
                        if (batteria_mv > soglia_off) {
                            GPIO.F4 = !attivo;       // Riaccensione
                            spento = 0;
                        } else {
                           spento = 1;
                        }
                        conteggio_cicli = 0;  // Reset timer
                    }
                }

                // --- CONTROLLO RTC OGNI 10 MINUTI (20 * 30s) ---
                if (minuti_count >= 20) {
                    Leggi_Ora_RTC();

                    //RIAVVIAMO ogni 3 GG ALLE 4 CON CON RTC PRESENTE!
                    if (finestra_oraria == 0) {
                        //riavviaomo alle 4 di mattina......
                        if (ore == 4) {
                            if (reset_fatto == 0) {
                               if ((giorno == 1) || (giorno == 4)) {
                                 GPIO.F4 = attivo;
                                 Delay_Safe_ms(10000);
                                 if ((batteria_mv > soglia_off) && (spento == 0)) { GPIO.F4 = !attivo; }
                                 reset_fatto = 1;
                               }
                            }
                        } else {
                            reset_fatto = 0;
                        }
                    } else {
                        //ACCENDIAMO IN FINESTRA_ORARIA dalle 7 alle 13
                        if ((ore >= 7) && (ore < 13)) { //dalle 7 alle 13 accendiamo
                            //ogni giorno oppure......
                            if ((giorno >= 1) && (giorno <= 7)) {
                               if ((batteria_mv > soglia_off) && (spento == 0)) {
                                  //accendiamo.....
                                  GPIO.F4 = !attivo;
                               } else {
                                  GPIO.F4 = attivo;
                               }
                            }
                        } else {
                            //fuori orario, spegniamo
                            GPIO.F4 = attivo;
                        }
                    }
                    minuti_count = 0;
                }
            }

            // --- Queste istruzioni devono stare fuori dall'if del conteggio batteria ---
            sveglie_wdt = sveglie_wdt + 1;    // Incrementa conteggio risvegli
            asm clrwdt;                       // Pulizia watchdog
            asm sleep;                        // Il chip dorme (Risparmio Max)
            asm nop;                          // Istruzione necessaria dopo lo sleep
        } else {
            // Se in manutenzione, resta sveglio e attendi
            Delay_Safe_ms(100);
            asm clrwdt;
        }
    }
}