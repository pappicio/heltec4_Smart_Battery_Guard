
_Delay_Safe_ms:

;heltec.c,17 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,19 :: 		for (k = 1; k <= n; k++) {
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Delay_Safe_ms0:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms64
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms64:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,20 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
;heltec.c,21 :: 		asm clrwdt;
	CLRWDT
;heltec.c,19 :: 		for (k = 1; k <= n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,22 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,23 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Leggi_Batteria_mV:

;heltec.c,26 :: 		void Leggi_Batteria_mV() {
;heltec.c,27 :: 		valore_adc = ADC_Read(1);      // Prima lettura (scarto per stabilizzare l'ADC)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,28 :: 		Delay_Safe_ms(5);
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,29 :: 		valore_adc = ADC_Read(1);      // Seconda lettura reale
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,33 :: 		batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVF       _taratura_vcc+0, 0
	MOVWF      R4+0
	MOVF       _taratura_vcc+1, 0
	MOVWF      R4+1
	MOVF       _taratura_vcc+2, 0
	MOVWF      R4+2
	MOVF       _taratura_vcc+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       R0+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R0+1, 0
	MOVWF      _batteria_mv+1
	MOVF       R0+2, 0
	MOVWF      _batteria_mv+2
	MOVF       R0+3, 0
	MOVWF      _batteria_mv+3
	MOVF       R4+0, 0
L__Leggi_Batteria_mV66:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV67
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV66
L__Leggi_Batteria_mV67:
;heltec.c,34 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Segnale_Avvio:

;heltec.c,37 :: 		void Segnale_Avvio() {
;heltec.c,38 :: 		for (i = 1; i <= 3; i++) {
	MOVLW      1
	MOVWF      _i+0
L_Segnale_Avvio4:
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Segnale_Avvio5
;heltec.c,39 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,40 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,41 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,42 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,38 :: 		for (i = 1; i <= 3; i++) {
	INCF       _i+0, 1
;heltec.c,43 :: 		}
	GOTO       L_Segnale_Avvio4
L_Segnale_Avvio5:
;heltec.c,44 :: 		}
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Init_Hardware:

;heltec.c,47 :: 		void Init_Hardware() {
;heltec.c,48 :: 		OSCCON = 0b01100111;    // 4MHz interno
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,49 :: 		CMCON0 = 7;             // Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,50 :: 		ANSEL  = 0b00010010;    // RA1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,51 :: 		TRISIO = 0b00001011;    // RA0, RA1, RA3 Input | RA2, RA5 Output
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,53 :: 		OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,54 :: 		WPU = 0b00000001;        // Pull-up su GP0
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,56 :: 		INTCON.GPIE = 1;         // Abilita interrupt GPIO
	BSF        INTCON+0, 3
;heltec.c,57 :: 		IOC.B0 = 1;              // Sveglia su GP0 (IOC0)
	BSF        IOC+0, 0
;heltec.c,62 :: 		soglia_off   = 3330;   // 3340 è il 10% Batteria stiamo sotto cosi sotto i 10% si spegne!!!!!
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,63 :: 		soglia_on    = 3700;   // 50% Batteria
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,64 :: 		taratura_vcc = 5000;   // 5080 = 5.08V
	MOVLW      136
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,66 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,67 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,70 :: 		Leggi_Batteria_mV();   // Leggiamo subito lo stato della batteria
	CALL       _Leggi_Batteria_mV+0
;heltec.c,72 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware70
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware70
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware70
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware70:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware7
;heltec.c,73 :: 		GPIO.F2 = 0;        // ACCENDI Heltec subito se la batteria è OK
	BCF        GPIO+0, 2
;heltec.c,74 :: 		} else {
	GOTO       L_Init_Hardware8
L_Init_Hardware7:
;heltec.c,75 :: 		GPIO.F2 = 1;        // Resta SPENTO se troppo scarica
	BSF        GPIO+0, 2
;heltec.c,76 :: 		}
L_Init_Hardware8:
;heltec.c,78 :: 		in_manutenzione = 0;    // false
	CLRF       _in_manutenzione+0
;heltec.c,79 :: 		asm clrwdt;
	CLRWDT
;heltec.c,80 :: 		Segnale_Avvio();        // Il LED segnala che il PIC è partito
	CALL       _Segnale_Avvio+0
;heltec.c,81 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_Salva_EEPROM:

;heltec.c,84 :: 		void Salva_EEPROM() {
;heltec.c,85 :: 		Leggi_Batteria_mV();    // Aggiorna i valori prima di scrivere
	CALL       _Leggi_Batteria_mV+0
;heltec.c,87 :: 		EEPROM_Write(0, (valore_adc >> 8));    // Hi(valore_adc)
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       _valore_adc+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,88 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,89 :: 		EEPROM_Write(1, (valore_adc & 0xFF));  // Lo(valore_adc)
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,90 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,91 :: 		EEPROM_Write(2, 0xFF);
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,92 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,93 :: 		EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // Highest
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _batteria_mv+3, 0
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,94 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,95 :: 		EEPROM_Write(4, (unsigned short)(batteria_mv >> 16)); // Higher
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _batteria_mv+2, 0
	MOVWF      R0+0
	MOVF       _batteria_mv+3, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,96 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,97 :: 		EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));  // Hi
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _batteria_mv+1, 0
	MOVWF      R0+0
	MOVF       _batteria_mv+2, 0
	MOVWF      R0+1
	MOVF       _batteria_mv+3, 0
	MOVWF      R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,98 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,99 :: 		EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF)); // Lo
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,100 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,101 :: 		}
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_main:

;heltec.c,104 :: 		void main() {
;heltec.c,105 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,106 :: 		sveglie_wdt = 15;
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,108 :: 		while (1) {
L_main9:
;heltec.c,110 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main11
;heltec.c,111 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,112 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,113 :: 		}
L_main11:
;heltec.c,116 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main12
;heltec.c,117 :: 		i = 0;
	CLRF       _i+0
;heltec.c,118 :: 		while ((GPIO.F0 == 0) && (i < 50)) {
L_main13:
	BTFSC      GPIO+0, 0
	GOTO       L_main14
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main14
L__main62:
;heltec.c,119 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,120 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,121 :: 		if (i >= 10) { GPIO.F5 = 1; }
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main17
	BSF        GPIO+0, 5
L_main17:
;heltec.c,122 :: 		}
	GOTO       L_main13
L_main14:
;heltec.c,125 :: 		if ((i >= 10) && (i < 50)) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main20
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main20
L__main61:
;heltec.c,126 :: 		Salva_EEPROM(); // Aggiorna batteria_mv e valore_adc
	CALL       _Salva_EEPROM+0
;heltec.c,129 :: 		if ((batteria_mv > soglia_off) && (batteria_mv < soglia_on)) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main73:
	BTFSC      STATUS+0, 0
	GOTO       L_main23
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main74:
	BTFSC      STATUS+0, 0
	GOTO       L_main23
L__main60:
;heltec.c,130 :: 		for (i = 1; i <= 3; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main24:
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main25
;heltec.c,131 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,132 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	NOP
	NOP
;heltec.c,133 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,134 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	NOP
	NOP
;heltec.c,135 :: 		asm clrwdt;
	CLRWDT
;heltec.c,130 :: 		for (i = 1; i <= 3; i++) {
	INCF       _i+0, 1
;heltec.c,136 :: 		}
	GOTO       L_main24
L_main25:
;heltec.c,137 :: 		}
L_main23:
;heltec.c,140 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main75:
	BTFSS      STATUS+0, 0
	GOTO       L_main29
;heltec.c,141 :: 		for (i = 1; i <= 6; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main30:
	MOVF       _i+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_main31
;heltec.c,142 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,143 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	NOP
	NOP
;heltec.c,144 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,145 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main34:
	DECFSZ     R13+0, 1
	GOTO       L_main34
	DECFSZ     R12+0, 1
	GOTO       L_main34
	NOP
	NOP
;heltec.c,146 :: 		asm clrwdt;
	CLRWDT
;heltec.c,141 :: 		for (i = 1; i <= 6; i++) {
	INCF       _i+0, 1
;heltec.c,147 :: 		}
	GOTO       L_main30
L_main31:
;heltec.c,148 :: 		}
L_main29:
;heltec.c,151 :: 		GPIO.F2 = 1;      // Spegni l'Heltec
	BSF        GPIO+0, 2
;heltec.c,152 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,153 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,156 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L_main35
;heltec.c,157 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,158 :: 		} else {
	GOTO       L_main36
L_main35:
;heltec.c,159 :: 		GPIO.F2 = 1;  // Conferma spegnimento se scarica
	BSF        GPIO+0, 2
;heltec.c,160 :: 		}
L_main36:
;heltec.c,162 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,163 :: 		}
L_main20:
;heltec.c,166 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main37
;heltec.c,167 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,168 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main38:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main39
;heltec.c,169 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,170 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,168 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,171 :: 		}
	GOTO       L_main38
L_main39:
;heltec.c,172 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,173 :: 		in_manutenzione = 1; // true
	MOVLW      1
	MOVWF      _in_manutenzione+0
;heltec.c,175 :: 		while (in_manutenzione == 1) {
L_main41:
	MOVF       _in_manutenzione+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main42
;heltec.c,176 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,177 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,178 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,179 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main43
;heltec.c,180 :: 		i = 0;
	CLRF       _i+0
;heltec.c,181 :: 		while ((GPIO.F0 == 0) && (i < 50)) {
L_main44:
	BTFSC      GPIO+0, 0
	GOTO       L_main45
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main45
L__main59:
;heltec.c,182 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,183 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,184 :: 		}
	GOTO       L_main44
L_main45:
;heltec.c,185 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main48
;heltec.c,186 :: 		in_manutenzione = 0; // false
	CLRF       _in_manutenzione+0
;heltec.c,187 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main49:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main50
;heltec.c,188 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,189 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,187 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,190 :: 		}
	GOTO       L_main49
L_main50:
;heltec.c,191 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,192 :: 		}
L_main48:
;heltec.c,193 :: 		} else {
	GOTO       L_main52
L_main43:
;heltec.c,194 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,195 :: 		}
L_main52:
;heltec.c,196 :: 		}
	GOTO       L_main41
L_main42:
;heltec.c,197 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,198 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,199 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,200 :: 		}
L_main37:
;heltec.c,201 :: 		}
L_main12:
;heltec.c,204 :: 		if (in_manutenzione == 0) {
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main53
;heltec.c,205 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main77:
	BTFSS      STATUS+0, 0
	GOTO       L_main54
;heltec.c,206 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,208 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main78:
	BTFSS      STATUS+0, 0
	GOTO       L_main55
;heltec.c,209 :: 		GPIO.F2 = 1;  // SPEGNI
	BSF        GPIO+0, 2
;heltec.c,210 :: 		}
L_main55:
;heltec.c,212 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main79:
	BTFSS      STATUS+0, 0
	GOTO       L_main56
;heltec.c,213 :: 		GPIO.F2 = 0;  // ACCENDI
	BCF        GPIO+0, 2
;heltec.c,214 :: 		}
L_main56:
;heltec.c,216 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,217 :: 		}
L_main54:
;heltec.c,218 :: 		}
L_main53:
;heltec.c,221 :: 		if (in_manutenzione == 0) {
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main57
;heltec.c,222 :: 		sveglie_wdt = sveglie_wdt + 1;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,223 :: 		asm clrwdt;
	CLRWDT
;heltec.c,224 :: 		asm sleep;
	SLEEP
;heltec.c,225 :: 		asm nop;
	NOP
;heltec.c,226 :: 		} else {
	GOTO       L_main58
L_main57:
;heltec.c,227 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,228 :: 		}
L_main58:
;heltec.c,229 :: 		}
	GOTO       L_main9
;heltec.c,230 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
