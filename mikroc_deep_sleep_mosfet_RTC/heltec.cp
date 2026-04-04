#line 1 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC/heltec.c"
#line 8 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC/heltec.c"
sbit Soft_I2C_Scl at GP0_bit;
sbit Soft_I2C_Sda at GP2_bit;
sbit Soft_I2C_Scl_Direction at TRISIO0_bit;
sbit Soft_I2C_Sda_Direction at TRISIO2_bit;

bit RTC_presente;
bit finestra_oraria;
bit spento;


unsigned int batteria_mv;
unsigned short i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned short dummy;
unsigned int soglia_off, soglia_on;
unsigned int taratura_vcc;

unsigned int val_da_lampeggiare;


unsigned short ore, minuti, giorno;
bit reset_fatto;
unsigned short minuti_count;


unsigned short giorni_riavvio;
unsigned long conteggio_cicli;
unsigned int cicli_per_giorno;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 1; k <= n; k++) {
 Delay_us(978);
 asm clrwdt;
 }
}


void Lampeggia_Cifra(unsigned short c) {
 unsigned short l;
 if (c == 0) {

 GP5_bit = 1;
 Delay_Safe_ms(50);
 GP5_bit = 0;
 } else {
 for (l = 1; l <= c; l++) {
 GP5_bit = 1;
 Delay_Safe_ms(250);
 GP5_bit = 0;
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
 unsigned short bcd_temp;

 GP5_bit = 1;
 Delay_Safe_ms(100);


 Soft_I2C_Start();
 Soft_I2C_Stop();
 Delay_Safe_ms(10);


 Soft_I2C_Start();
 Soft_I2C_Write(0xD0);
 Soft_I2C_Write(0x01);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);
 bcd_temp = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 minuti = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

 Delay_Safe_ms(10);


 Soft_I2C_Start();
 Soft_I2C_Write(0xD0);
 Soft_I2C_Write(0x02);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);
 bcd_temp = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 bcd_temp &= 0x3F;
 ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

 GP5_bit = 0;
}


void Leggi_Batteria_mV() {
 unsigned short i_adc;
 unsigned long somma = 0;
 unsigned int media_pulita;


 for (i_adc = 1; i_adc <= 64; i_adc++) {
 somma += ADC_Read(1);
 Delay_Safe_ms(1);
 }


 media_pulita = (unsigned int)(somma >> 6);


 batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
}


void Lampi(unsigned short n, unsigned int t_on) {
 for (j = 1; j <= n; j++) {
 GP5_bit = 1;
 Delay_Safe_ms(t_on);
 GP5_bit = 0;
 Delay_Safe_ms(t_on);
 }
}


void soglia_batteria() {
 if (batteria_mv <= soglia_off) {
 GP5_bit = 0;
 Delay_Safe_ms(500);

 Lampi(6, 100);
 } else {
 if ((batteria_mv > soglia_off) && (batteria_mv <= soglia_on)) {

 Delay_Safe_ms(500);
 Lampi(3, 100);
 }
 }
}


void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
 GP5_bit = 1;
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
 GP5_bit = 0;
 Delay_Safe_ms(500);
}


void Init_Hardware() {

 RTC_presente = 0;
 OSCCON = 0b01100111;


 CMCON0 = 7;


 ANSEL = 0b00010010;


 TRISIO = 0b00001010;


 OPTION_REG = 0b00001111;


 WPU = 0b00000000;


 INTCON.GPIE = 1;


 IOC.B3 = 1;


 conteggio_cicli = 0;


 cicli_per_giorno = 2883;

 spento = 0;


 soglia_off = 3300;
 soglia_on = 3600;
 taratura_vcc = 5050;
 giorni_riavvio = 0;


 GP4_bit = 1;


 GP5_bit = 0;

 RTC_presente = 0;
 finestra_oraria = 0;
 giorni_riavvio = 3;


 if (RTC_presente == 1) {
 TRISIO.B0 = 0;
 TRISIO.B2 = 0;
 GP0_bit = 1;
 GP2_bit = 1;

 giorni_riavvio = 0;
 i = 0;
 while ((GP3_bit == 0) && (i < 15)) {
 GP5_bit = 1;
 Delay_Safe_ms(100);
 i++;
 }

 if (i == 15) {
 GP5_bit = 0;

 Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
 GP5_bit = 0;
 Delay_Safe_ms(500);
 Lampi(10, 100);
 Delay_Safe_ms(500);
 }
 } else {
 TRISIO.B0 = 1;
 TRISIO.B2 = 1;
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


void main() {
 Init_Hardware();

 while (1) {

 if (INTCON.GPIF == 1) {
 dummy = GPIO;
 INTCON.GPIF = 0;
 }


 if (GP3_bit == 0) {
 i = 0;
 while ((GP3_bit == 0) && (i < 50)) {
 Delay_Safe_ms(100);
 i++;
 if (i == 10) GP5_bit = 1;
 if (i == 25) GP5_bit = 0;
 }


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
