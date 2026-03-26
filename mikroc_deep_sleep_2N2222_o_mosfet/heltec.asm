
_Delay_Safe_ms:

;heltec.c,21 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,23 :: 		for (k = 1; k <= n; k++) {
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Delay_Safe_ms0:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms69
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms69:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,24 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
;heltec.c,25 :: 		asm clrwdt;
	CLRWDT
;heltec.c,23 :: 		for (k = 1; k <= n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,26 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,27 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Triplo:

;heltec.c,30 :: 		void Segnale_Triplo() {
;heltec.c,31 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Segnale_Triplo4:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Segnale_Triplo5
;heltec.c,32 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,33 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,34 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,35 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,31 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,36 :: 		}
	GOTO       L_Segnale_Triplo4
L_Segnale_Triplo5:
;heltec.c,37 :: 		}
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Lampeggia_Cifra:

;heltec.c,40 :: 		void Lampeggia_Cifra(unsigned short c) {
;heltec.c,42 :: 		if (c == 0) {
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Lampeggia_Cifra7
;heltec.c,44 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,45 :: 		Delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_Lampeggia_Cifra8:
	DECFSZ     R13+0, 1
	GOTO       L_Lampeggia_Cifra8
	DECFSZ     R12+0, 1
	GOTO       L_Lampeggia_Cifra8
	NOP
;heltec.c,46 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,47 :: 		} else {
	GOTO       L_Lampeggia_Cifra9
L_Lampeggia_Cifra7:
;heltec.c,48 :: 		for (l = 1; l <= c; l++) {
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra10:
	MOVF       Lampeggia_Cifra_l_L0+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra11
;heltec.c,49 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,50 :: 		Delay_ms(250);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Lampeggia_Cifra13:
	DECFSZ     R13+0, 1
	GOTO       L_Lampeggia_Cifra13
	DECFSZ     R12+0, 1
	GOTO       L_Lampeggia_Cifra13
	DECFSZ     R11+0, 1
	GOTO       L_Lampeggia_Cifra13
	NOP
	NOP
;heltec.c,51 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,52 :: 		Delay_ms(250);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Lampeggia_Cifra14:
	DECFSZ     R13+0, 1
	GOTO       L_Lampeggia_Cifra14
	DECFSZ     R12+0, 1
	GOTO       L_Lampeggia_Cifra14
	DECFSZ     R11+0, 1
	GOTO       L_Lampeggia_Cifra14
	NOP
	NOP
;heltec.c,53 :: 		asm clrwdt;
	CLRWDT
;heltec.c,48 :: 		for (l = 1; l <= c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,54 :: 		}
	GOTO       L_Lampeggia_Cifra10
L_Lampeggia_Cifra11:
;heltec.c,55 :: 		}
L_Lampeggia_Cifra9:
;heltec.c,56 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,57 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Leggi_Batteria_mV:

;heltec.c,60 :: 		void Leggi_Batteria_mV() {
;heltec.c,61 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,62 :: 		Delay_Safe_ms(5);
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,63 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,66 :: 		batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
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
L__Leggi_Batteria_mV73:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV74
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV73
L__Leggi_Batteria_mV74:
;heltec.c,67 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Salva_EEPROM:

;heltec.c,70 :: 		void Salva_EEPROM() {
;heltec.c,72 :: 		EEPROM_Write(0, (unsigned short)(valore_adc >> 8));   // Byte alto
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       _valore_adc+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,73 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,74 :: 		EEPROM_Write(1, (unsigned short)(valore_adc));        // Byte basso
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,75 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,78 :: 		EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // Byte 3 (Highest)
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
;heltec.c,79 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,80 :: 		EEPROM_Write(4, (unsigned short)(batteria_mv >> 16)); // Byte 2 (Higher)
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
;heltec.c,81 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,82 :: 		EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));  // Byte 1 (Hi)
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
;heltec.c,83 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,84 :: 		EEPROM_Write(6, (unsigned short)(batteria_mv));       // Byte 0 (Lo)
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,85 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,86 :: 		}
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;heltec.c,89 :: 		void Init_Hardware() {
;heltec.c,90 :: 		OSCCON = 0b01100111;    // 4MHz
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,91 :: 		CMCON0 = 7;             // No comparatori
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,92 :: 		ANSEL  = 0b00010010;    // GP1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,93 :: 		TRISIO = 0b00001011;    // GP0, GP1, GP3 Input
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,95 :: 		OPTION_REG = 0b00001111; // WDT ~2.3s
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,96 :: 		WPU = 0b00000001;        // Pull-up GP0
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,97 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,98 :: 		IOC.B0 = 1;
	BSF        IOC+0, 0
;heltec.c,101 :: 		soglia_off   = 3330;
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,102 :: 		soglia_on    = 3700;
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,103 :: 		taratura_vcc = 5030;
	MOVLW      166
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,104 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,106 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,107 :: 		cicli_per_giorno = 2880;
	MOVLW      64
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;heltec.c,109 :: 		GPIO.F2 = 1; // MOSFET OFF
	BSF        GPIO+0, 2
;heltec.c,110 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,111 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware77
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware77
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware77
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware77:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware15
;heltec.c,112 :: 		GPIO.F2 = 0; // MOSFET ON
	BCF        GPIO+0, 2
;heltec.c,113 :: 		}
L_Init_Hardware15:
;heltec.c,115 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,116 :: 		asm clrwdt;
	CLRWDT
;heltec.c,117 :: 		Segnale_Triplo();
	CALL       _Segnale_Triplo+0
;heltec.c,118 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,121 :: 		void main() {
;heltec.c,122 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,123 :: 		sveglie_wdt = 15;
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,125 :: 		while (1) {
L_main16:
;heltec.c,126 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main18
;heltec.c,127 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,128 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,129 :: 		}
L_main18:
;heltec.c,132 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main19
;heltec.c,133 :: 		i = 0;
	CLRF       _i+0
;heltec.c,134 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main20:
	BTFSC      GPIO+0, 0
	GOTO       L_main21
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main21
L__main67:
;heltec.c,135 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,136 :: 		i++;
	INCF       _i+0, 1
;heltec.c,137 :: 		if (i == 10) GPIO.F5 = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	BSF        GPIO+0, 5
L_main24:
;heltec.c,138 :: 		if (i == 25) GPIO.F5 = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	BCF        GPIO+0, 5
L_main25:
;heltec.c,139 :: 		}
	GOTO       L_main20
L_main21:
;heltec.c,142 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main28
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main28
L__main66:
;heltec.c,143 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,144 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,147 :: 		if (batteria_mv >= soglia_on) {
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
	GOTO       L_main29
;heltec.c,149 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,150 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,151 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,152 :: 		} else {
	GOTO       L_main30
L_main29:
;heltec.c,153 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main80:
	BTFSS      STATUS+0, 0
	GOTO       L_main31
;heltec.c,154 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,155 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,157 :: 		for (j = 1; j <= 6; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main32:
	MOVF       _j+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_main33
;heltec.c,158 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,159 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,160 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,161 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,162 :: 		asm clrwdt;
	CLRWDT
;heltec.c,157 :: 		for (j = 1; j <= 6; j++) {
	INCF       _j+0, 1
;heltec.c,163 :: 		}
	GOTO       L_main32
L_main33:
;heltec.c,164 :: 		} else {
	GOTO       L_main35
L_main31:
;heltec.c,166 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,167 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main36:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main37
;heltec.c,168 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,169 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,170 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,171 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,172 :: 		asm clrwdt;
	CLRWDT
;heltec.c,167 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,173 :: 		}
	GOTO       L_main36
L_main37:
;heltec.c,174 :: 		}
L_main35:
;heltec.c,175 :: 		}
L_main30:
;heltec.c,178 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,179 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,182 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main81:
	BTFSC      STATUS+0, 0
	GOTO       L_main39
;heltec.c,183 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,184 :: 		}
L_main39:
;heltec.c,186 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,187 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,188 :: 		}
L_main28:
;heltec.c,191 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main42
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main42
L__main65:
;heltec.c,192 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,193 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,194 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,195 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,197 :: 		temp_mv = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;heltec.c,198 :: 		cifra = temp_mv / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _batteria_mv+0, 0
	MOVWF      R0+0
	MOVF       _batteria_mv+1, 0
	MOVWF      R0+1
	MOVF       _batteria_mv+2, 0
	MOVWF      R0+2
	MOVF       _batteria_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,199 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,200 :: 		temp_mv %= 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _temp_mv+0
	MOVF       R0+1, 0
	MOVWF      _temp_mv+1
	MOVF       R0+2, 0
	MOVWF      _temp_mv+2
	MOVF       R0+3, 0
	MOVWF      _temp_mv+3
;heltec.c,202 :: 		cifra = temp_mv / 100;
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,203 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,204 :: 		temp_mv %= 100;
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _temp_mv+0
	MOVF       R0+1, 0
	MOVWF      _temp_mv+1
	MOVF       R0+2, 0
	MOVWF      _temp_mv+2
	MOVF       R0+3, 0
	MOVWF      _temp_mv+3
;heltec.c,206 :: 		cifra = temp_mv / 10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,207 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,209 :: 		cifra = temp_mv % 10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,210 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,212 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,213 :: 		}
L_main42:
;heltec.c,216 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main43
;heltec.c,217 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,218 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main44:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main45
;heltec.c,219 :: 		GPIO.F5 = ~GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,220 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,218 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,221 :: 		}
	GOTO       L_main44
L_main45:
;heltec.c,222 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,223 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,225 :: 		while (in_manutenzione) {
L_main47:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main48
;heltec.c,226 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,227 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,228 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,229 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main49
;heltec.c,230 :: 		i = 0;
	CLRF       _i+0
;heltec.c,231 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main50:
	BTFSC      GPIO+0, 0
	GOTO       L_main51
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main51
L__main64:
;heltec.c,232 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,233 :: 		i++;
	INCF       _i+0, 1
;heltec.c,234 :: 		}
	GOTO       L_main50
L_main51:
;heltec.c,235 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main54
;heltec.c,236 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,237 :: 		Segnale_Triplo();
	CALL       _Segnale_Triplo+0
;heltec.c,238 :: 		}
L_main54:
;heltec.c,239 :: 		} else {
	GOTO       L_main55
L_main49:
;heltec.c,240 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,241 :: 		}
L_main55:
;heltec.c,242 :: 		}
	GOTO       L_main47
L_main48:
;heltec.c,243 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,244 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,245 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,246 :: 		}
L_main43:
;heltec.c,247 :: 		}
L_main19:
;heltec.c,250 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main56
;heltec.c,251 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main82
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main82:
	BTFSS      STATUS+0, 0
	GOTO       L_main57
;heltec.c,252 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,253 :: 		if (batteria_mv <= soglia_off) GPIO.F2 = 1;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main83:
	BTFSS      STATUS+0, 0
	GOTO       L_main58
	BSF        GPIO+0, 2
L_main58:
;heltec.c,254 :: 		if (batteria_mv >= soglia_on)  GPIO.F2 = 0;
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main84
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main84
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main84
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main84:
	BTFSS      STATUS+0, 0
	GOTO       L_main59
	BCF        GPIO+0, 2
L_main59:
;heltec.c,256 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main60
;heltec.c,257 :: 		conteggio_cicli++;
	MOVF       _conteggio_cicli+0, 0
	MOVWF      R0+0
	MOVF       _conteggio_cicli+1, 0
	MOVWF      R0+1
	MOVF       _conteggio_cicli+2, 0
	MOVWF      R0+2
	MOVF       _conteggio_cicli+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _conteggio_cicli+0
	MOVF       R0+1, 0
	MOVWF      _conteggio_cicli+1
	MOVF       R0+2, 0
	MOVWF      _conteggio_cicli+2
	MOVF       R0+3, 0
	MOVWF      _conteggio_cicli+3
;heltec.c,258 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
	MOVF       _cicli_per_giorno+0, 0
	MOVWF      R0+0
	MOVF       _cicli_per_giorno+1, 0
	MOVWF      R0+1
	MOVF       _cicli_per_giorno+2, 0
	MOVWF      R0+2
	MOVF       _cicli_per_giorno+3, 0
	MOVWF      R0+3
	MOVF       _giorni_riavvio+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+3, 0
	SUBWF      _conteggio_cicli+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main85
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main85
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main85
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main85:
	BTFSS      STATUS+0, 0
	GOTO       L_main61
;heltec.c,259 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,260 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,261 :: 		if (batteria_mv > soglia_off) GPIO.F2 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main86:
	BTFSC      STATUS+0, 0
	GOTO       L_main62
	BCF        GPIO+0, 2
L_main62:
;heltec.c,262 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,263 :: 		}
L_main61:
;heltec.c,264 :: 		}
L_main60:
;heltec.c,265 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,266 :: 		}
L_main57:
;heltec.c,267 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,268 :: 		asm clrwdt;
	CLRWDT
;heltec.c,269 :: 		asm sleep;
	SLEEP
;heltec.c,270 :: 		asm nop;
	NOP
;heltec.c,271 :: 		} else {
	GOTO       L_main63
L_main56:
;heltec.c,272 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,273 :: 		}
L_main63:
;heltec.c,274 :: 		}
	GOTO       L_main16
;heltec.c,275 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
