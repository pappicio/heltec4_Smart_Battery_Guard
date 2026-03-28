
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
	GOTO       L__Delay_Safe_ms79
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms79:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,23 :: 		Delay_ms(1);
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
;heltec.c,31 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,32 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,33 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
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
;heltec.c,43 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,44 :: 		Delay_ms(50);
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
;heltec.c,45 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
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
;heltec.c,48 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,49 :: 		Delay_ms(250);
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
;heltec.c,50 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,51 :: 		Delay_ms(250);
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
;heltec.c,63 :: 		somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
;heltec.c,66 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i_adc_L0+0
L_Leggi_Batteria_mV15:
	MOVF       Leggi_Batteria_mV_i_adc_L0+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV16
;heltec.c,67 :: 		somma = somma + ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma_L0+1, 1
;heltec.c,68 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Leggi_Batteria_mV18:
	DECFSZ     R13+0, 1
	GOTO       L_Leggi_Batteria_mV18
	DECFSZ     R12+0, 1
	GOTO       L_Leggi_Batteria_mV18
;heltec.c,66 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	INCF       Leggi_Batteria_mV_i_adc_L0+0, 1
;heltec.c,69 :: 		}
	GOTO       L_Leggi_Batteria_mV15
L_Leggi_Batteria_mV16:
;heltec.c,72 :: 		media_pulita = somma >> 6;
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma_L0+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma_L0+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV83:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV84
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV83
L__Leggi_Batteria_mV84:
;heltec.c,75 :: 		batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
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
L__Leggi_Batteria_mV85:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV86
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV85
L__Leggi_Batteria_mV86:
;heltec.c,76 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_soglia_batteria:

;heltec.c,78 :: 		void soglia_batteria() {
;heltec.c,79 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria88
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria88
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria88
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria88:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria19
;heltec.c,80 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,81 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,83 :: 		for (j = 1; j <= 6; j++) {
	MOVLW      1
	MOVWF      _j+0
L_soglia_batteria20:
	MOVF       _j+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
;heltec.c,84 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,85 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,86 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,87 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,88 :: 		asm clrwdt;
	CLRWDT
;heltec.c,83 :: 		for (j = 1; j <= 6; j++) {
	INCF       _j+0, 1
;heltec.c,89 :: 		}
	GOTO       L_soglia_batteria20
L_soglia_batteria21:
;heltec.c,90 :: 		} else {
	GOTO       L_soglia_batteria23
L_soglia_batteria19:
;heltec.c,91 :: 		if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria89
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria89
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria89
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria89:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria26
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria90
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria90
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria90
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria90:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria26
L__soglia_batteria73:
;heltec.c,93 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,94 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      _j+0
L_soglia_batteria27:
	MOVF       _j+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria28
;heltec.c,95 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,96 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,97 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,98 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,99 :: 		asm clrwdt;
	CLRWDT
;heltec.c,94 :: 		for (j = 1; j <= 3; j++) {
	INCF       _j+0, 1
;heltec.c,100 :: 		}
	GOTO       L_soglia_batteria27
L_soglia_batteria28:
;heltec.c,101 :: 		}
L_soglia_batteria26:
;heltec.c,102 :: 		}
L_soglia_batteria23:
;heltec.c,103 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Init_Hardware:

;heltec.c,106 :: 		void Init_Hardware() {
;heltec.c,107 :: 		OSCCON = 0b01100111;
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,108 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,109 :: 		ANSEL  = 0b00010010;
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,110 :: 		TRISIO = 0b00001011;
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,111 :: 		OPTION_REG = 0b00001111;
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,112 :: 		WPU = 0b00000001;
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,113 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,114 :: 		IOC.B0 = 1;
	BSF        IOC+0, 0
;heltec.c,117 :: 		soglia_off   = 3300;  // 3300 mV
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,118 :: 		soglia_on    = 3600;  // (45%)
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,119 :: 		taratura_vcc = 5050;  // 5050 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,120 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,122 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,123 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;heltec.c,125 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,126 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,127 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,128 :: 		Segnale_Triplo();
	CALL       _Segnale_Triplo+0
;heltec.c,129 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,130 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,132 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware92
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware92
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware92
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware92:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware30
;heltec.c,133 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,134 :: 		}
L_Init_Hardware30:
;heltec.c,136 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,137 :: 		asm clrwdt;
	CLRWDT
;heltec.c,139 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,140 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,143 :: 		void main() {
;heltec.c,144 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,145 :: 		sveglie_wdt = 15;
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,147 :: 		while (1) {
L_main31:
;heltec.c,148 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main33
;heltec.c,149 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,150 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,151 :: 		}
L_main33:
;heltec.c,153 :: 		if (GP0_bit == 0) {
	BTFSC      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L_main34
;heltec.c,154 :: 		i = 0;
	CLRF       _i+0
;heltec.c,155 :: 		while (GP0_bit == 0 && i < 50) {
L_main35:
	BTFSC      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L_main36
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main36
L__main77:
;heltec.c,156 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,157 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,158 :: 		if (i == 10) GP5_bit = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
L_main39:
;heltec.c,159 :: 		if (i == 25) GP5_bit = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
L_main40:
;heltec.c,160 :: 		}
	GOTO       L_main35
L_main36:
;heltec.c,163 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main43
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
L__main76:
;heltec.c,164 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,165 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,167 :: 		if (batteria_mv < soglia_on) {
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main94
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main94
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main94
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main94:
	BTFSC      STATUS+0, 0
	GOTO       L_main44
;heltec.c,168 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,169 :: 		}
L_main44:
;heltec.c,171 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,172 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,174 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main95
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main95
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main95
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main95:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
;heltec.c,175 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,176 :: 		}
L_main45:
;heltec.c,178 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,179 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,180 :: 		}
L_main43:
;heltec.c,183 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main48
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main48
L__main75:
;heltec.c,184 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,185 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,186 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,188 :: 		temp_mv = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;heltec.c,189 :: 		cifra = temp_mv / 1000;
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
;heltec.c,190 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,191 :: 		temp_mv = temp_mv % 1000;
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
;heltec.c,193 :: 		cifra = temp_mv / 100;
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,194 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,195 :: 		temp_mv = temp_mv % 100;
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
;heltec.c,197 :: 		cifra = temp_mv / 10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;heltec.c,198 :: 		Lampeggia_Cifra(cifra);
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,200 :: 		cifra = 0; // forza sempre a 0 quarto valore
	CLRF       _cifra+0
;heltec.c,201 :: 		Lampeggia_Cifra(cifra);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,203 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,204 :: 		}
L_main48:
;heltec.c,207 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main49
;heltec.c,208 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,209 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main50:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main51
;heltec.c,210 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,211 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,209 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,212 :: 		}
	GOTO       L_main50
L_main51:
;heltec.c,213 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,214 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,215 :: 		while (in_manutenzione == 1) {
L_main53:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main54
;heltec.c,216 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,217 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,218 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,219 :: 		if (GP0_bit == 0) {
	BTFSC      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L_main55
;heltec.c,220 :: 		i = 0;
	CLRF       _i+0
;heltec.c,221 :: 		while (GP0_bit == 0 && i < 50) {
L_main56:
	BTFSC      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L_main57
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main57
L__main74:
;heltec.c,222 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,223 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,224 :: 		}
	GOTO       L_main56
L_main57:
;heltec.c,225 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main60
;heltec.c,226 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,227 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main61:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main62
;heltec.c,228 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,229 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,227 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,230 :: 		}
	GOTO       L_main61
L_main62:
;heltec.c,231 :: 		}
L_main60:
;heltec.c,232 :: 		} else {
	GOTO       L_main64
L_main55:
;heltec.c,233 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,234 :: 		}
L_main64:
;heltec.c,235 :: 		}
	GOTO       L_main53
L_main54:
;heltec.c,236 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,237 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,238 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,239 :: 		}
L_main49:
;heltec.c,240 :: 		}
L_main34:
;heltec.c,242 :: 		if (in_manutenzione == 0) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main65
;heltec.c,243 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main96
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main96:
	BTFSS      STATUS+0, 0
	GOTO       L_main66
;heltec.c,244 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,245 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main97:
	BTFSS      STATUS+0, 0
	GOTO       L_main67
;heltec.c,246 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,247 :: 		}
L_main67:
;heltec.c,248 :: 		if (batteria_mv >= soglia_on) {
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
	BTFSS      STATUS+0, 0
	GOTO       L_main68
;heltec.c,249 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,250 :: 		}
L_main68:
;heltec.c,252 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main69
;heltec.c,253 :: 		conteggio_cicli = conteggio_cicli + 1;
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
;heltec.c,254 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
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
	GOTO       L__main99
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main99:
	BTFSS      STATUS+0, 0
	GOTO       L_main70
;heltec.c,255 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,256 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,257 :: 		if (batteria_mv > soglia_off) {
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
	GOTO       L_main71
;heltec.c,258 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,259 :: 		}
L_main71:
;heltec.c,260 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,261 :: 		}
L_main70:
;heltec.c,262 :: 		}
L_main69:
;heltec.c,263 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,264 :: 		}
L_main66:
;heltec.c,265 :: 		sveglie_wdt = sveglie_wdt + 1;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,266 :: 		asm clrwdt;
	CLRWDT
;heltec.c,267 :: 		asm sleep;
	SLEEP
;heltec.c,268 :: 		asm nop;
	NOP
;heltec.c,269 :: 		} else {
	GOTO       L_main72
L_main65:
;heltec.c,270 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,271 :: 		}
L_main72:
;heltec.c,272 :: 		}
	GOTO       L_main31
;heltec.c,273 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
