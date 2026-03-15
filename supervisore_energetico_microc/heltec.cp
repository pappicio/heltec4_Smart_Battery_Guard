#line 1 "C:/Users/io/Desktop/microc_project/heltec.c"

unsigned int valore_adc;
unsigned char i;
unsigned int secondi_contatore;
bit in_manutenzione;


void Segnale_Avvio() {
 unsigned char j;
 for (j = 1; j <= 3; j++) {
 GPIO.F5 = 1;
 Delay_ms(250);
 GPIO.F5 = 0;
 Delay_ms(250);
 }
}

void Salva_EEPROM() {
 valore_adc = ADC_Read(1);


 EEPROM_Write(0, (unsigned char)(valore_adc >> 8));
 Delay_ms(20);


 EEPROM_Write(1, (unsigned char)(valore_adc & 0xFF));
 Delay_ms(20);
}

void Init_Hardware() {

 CMCON0 = 7;


 ANSEL = 0x02;


 TRISIO.F0 = 1;
 TRISIO.F1 = 1;
 TRISIO.F2 = 0;
 TRISIO.F3 = 1;
 TRISIO.F4 = 0;
 TRISIO.F5 = 0;


 OPTION_REG.F7 = 0;
 WPU = 0x01;


 GPIO.F2 = 1;
 GPIO.F5 = 0;

 in_manutenzione = 0;


 Delay_ms(100);

 Segnale_Avvio();
}

void main() {
 Init_Hardware();
 secondi_contatore = 300;

 while (1) {

 if (GPIO.F0 == 0) {
 i = 0;

 while (GPIO.F0 == 0 && i < 50) {
 Delay_ms(100);
 i++;
 if (i >= 10) GPIO.F5 = 1;
 }


 if (i >= 10 && i < 50) {
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
 GPIO.F5 = 1; Delay_ms(500);
 GPIO.F5 = 0;

 if (GPIO.F0 == 0) {
 i = 0;
 while (GPIO.F0 == 0 && i < 50) {
 Delay_ms(100);
 i++;
 }
 if (i >= 50) {
 Salva_EEPROM();
 in_manutenzione = 0;

 for (i = 1; i <= 20; i++) {
 GPIO.F5 = ~GPIO.F5; Delay_ms(100);
 }
 GPIO.F5 = 0;
 }
 } else {
 Delay_ms(500);
 }
 }

 Segnale_Avvio();
 GPIO.F2 = 0;
 secondi_contatore = 300;
 }
 GPIO.F5 = 0;
 }


 if (!in_manutenzione) {
 secondi_contatore++;
 if (secondi_contatore >= 300) {
 valore_adc = ADC_Read(1);
 if (valore_adc < 582) GPIO.F2 = 1;
 if (valore_adc > 651) GPIO.F2 = 0;
 secondi_contatore = 0;
 }
 }
 Delay_ms(100);
 }
}
