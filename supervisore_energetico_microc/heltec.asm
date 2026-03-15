
_Segnale_Avvio:

;heltec.c,8 :: 		void Segnale_Avvio() {
;heltec.c,10 :: 		for (j = 1; j <= 3; j++) {
	MOVLW      1
	MOVWF      R1+0
L_Segnale_Avvio0:
	MOVF       R1+0, 0
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
;heltec.c,10 :: 		for (j = 1; j <= 3; j++) {
	INCF       R1+0, 1
;heltec.c,15 :: 		}
	GOTO       L_Segnale_Avvio0
L_Segnale_Avvio1:
;heltec.c,16 :: 		}
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Salva_EEPROM:

;heltec.c,18 :: 		void Salva_EEPROM() {
;heltec.c,19 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,22 :: 		EEPROM_Write(0, (unsigned char)(valore_adc >> 8));
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       R0+1, 0
	MOVWF      R2+0
	CLRF       R2+1
	MOVF       R2+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,23 :: 		Delay_ms(20);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Salva_EEPROM5:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM5
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM5
	NOP
;heltec.c,26 :: 		EEPROM_Write(1, (unsigned char)(valore_adc & 0xFF));
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,27 :: 		Delay_ms(20);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Salva_EEPROM6:
	DECFSZ     R13+0, 1
	GOTO       L_Salva_EEPROM6
	DECFSZ     R12+0, 1
	GOTO       L_Salva_EEPROM6
	NOP
;heltec.c,28 :: 		}
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;heltec.c,30 :: 		void Init_Hardware() {
;heltec.c,32 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,35 :: 		ANSEL  = 0x02;     // Solo AN1 (GP1) è analogico, gli altri digitali
	MOVLW      2
	MOVWF      ANSEL+0
;heltec.c,38 :: 		TRISIO.F0 = 1;     // GP0 Input (Tasto)
	BSF        TRISIO+0, 0
;heltec.c,39 :: 		TRISIO.F1 = 1;     // GP1 Input (ADC)
	BSF        TRISIO+0, 1
;heltec.c,40 :: 		TRISIO.F2 = 0;     // GP2 Output (Heltec)
	BCF        TRISIO+0, 2
;heltec.c,41 :: 		TRISIO.F3 = 1;     // GP3 è solo Input (MCLR)
	BSF        TRISIO+0, 3
;heltec.c,42 :: 		TRISIO.F4 = 0;     // GP4 Output
	BCF        TRISIO+0, 4
;heltec.c,43 :: 		TRISIO.F5 = 0;     // GP5 Output (LED)
	BCF        TRISIO+0, 5
;heltec.c,46 :: 		OPTION_REG.F7 = 0; // 0 = Abilita i pull-up globali
	BCF        OPTION_REG+0, 7
;heltec.c,47 :: 		WPU = 0x01;        // Attiva pull-up specifico solo su GP0 (00000001)
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,50 :: 		GPIO.F2 = 1;       // Heltec spento al boot
	BSF        GPIO+0, 2
;heltec.c,51 :: 		GPIO.F5 = 0;       // LED spento
	BCF        GPIO+0, 5
;heltec.c,53 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,56 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_Init_Hardware7:
	DECFSZ     R13+0, 1
	GOTO       L_Init_Hardware7
	DECFSZ     R12+0, 1
	GOTO       L_Init_Hardware7
	NOP
	NOP
;heltec.c,58 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,59 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,61 :: 		void main() {
;heltec.c,62 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,63 :: 		secondi_contatore = 300;
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;heltec.c,65 :: 		while (1) {
L_main8:
;heltec.c,67 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main10
;heltec.c,68 :: 		i = 0;
	CLRF       _i+0
;heltec.c,70 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main11:
	BTFSC      GPIO+0, 0
	GOTO       L_main12
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main12
L__main49:
;heltec.c,71 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	NOP
	NOP
;heltec.c,72 :: 		i++;
	INCF       _i+0, 1
;heltec.c,73 :: 		if (i >= 10) GPIO.F5 = 1; // Accende LED dopo 1 secondo
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main16
	BSF        GPIO+0, 5
L_main16:
;heltec.c,74 :: 		}
	GOTO       L_main11
L_main12:
;heltec.c,77 :: 		if (i >= 10 && i < 50) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main19
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main19
L__main48:
;heltec.c,78 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,79 :: 		GPIO.F2 = 1;  // Spegne Heltec
	BSF        GPIO+0, 2
;heltec.c,80 :: 		GPIO.F5 = 0;  // Spegne LED
	BCF        GPIO+0, 5
;heltec.c,81 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
	NOP
;heltec.c,82 :: 		GPIO.F2 = 0;  // Riaccende Heltec
	BCF        GPIO+0, 2
;heltec.c,83 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,84 :: 		}
L_main19:
;heltec.c,87 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main21
;heltec.c,88 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,89 :: 		GPIO.F2 = 1; // Spegne Heltec per manutenzione
	BSF        GPIO+0, 2
;heltec.c,92 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main22:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main23
;heltec.c,93 :: 		GPIO.F5 = ~GPIO.F5; // Inverte stato LED
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,94 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	NOP
	NOP
;heltec.c,92 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,95 :: 		}
	GOTO       L_main22
L_main23:
;heltec.c,96 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,97 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,100 :: 		while (in_manutenzione) {
L_main26:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main27
;heltec.c,101 :: 		GPIO.F5 = 1; Delay_ms(500);
	BSF        GPIO+0, 5
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;heltec.c,102 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,104 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main29
;heltec.c,105 :: 		i = 0;
	CLRF       _i+0
;heltec.c,106 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main30:
	BTFSC      GPIO+0, 0
	GOTO       L_main31
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main31
L__main47:
;heltec.c,107 :: 		Delay_ms(100);
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
;heltec.c,108 :: 		i++;
	INCF       _i+0, 1
;heltec.c,109 :: 		}
	GOTO       L_main30
L_main31:
;heltec.c,110 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main35
;heltec.c,111 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,112 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,114 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main36:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main37
;heltec.c,115 :: 		GPIO.F5 = ~GPIO.F5; Delay_ms(100);
	MOVLW      32
	XORWF      GPIO+0, 1
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
;heltec.c,114 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,116 :: 		}
	GOTO       L_main36
L_main37:
;heltec.c,117 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,118 :: 		}
L_main35:
;heltec.c,119 :: 		} else {
	GOTO       L_main40
L_main29:
;heltec.c,120 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	DECFSZ     R11+0, 1
	GOTO       L_main41
	NOP
	NOP
;heltec.c,121 :: 		}
L_main40:
;heltec.c,122 :: 		}
	GOTO       L_main26
L_main27:
;heltec.c,124 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,125 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,126 :: 		secondi_contatore = 300;
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;heltec.c,127 :: 		}
L_main21:
;heltec.c,128 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,129 :: 		}
L_main10:
;heltec.c,132 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main42
;heltec.c,133 :: 		secondi_contatore++;
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;heltec.c,134 :: 		if (secondi_contatore >= 300) {
	MOVLW      1
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVLW      44
	SUBWF      _secondi_contatore+0, 0
L__main54:
	BTFSS      STATUS+0, 0
	GOTO       L_main43
;heltec.c,135 :: 		valore_adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,136 :: 		if (valore_adc < 582) GPIO.F2 = 1; // Spegne
	MOVLW      2
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVLW      70
	SUBWF      R0+0, 0
L__main55:
	BTFSC      STATUS+0, 0
	GOTO       L_main44
	BSF        GPIO+0, 2
L_main44:
;heltec.c,137 :: 		if (valore_adc > 651) GPIO.F2 = 0; // Accende
	MOVF       _valore_adc+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       _valore_adc+0, 0
	SUBLW      139
L__main56:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
	BCF        GPIO+0, 2
L_main45:
;heltec.c,138 :: 		secondi_contatore = 0;
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;heltec.c,139 :: 		}
L_main43:
;heltec.c,140 :: 		}
L_main42:
;heltec.c,141 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	DECFSZ     R12+0, 1
	GOTO       L_main46
	NOP
	NOP
;heltec.c,142 :: 		}
	GOTO       L_main8
;heltec.c,143 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
