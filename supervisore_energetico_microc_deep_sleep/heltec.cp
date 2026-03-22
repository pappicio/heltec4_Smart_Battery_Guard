#line 1 "C:/projects/accensione_heltec/supervisore_energetico_microc_deep_sleep/heltec.c"
#line 7 "C:/projects/accensione_heltec/supervisore_energetico_microc_deep_sleep/heltec.c"
unsigned int valore_adc;
unsigned long batteria_mv;
unsigned char i;
unsigned int sveglie_wdt;
short in_manutenzione;
unsigned char dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 1; k <= n; k++) {
 Delay_ms(1);
 asm clrwdt;
 }
}


void Leggi_Batteria_mV() {
 valore_adc = ADC_Read(1);
 Delay_Safe_ms(5);
 valore_adc = ADC_Read(1);



 batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}


void Segnale_Avvio() {
 for (i = 1; i <= 3; i++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(250);
 GPIO.F5 = 0;
 Delay_Safe_ms(250);
 }
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
 taratura_vcc = 5000;

 GPIO.F2 = 1;
 GPIO.F2 = 0;


 Leggi_Batteria_mV();

 if (batteria_mv > soglia_off) {
 GPIO.F2 = 0;
 } else {
 GPIO.F2 = 1;
 }

 in_manutenzione = 0;
 asm clrwdt;
 Segnale_Avvio();
}


void Salva_EEPROM() {
 Leggi_Batteria_mV();

 EEPROM_Write(0, (valore_adc >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(1, (valore_adc & 0xFF));
 Delay_Safe_ms(20);
 EEPROM_Write(2, 0xFF);
 Delay_Safe_ms(20);
 EEPROM_Write(3, (unsigned short)(batteria_mv >> 24));
 Delay_Safe_ms(20);
 EEPROM_Write(4, (unsigned short)(batteria_mv >> 16));
 Delay_Safe_ms(20);
 EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF));
 Delay_Safe_ms(20);
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
 while ((GPIO.F0 == 0) && (i < 50)) {
 Delay_Safe_ms(100);
 i = i + 1;
 if (i >= 10) { GPIO.F5 = 1; }
 }


 if ((i >= 10) && (i < 50)) {
 Salva_EEPROM();


 if ((batteria_mv > soglia_off) && (batteria_mv < soglia_on)) {
 for (i = 1; i <= 3; i++) {
 GPIO.F5 = 1;
 Delay_ms(100);
 GPIO.F5 = 0;
 Delay_ms(100);
 asm clrwdt;
 }
 }


 if (batteria_mv <= soglia_off) {
 for (i = 1; i <= 6; i++) {
 GPIO.F5 = 1;
 Delay_ms(100);
 GPIO.F5 = 0;
 Delay_ms(100);
 asm clrwdt;
 }
 }


 GPIO.F2 = 1;
 GPIO.F5 = 0;
 Delay_Safe_ms(1000);


 if (batteria_mv > soglia_off) {
 GPIO.F2 = 0;
 } else {
 GPIO.F2 = 1;
 }

 sveglie_wdt = 0;
 }


 if (i >= 50) {
 GPIO.F2 = 1;
 for (i = 1; i <= 20; i++) {
 GPIO.F5 = !GPIO.F5;
 Delay_Safe_ms(100);
 }
 GPIO.F5 = 0;
 in_manutenzione = 1;

 while (in_manutenzione == 1) {
 GPIO.F5 = 1;
 Delay_Safe_ms(500);
 GPIO.F5 = 0;
 if (GPIO.F0 == 0) {
 i = 0;
 while ((GPIO.F0 == 0) && (i < 50)) {
 Delay_Safe_ms(100);
 i = i + 1;
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
 GPIO.F2 = 0;
 sveglie_wdt = 0;
 }
 }


 if (in_manutenzione == 0) {
 if (sveglie_wdt >= 13) {
 Leggi_Batteria_mV();

 if (batteria_mv <= soglia_off) {
 GPIO.F2 = 1;
 }

 if (batteria_mv >= soglia_on) {
 GPIO.F2 = 0;
 }

 sveglie_wdt = 0;
 }
 }


 if (in_manutenzione == 0) {
 sveglie_wdt = sveglie_wdt + 1;
 asm clrwdt;
 asm sleep;
 asm nop;
 } else {
 Delay_Safe_ms(100);
 }
 }
}
