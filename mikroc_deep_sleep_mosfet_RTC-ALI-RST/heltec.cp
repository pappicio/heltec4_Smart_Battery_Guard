#line 1 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC-ALI-RST/heltec.c"
#line 8 "C:/projects/accensione_heltec/mikroc_deep_sleep_mosfet_RTC-ALI-RST/heltec.c"
sbit Soft_I2C_Scl at GP0_bit;
sbit Soft_I2C_Sda at GP2_bit;
sbit Soft_I2C_Scl_Direction at TRISIO0_bit;
sbit Soft_I2C_Sda_Direction at TRISIO2_bit;

bit RSTpin;
bit attivo;

bit RTC_presente;
bit finestra_oraria;
bit spento;


unsigned int batteria_mv;
unsigned char i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned char dummy;
unsigned int soglia_off, soglia_on;
unsigned int taratura_vcc;

unsigned int val_da_lampeggiare;


unsigned char ore, minuti, giorno;
unsigned char bcd_val, dec_val;
bit reset_fatto;
unsigned char minuti_count;


unsigned char giorni_riavvio;
unsigned long conteggio_cicli;
unsigned int cicli_per_giorno;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 1; k <= n; k++) {
 Delay_us(978);
 asm clrwdt;
 }
}


void Lampeggia_Cifra(unsigned char c) {
 unsigned char l;
 if (c == 0) {

 GPIO.F5 = 1;
 Delay_Safe_ms(50);
 GPIO.F5 = 0;
 } else {
 for (l = 1; l <= c; l++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(250);
 GPIO.F5 = 0;
 Delay_Safe_ms(250);
 asm clrwdt;
 }
 }
 Delay_Safe_ms(1000);
}


void Estrai_e_Lampeggia(unsigned int divisore) {
 unsigned char contatore;
 contatore = 0;
 while (val_da_lampeggiare >= divisore) {
 val_da_lampeggiare = val_da_lampeggiare - divisore;
 contatore = contatore + 1;
 }
 Lampeggia_Cifra(contatore);
}



void Leggi_Ora_RTC() {
 unsigned char bcd_temp;

 GPIO.F5 = 1;
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

 bcd_temp = bcd_temp & 0x3F;
 ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);

 GPIO.F5 = 0;
}


void Leggi_Batteria_mV() {
 unsigned char i_idx;
 unsigned long somma;
 unsigned int media_pulita;

 somma = 0;

 for (i_idx = 1; i_idx <= 64; i_idx++) {
 somma = somma + ADC_Read(1);
 Delay_Safe_ms(1);
 }


 media_pulita = (unsigned int)(somma >> 6);


 batteria_mv = (unsigned int)(((unsigned long)media_pulita * taratura_vcc) >> 10);
}


void Lampi(unsigned char n, unsigned int t_on) {
 for (j = 1; j <= n; j++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(t_on);
 GPIO.F5 = 0;
 Delay_Safe_ms(t_on);
 }
}


void soglia_batteria() {
 if (batteria_mv <= soglia_off) {
 GPIO.F5 = 0;
 Delay_Safe_ms(500);

 Lampi(5, 100);
 } else {
 if ((batteria_mv > soglia_off) && (batteria_mv <= soglia_on)) {

 Delay_Safe_ms(500);
 Lampi(3, 100);
 } else {

 Delay_Safe_ms(500);
 Lampi(1, 100);
 }
 }
}


void Scrivi_Ora_RTC(unsigned char s_g_sett, unsigned char s_g, unsigned char s_m, unsigned char s_a, unsigned char s_ore, unsigned char s_min) {
 GPIO.F5 = 1;
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
 GPIO.F5 = 0;
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


 IOC.F3 = 1;


 conteggio_cicli = 0;


 cicli_per_giorno = 2883;

 spento = 0;
 attivo = 1;


 RSTpin = 1;


 RTC_presente = 1;


 finestra_oraria = 0;
 giorni_riavvio = 3;



 soglia_off = 3300;
 soglia_on = 3600;
 taratura_vcc = 5010;
 giorni_riavvio = 0;



 if (RSTpin == 1) {
 attivo = 0;
 }


 GPIO.F4 = attivo;


 GPIO.F5 = 0;




 if (RTC_presente == 1) {

 TRISIO.F0 = 0;
 TRISIO.F2 = 0;
 GPIO.F0 = 1;
 GPIO.F2 = 1;

 giorni_riavvio = 0;
 i = 0;
 while ((GPIO.F3 == 0) && (i < 15)) {
 GPIO.F5 = 1;
 Delay_Safe_ms(100);
 i = i + 1;
 }


 if (i == 15) {
 GPIO.F5 = 0;






 Scrivi_Ora_RTC(0x06, 0x04, 0x04, 0x26, 0x20, 0x55);
 GPIO.F5 = 0;
 Delay_Safe_ms(500);

 Lampi(10, 100);
 Delay_Safe_ms(500);
 }
 } else {

 TRISIO.F0 = 1;
 TRISIO.F2 = 1;
 GPIO.F0 = 0;
 GPIO.F2 = 0;
 }
 GPIO.F5 = 0;


 Delay_Safe_ms(500);


 Lampi(3, 250);


 Delay_Safe_ms(500);


 Leggi_Batteria_mV();


 if (batteria_mv > soglia_off) {
 GPIO.F4 = !attivo;
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
 while ((GPIO.F3 == 0) && (i < 50)) {
 Delay_Safe_ms(100);
 i = i + 1;
 if (i == 10) {
 GPIO.F5 = 1;
 }
 if (i == 25) {
 GPIO.F5 = 0;
 }
 }


 if ((i >= 10) && (i < 25)) {
 GPIO.F5 = 0;
 Leggi_Batteria_mV();


 GPIO.F4 = attivo;
 Delay_Safe_ms(2000);


 if (batteria_mv > soglia_off) {
 GPIO.F4 = !attivo;
 spento = 0;
 } else {
 spento = 1;
 }
 GPIO.F5 = 0;
 soglia_batteria();

 sveglie_wdt = 0;
 conteggio_cicli = 0;
 }


 if ((i >= 25) && (i < 50)) {
 GPIO.F5 = 0;
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
 GPIO.F5 = 1;
 Delay_Safe_ms(100);
 GPIO.F5 = 0;
 Delay_Safe_ms(1000);

 val_da_lampeggiare = (unsigned int)ore;
 Estrai_e_Lampeggia(10);
 Lampeggia_Cifra((unsigned char)val_da_lampeggiare);

 Delay_Safe_ms(1000);


 val_da_lampeggiare = (unsigned int)minuti;
 Estrai_e_Lampeggia(10);
 Lampeggia_Cifra((unsigned char)val_da_lampeggiare);
 }
 }


 if (i >= 50) {
 GPIO.F4 = attivo;

 for (j = 1; j <= 20; j++) {
 GPIO.F5 = !GPIO.F5;
 Delay_Safe_ms(100);
 }
 GPIO.F5 = 0;
 in_manutenzione = 1;
 while (in_manutenzione == 1) {

 GPIO.F5 = 1;
 Delay_Safe_ms(500);
 GPIO.F5 = 0;
 if (GPIO.F3 == 0) {
 i = 0;
 while ((GPIO.F3 == 0) && (i < 50)) {
 Delay_Safe_ms(100);
 i = i + 1;
 }
 if (i >= 50) {
 in_manutenzione = 0;

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

 Leggi_Batteria_mV();
 if (batteria_mv > soglia_off) {
 GPIO.F4 = !attivo;
 spento = 0;
 } else {
 spento = 1;
 }
 soglia_batteria();

 sveglie_wdt = 13;
 conteggio_cicli = 0;
 minuti_count = 0;
 asm clrwdt;
 }
 }


 if (in_manutenzione == 0) {

 if (sveglie_wdt >= 13) {
 Leggi_Batteria_mV();

 if (batteria_mv <= soglia_off) {
 GPIO.F4 = attivo;
 spento = 1;
 }

 if (batteria_mv >= soglia_on) {
 GPIO.F4 = !attivo;
 spento = 0;
 }

 sveglie_wdt = 0;

 if (RTC_presente == 1) {
 giorni_riavvio = 0;
 minuti_count = minuti_count + 1;
 } else {
 minuti_count = 0;
 finestra_oraria = 0;
 }


 if (giorni_riavvio > 0) {
 conteggio_cicli = conteggio_cicli + 1;

 if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
 GPIO.F4 = attivo;
 Delay_Safe_ms(2000);
 if (batteria_mv > soglia_off) {
 GPIO.F4 = !attivo;
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

 if ((ore >= 7) && (ore < 13)) {

 if ((giorno >= 1) && (giorno <= 7)) {
 if ((batteria_mv > soglia_off) && (spento == 0)) {

 GPIO.F4 = !attivo;
 } else {
 GPIO.F4 = attivo;
 }
 }
 } else {

 GPIO.F4 = attivo;
 }
 }
 minuti_count = 0;
 }
 }


 sveglie_wdt = sveglie_wdt + 1;
 asm clrwdt;
 asm sleep;
 asm nop;
 } else {

 Delay_Safe_ms(100);
 asm clrwdt;
 }
 }
}
