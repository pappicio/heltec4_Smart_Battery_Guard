#line 1 "C:/projects/accensione_heltec/supervisore_energetico_mikroc_deep_sleep_mosfet/heltec.c"

unsigned int valore_adc;
unsigned long batteria_mv;
unsigned short i, j;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned short dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;


unsigned long temp_mv;
unsigned short cifra;


unsigned short giorni_riavvio;
unsigned long conteggio_cicli;
unsigned long cicli_per_giorno;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 1; k <= n; k++) {
 Delay_ms(1);
 asm clrwdt;
 }
}


void Segnale_Triplo() {
 for (j = 1; j <= 3; j++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(250);
 GPIO.F5 = 0;
 Delay_Safe_ms(250);
 }
}


void Lampeggia_Cifra(unsigned short c) {
 unsigned short l;
 if (c == 0) {

 GPIO.F5 = 1;
 Delay_ms(50);
 GPIO.F5 = 0;
 } else {
 for (l = 1; l <= c; l++) {
 GPIO.F5 = 1;
 Delay_ms(250);
 GPIO.F5 = 0;
 Delay_ms(250);
 asm clrwdt;
 }
 }
 Delay_Safe_ms(1000);
}


void Leggi_Batteria_mV() {
 valore_adc = ADC_Read(1);
 Delay_Safe_ms(5);
 valore_adc = ADC_Read(1);


 batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}


void Salva_EEPROM() {

 EEPROM_Write(0, (unsigned short)(valore_adc >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(1, (unsigned short)(valore_adc));
 Delay_Safe_ms(20);


 EEPROM_Write(3, (unsigned short)(batteria_mv >> 24));
 Delay_Safe_ms(20);
 EEPROM_Write(4, (unsigned short)(batteria_mv >> 16));
 Delay_Safe_ms(20);
 EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(6, (unsigned short)(batteria_mv));
 Delay_Safe_ms(20);
}


void Init_Hardware() {
 OSCCON = 0b01100111;
 CMCON0 = 7;
 ANSEL = 0b00010010;
 TRISIO = 0b00001011;

 OPTION_REG = 0b00001111;
 WPU = 0b00000001;
 INTCON.GPIE = 1;
 IOC.B0 = 1;


 soglia_off = 3330;
 soglia_on = 3700;
 taratura_vcc = 5030;
 giorni_riavvio = 3;

 conteggio_cicli = 0;
 cicli_per_giorno = 2880;

 GPIO.F2 = 1;
 Leggi_Batteria_mV();
 if (batteria_mv > soglia_off) {
 GPIO.F2 = 0;
 }

 in_manutenzione = 0;
 asm clrwdt;
 Segnale_Triplo();
}


void main() {
 Init_Hardware();
 sveglie_wdt = 15;

 while (1) {
 if (INTCON.GPIF == 1) {
 dummy = GPIO;
 INTCON.GPIF = 0;
 }


 if (GPIO.F0 == 0) {
 i = 0;
 while (GPIO.F0 == 0 && i < 50) {
 Delay_Safe_ms(100);
 i++;
 if (i == 10) GPIO.F5 = 1;
 if (i == 25) GPIO.F5 = 0;
 }


 if (i >= 10 && i < 25) {
 GPIO.F5 = 0;
 Leggi_Batteria_mV();


 if (batteria_mv >= soglia_on) {

 GPIO.F5 = 1;
 Delay_Safe_ms(1000);
 GPIO.F5 = 0;
 } else {
 if (batteria_mv <= soglia_off) {
 GPIO.F5 = 0;
 Delay_Safe_ms(500);

 for (j = 1; j <= 6; j++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(100);
 GPIO.F5 = 0;
 Delay_Safe_ms(100);
 asm clrwdt;
 }
 } else {

 Delay_Safe_ms(500);
 for (j = 1; j <= 3; j++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(100);
 GPIO.F5 = 0;
 Delay_Safe_ms(100);
 asm clrwdt;
 }
 }
 }


 GPIO.F2 = 1;
 Delay_Safe_ms(2000);


 if (batteria_mv > soglia_off) {
 GPIO.F2 = 0;
 }

 sveglie_wdt = 0;
 conteggio_cicli = 0;
 }


 if (i >= 25 && i < 50) {
 GPIO.F5 = 0;
 Leggi_Batteria_mV();
 Salva_EEPROM();
 Delay_Safe_ms(1000);

 temp_mv = batteria_mv;
 cifra = temp_mv / 1000;
 Lampeggia_Cifra(cifra);
 temp_mv %= 1000;

 cifra = temp_mv / 100;
 Lampeggia_Cifra(cifra);
 temp_mv %= 100;

 cifra = temp_mv / 10;
 Lampeggia_Cifra(cifra);

 cifra = temp_mv % 10;
 Lampeggia_Cifra(cifra);

 Delay_Safe_ms(1000);
 }


 if (i >= 50) {
 GPIO.F2 = 1;
 for (j = 1; j <= 20; j++) {
 GPIO.F5 = ~GPIO.F5;
 Delay_Safe_ms(100);
 }
 GPIO.F5 = 0;
 in_manutenzione = 1;

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
 Segnale_Triplo();
 }
 } else {
 Delay_Safe_ms(500);
 }
 }
 GPIO.F2 = 0;
 sveglie_wdt = 0;
 conteggio_cicli = 0;
 }
 }


 if (!in_manutenzione) {
 if (sveglie_wdt >= 13) {
 Leggi_Batteria_mV();
 if (batteria_mv <= soglia_off) GPIO.F2 = 1;
 if (batteria_mv >= soglia_on) GPIO.F2 = 0;

 if (giorni_riavvio > 0) {
 conteggio_cicli++;
 if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
 GPIO.F2 = 1;
 Delay_Safe_ms(2000);
 if (batteria_mv > soglia_off) GPIO.F2 = 0;
 conteggio_cicli = 0;
 }
 }
 sveglie_wdt = 0;
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
