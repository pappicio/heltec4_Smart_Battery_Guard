
_Segnale_Avvio:

;heltec.c,9 :: 		void Segnale_Avvio() {
;heltec.c,10 :: 		for (i = 1; i <= 3; i++) {
	MOVLW      1
	MOVWF      _i+0
L_Segnale_Avvio0:
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Segnale_Avvio1
;heltec.c,11 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,12 :: 		Delay_ms(250);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Segnale_Avvio3:
	DECFSZ     R13+0, 1
	GOTO       L_Segnale_Avvio3
	DECFSZ     R12+0, 1
	GOTO       L_Segnale_Avvio3
	DECFSZ     R11+0, 1
	GOTO       L_Segnale_Avvio3
	NOP
	NOP
;heltec.c,13 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,14 :: 		Delay_ms(250);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Segnale_Avvio4:
	DECFSZ     R13+0, 1
	GOTO       L_Segnale_Avvio4
	DECFSZ     R12+0, 1
	GOTO       L_Segnale_Avvio4
	DECFSZ     R11+0, 1
	GOTO       L_Segnale_Avvio4
	NOP
	NOP
;heltec.c,10 :: 		for (i = 1; i <= 3; i++) {
	INCF       _i+0, 1
;heltec.c,15 :: 		}
	GOTO       L_Segnale_Avvio0
L_Segnale_Avvio1:
;heltec.c,16 :: 		}
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Salva_EEPROM:

;heltec.c,19 :: 		void Salva_EEPROM() {
;heltec.c,21 :: 		ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
;heltec.c,22 :: 		Delay_ms(5);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_Salva_EEPROM5:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM5
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM5
;heltec.c,23 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__Salva_EEPROM+0
	MOVF       R0+1, 0
	MOVWF      FLOC__Salva_EEPROM+1
	MOVF       FLOC__Salva_EEPROM+0, 0
	MOVWF      _valore_adc+0
	MOVF       FLOC__Salva_EEPROM+1, 0
	MOVWF      _valore_adc+1
;heltec.c,26 :: 		batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;
	MOVF       FLOC__Salva_EEPROM+0, 0
	MOVWF      R0+0
	MOVF       FLOC__Salva_EEPROM+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
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
L__Salva_EEPROM58:
	BTFSC      STATUS+0, 2
	GOTO       L__Salva_EEPROM59
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Salva_EEPROM58
L__Salva_EEPROM59:
;heltec.c,30 :: 		EEPROM_Write(0, (unsigned short)(valore_adc >> 8));
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       FLOC__Salva_EEPROM+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,31 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM6:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM6
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM6
	NOP
;heltec.c,32 :: 		EEPROM_Write(1, (unsigned short)(valore_adc & 0xFF));
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,33 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM7:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM7
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM7
	NOP
;heltec.c,36 :: 		EEPROM_Write(2, 0xFF);
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,37 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM8:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM8
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM8
	NOP
;heltec.c,41 :: 		EEPROM_Write(3, (unsigned short)(batteria_mv >> 24)); // MSB (più significativo)
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
;heltec.c,42 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM9:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM9
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM9
	NOP
;heltec.c,43 :: 		EEPROM_Write(4, (unsigned short)(batteria_mv >> 16));
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
;heltec.c,44 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM10:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM10
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM10
	NOP
;heltec.c,45 :: 		EEPROM_Write(5, (unsigned short)(batteria_mv >> 8));
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
;heltec.c,46 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM11:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM11
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM11
	NOP
;heltec.c,47 :: 		EEPROM_Write(6, (unsigned short)(batteria_mv & 0xFF)); // LSB (meno significativo)
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,48 :: 		Delay_ms(25);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Salva_EEPROM12:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM12
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM12
	NOP
;heltec.c,49 :: 		}
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;heltec.c,52 :: 		void Init_Hardware() {
;heltec.c,53 :: 		OSCCON = 0b01100000;    // 4MHz interno
	MOVLW      96
	MOVWF      OSCCON+0
;heltec.c,54 :: 		CMCON0 = 7;             // Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,55 :: 		ANSEL  = 0b00000010;    // ANS1 (GP1) Analogico
	MOVLW      2
	MOVWF      ANSEL+0
;heltec.c,56 :: 		TRISIO = 0b00001011;    // RA0, RA1, RA3 Input | RA2, RA5 Output
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,57 :: 		OPTION_REG.NOT_GPPU = 0; // Abilita Pull-ups (bit 7)
	BCF        OPTION_REG+0, 7
;heltec.c,58 :: 		WPU = 0b00000001;       // Pull-up su GP0 (Tasto)
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,60 :: 		GPIO.F2 = 1;            // Heltec SPENTO al boot (Logica Inversa 2N2222 su RST)
	BSF        GPIO+0, 2
;heltec.c,61 :: 		in_manutenzione = 0;    // False
	CLRF       _in_manutenzione+0
;heltec.c,62 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,63 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,65 :: 		void main() {
;heltec.c,66 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,67 :: 		secondi_contatore = 300; // Forza lettura immediata al boot
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;heltec.c,69 :: 		while (1) {
L_main13:
;heltec.c,71 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main15
;heltec.c,72 :: 		i = 0;
	CLRF       _i+0
;heltec.c,73 :: 		while ((GPIO.F0 == 0) && (i < 50)) {
L_main16:
	BTFSC      GPIO+0, 0
	GOTO       L_main17
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main17
L__main55:
;heltec.c,74 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	NOP
	NOP
;heltec.c,75 :: 		i++;
	INCF       _i+0, 1
;heltec.c,76 :: 		if (i >= 10) GPIO.F5 = 1; // Accendi LED dopo 1 sec
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main21
	BSF        GPIO+0, 5
L_main21:
;heltec.c,77 :: 		}
	GOTO       L_main16
L_main17:
;heltec.c,80 :: 		if ((i >= 10) && (i < 50)) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main24
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main24
L__main54:
;heltec.c,81 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,82 :: 		GPIO.F2 = 1; // Forza reset (OFF)
	BSF        GPIO+0, 2
;heltec.c,83 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,84 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
	NOP
;heltec.c,85 :: 		GPIO.F2 = 0; // Rilascia reset (ON)
	BCF        GPIO+0, 2
;heltec.c,86 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,87 :: 		}
L_main24:
;heltec.c,90 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main26
;heltec.c,91 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,92 :: 		GPIO.F2 = 1; // Spegne Heltec
	BSF        GPIO+0, 2
;heltec.c,93 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main27:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main28
;heltec.c,94 :: 		GPIO.F5 = ~GPIO.F5; // Lampeggio rapido ingresso
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,95 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
	NOP
	NOP
;heltec.c,93 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,96 :: 		}
	GOTO       L_main27
L_main28:
;heltec.c,97 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,98 :: 		in_manutenzione = 1; // True
	MOVLW      1
	MOVWF      _in_manutenzione+0
;heltec.c,100 :: 		while (in_manutenzione) {
L_main31:
	MOVF       _in_manutenzione+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main32
;heltec.c,101 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,102 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
	NOP
;heltec.c,103 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,104 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main34
;heltec.c,105 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,106 :: 		while ((GPIO.F0 == 0) && (secondi_contatore < 50)) {
L_main35:
	BTFSC      GPIO+0, 0
	GOTO       L_main36
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main62:
	BTFSC      STATUS+0, 0
	GOTO       L_main36
L__main53:
;heltec.c,107 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main39:
	DECFSZ     R13+0, 1
	GOTO       L_main39
	DECFSZ     R12+0, 1
	GOTO       L_main39
	NOP
	NOP
;heltec.c,108 :: 		secondi_contatore++;
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;heltec.c,109 :: 		}
	GOTO       L_main35
L_main36:
;heltec.c,110 :: 		if (secondi_contatore >= 50) {
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main63:
	BTFSS      STATUS+0, 0
	GOTO       L_main40
;heltec.c,111 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,112 :: 		in_manutenzione = 0;
	CLRF       _in_manutenzione+0
;heltec.c,113 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main41:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main42
;heltec.c,114 :: 		GPIO.F5 = ~GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,115 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main44:
	DECFSZ     R13+0, 1
	GOTO       L_main44
	DECFSZ     R12+0, 1
	GOTO       L_main44
	NOP
	NOP
;heltec.c,113 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,116 :: 		}
	GOTO       L_main41
L_main42:
;heltec.c,117 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,118 :: 		}
L_main40:
;heltec.c,119 :: 		} else {
	GOTO       L_main45
L_main34:
;heltec.c,120 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	DECFSZ     R12+0, 1
	GOTO       L_main46
	DECFSZ     R11+0, 1
	GOTO       L_main46
	NOP
	NOP
;heltec.c,121 :: 		}
L_main45:
;heltec.c,122 :: 		}
	GOTO       L_main31
L_main32:
;heltec.c,123 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,124 :: 		GPIO.F2 = 0; // Riaccende Heltec usciti dalla manutenzione
	BCF        GPIO+0, 2
;heltec.c,125 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,126 :: 		}
L_main26:
;heltec.c,127 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,128 :: 		}
L_main15:
;heltec.c,131 :: 		if (!in_manutenzione) {
	MOVF       _in_manutenzione+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main47
;heltec.c,132 :: 		secondi_contatore++;
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;heltec.c,133 :: 		if (secondi_contatore >= 300) {
	MOVLW      1
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      44
	SUBWF      _secondi_contatore+0, 0
L__main64:
	BTFSS      STATUS+0, 0
	GOTO       L_main48
;heltec.c,135 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,136 :: 		Delay_ms(5);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
;heltec.c,137 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,140 :: 		batteria_mv = ((unsigned long)valore_adc * 5000) >> 10;
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      10
	MOVWF      R8+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       R8+0, 0
L__main65:
	BTFSC      STATUS+0, 2
	GOTO       L__main66
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__main65
L__main66:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
	MOVF       R4+2, 0
	MOVWF      _batteria_mv+2
	MOVF       R4+3, 0
	MOVWF      _batteria_mv+3
;heltec.c,143 :: 		if (batteria_mv <= 3300) {
	MOVF       R4+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       R4+1, 0
	SUBLW      12
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       R4+0, 0
	SUBLW      228
L__main67:
	BTFSS      STATUS+0, 0
	GOTO       L_main50
;heltec.c,144 :: 		GPIO.F2 = 1;  // RST a GND tramite transistor
	BSF        GPIO+0, 2
;heltec.c,145 :: 		}
L_main50:
;heltec.c,146 :: 		if (batteria_mv >= 3700) {
	MOVLW      0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      14
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      116
	SUBWF      _batteria_mv+0, 0
L__main68:
	BTFSS      STATUS+0, 0
	GOTO       L_main51
;heltec.c,147 :: 		GPIO.F2 = 0;  // RST Libero
	BCF        GPIO+0, 2
;heltec.c,148 :: 		}
L_main51:
;heltec.c,150 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,151 :: 		}
L_main48:
;heltec.c,152 :: 		}
L_main47:
;heltec.c,154 :: 		Delay_ms(100); // Base tempi del ciclo main
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main52:
	DECFSZ     R13+0, 1
	GOTO       L_main52
	DECFSZ     R12+0, 1
	GOTO       L_main52
	NOP
	NOP
;heltec.c,155 :: 		}
	GOTO       L_main13
;heltec.c,156 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
