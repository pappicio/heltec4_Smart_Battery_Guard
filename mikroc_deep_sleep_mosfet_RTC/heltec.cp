#line 1 "C:/projects/accensione_heltec/mikroc_deep_sleep_2N2222_o_mosfet_RTC/heltec.c"
#line 7 "C:/projects/accensione_heltec/mikroc_deep_sleep_2N2222_o_mosfet_RTC/heltec.c"
sbit Soft_I2C_Scl at GP5_bit;
sbit Soft_I2C_Sda at GP4_bit;
sbit Soft_I2C_Scl_Direction at TRISIO5_bit;
sbit Soft_I2C_Sda_Direction at TRISIO4_bit;


unsigned short RTC_presente = 0;
unsigned long batteria_mv;
unsigned short i, j;
unsigned int sveglie_wdt = 0;
bit in_manutenzione;
unsigned short dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;
unsigned int val_da_lampeggiare;


unsigned short ore, minuti, giorno;
unsigned short bcd_val;
unsigned short reset_fatto = 0;
unsigned short minuti_count = 20;


unsigned short giorni_riavvio;
unsigned long conteggio_cicli = 0;
unsigned long cicli_per_giorno = 2883;


void Leggi_Batteria_mV();
void Lampi(unsigned short n, unsigned int t_on);


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
 batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
}


void Lampi(unsigned short n, unsigned int t_on) {
 unsigned short k;
 for (k = 0; k < n; k++) {
 GPIO.F2 = 1;
 Delay_Safe_ms(t_on);
 GPIO.F2 = 0;
 Delay_Safe_ms(t_on);
 }
}


void soglia_batteria() {
 if (batteria_mv <= soglia_off) {
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
 OSCCON = 0b01100111;
 CMCON0 = 7;
 ANSEL = 0b00010010;
 TRISIO = 0b00001010;
 OPTION_REG = 0b00001111;
 WPU = 0;
 INTCON.GPIE = 1;
 IOC.B3 = 1;


 TRISIO.B4 = 0; GPIO.B4 = 1;
 TRISIO.B5 = 0; GPIO.B5 = 1;


 soglia_off = 3300;
 soglia_on = 3600;
 taratura_vcc = 5050;
 giorni_riavvio = 3;

 GPIO.F0 = 1;
 GPIO.F2 = 0;

 RTC_presente = 0;
 if (RTC_presente && giorni_riavvio > 0) giorni_riavvio = 0;


 if (RTC_presente) {
 i = 0;
 while (GPIO.B3 == 0 && i < 15) {
 Delay_Safe_ms(100);
 i++;
 }
 if (i == 15) {

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


void main() {
 Init_Hardware();

 while (1) {
 if (INTCON.GPIF) {
 dummy = GPIO;
 INTCON.GPIF = 0;
 }


 if (GPIO.B3 == 0) {
 i = 0;
 while (GPIO.B3 == 0 && i < 50) {
 Delay_Safe_ms(100);
 i++;
 if (i == 10) GPIO.F2 = 1;
 if (i == 25) GPIO.F2 = 0;
 }


 if (i >= 10 && i < 25) {
 GPIO.F0 = 1;
 Delay_Safe_ms(2000);
 Leggi_Batteria_mV();
 if (batteria_mv > soglia_off) GPIO.F0 = 0;
 if (batteria_mv < soglia_on) soglia_batteria();
 sveglie_wdt = 0;
 conteggio_cicli = 0;
 }


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


 if (!in_manutenzione) {
 if (sveglie_wdt >= 13) {
 Leggi_Batteria_mV();
 if (batteria_mv <= soglia_off) GPIO.F0 = 1;
 if (batteria_mv >= soglia_on) GPIO.F0 = 0;

 sveglie_wdt = 0;
 if (RTC_presente) minuti_count++;


 if (giorni_riavvio > 0) {
 conteggio_cicli++;
 if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
 GPIO.F0 = 1; Delay_Safe_ms(2000);
 if (batteria_mv > soglia_off) GPIO.F0 = 0;
 conteggio_cicli = 0;
 }
 }


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
