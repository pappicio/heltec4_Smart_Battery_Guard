/*
 * Programma: Solar Power Manager 683 Final (Versione MikroC)
 * Descrizione: Gestione alimentazione Heltec con RTC, ADC e Sleep
 */

// --- CONFIGURAZIONE PIN I2C SOFTWARE ---
sbit Soft_I2C_Scl           at GP5_bit;
sbit Soft_I2C_Sda           at GP4_bit;
sbit Soft_I2C_Scl_Direction at TRISIO5_bit;
sbit Soft_I2C_Sda_Direction at TRISIO4_bit;

// --- VARIABILI GLOBALI ---
unsigned short RTC_presente = 0;   // 0 = Assente, 1 = Funzionante
unsigned long batteria_mv;         // Tensione batteria in millivolt
unsigned short i, j;               // Utility per cicli
unsigned int sveglie_wdt = 0;      // Contatore risvegli Watchdog
bit in_manutenzione;               // Flag stato manutenzione
unsigned short dummy;              // Appoggio per lettura GPIO
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;
unsigned int val_da_lampeggiare;

// --- VARIABILI RTC ---
unsigned short ore, minuti, giorno;
unsigned short bcd_val;
unsigned short reset_fatto = 0;
unsigned short minuti_count = 20;

// --- VARIABILI TIMER RIAVVIO ---
unsigned short giorni_riavvio;
unsigned long conteggio_cicli = 0;
unsigned long cicli_per_giorno = 2883;

// --- PROTOTIPI DELLE FUNZIONI ---
void Leggi_Batteria_mV();
void Lampi(unsigned short n, unsigned int t_on);

// --- RITARDO SICURO (Reset Watchdog durante le pause) ---
void Delay_Safe_ms(unsigned int n) {
    unsigned int k;
    for (k = 0; k < n; k++) {
        delay_us(980);
        asm clrwdt; // Reset del Watchdog via Assembly
    }
}

// --- LAMPEGGIO CIFRA ---
void Lampeggia_Cifra(unsigned short c) {
    unsigned short l;
    if (c == 0) {
        GPIO.F2 = 1;
        Delay_Safe_ms(50);
        GPIO.F2 = 0;
    } else {
        for (l = 0; l < c; l++) {
            GPIO.F2 = 1;
            Delay_Safe_ms(250);
            GPIO.F2 = 0;
            Delay_Safe_ms(250);
        }
    }
    Delay_Safe_ms(1000);
}

// --- ESTRAZIONE CIFRE PER LAMPEGGIO ---
void Estrai_e_Lampeggia(unsigned int divisore) {
    unsigned short contatore = 0;
    while (val_da_lampeggiare >= divisore) {
        val_da_lampeggiare -= divisore;
        contatore++;
    }
    Lampeggia_Cifra(contatore);
}

// --- LETTURA ORA RTC ---
void Leggi_Ora_RTC() {
    GPIO.F2 = 1; // LED Acceso durante I2C
    Soft_I2C_Start();
    Soft_I2C_Stop();
    Delay_Safe_ms(1);

    // Puntamento
    Soft_I2C_Start();
    Soft_I2C_Write(0xD0);
    Soft_I2C_Write(0x01); // Punta ai minuti

    // Lettura
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);

    bcd_val = Soft_I2C_Read(1); // Minuti
    minuti = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);

    bcd_val = Soft_I2C_Read(1); // Ore
    bcd_val &= 0x3F;            // Pulizia bit 12/24h
    ore = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);

    bcd_val = Soft_I2C_Read(0); // Giorno Settimana
    giorno = bcd_val & 0x07;

    Soft_I2C_Stop();
    Delay_Safe_ms(1);
    GPIO.F2 = 0;
}

// --- LETTURA ANALOGICA MEDIA ---
void Leggi_Batteria_mV() {
    unsigned short k;
    unsigned long somma = 0;
    unsigned int media_pulita;

    for (k = 0; k < 64; k++) {
        somma += ADC_Read(1);
        Delay_Safe_ms(1);
    }
    media_pulita = (unsigned int)(somma >> 6);
    batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
}

// --- FUNZIONE LAMPI ---
void Lampi(unsigned short n, unsigned int t_on) {
    unsigned short k;
    for (k = 0; k < n; k++) {
        GPIO.F2 = 1;
        Delay_Safe_ms(t_on);
        GPIO.F2 = 0;
        Delay_Safe_ms(t_on);
    }
}

// --- FEEDBACK STATO BATTERIA ---
void soglia_batteria() {
    if (batteria_mv <= soglia_off) {
        Delay_Safe_ms(500);
        Lampi(6, 100);
    } else if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
        Delay_Safe_ms(500);
        Lampi(3, 100);
    }
}

// --- SCRITTURA ORA RTC ---
void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
    GPIO.F2 = 1;
    Delay_Safe_ms(100);
    Soft_I2C_Init();
    Delay_Safe_ms(100);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD0);
    Soft_I2C_Write(0x00); // Inizia dai secondi

    Soft_I2C_Write(0x00);  // Sec
    Soft_I2C_Write(s_min); // Min
    Soft_I2C_Write(s_ore); // Ore
    Soft_I2C_Write(s_g_sett);
    Soft_I2C_Write(s_g);
    Soft_I2C_Write(s_m);
    Soft_I2C_Write(s_a);
    Soft_I2C_Stop();
    Delay_Safe_ms(800);
    GPIO.F2 = 0;
    Delay_Safe_ms(500);
}

// --- INIZIALIZZAZIONE HARDWARE ---
void Init_Hardware() {
    OSCCON = 0b01100111; // 4MHz
    CMCON0 = 7;          // No comparatori
    ANSEL  = 0b00010010; // AN1 analogico
    TRISIO = 0b00001010; // GP1, GP3 Input
    OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
    WPU = 0;
    INTCON.GPIE = 1;
    IOC.B3 = 1;

    // I2C Pins
    TRISIO.B4 = 0; GPIO.B4 = 1;
    TRISIO.B5 = 0; GPIO.B5 = 1;

    // Configurazione Soglie
    soglia_off   = 3300;
    soglia_on    = 3600;
    taratura_vcc = 5050;
    giorni_riavvio = 3;

    GPIO.F0 = 1; // Spegne carico (MOSFET P)
    GPIO.F2 = 0; // LED Off

    RTC_presente = 0; // Cambiare a 1 se RTC montato
    if (RTC_presente && giorni_riavvio > 0) giorni_riavvio = 0;

    // Logica Sincronizzazione Manuale
    if (RTC_presente) {
        i = 0;
        while (GPIO.B3 == 0 && i < 15) {
            Delay_Safe_ms(100);
            i++;
        }
        if (i == 15) {
            // Sincronizza: Lunedì 30 Marzo 2026, 04:05:00
            Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
            Lampi(10, 100);
        }
    }

    Delay_Safe_ms(500);
    Lampi(3, 250);
    Leggi_Batteria_mV();
    if (batteria_mv > soglia_off) GPIO.F0 = 0;

    in_manutenzione = 0;
    sveglie_wdt = 0;
    soglia_batteria();
}

// --- LOOP PRINCIPALE ---
void main() {
    Init_Hardware();

    while (1) {
        if (INTCON.GPIF) {
            dummy = GPIO;
            INTCON.GPIF = 0;
        }

        // --- GESTIONE PULSANTE ---
        if (GPIO.B3 == 0) {
            i = 0;
            while (GPIO.B3 == 0 && i < 50) {
                Delay_Safe_ms(100);
                i++;
                if (i == 10) GPIO.F2 = 1;
                if (i == 25) GPIO.F2 = 0;
            }

            // Reset Heltec (1-2.5s)
            if (i >= 10 && i < 25) {
                GPIO.F0 = 1;
                Delay_Safe_ms(2000);
                Leggi_Batteria_mV();
                if (batteria_mv > soglia_off) GPIO.F0 = 0;
                if (batteria_mv < soglia_on) soglia_batteria();
                sveglie_wdt = 0;
                conteggio_cicli = 0;
            }

            // Visualizzazione Volt e Ora (2.5-5s)
            if (i >= 25 && i < 50) {
                Leggi_Batteria_mV();
                Delay_Safe_ms(1000);
                val_da_lampeggiare = (unsigned int)batteria_mv;
                Estrai_e_Lampeggia(1000);
                Estrai_e_Lampeggia(100);
                Estrai_e_Lampeggia(10);
                Lampeggia_Cifra(0);

                if (RTC_presente) {
                    Delay_Safe_ms(1000);
                    Lampi(2, 100);
                    Leggi_Ora_RTC();
                    Delay_Safe_ms(1000);
                    val_da_lampeggiare = ore;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra(val_da_lampeggiare % 10);
                    Delay_Safe_ms(1000);
                    val_da_lampeggiare = minuti;
                    Estrai_e_Lampeggia(10);
                    Lampeggia_Cifra(val_da_lampeggiare % 10);
                }
            }

            // Manutenzione (>5s)
            if (i >= 50) {
                GPIO.F0 = 1;
                for (j = 0; j < 20; j++) { GPIO.F2 = !GPIO.F2; Delay_Safe_ms(100); }
                GPIO.F2 = 0;
                in_manutenzione = 1;
                while (in_manutenzione) {
                    GPIO.F2 = 1; Delay_Safe_ms(500); GPIO.F2 = 0;
                    if (GPIO.B3 == 0) {
                        i = 0;
                        while (GPIO.B3 == 0 && i < 50) { Delay_Safe_ms(100); i++; }
                        if (i >= 50) in_manutenzione = 0;
                    } else { Delay_Safe_ms(500); }
                    asm clrwdt;
                }
                for (j = 0; j < 20; j++) { GPIO.F2 = !GPIO.F2; Delay_Safe_ms(100); }
                Leggi_Batteria_mV();
                if (batteria_mv > soglia_off) GPIO.F0 = 0;
                sveglie_wdt = 13;
                conteggio_cicli = 0;
            }
        }

        // --- RISPARMIO ENERGETICO ---
        if (!in_manutenzione) {
            if (sveglie_wdt >= 13) {
                Leggi_Batteria_mV();
                if (batteria_mv <= soglia_off) GPIO.F0 = 1;
                if (batteria_mv >= soglia_on)  GPIO.F0 = 0;

                sveglie_wdt = 0;
                if (RTC_presente) minuti_count++;

                // Timer Riavvio (Senza RTC)
                if (giorni_riavvio > 0) {
                    conteggio_cicli++;
                    if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
                        GPIO.F0 = 1; Delay_Safe_ms(2000);
                        if (batteria_mv > soglia_off) GPIO.F0 = 0;
                        conteggio_cicli = 0;
                    }
                }

                // Controllo RTC (Ogni 10 Minuti)
                if (minuti_count >= 20) {
                    Leggi_Ora_RTC();
                    if (ore == 4 && minuti < 11) {
                        if (!reset_fatto) {
                            if (giorno == 1 || giorno == 4) {
                                GPIO.F0 = 1; Delay_Safe_ms(10000);
                                if (batteria_mv > soglia_off) GPIO.F0 = 0;
                                reset_fatto = 1;
                            }
                        }
                    } else { reset_fatto = 0; }
                    minuti_count = 0;
                }
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