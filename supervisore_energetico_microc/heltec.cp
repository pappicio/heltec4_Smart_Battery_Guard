#line 1 "C:/projects/accensione_heltec/supervisore_energetico_microc/heltec.c"

unsigned int valore_adc;
unsigned long batteria_mv;
unsigned char i;
unsigned int secondi_contatore;
short in_manutenzione;


void Segnale_Avvio() {
 for (i = 1; i <= 3; i++) {
 GPIO.F5 = 1;
 Delay_ms(250);
 GPIO.F5 = 0;
 Delay_ms(250);
 }
}


void Salva_EEPROM() {

 ADC_Read(1);
 Delay_ms(5);
 valore_adc = ADC_Read(1);


 batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;



 EEPROM_Write(0, (unsigned short)(valore_adc >> 8));
 Delay_ms(25);
 EEPROM_Write(1, (unsigned short)(valore_adc & 0xFF));
 Delay_ms(25);


 EEPROM_Write(2, 0xFF);
 Delay_ms(25);



 EEPROM_Write(3, (unsigned short)(batteria_mv >> 24));
 Delay_ms(25);
 EEPROM_Write(4, (unsigned short)(batteria_mv >> 16));
 Delay_ms(25);
 EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));
 Delay_ms(25);
 EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF));
 Delay_ms(25);
}


void Init_Hardware() {
 OSCCON = 0b01100000;
 CMCON0 = 7;
 ANSEL = 0b00000010;
 TRISIO = 0b00001011;
 OPTION_REG.NOT_GPPU = 0;
 WPU = 0b00000001;

 GPIO.F2 = 1;
 in_manutenzione = 0;
 Segnale_Avvio();
}

void main() {
 Init_Hardware();
 secondi_contatore = 300;

 while (1) {

 if (GPIO.F0 == 0) {
 i = 0;
 while ((GPIO.F0 == 0) && (i < 50)) {
 Delay_ms(100);
 i++;
 if (i >= 10) GPIO.F5 = 1;
 }


 if ((i >= 10) && (i < 50)) {
 Salva_EEPROM();
 GPIO.F2 = 1;
 GPIO.F5 = 0;
 Delay_ms(1000);
 GPIO.F2 = 0;
 secondi_contatore = 0;
 }


 if (i >= 50) {
 Salva_EEPROM();
 GPIO.F2 = 1;
 for (i = 1; i <= 20; i++) {
 GPIO.F5 = ~GPIO.F5;
 Delay_ms(100);
 }
 GPIO.F5 = 0;
 in_manutenzione = 1;

 while (in_manutenzione) {
 GPIO.F5 = 1;
 Delay_ms(500);
 GPIO.F5 = 0;
 if (GPIO.F0 == 0) {
 secondi_contatore = 0;
 while ((GPIO.F0 == 0) && (secondi_contatore < 50)) {
 Delay_ms(100);
 secondi_contatore++;
 }
 if (secondi_contatore >= 50) {
 Salva_EEPROM();
 in_manutenzione = 0;
 for (i = 1; i <= 20; i++) {
 GPIO.F5 = ~GPIO.F5;
 Delay_ms(100);
 }
 GPIO.F5 = 0;
 }
 } else {
 Delay_ms(500);
 }
 }
 Segnale_Avvio();
 GPIO.F2 = 0;
 secondi_contatore = 0;
 }
 GPIO.F5 = 0;
 }


 if (!in_manutenzione) {
 secondi_contatore++;
 if (secondi_contatore >= 300) {

 valore_adc = ADC_Read(1);
 Delay_ms(5);
 valore_adc = ADC_Read(1);


 batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;


 if (batteria_mv <= 3300) {
 GPIO.F2 = 1;
 }
 if (batteria_mv >= 3700) {
 GPIO.F2 = 0;
 }

 secondi_contatore = 0;
 }
 }

 Delay_ms(100);
 }
}
