
_Delay_Safe_ms:

;heltec.c,43 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,45 :: 		for (k = 1; k <= n; k++) {
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Delay_Safe_ms0:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms117
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms117:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,46 :: 		Delay_us(978);             // Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
	MOVLW      2
	MOVWF      R12+0
	MOVLW      67
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
	NOP
	NOP
;heltec.c,47 :: 		asm clrwdt;                // Reset del Watchdog ad ogni millisecondo
	CLRWDT
;heltec.c,45 :: 		for (k = 1; k <= n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,48 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,49 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;heltec.c,52 :: 		void Lampeggia_Cifra(unsigned char c) {
;heltec.c,54 :: 		if (c == 0) {
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Lampeggia_Cifra4
;heltec.c,56 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,57 :: 		Delay_Safe_ms(50);
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,58 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,59 :: 		} else {
	GOTO       L_Lampeggia_Cifra5
L_Lampeggia_Cifra4:
;heltec.c,60 :: 		for (l = 1; l <= c; l++) {
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra6:
	MOVF       Lampeggia_Cifra_l_L0+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra7
;heltec.c,61 :: 		GPIO.F5 = 1;           // Accende LED su GP5
	BSF        GPIO+0, 5
;heltec.c,62 :: 		Delay_Safe_ms(250);    // Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,63 :: 		GPIO.F5 = 0;           // Spegne LED
	BCF        GPIO+0, 5
;heltec.c,64 :: 		Delay_Safe_ms(250);    // Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,65 :: 		asm clrwdt;            // Mantiene il sistema attivo
	CLRWDT
;heltec.c,60 :: 		for (l = 1; l <= c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,66 :: 		}
	GOTO       L_Lampeggia_Cifra6
L_Lampeggia_Cifra7:
;heltec.c,67 :: 		}
L_Lampeggia_Cifra5:
;heltec.c,68 :: 		Delay_Safe_ms(1000);           // Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,69 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;heltec.c,72 :: 		void Estrai_e_Lampeggia(unsigned int divisore) {
;heltec.c,74 :: 		contatore = 0;
	CLRF       Estrai_e_Lampeggia_contatore_L0+0
;heltec.c,75 :: 		while (val_da_lampeggiare >= divisore) {
L_Estrai_e_Lampeggia9:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia120
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia120:
	BTFSS      STATUS+0, 0
	GOTO       L_Estrai_e_Lampeggia10
;heltec.c,76 :: 		val_da_lampeggiare = val_da_lampeggiare - divisore;
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;heltec.c,77 :: 		contatore = contatore + 1;
	INCF       Estrai_e_Lampeggia_contatore_L0+0, 1
;heltec.c,78 :: 		}
	GOTO       L_Estrai_e_Lampeggia9
L_Estrai_e_Lampeggia10:
;heltec.c,79 :: 		Lampeggia_Cifra(contatore);
	MOVF       Estrai_e_Lampeggia_contatore_L0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,80 :: 		}
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;heltec.c,84 :: 		void Leggi_Ora_RTC() {
;heltec.c,87 :: 		GPIO.F5 = 1;          // Accende tutto (LED su GP5)
	BSF        GPIO+0, 5
;heltec.c,88 :: 		Delay_Safe_ms(100);   // Tempo di sveglia
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,91 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,92 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,93 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,96 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,97 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,98 :: 		Soft_I2C_Write(0x01);
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,99 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,100 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,101 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,102 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,104 :: 		minuti = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
	MOVF       Leggi_Ora_RTC_bcd_temp_L0+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      15
	ANDWF      Leggi_Ora_RTC_bcd_temp_L0+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _minuti+0
;heltec.c,106 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,109 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,110 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,111 :: 		Soft_I2C_Write(0x02);
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,112 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,113 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,114 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,115 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,117 :: 		bcd_temp = bcd_temp & 0x3F;
	MOVLW      63
	ANDWF      Leggi_Ora_RTC_bcd_temp_L0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,118 :: 		ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      15
	ANDWF      FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _ore+0
;heltec.c,120 :: 		GPIO.F5 = 0;          // Spegne tutto
	BCF        GPIO+0, 5
;heltec.c,121 :: 		}
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;heltec.c,124 :: 		void Leggi_Batteria_mV() {
;heltec.c,129 :: 		somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
	CLRF       Leggi_Batteria_mV_somma_L0+2
	CLRF       Leggi_Batteria_mV_somma_L0+3
;heltec.c,131 :: 		for (i_idx = 1; i_idx <= 64; i_idx++) {
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i_idx_L0+0
L_Leggi_Batteria_mV11:
	MOVF       Leggi_Batteria_mV_i_idx_L0+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV12
;heltec.c,132 :: 		somma = somma + ADC_Read(1); // Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVF       Leggi_Batteria_mV_somma_L0+0, 0
	ADDWF      R0+0, 1
	MOVF       Leggi_Batteria_mV_somma_L0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Leggi_Batteria_mV_somma_L0+1, 0
	ADDWF      R0+1, 1
	MOVF       Leggi_Batteria_mV_somma_L0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Leggi_Batteria_mV_somma_L0+2, 0
	ADDWF      R0+2, 1
	MOVF       Leggi_Batteria_mV_somma_L0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Leggi_Batteria_mV_somma_L0+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      Leggi_Batteria_mV_somma_L0+0
	MOVF       R0+1, 0
	MOVWF      Leggi_Batteria_mV_somma_L0+1
	MOVF       R0+2, 0
	MOVWF      Leggi_Batteria_mV_somma_L0+2
	MOVF       R0+3, 0
	MOVWF      Leggi_Batteria_mV_somma_L0+3
;heltec.c,133 :: 		Delay_Safe_ms(1);            // Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,131 :: 		for (i_idx = 1; i_idx <= 64; i_idx++) {
	INCF       Leggi_Batteria_mV_i_idx_L0+0, 1
;heltec.c,134 :: 		}
	GOTO       L_Leggi_Batteria_mV11
L_Leggi_Batteria_mV12:
;heltec.c,137 :: 		media_pulita = (unsigned int)(somma >> 6);
	MOVLW      6
	MOVWF      R4+0
	MOVF       Leggi_Batteria_mV_somma_L0+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma_L0+1, 0
	MOVWF      R0+1
	MOVF       Leggi_Batteria_mV_somma_L0+2, 0
	MOVWF      R0+2
	MOVF       Leggi_Batteria_mV_somma_L0+3, 0
	MOVWF      R0+3
	MOVF       R4+0, 0
L__Leggi_Batteria_mV123:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV124
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV123
L__Leggi_Batteria_mV124:
;heltec.c,140 :: 		batteria_mv = (unsigned int)(((unsigned long)media_pulita * taratura_vcc) >> 10);
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVF       _taratura_vcc+0, 0
	MOVWF      R4+0
	MOVF       _taratura_vcc+1, 0
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
L__Leggi_Batteria_mV125:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV126
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV125
L__Leggi_Batteria_mV126:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
;heltec.c,141 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;heltec.c,144 :: 		void Lampi(unsigned char n, unsigned int t_on) {
;heltec.c,145 :: 		for (j = 1; j <= n; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Lampi14:
	MOVF       _j+0, 0
	SUBWF      FARG_Lampi_n+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampi15
;heltec.c,146 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,147 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,148 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,149 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,145 :: 		for (j = 1; j <= n; j++) {
	INCF       _j+0, 1
;heltec.c,150 :: 		}
	GOTO       L_Lampi14
L_Lampi15:
;heltec.c,151 :: 		}
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;heltec.c,154 :: 		void soglia_batteria() {
;heltec.c,155 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria129
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria129:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria17
;heltec.c,156 :: 		GPIO.F5 = 0;                   // Spegne LED su GP5
	BCF        GPIO+0, 5
;heltec.c,157 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,159 :: 		Lampi(6, 100);
	MOVLW      6
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,160 :: 		} else {
	GOTO       L_soglia_batteria18
L_soglia_batteria17:
;heltec.c,161 :: 		if ((batteria_mv > soglia_off) && (batteria_mv <= soglia_on)) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria130
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria130:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria21
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria131
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria131:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
L__soglia_batteria105:
;heltec.c,163 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,164 :: 		Lampi(3, 100);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,165 :: 		}
L_soglia_batteria21:
;heltec.c,166 :: 		}
L_soglia_batteria18:
;heltec.c,167 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;heltec.c,170 :: 		void Scrivi_Ora_RTC(unsigned char s_g_sett, unsigned char s_g, unsigned char s_m, unsigned char s_a, unsigned char s_ore, unsigned char s_min) {
;heltec.c,171 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,172 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,173 :: 		Soft_I2C_Init();     // Inizializza
	CALL       _Soft_I2C_Init+0
;heltec.c,174 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,175 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,176 :: 		Soft_I2C_Write(0xD0); // Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,177 :: 		Soft_I2C_Write(0x00); // Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,178 :: 		Soft_I2C_Write(0x00); // Secondi (sempre 00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,179 :: 		Soft_I2C_Write(s_min); // Minuti (es. 0x05)
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,180 :: 		Soft_I2C_Write(s_ore); // Ore (es. 0x04)
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,181 :: 		Soft_I2C_Write(s_g_sett); // Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,182 :: 		Soft_I2C_Write(s_g);   // Giorno Mese (es. 0x30)
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,183 :: 		Soft_I2C_Write(s_m);   // Mese (es. 0x03)
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,184 :: 		Soft_I2C_Write(s_a);   // Anno (es. 0x26)
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,185 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,186 :: 		Delay_Safe_ms(800);
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,187 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,188 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,189 :: 		}
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;heltec.c,192 :: 		void Init_Hardware() {
;heltec.c,194 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,195 :: 		OSCCON = 0b01100111;
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,198 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,201 :: 		ANSEL = 0b00010010;
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,204 :: 		TRISIO = 0b00001010;
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,207 :: 		OPTION_REG = 0b00001111;
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,210 :: 		WPU = 0b00000000;
	CLRF       WPU+0
;heltec.c,213 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,216 :: 		IOC.F3 = 1;
	BSF        IOC+0, 3
;heltec.c,219 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,222 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;heltec.c,224 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,225 :: 		attivo = 1;
	BSF        _attivo+0, BitPos(_attivo+0)
;heltec.c,228 :: 		RSTpin = 1; // true
	BSF        _RSTpin+0, BitPos(_RSTpin+0)
;heltec.c,231 :: 		RTC_presente = 1; //se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	BSF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,234 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,235 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,239 :: 		soglia_off   = 3300;  //300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;heltec.c,240 :: 		soglia_on    = 3600;  //(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;heltec.c,241 :: 		taratura_vcc = 5010;  //segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      146
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;heltec.c,242 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,246 :: 		if (RSTpin == 1) {
	BTFSS      _RSTpin+0, BitPos(_RSTpin+0)
	GOTO       L_Init_Hardware22
;heltec.c,247 :: 		attivo = 0;
	BCF        _attivo+0, BitPos(_attivo+0)
;heltec.c,248 :: 		}
L_Init_Hardware22:
;heltec.c,251 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__Init_Hardware134
	BCF        GPIO+0, 4
	GOTO       L__Init_Hardware135
L__Init_Hardware134:
	BSF        GPIO+0, 4
L__Init_Hardware135:
;heltec.c,254 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,259 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_Init_Hardware23
;heltec.c,261 :: 		TRISIO.F0 = 0;    // SDA come Uscita (GP0)
	BCF        TRISIO+0, 0
;heltec.c,262 :: 		TRISIO.F2 = 0;    // SCL come Uscita (GP2)
	BCF        TRISIO+0, 2
;heltec.c,263 :: 		GPIO.F0 = 1;      // SDA Alto (Idle I2C)
	BSF        GPIO+0, 0
;heltec.c,264 :: 		GPIO.F2 = 1;      // SCL Alto (Idle I2C)
	BSF        GPIO+0, 2
;heltec.c,266 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,267 :: 		i = 0;
	CLRF       _i+0
;heltec.c,268 :: 		while ((GPIO.F3 == 0) && (i < 15)) {
L_Init_Hardware24:
	BTFSC      GPIO+0, 3
	GOTO       L_Init_Hardware25
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware25
L__Init_Hardware106:
;heltec.c,269 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,270 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,271 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,272 :: 		}
	GOTO       L_Init_Hardware24
L_Init_Hardware25:
;heltec.c,275 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware28
;heltec.c,276 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,283 :: 		Scrivi_Ora_RTC(0x06, 0x04, 0x04, 0x26, 0x20, 0x55);
	MOVLW      6
	MOVWF      FARG_Scrivi_Ora_RTC_s_g_sett+0
	MOVLW      4
	MOVWF      FARG_Scrivi_Ora_RTC_s_g+0
	MOVLW      4
	MOVWF      FARG_Scrivi_Ora_RTC_s_m+0
	MOVLW      38
	MOVWF      FARG_Scrivi_Ora_RTC_s_a+0
	MOVLW      32
	MOVWF      FARG_Scrivi_Ora_RTC_s_ore+0
	MOVLW      85
	MOVWF      FARG_Scrivi_Ora_RTC_s_min+0
	CALL       _Scrivi_Ora_RTC+0
;heltec.c,284 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,285 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,287 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,288 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,289 :: 		}
L_Init_Hardware28:
;heltec.c,290 :: 		} else {
	GOTO       L_Init_Hardware29
L_Init_Hardware23:
;heltec.c,292 :: 		TRISIO.F0 = 1;    // SDA in Alta Impedenza (Input)
	BSF        TRISIO+0, 0
;heltec.c,293 :: 		TRISIO.F2 = 1;    // SCL in Alta Impedenza (Input)
	BSF        TRISIO+0, 2
;heltec.c,294 :: 		GPIO.F0 = 0;
	BCF        GPIO+0, 0
;heltec.c,295 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,296 :: 		}
L_Init_Hardware29:
;heltec.c,297 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,300 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,303 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,306 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,309 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,312 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware136
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware136:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware30
;heltec.c,313 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__Init_Hardware137
	BSF        GPIO+0, 4
	GOTO       L__Init_Hardware138
L__Init_Hardware137:
	BCF        GPIO+0, 4
L__Init_Hardware138:
;heltec.c,314 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,315 :: 		} else {
	GOTO       L_Init_Hardware31
L_Init_Hardware30:
;heltec.c,316 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,317 :: 		}
L_Init_Hardware31:
;heltec.c,320 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,321 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,322 :: 		sveglie_wdt = 0;  // Forza lettura batteria al primo giro
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,325 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,326 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,329 :: 		void main() {
;heltec.c,330 :: 		Init_Hardware();                // Configura il chip
	CALL       _Init_Hardware+0
;heltec.c,332 :: 		while (1) {
L_main32:
;heltec.c,334 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main34
;heltec.c,335 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,336 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,337 :: 		}
L_main34:
;heltec.c,340 :: 		if (GPIO.F3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main35
;heltec.c,341 :: 		i = 0;
	CLRF       _i+0
;heltec.c,342 :: 		while ((GPIO.F3 == 0) && (i < 50)) {
L_main36:
	BTFSC      GPIO+0, 3
	GOTO       L_main37
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main37
L__main115:
;heltec.c,343 :: 		Delay_Safe_ms(100); // Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,344 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,345 :: 		if (i == 10) {
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main40
;heltec.c,346 :: 		GPIO.F5 = 1;     // Accende LED dopo 1 secondo di pressione (GP5)
	BSF        GPIO+0, 5
;heltec.c,347 :: 		}
L_main40:
;heltec.c,348 :: 		if (i == 25) {
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main41
;heltec.c,349 :: 		GPIO.F5 = 0;     // Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 5
;heltec.c,350 :: 		}
L_main41:
;heltec.c,351 :: 		}
	GOTO       L_main36
L_main37:
;heltec.c,354 :: 		if ((i >= 10) && (i < 25)) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main44
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main44
L__main114:
;heltec.c,355 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,356 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,359 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main140
	BCF        GPIO+0, 4
	GOTO       L__main141
L__main140:
	BSF        GPIO+0, 4
L__main141:
;heltec.c,360 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,363 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main142
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main142:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
;heltec.c,364 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main143
	BSF        GPIO+0, 4
	GOTO       L__main144
L__main143:
	BCF        GPIO+0, 4
L__main144:
;heltec.c,365 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,366 :: 		} else {
	GOTO       L_main46
L_main45:
;heltec.c,367 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,368 :: 		}
L_main46:
;heltec.c,369 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,370 :: 		if (batteria_mv < soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main145
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main145:
	BTFSC      STATUS+0, 0
	GOTO       L_main47
;heltec.c,371 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,372 :: 		}
L_main47:
;heltec.c,373 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,374 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,375 :: 		}
L_main44:
;heltec.c,378 :: 		if ((i >= 25) && (i < 50)) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main50
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main50
L__main113:
;heltec.c,379 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,380 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,381 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,384 :: 		val_da_lampeggiare = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,386 :: 		Estrai_e_Lampeggia(1000); // Migliaia
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,387 :: 		Estrai_e_Lampeggia(100);  // Centinaia
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,388 :: 		Estrai_e_Lampeggia(10);   // Decine
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,389 :: 		Lampeggia_Cifra(0);       // Unità fisse
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,392 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main51
;heltec.c,393 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,394 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,395 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,396 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,397 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,398 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,399 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,401 :: 		val_da_lampeggiare = (unsigned int)ore;
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,402 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,403 :: 		Lampeggia_Cifra((unsigned char)val_da_lampeggiare); // Il resto sono le unità
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,405 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,408 :: 		val_da_lampeggiare = (unsigned int)minuti;
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,409 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,410 :: 		Lampeggia_Cifra((unsigned char)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,411 :: 		}
L_main51:
;heltec.c,412 :: 		}
L_main50:
;heltec.c,415 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main52
;heltec.c,416 :: 		GPIO.F4 = attivo;                       // Distacca il carico (Heltec OFF) su GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main146
	BCF        GPIO+0, 4
	GOTO       L__main147
L__main146:
	BSF        GPIO+0, 4
L__main147:
;heltec.c,418 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main53:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main54
;heltec.c,419 :: 		GPIO.F5 = !GPIO.F5;         // Lampeggio veloce di conferma
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,420 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,418 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,421 :: 		}
	GOTO       L_main53
L_main54:
;heltec.c,422 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,423 :: 		in_manutenzione = 1;          // Entra nel loop di blocco
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,424 :: 		while (in_manutenzione == 1) {
L_main56:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main57
;heltec.c,426 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,427 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,428 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,429 :: 		if (GPIO.F3 == 0) {        // Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L_main58
;heltec.c,430 :: 		i = 0;
	CLRF       _i+0
;heltec.c,431 :: 		while ((GPIO.F3 == 0) && (i < 50)) {
L_main59:
	BTFSC      GPIO+0, 3
	GOTO       L_main60
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main60
L__main112:
;heltec.c,432 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,433 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,434 :: 		}
	GOTO       L_main59
L_main60:
;heltec.c,435 :: 		if (i >= 50) {       // Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main63
;heltec.c,436 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,438 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main64:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main65
;heltec.c,439 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,440 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,438 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,441 :: 		}
	GOTO       L_main64
L_main65:
;heltec.c,442 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,443 :: 		}
L_main63:
;heltec.c,444 :: 		} else {
	GOTO       L_main67
L_main58:
;heltec.c,445 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,446 :: 		}
L_main67:
;heltec.c,447 :: 		asm clrwdt;
	CLRWDT
;heltec.c,448 :: 		}
	GOTO       L_main56
L_main57:
;heltec.c,450 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,451 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main148
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main148:
	BTFSC      STATUS+0, 0
	GOTO       L_main68
;heltec.c,452 :: 		GPIO.F4 = !attivo; // Carico ON
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main149
	BSF        GPIO+0, 4
	GOTO       L__main150
L__main149:
	BCF        GPIO+0, 4
L__main150:
;heltec.c,453 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,454 :: 		} else {
	GOTO       L_main69
L_main68:
;heltec.c,455 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,456 :: 		}
L_main69:
;heltec.c,457 :: 		if (batteria_mv < soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main151
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main151:
	BTFSC      STATUS+0, 0
	GOTO       L_main70
;heltec.c,458 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,459 :: 		}
L_main70:
;heltec.c,460 :: 		sveglie_wdt = 13; // Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,461 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,462 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,463 :: 		asm clrwdt;
	CLRWDT
;heltec.c,464 :: 		}
L_main52:
;heltec.c,465 :: 		}
L_main35:
;heltec.c,468 :: 		if (in_manutenzione == 0) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main71
;heltec.c,470 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main152
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main152:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
;heltec.c,471 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,473 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main153:
	BTFSS      STATUS+0, 0
	GOTO       L_main73
;heltec.c,474 :: 		GPIO.F4 = attivo; // Spegne Heltec su GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main154
	BCF        GPIO+0, 4
	GOTO       L__main155
L__main154:
	BSF        GPIO+0, 4
L__main155:
;heltec.c,475 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,476 :: 		}
L_main73:
;heltec.c,478 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main156
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main156:
	BTFSS      STATUS+0, 0
	GOTO       L_main74
;heltec.c,479 :: 		GPIO.F4 = !attivo; // Accende Heltec
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main157
	BSF        GPIO+0, 4
	GOTO       L__main158
L__main157:
	BCF        GPIO+0, 4
L__main158:
;heltec.c,480 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,481 :: 		}
L_main74:
;heltec.c,483 :: 		sveglie_wdt = 0; // Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,485 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main75
;heltec.c,486 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,487 :: 		minuti_count = minuti_count + 1;
	INCF       _minuti_count+0, 1
;heltec.c,488 :: 		} else {
	GOTO       L_main76
L_main75:
;heltec.c,489 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,490 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,491 :: 		}
L_main76:
;heltec.c,494 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main77
;heltec.c,495 :: 		conteggio_cicli = conteggio_cicli + 1;
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
;heltec.c,497 :: 		if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
	MOVF       _cicli_per_giorno+0, 0
	MOVWF      R0+0
	MOVF       _cicli_per_giorno+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _giorni_riavvio+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+3, 0
	SUBWF      _conteggio_cicli+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main159:
	BTFSS      STATUS+0, 0
	GOTO       L_main78
;heltec.c,498 :: 		GPIO.F4 = attivo;           // Ciclo di spegnimento GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main160
	BCF        GPIO+0, 4
	GOTO       L__main161
L__main160:
	BSF        GPIO+0, 4
L__main161:
;heltec.c,499 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,500 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main162:
	BTFSC      STATUS+0, 0
	GOTO       L_main79
;heltec.c,501 :: 		GPIO.F4 = !attivo;       // Riaccensione
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main163
	BSF        GPIO+0, 4
	GOTO       L__main164
L__main163:
	BCF        GPIO+0, 4
L__main164:
;heltec.c,502 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,503 :: 		} else {
	GOTO       L_main80
L_main79:
;heltec.c,504 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,505 :: 		}
L_main80:
;heltec.c,506 :: 		conteggio_cicli = 0;  // Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,507 :: 		}
L_main78:
;heltec.c,508 :: 		}
L_main77:
;heltec.c,511 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main81
;heltec.c,512 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,515 :: 		if (finestra_oraria == 0) {
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L_main82
;heltec.c,517 :: 		if (ore == 4) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main83
;heltec.c,518 :: 		if (reset_fatto == 0) {
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L_main84
;heltec.c,519 :: 		if ((giorno == 1) || (giorno == 4)) {
	MOVF       _giorno+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__main111
	MOVF       _giorno+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main111
	GOTO       L_main87
L__main111:
;heltec.c,520 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main165
	BCF        GPIO+0, 4
	GOTO       L__main166
L__main165:
	BSF        GPIO+0, 4
L__main166:
;heltec.c,521 :: 		Delay_Safe_ms(10000);
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,522 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) { GPIO.F4 = !attivo; }
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main167
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main167:
	BTFSC      STATUS+0, 0
	GOTO       L_main90
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main90
L__main110:
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main168
	BSF        GPIO+0, 4
	GOTO       L__main169
L__main168:
	BCF        GPIO+0, 4
L__main169:
L_main90:
;heltec.c,523 :: 		reset_fatto = 1;
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,524 :: 		}
L_main87:
;heltec.c,525 :: 		}
L_main84:
;heltec.c,526 :: 		} else {
	GOTO       L_main91
L_main83:
;heltec.c,527 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,528 :: 		}
L_main91:
;heltec.c,529 :: 		} else {
	GOTO       L_main92
L_main82:
;heltec.c,531 :: 		if ((ore >= 7) && (ore < 13)) { //dalle 7 alle 13 accendiamo
	MOVLW      7
	SUBWF      _ore+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main95
	MOVLW      13
	SUBWF      _ore+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main95
L__main109:
;heltec.c,533 :: 		if ((giorno >= 1) && (giorno <= 7)) {
	MOVLW      1
	SUBWF      _giorno+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main98
	MOVF       _giorno+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_main98
L__main108:
;heltec.c,534 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main170
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main170:
	BTFSC      STATUS+0, 0
	GOTO       L_main101
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main101
L__main107:
;heltec.c,536 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main171
	BSF        GPIO+0, 4
	GOTO       L__main172
L__main171:
	BCF        GPIO+0, 4
L__main172:
;heltec.c,537 :: 		} else {
	GOTO       L_main102
L_main101:
;heltec.c,538 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main173
	BCF        GPIO+0, 4
	GOTO       L__main174
L__main173:
	BSF        GPIO+0, 4
L__main174:
;heltec.c,539 :: 		}
L_main102:
;heltec.c,540 :: 		}
L_main98:
;heltec.c,541 :: 		} else {
	GOTO       L_main103
L_main95:
;heltec.c,543 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main175
	BCF        GPIO+0, 4
	GOTO       L__main176
L__main175:
	BSF        GPIO+0, 4
L__main176:
;heltec.c,544 :: 		}
L_main103:
;heltec.c,545 :: 		}
L_main92:
;heltec.c,546 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,547 :: 		}
L_main81:
;heltec.c,548 :: 		}
L_main72:
;heltec.c,551 :: 		sveglie_wdt = sveglie_wdt + 1;    // Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,552 :: 		asm clrwdt;                       // Pulizia watchdog
	CLRWDT
;heltec.c,553 :: 		asm sleep;                        // Il chip dorme (Risparmio Max)
	SLEEP
;heltec.c,554 :: 		asm nop;                          // Istruzione necessaria dopo lo sleep
	NOP
;heltec.c,555 :: 		} else {
	GOTO       L_main104
L_main71:
;heltec.c,557 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,558 :: 		asm clrwdt;
	CLRWDT
;heltec.c,559 :: 		}
L_main104:
;heltec.c,560 :: 		}
	GOTO       L_main32
;heltec.c,561 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
