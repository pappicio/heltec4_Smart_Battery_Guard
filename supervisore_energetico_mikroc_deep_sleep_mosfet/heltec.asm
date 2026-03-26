
_Delay_Safe_ms:

;heltec.c,24 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,26 :: 		for (k = 1; k <= n; k++) {
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
;heltec.c,27 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
;heltec.c,28 :: 		asm clrwdt;
	CLRWDT
;heltec.c,26 :: 		for (k = 1; k <= n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,29 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,30 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Avvio:

;heltec.c,33 :: 		void Segnale_Avvio() {
;heltec.c,34 :: 		for (i = 1; i <= 3; i++) {
	MOVLW      1
	MOVWF      _i+0
L_Segnale_Avvio4:
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Segnale_Avvio5
;heltec.c,35 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,36 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,37 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,38 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,34 :: 		for (i = 1; i <= 3; i++) {
	INCF       _i+0, 1
;heltec.c,39 :: 		}
	GOTO       L_Segnale_Avvio4
L_Segnale_Avvio5:
;heltec.c,40 :: 		}
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Leggi_Batteria_mV:

;heltec.c,43 :: 		void Leggi_Batteria_mV() {
;heltec.c,44 :: 		valore_adc = ADC_Read(1);       // Prima lettura (scarto)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,45 :: 		Delay_Safe_ms(5);
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,46 :: 		valore_adc = ADC_Read(1);       // Seconda lettura reale
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;heltec.c,47 :: 		batteria_mv = ((unsigned long)valore_adc * taratura_vcc) >> 10;
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
L__Leggi_Batteria_mV72:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV73
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV72
L__Leggi_Batteria_mV73:
;heltec.c,48 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Gestione_Stato_Sistema:

;heltec.c,51 :: 		void Gestione_Stato_Sistema() {
;heltec.c,53 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,56 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema75
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema75
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema75
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Gestione_Stato_Sistema75:
	BTFSS      STATUS+0, 0
	GOTO       L_Gestione_Stato_Sistema7
;heltec.c,57 :: 		GPIO.F2 = spento;
	BTFSC      _spento+0, 0
	GOTO       L__Gestione_Stato_Sistema76
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema77
L__Gestione_Stato_Sistema76:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema77:
;heltec.c,58 :: 		}
L_Gestione_Stato_Sistema7:
;heltec.c,60 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema78
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema78
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema78
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__Gestione_Stato_Sistema78:
	BTFSS      STATUS+0, 0
	GOTO       L_Gestione_Stato_Sistema8
;heltec.c,61 :: 		GPIO.F2 = acceso;
	BTFSC      _acceso+0, 0
	GOTO       L__Gestione_Stato_Sistema79
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema80
L__Gestione_Stato_Sistema79:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema80:
;heltec.c,62 :: 		}
L_Gestione_Stato_Sistema8:
;heltec.c,65 :: 		if (giorni_per_reset > 0) {
	MOVF       _giorni_per_reset+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema81
	MOVF       _giorni_per_reset+0, 0
	SUBLW      0
L__Gestione_Stato_Sistema81:
	BTFSC      STATUS+0, 0
	GOTO       L_Gestione_Stato_Sistema9
;heltec.c,67 :: 		soglia_reset_giorni = (unsigned long)giorni_per_reset * RISVEGLI_AL_GIORNO;
	MOVF       _giorni_per_reset+0, 0
	MOVWF      R0+0
	MOVF       _giorni_per_reset+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      189
	MOVWF      R4+0
	MOVLW      146
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      0
	MOVWF      R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _soglia_reset_giorni+0
	MOVF       R0+1, 0
	MOVWF      _soglia_reset_giorni+1
	MOVF       R0+2, 0
	MOVWF      _soglia_reset_giorni+2
	MOVF       R0+3, 0
	MOVWF      _soglia_reset_giorni+3
;heltec.c,69 :: 		if (conteggio_giorni >= soglia_reset_giorni) {
	MOVF       R0+3, 0
	SUBWF      _conteggio_giorni+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema82
	MOVF       R0+2, 0
	SUBWF      _conteggio_giorni+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema82
	MOVF       R0+1, 0
	SUBWF      _conteggio_giorni+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema82
	MOVF       R0+0, 0
	SUBWF      _conteggio_giorni+0, 0
L__Gestione_Stato_Sistema82:
	BTFSS      STATUS+0, 0
	GOTO       L_Gestione_Stato_Sistema10
;heltec.c,71 :: 		if (GPIO.F2 == acceso) {
	CLRF       R1+0
	BTFSC      GPIO+0, 2
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORWF      _acceso+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Gestione_Stato_Sistema11
;heltec.c,72 :: 		GPIO.F2 = spento;        // Forza OFF
	BTFSC      _spento+0, 0
	GOTO       L__Gestione_Stato_Sistema83
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema84
L__Gestione_Stato_Sistema83:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema84:
;heltec.c,73 :: 		Delay_Safe_ms(10000);   // 10 secondi scarica
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,74 :: 		GPIO.F2 = acceso;        // Riavvio
	BTFSC      _acceso+0, 0
	GOTO       L__Gestione_Stato_Sistema85
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema86
L__Gestione_Stato_Sistema85:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema86:
;heltec.c,75 :: 		}
L_Gestione_Stato_Sistema11:
;heltec.c,76 :: 		conteggio_giorni = 0;       // Azzera il ciclo giorni
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;heltec.c,77 :: 		}
L_Gestione_Stato_Sistema10:
;heltec.c,78 :: 		} else {
	GOTO       L_Gestione_Stato_Sistema12
L_Gestione_Stato_Sistema9:
;heltec.c,80 :: 		if (conteggio_giorni > RISVEGLI_AL_GIORNO) {
	MOVF       _conteggio_giorni+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema87
	MOVF       _conteggio_giorni+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema87
	MOVF       _conteggio_giorni+1, 0
	SUBLW      146
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema87
	MOVF       _conteggio_giorni+0, 0
	SUBLW      189
L__Gestione_Stato_Sistema87:
	BTFSC      STATUS+0, 0
	GOTO       L_Gestione_Stato_Sistema13
;heltec.c,81 :: 		conteggio_giorni = 0;
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;heltec.c,82 :: 		}
L_Gestione_Stato_Sistema13:
;heltec.c,83 :: 		}
L_Gestione_Stato_Sistema12:
;heltec.c,84 :: 		}
L_end_Gestione_Stato_Sistema:
	RETURN
; end of _Gestione_Stato_Sistema

_Init_Hardware:

;heltec.c,86 :: 		void Init_Hardware() {
;heltec.c,87 :: 		OSCCON = 0b01100111;    // 4MHz interno
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,88 :: 		CMCON0 = 7;             // Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,89 :: 		ANSEL  = 0b00010010;    // RA1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,91 :: 		acceso = 0;
	CLRF       _acceso+0
;heltec.c,92 :: 		spento = 1;
	MOVLW      1
	MOVWF      _spento+0
;heltec.c,95 :: 		giorni_per_reset = 7;   // Reset ogni 7 gg (0 disabilita)
	MOVLW      7
	MOVWF      _giorni_per_reset+0
	MOVLW      0
	MOVWF      _giorni_per_reset+1
;heltec.c,96 :: 		conteggio_giorni = 0;
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;heltec.c,97 :: 		soglia_off   = 3330;
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,98 :: 		soglia_on    = 3700;
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,99 :: 		taratura_vcc = 5070;
	MOVLW      206
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,101 :: 		GPIO.F2 = acceso;
	BCF        GPIO+0, 2
;heltec.c,102 :: 		TRISIO = 0b00001011;
	MOVLW      11
	MOVWF      TRISIO+0
;heltec.c,104 :: 		OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,105 :: 		WPU = 0b00000001;        // Pull-up su GP0
	MOVLW      1
	MOVWF      WPU+0
;heltec.c,106 :: 		INTCON.GPIE = 1;         // Abilita interrupt GPIO
	BSF        INTCON+0, 3
;heltec.c,107 :: 		IOC.B0 = 1;              // Sveglia su GP0
	BSF        IOC+0, 0
;heltec.c,109 :: 		GPIO.F2 = spento;
	BSF        GPIO+0, 2
;heltec.c,110 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,112 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware89
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware89
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware89
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware89:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware14
;heltec.c,113 :: 		GPIO.F2 = acceso;
	BTFSC      _acceso+0, 0
	GOTO       L__Init_Hardware90
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware91
L__Init_Hardware90:
	BSF        GPIO+0, 2
L__Init_Hardware91:
;heltec.c,114 :: 		} else {
	GOTO       L_Init_Hardware15
L_Init_Hardware14:
;heltec.c,115 :: 		GPIO.F2 = spento;
	BTFSC      _spento+0, 0
	GOTO       L__Init_Hardware92
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware93
L__Init_Hardware92:
	BSF        GPIO+0, 2
L__Init_Hardware93:
;heltec.c,116 :: 		}
L_Init_Hardware15:
;heltec.c,118 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,119 :: 		asm clrwdt;
	CLRWDT
;heltec.c,120 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,121 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_Salva_EEPROM:

;heltec.c,125 :: 		void Salva_EEPROM() {
;heltec.c,126 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,129 :: 		EEPROM_Write(0, (unsigned char)(valore_adc >> 8));   // Parte Alta (Hi)
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       _valore_adc+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,130 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,131 :: 		EEPROM_Write(1, (unsigned char)(valore_adc));        // Parte Bassa (Lo)
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,132 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,134 :: 		EEPROM_Write(2, 0xFF); // Separatore
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,135 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,138 :: 		EEPROM_Write(3, (unsigned char)(batteria_mv >> 24)); // Highest
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
;heltec.c,139 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,140 :: 		EEPROM_Write(4, (unsigned char)(batteria_mv >> 16)); // Higher
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
;heltec.c,141 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,142 :: 		EEPROM_Write(5, (unsigned char)(batteria_mv >> 8));  // Hi
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
;heltec.c,143 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,144 :: 		EEPROM_Write(6, (unsigned char)(batteria_mv));       // Lo
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;heltec.c,145 :: 		Delay_Safe_ms(20);
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,146 :: 		}
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_main:

;heltec.c,149 :: 		void main() {
;heltec.c,150 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,151 :: 		sveglie_wdt = 15;
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,153 :: 		while (1) {
L_main16:
;heltec.c,154 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main18
;heltec.c,155 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,156 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,157 :: 		}
L_main18:
;heltec.c,160 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main19
;heltec.c,161 :: 		i = 0;
	CLRF       _i+0
;heltec.c,162 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main20:
	BTFSC      GPIO+0, 0
	GOTO       L_main21
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main21
L__main67:
;heltec.c,163 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,164 :: 		i++;
	INCF       _i+0, 1
;heltec.c,165 :: 		if (i >= 10) GPIO.F5 = 1;
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main24
	BSF        GPIO+0, 5
L_main24:
;heltec.c,166 :: 		}
	GOTO       L_main20
L_main21:
;heltec.c,168 :: 		if (i >= 10 && i < 50) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main27
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main27
L__main66:
;heltec.c,169 :: 		Salva_EEPROM();
	CALL       _Salva_EEPROM+0
;heltec.c,171 :: 		if (batteria_mv > soglia_off && batteria_mv < soglia_on) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main96
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main96
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main96
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main96:
	BTFSC      STATUS+0, 0
	GOTO       L_main30
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main97:
	BTFSC      STATUS+0, 0
	GOTO       L_main30
L__main65:
;heltec.c,172 :: 		for (i = 1; i <= 3; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main31:
	MOVF       _i+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main32
;heltec.c,173 :: 		GPIO.F5 = 1; Delay_ms(100);
	BSF        GPIO+0, 5
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
;heltec.c,174 :: 		GPIO.F5 = 0; Delay_ms(100);
	BCF        GPIO+0, 5
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main35:
	DECFSZ     R13+0, 1
	GOTO       L_main35
	DECFSZ     R12+0, 1
	GOTO       L_main35
	NOP
	NOP
;heltec.c,175 :: 		asm clrwdt;
	CLRWDT
;heltec.c,172 :: 		for (i = 1; i <= 3; i++) {
	INCF       _i+0, 1
;heltec.c,176 :: 		}
	GOTO       L_main31
L_main32:
;heltec.c,177 :: 		}
L_main30:
;heltec.c,178 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main98:
	BTFSS      STATUS+0, 0
	GOTO       L_main36
;heltec.c,179 :: 		for (i = 1; i <= 6; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main37:
	MOVF       _i+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_main38
;heltec.c,180 :: 		GPIO.F5 = 1; Delay_ms(100);
	BSF        GPIO+0, 5
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	NOP
	NOP
;heltec.c,181 :: 		GPIO.F5 = 0; Delay_ms(100);
	BCF        GPIO+0, 5
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	NOP
	NOP
;heltec.c,182 :: 		asm clrwdt;
	CLRWDT
;heltec.c,179 :: 		for (i = 1; i <= 6; i++) {
	INCF       _i+0, 1
;heltec.c,183 :: 		}
	GOTO       L_main37
L_main38:
;heltec.c,184 :: 		}
L_main36:
;heltec.c,186 :: 		GPIO.F2 = spento;
	BTFSC      _spento+0, 0
	GOTO       L__main99
	BCF        GPIO+0, 2
	GOTO       L__main100
L__main99:
	BSF        GPIO+0, 2
L__main100:
;heltec.c,187 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,188 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,190 :: 		if (batteria_mv > soglia_off) GPIO.F2 = acceso;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main101
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main101
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main101
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main101:
	BTFSC      STATUS+0, 0
	GOTO       L_main42
	BTFSC      _acceso+0, 0
	GOTO       L__main102
	BCF        GPIO+0, 2
	GOTO       L__main103
L__main102:
	BSF        GPIO+0, 2
L__main103:
	GOTO       L_main43
L_main42:
;heltec.c,191 :: 		else GPIO.F2 = spento;
	BTFSC      _spento+0, 0
	GOTO       L__main104
	BCF        GPIO+0, 2
	GOTO       L__main105
L__main104:
	BSF        GPIO+0, 2
L__main105:
L_main43:
;heltec.c,193 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,194 :: 		conteggio_giorni = 0;
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;heltec.c,195 :: 		}
L_main27:
;heltec.c,197 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main44
;heltec.c,198 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,199 :: 		GPIO.F2 = spento;
	BTFSC      _spento+0, 0
	GOTO       L__main106
	BCF        GPIO+0, 2
	GOTO       L__main107
L__main106:
	BSF        GPIO+0, 2
L__main107:
;heltec.c,200 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main45:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main46
;heltec.c,201 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,202 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,200 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,203 :: 		}
	GOTO       L_main45
L_main46:
;heltec.c,204 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,206 :: 		while (in_manutenzione) {
L_main48:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main49
;heltec.c,207 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,208 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,209 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,210 :: 		if (GPIO.F0 == 0) {
	BTFSC      GPIO+0, 0
	GOTO       L_main50
;heltec.c,211 :: 		i = 0;
	CLRF       _i+0
;heltec.c,212 :: 		while (GPIO.F0 == 0 && i < 50) {
L_main51:
	BTFSC      GPIO+0, 0
	GOTO       L_main52
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main52
L__main64:
;heltec.c,213 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,214 :: 		i++;
	INCF       _i+0, 1
;heltec.c,215 :: 		}
	GOTO       L_main51
L_main52:
;heltec.c,216 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main55
;heltec.c,217 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,218 :: 		for (i = 1; i <= 20; i++) {
	MOVLW      1
	MOVWF      _i+0
L_main56:
	MOVF       _i+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main57
;heltec.c,219 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,220 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,218 :: 		for (i = 1; i <= 20; i++) {
	INCF       _i+0, 1
;heltec.c,221 :: 		}
	GOTO       L_main56
L_main57:
;heltec.c,222 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,223 :: 		}
L_main55:
;heltec.c,224 :: 		} else {
	GOTO       L_main59
L_main50:
;heltec.c,225 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,226 :: 		}
L_main59:
;heltec.c,227 :: 		}
	GOTO       L_main48
L_main49:
;heltec.c,228 :: 		Segnale_Avvio();
	CALL       _Segnale_Avvio+0
;heltec.c,229 :: 		GPIO.F2 = acceso;
	BTFSC      _acceso+0, 0
	GOTO       L__main108
	BCF        GPIO+0, 2
	GOTO       L__main109
L__main108:
	BSF        GPIO+0, 2
L__main109:
;heltec.c,230 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,231 :: 		conteggio_giorni = 0;
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;heltec.c,232 :: 		}
L_main44:
;heltec.c,233 :: 		}
L_main19:
;heltec.c,236 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main60
;heltec.c,237 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main110
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main110:
	BTFSS      STATUS+0, 0
	GOTO       L_main61
;heltec.c,238 :: 		Gestione_Stato_Sistema();
	CALL       _Gestione_Stato_Sistema+0
;heltec.c,239 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,240 :: 		}
L_main61:
;heltec.c,241 :: 		}
L_main60:
;heltec.c,244 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main62
;heltec.c,245 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,246 :: 		conteggio_giorni++;
	MOVF       _conteggio_giorni+0, 0
	MOVWF      R0+0
	MOVF       _conteggio_giorni+1, 0
	MOVWF      R0+1
	MOVF       _conteggio_giorni+2, 0
	MOVWF      R0+2
	MOVF       _conteggio_giorni+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _conteggio_giorni+0
	MOVF       R0+1, 0
	MOVWF      _conteggio_giorni+1
	MOVF       R0+2, 0
	MOVWF      _conteggio_giorni+2
	MOVF       R0+3, 0
	MOVWF      _conteggio_giorni+3
;heltec.c,247 :: 		asm clrwdt;
	CLRWDT
;heltec.c,248 :: 		asm sleep;
	SLEEP
;heltec.c,249 :: 		asm nop;
	NOP
;heltec.c,250 :: 		} else {
	GOTO       L_main63
L_main62:
;heltec.c,251 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,252 :: 		}
L_main63:
;heltec.c,253 :: 		}
	GOTO       L_main16
;heltec.c,254 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
