
_Delay_Safe_ms:

;heltec.c,20 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,22 :: 		for (k = 1; k <= n; k++) {
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Delay_Safe_ms0:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms84
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms84:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,23 :: 		delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
;heltec.c,24 :: 		asm clrwdt;
	CLRWDT
;heltec.c,22 :: 		for (k = 1; k <= n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,25 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,26 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Triplo:

;heltec.c,29 :: 		void Segnale_Triplo() {
;heltec.c,30 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Segnale_Triplo4:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Segnale_Triplo5
;heltec.c,31 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,32 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,33 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,34 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,30 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,35 :: 		}
	GOTO       L_Segnale_Triplo4
L_Segnale_Triplo5:
;heltec.c,36 :: 		}
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Lampeggia_Cifra:

;heltec.c,39 :: 		void Lampeggia_Cifra(unsigned char c) {
;heltec.c,41 :: 		if (c == 0) {
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Lampeggia_Cifra7
;heltec.c,43 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,44 :: 		delay_ms(50);
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
;heltec.c,45 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,46 :: 		} else {
	GOTO       L_Lampeggia_Cifra9
L_Lampeggia_Cifra7:
;heltec.c,47 :: 		for (l = 1; l <= c; l++) {
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra10:
	MOVF       Lampeggia_Cifra_l_L0+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra11
;heltec.c,48 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,49 :: 		delay_ms(250);
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
;heltec.c,50 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,51 :: 		delay_ms(250);
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
;heltec.c,52 :: 		asm clrwdt;
	CLRWDT
;heltec.c,47 :: 		for (l = 1; l <= c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,53 :: 		}
	GOTO       L_Lampeggia_Cifra10
L_Lampeggia_Cifra11:
;heltec.c,54 :: 		}
L_Lampeggia_Cifra9:
;heltec.c,55 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,56 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Leggi_Batteria_mV:

;heltec.c,58 :: 		void Leggi_Batteria_mV() {
;heltec.c,60 :: 		unsigned int somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
;heltec.c,65 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i_adc_L0+0
L_Leggi_Batteria_mV15:
	MOVF       Leggi_Batteria_mV_i_adc_L0+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV16
;heltec.c,66 :: 		somma = somma + ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma_L0+1, 1
;heltec.c,67 :: 		delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Leggi_Batteria_mV18:
	DECFSZ     R13+0, 1
	GOTO       L_Leggi_Batteria_mV18
	DECFSZ     R12+0, 1
	GOTO       L_Leggi_Batteria_mV18
;heltec.c,65 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	INCF       Leggi_Batteria_mV_i_adc_L0+0, 1
;heltec.c,68 :: 		}
	GOTO       L_Leggi_Batteria_mV15
L_Leggi_Batteria_mV16:
;heltec.c,71 :: 		media_pulita = somma >> 6;
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma_L0+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma_L0+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV88:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV89
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV88
L__Leggi_Batteria_mV89:
;heltec.c,74 :: 		batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
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
L__Leggi_Batteria_mV90:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV91
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV90
L__Leggi_Batteria_mV91:
;heltec.c,75 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Init_Hardware:

;heltec.c,78 :: 		void Init_Hardware() {
;heltec.c,79 :: 		OSCCON = 0b01100111;
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,80 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,81 :: 		ANSEL  = 0b00010010;
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,82 :: 		TRISIO = 0b00001011;
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,83 :: 		OPTION_REG = 0b00001111;
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,84 :: 		WPU = 0b00000001;
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,85 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,86 :: 		IOC.B0 = 1;
	BSF        IOC+0, 0
;heltec.c,90 :: 		soglia_off   = 3330;
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,91 :: 		soglia_on    = 3700;
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,92 :: 		taratura_vcc = 5030;
	MOVLW      166
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,93 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,96 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,97 :: 		cicli_per_giorno = 2880;
	MOVLW      64
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;heltec.c,99 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,100 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,101 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,102 :: 		Segnale_Triplo();
	CALL       _Segnale_Triplo+0
;heltec.c,103 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,104 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,106 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware93
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware93
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware93
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware93:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware19
;heltec.c,107 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,108 :: 		}
L_Init_Hardware19:
;heltec.c,110 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,111 :: 		asm clrwdt;
	CLRWDT
;heltec.c,113 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware94
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware94
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware94
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware94:
	BTFSS      STATUS+0, 0
	GOTO       L_Init_Hardware20
;heltec.c,114 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,115 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,117 :: 		for (j = 1; j <= 6; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Init_Hardware21:
	MOVF       _j+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_Init_Hardware22
;heltec.c,118 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,119 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,120 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,121 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,122 :: 		asm clrwdt;
	CLRWDT
;heltec.c,117 :: 		for (j = 1; j <= 6; j++) {
	INCF       _j+0, 1
;heltec.c,123 :: 		}
	GOTO       L_Init_Hardware21
L_Init_Hardware22:
;heltec.c,124 :: 		} else {
	GOTO       L_Init_Hardware24
L_Init_Hardware20:
;heltec.c,125 :: 		if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware95
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware95
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware95
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware95:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware27
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware96
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware96
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware96
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__Init_Hardware96:
	BTFSS      STATUS+0, 0
	GOTO       L_Init_Hardware27
L__Init_Hardware78:
;heltec.c,127 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,128 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Init_Hardware28:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Init_Hardware29
;heltec.c,129 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,130 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,131 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,132 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,133 :: 		asm clrwdt;
	CLRWDT
;heltec.c,128 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,134 :: 		}
	GOTO       L_Init_Hardware28
L_Init_Hardware29:
;heltec.c,135 :: 		}
L_Init_Hardware27:
;heltec.c,136 :: 		}
L_Init_Hardware24:
;heltec.c,137 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,140 :: 		void main() {
;heltec.c,141 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,142 :: 		sveglie_wdt = 15;
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,144 :: 		while (1) {
L_main31:
;heltec.c,145 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main33
;heltec.c,146 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,147 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,148 :: 		}
L_main33:
;heltec.c,150 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main34
;heltec.c,151 :: 		i = 0;
	CLRF       _i+0
;heltec.c,152 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main35:
	BTFSC      GPIO+0, 0
	GOTO       L_main36
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main36
L__main82:
;heltec.c,153 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,154 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,155 :: 		if (i == 10) GPIO.F5 = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	BSF        GPIO+0, 5
L_main39:
;heltec.c,156 :: 		if (i == 25) GPIO.F5 = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	BCF        GPIO+0, 5
L_main40:
;heltec.c,157 :: 		}
	GOTO       L_main35
L_main36:
;heltec.c,160 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main43
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
L__main81:
;heltec.c,161 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,162 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,164 :: 		if (batteria_mv < soglia_on) { // Se non è OK (sopra 3.7) diamo feedback
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main98:
	BTFSC      STATUS+0, 0
	GOTO       L_main44
;heltec.c,165 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main99:
	BTFSS      STATUS+0, 0
	GOTO       L_main45
;heltec.c,166 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,167 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,168 :: 		for (j = 1; j <= 6; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main46:
	MOVF       _j+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_main47
;heltec.c,169 :: 		GPIO.F5 = 1; Delay_Safe_ms(100);
	BSF        GPIO+0, 5
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,170 :: 		GPIO.F5 = 0; Delay_Safe_ms(100);
	BCF        GPIO+0, 5
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,171 :: 		asm clrwdt;
	CLRWDT
;heltec.c,168 :: 		for (j = 1; j <= 6; j++) {
	INCF       _j+0, 1
;heltec.c,172 :: 		}
	GOTO       L_main46
L_main47:
;heltec.c,173 :: 		} else {
	GOTO       L_main49
L_main45:
;heltec.c,174 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,175 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main50:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main51
;heltec.c,176 :: 		GPIO.F5 = 1; Delay_Safe_ms(100);
	BSF        GPIO+0, 5
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,177 :: 		GPIO.F5 = 0; Delay_Safe_ms(100);
	BCF        GPIO+0, 5
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,178 :: 		asm clrwdt;
	CLRWDT
;heltec.c,175 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,179 :: 		}
	GOTO       L_main50
L_main51:
;heltec.c,180 :: 		}
L_main49:
;heltec.c,181 :: 		}
L_main44:
;heltec.c,184 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,185 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,187 :: 		if (batteria_mv > soglia_off) GPIO.F2 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main100
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main100
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main100
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main100:
	BTFSC      STATUS+0, 0
	GOTO       L_main53
	BCF        GPIO+0, 2
L_main53:
;heltec.c,189 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,190 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,191 :: 		}
L_main43:
;heltec.c,194 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main56
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main56
L__main80:
;heltec.c,195 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,196 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,197 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,199 :: 		temp_mv = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;heltec.c,200 :: 		cifra = temp_mv / 1000;
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
;heltec.c,201 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,202 :: 		temp_mv = temp_mv % 1000;
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
;heltec.c,204 :: 		cifra = temp_mv / 100;
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,205 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,206 :: 		temp_mv = temp_mv % 100;
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
;heltec.c,208 :: 		cifra = temp_mv / 10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,209 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,211 :: 		cifra = 0; // forza sempre a 0 quarto valore
	CLRF       _cifra+0
;heltec.c,212 :: 		Lampeggia_Cifra(cifra);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,214 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,215 :: 		}
L_main56:
;heltec.c,218 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main57
;heltec.c,219 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,220 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main58:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main59
;heltec.c,221 :: 		GPIO.F5 = ~GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,222 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,220 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,223 :: 		}
	GOTO       L_main58
L_main59:
;heltec.c,224 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,225 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,226 :: 		while (in_manutenzione == 1) {
L_main61:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main62
;heltec.c,227 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,228 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,229 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,230 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main63
;heltec.c,231 :: 		i = 0;
	CLRF       _i+0
;heltec.c,232 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main64:
	BTFSC      GPIO+0, 0
	GOTO       L_main65
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main65
L__main79:
;heltec.c,233 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,234 :: 		i++;
	INCF       _i+0, 1
;heltec.c,235 :: 		}
	GOTO       L_main64
L_main65:
;heltec.c,236 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main68
;heltec.c,237 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,238 :: 		Segnale_Triplo();
	CALL       _Segnale_Triplo+0
;heltec.c,239 :: 		}
L_main68:
;heltec.c,240 :: 		} else {
	GOTO       L_main69
L_main63:
;heltec.c,241 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,242 :: 		}
L_main69:
;heltec.c,243 :: 		}
	GOTO       L_main61
L_main62:
;heltec.c,244 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,245 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,246 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,247 :: 		}
L_main57:
;heltec.c,248 :: 		}
L_main34:
;heltec.c,250 :: 		if (in_manutenzione == 0) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main70
;heltec.c,251 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main101
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main101:
	BTFSS      STATUS+0, 0
	GOTO       L_main71
;heltec.c,252 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,253 :: 		if (batteria_mv <= soglia_off) GPIO.F2 = 1;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main102:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
	BSF        GPIO+0, 2
L_main72:
;heltec.c,254 :: 		if (batteria_mv >= soglia_on) GPIO.F2 = 0;
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main103:
	BTFSS      STATUS+0, 0
	GOTO       L_main73
	BCF        GPIO+0, 2
L_main73:
;heltec.c,256 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main74
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
	GOTO       L__main104
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main104
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main104
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main104:
	BTFSS      STATUS+0, 0
	GOTO       L_main75
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
	GOTO       L__main105
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main105
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main105
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main105:
	BTFSC      STATUS+0, 0
	GOTO       L_main76
	BCF        GPIO+0, 2
L_main76:
;heltec.c,262 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,263 :: 		}
L_main75:
;heltec.c,264 :: 		}
L_main74:
;heltec.c,265 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,266 :: 		}
L_main71:
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
	GOTO       L_main77
L_main70:
;heltec.c,272 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,273 :: 		}
L_main77:
;heltec.c,274 :: 		}
	GOTO       L_main31
;heltec.c,275 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
