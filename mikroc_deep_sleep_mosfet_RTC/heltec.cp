#line 1 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC/heltec.c"
#line 7 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC/heltec.c"
sbit Soft_I2C_Scl at GP5_bit;
sbit Soft_I2C_Sda at GP4_bit;
sbit Soft_I2C_Scl_Direction at TRISIO5_bit;
sbit Soft_I2C_Sda_Direction at TRISIO4_bit;


bit RTC_presente;
bit finestra_oraria;
bit spento;
bit reset_fatto;


unsigned int batteria_mv;
unsigned short i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned short dummy;
unsigned int soglia_off, soglia_on;
unsigned int taratura_vcc;

unsigned int val_da_lampeggiare;


unsigned short ore, minuti, giorno;
unsigned short bcd_val;
unsigned short minuti_count;


unsigned short giorni_riavvio;
unsigned long conteggio_cicli;
unsigned int cicli_per_giorno;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 0; k < n; k++) {
 delay_us(980);
 asm clrwdt;
 }
}


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
 asm clrwdt;
 }
 }
 Delay_Safe_ms(1000);
}


void Estrai_e_Lampeggia(unsigned int divisore) {
 unsigned short contatore = 0;
 while (val_da_lampeggiare >= divisore) {
 val_da_lampeggiare -= divisore;
 contatore++;
 }
 Lampeggia_Cifra(contatore);
}


void Leggi_Ora_RTC() {

 GPIO.F2 = 1;


 Soft_I2C_Start();
 Soft_I2C_Stop();
 Delay_Safe_ms(1);


 Soft_I2C_Start();
 Soft_I2C_Write(0xD0);
 Soft_I2C_Write(0x01);


 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);


 bcd_val = Soft_I2C_Read(1);
 minuti = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);


 bcd_val = Soft_I2C_Read(1);
 bcd_val &= 0x3F;
 ore = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);


 bcd_val = Soft_I2C_Read(0);
 giorno = bcd_val & 0x07;

 Soft_I2C_Stop();
 Delay_Safe_ms(1);
 GPIO.F2 = 0;
}


void Leggi_Batteria_mV() {
 unsigned short k;
 unsigned long somma = 0;
 unsigned int media_pulita;

 for (k = 0; k < 64; k++) {
 somma += ADC_Read(1);
 Delay_Safe_ms(1);
 }
 media_pulita = (unsigned int)(somma >> 6);
 batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
}


void Lampi(unsigned short n, unsigned int t_on) {
 for (j = 0; j < n; j++) {
 GPIO.F2 = 1;
 Delay_Safe_ms(t_on);
 GPIO.F2 = 0;
 Delay_Safe_ms(t_on);
 }
}


void soglia_batteria() {
 if (batteria_mv <= soglia_off) {
 GPIO.F2 = 0;
 Delay_Safe_ms(500);
 Lampi(6, 100);
 } else if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
 Delay_Safe_ms(500);
 Lampi(3, 100);
 }
}


void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
 GPIO.F2 = 1;
 Delay_Safe_ms(100);
 Soft_I2C_Init();
 Delay_Safe_ms(100);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD0);
 Soft_I2C_Write(0x00);
 Soft_I2C_Write(0x00);
 Soft_I2C_Write(s_min);
 Soft_I2C_Write(s_ore);
 Soft_I2C_Write(s_g_sett);
 Soft_I2C_Write(s_g);
 Soft_I2C_Write(s_m);
 Soft_I2C_Write(s_a);
 Soft_I2C_Stop();
 Delay_Safe_ms(800);
 GPIO.F2 = 0;
 Delay_Safe_ms(500);
}


void Init_Hardware() {
 RTC_presente = 0;
 OSCCON = 0x67;
 CMCON0 = 7;
 ANSEL = 0x12;
 TRISIO = 0x0A;
 OPTION_REG = 0x0F;
 WPU = 0x00;
 INTCON.GPIE = 1;
 IOC.B3 = 1;

 conteggio_cicli = 0;
 cicli_per_giorno = 2883;
 spento = 0;

 TRISIO.F4 = 0; GPIO.F4 = 1;
 TRISIO.F5 = 0; GPIO.F5 = 1;


 soglia_off = 3300;
 soglia_on = 3600;
 taratura_vcc = 5050;
 giorni_riavvio = 3;

 GPIO.F0 = 1;
 GPIO.F2 = 0;

 RTC_presente = 0;
 finestra_oraria = 0;


 if (RTC_presente == 1) {
 minuti_count = 20;
 giorni_riavvio = 0;
 i = 0;
 while (GPIO.F3 == 0 && i < 15) {
 GPIO.F2 = 1;
 Delay_Safe_ms(100);
 i++;
 }
 if (i == 15) {
 GPIO.F2 = 0;
 Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
 Lampi(10, 100);
 }
 }
 GPIO.F2 = 0;

 Delay_Safe_ms(500);
 Lampi(3, 250);
 Delay_Safe_ms(500);
 Leggi_Batteria_mV();

 if (batteria_mv > soglia_off) {
 GPIO.F0 = 0;
 spento = 0;
 } else {
 spento = 1;
 }

 in_manutenzione = 0;
 reset_fatto = 0;
 sveglie_wdt = 0;
 soglia_batteria();
}


void main() {
 Init_Hardware();

 while (1) {
 if (INTCON.GPIF == 1) {
 dummy = GPIO;
 INTCON.GPIF = 0;
 }


 if (GPIO.F3 == 0) {
 i = 0;
 while (GPIO.F3 == 0 && i < 50) {
 Delay_Safe_ms(100);
 i++;
 if (i == 10) GPIO.F2 = 1;
 if (i == 25) GPIO.F2 = 0;
 }


 if (i >= 10 && i < 25) {
 GPIO.F2 = 0;
 Leggi_Batteria_mV();
 GPIO.F0 = 1;
 Delay_Safe_ms(2000);
 if (batteria_mv > soglia_off) {
 GPIO.F0 = 0;
 spento = 0;
 } else {
 spento = 1;
 }
 GPIO.F2 = 0;
 if (batteria_mv < soglia_on) soglia_batteria();
 sveglie_wdt = 0;
 conteggio_cicli = 0;
 }


 if (i >= 25 && i < 50) {
 GPIO.F2 = 0;
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
 GPIO.F2 = 1; Delay_Safe_ms(100); GPIO.F2 = 0;
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


 if (i >= 50) {
 GPIO.F0 = 1;
 Lampi(10, 100);
 in_manutenzione = 1;
 while (in_manutenzione) {
 GPIO.F2 = 1; Delay_Safe_ms(500); GPIO.F2 = 0;
 if (GPIO.F3 == 0) {
 i = 0;
 while (GPIO.F3 == 0 && i < 50) { Delay_Safe_ms(100); i++; }
 if (i >= 50) in_manutenzione = 0;
 } else {
 Delay_Safe_ms(500);
 }
 asm clrwdt;
 }
 Lampi(10, 100);
 Leggi_Batteria_mV();
 if (batteria_mv > soglia_off) { GPIO.F0 = 0; spento = 0; }
 else spento = 1;
 if (batteria_mv < soglia_on) soglia_batteria();
 sveglie_wdt = 13;
 conteggio_cicli = 0;
 minuti_count = 0;
 }
 }


 if (!in_manutenzione) {
 if (sveglie_wdt >= 13) {
 Leggi_Batteria_mV();
 if (batteria_mv <= soglia_off) { GPIO.F0 = 1; spento = 1; }
 if (batteria_mv >= soglia_on) { GPIO.F0 = 0; spento = 0; }

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
 GPIO.F0 = 1; Delay_Safe_ms(2000);
 if (batteria_mv > soglia_off) { GPIO.F0 = 0; spento = 0; }
 else spento = 1;
 conteggio_cicli = 0;
 }
 }


 if (minuti_count >= 20) {
 Leggi_Ora_RTC();
 if (!finestra_oraria) {
 if (ore == 4) {
 if (!reset_fatto) {
 if (giorno == 1 || giorno == 4) {
 GPIO.F0 = 1; Delay_Safe_ms(10000);
 if (batteria_mv > soglia_off && !spento) GPIO.F0 = 0;
 reset_fatto = 1;
 }
 }
 } else { reset_fatto = 0; }
 } else {

 if (ore >= 7 && ore < 13) {
 if (batteria_mv > soglia_off && !spento) GPIO.F0 = 0;
 else GPIO.F0 = 1;
 } else { GPIO.F0 = 1; }
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
