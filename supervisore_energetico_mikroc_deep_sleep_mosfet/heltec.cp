#line 1 "C:/projects/accensione_heltec/supervisore_energetico_mikroc_deep_sleep_mosfet/heltec.c"
#line 7 "C:/projects/accensione_heltec/supervisore_energetico_mikroc_deep_sleep_mosfet/heltec.c"
unsigned int valore_adc;
unsigned long batteria_mv;
unsigned char i;
unsigned int sveglie_wdt;
bit in_manutenzione;
unsigned char dummy;
unsigned long soglia_off, soglia_on;
unsigned long taratura_vcc;
unsigned char acceso, spento;


unsigned int giorni_per_reset;
unsigned long conteggio_giorni;
unsigned long soglia_reset_giorni;
const unsigned long RISVEGLI_AL_GIORNO = 37565;


void Delay_Safe_ms(unsigned int n) {
 unsigned int k;
 for (k = 1; k <= n; k++) {
 Delay_ms(1);
 asm clrwdt;
 }
}


void Segnale_Avvio() {
 for (i = 1; i <= 3; i++) {
 GPIO.F5 = 1;
 Delay_Safe_ms(250);
 GPIO.F5 = 0;
 Delay_Safe_ms(250);
 }
}


void Leggi_Batteria_mV() {
 valore_adc = ADC_Read(1);
 Delay_Safe_ms(5);
 valore_adc = ADC_Read(1);
 batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
}


void Gestione_Stato_Sistema() {

 Leggi_Batteria_mV();


 if (batteria_mv <= soglia_off) {
 GPIO.F2 = spento;
 }

 if (batteria_mv >= soglia_on) {
 GPIO.F2 = acceso;
 }


 if (giorni_per_reset > 0) {

 soglia_reset_giorni = (unsigned long)giorni_per_reset * RISVEGLI_AL_GIORNO;

 if (conteggio_giorni >= soglia_reset_giorni) {

 if (GPIO.F2 == acceso) {
 GPIO.F2 = spento;
 Delay_Safe_ms(10000);
 GPIO.F2 = acceso;
 }
 conteggio_giorni = 0;
 }
 } else {

 if (conteggio_giorni > RISVEGLI_AL_GIORNO) {
 conteggio_giorni = 0;
 }
 }
}

void Init_Hardware() {
 OSCCON = 0b01100111;
 CMCON0 = 7;
 ANSEL = 0b00010010;

 acceso = 0;
 spento = 1;


 giorni_per_reset = 7;
 conteggio_giorni = 0;
 soglia_off = 3330;
 soglia_on = 3700;
 taratura_vcc = 5070;

 GPIO.F2 = acceso;
 TRISIO = 0b00001011;

 OPTION_REG = 0b00001111;
 WPU = 0b00000001;
 INTCON.GPIE = 1;
 IOC.B0 = 1;

 GPIO.F2 = spento;
 Leggi_Batteria_mV();

 if (batteria_mv > soglia_off) {
 GPIO.F2 = acceso;
 } else {
 GPIO.F2 = spento;
 }

 in_manutenzione = 0;
 asm clrwdt;
 Segnale_Avvio();
}



void Salva_EEPROM() {
 Leggi_Batteria_mV();


 EEPROM_Write(0, (unsigned char)(valore_adc >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(1, (unsigned char)(valore_adc));
 Delay_Safe_ms(20);

 EEPROM_Write(2, 0xFF);
 Delay_Safe_ms(20);


 EEPROM_Write(3, (unsigned char)(batteria_mv >> 24));
 Delay_Safe_ms(20);
 EEPROM_Write(4, (unsigned char)(batteria_mv >> 16));
 Delay_Safe_ms(20);
 EEPROM_Write(5, (unsigned char)(batteria_mv >> 8));
 Delay_Safe_ms(20);
 EEPROM_Write(6, (unsigned char)(batteria_mv));
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
 while (GPIO.F0 == 0 && i < 50) {
 Delay_Safe_ms(100);
 i++;
 if (i >= 10) GPIO.F5 = 1;
 }

 if (i >= 10 && i < 50) {
 Salva_EEPROM();

 if (batteria_mv > soglia_off && batteria_mv < soglia_on) {
 for (i = 1; i <= 3; i++) {
 GPIO.F5 = 1; Delay_ms(100);
 GPIO.F5 = 0; Delay_ms(100);
 asm clrwdt;
 }
 }
 if (batteria_mv <= soglia_off) {
 for (i = 1; i <= 6; i++) {
 GPIO.F5 = 1; Delay_ms(100);
 GPIO.F5 = 0; Delay_ms(100);
 asm clrwdt;
 }
 }

 GPIO.F2 = spento;
 GPIO.F5 = 0;
 Delay_Safe_ms(1000);

 if (batteria_mv > soglia_off) GPIO.F2 = acceso;
 else GPIO.F2 = spento;

 sveglie_wdt = 0;
 conteggio_giorni = 0;
 }

 if (i >= 50) {
 in_manutenzione = 1;
 GPIO.F2 = spento;
 for (i = 1; i <= 20; i++) {
 GPIO.F5 = !GPIO.F5;
 Delay_Safe_ms(100);
 }
 GPIO.F5 = 0;

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
 GPIO.F2 = acceso;
 sveglie_wdt = 0;
 conteggio_giorni = 0;
 }
 }


 if (!in_manutenzione) {
 if (sveglie_wdt >= 13) {
 Gestione_Stato_Sistema();
 sveglie_wdt = 0;
 }
 }


 if (!in_manutenzione) {
 sveglie_wdt++;
 conteggio_giorni++;
 asm clrwdt;
 asm sleep;
 asm nop;
 } else {
 Delay_Safe_ms(100);
 }
 }
}
