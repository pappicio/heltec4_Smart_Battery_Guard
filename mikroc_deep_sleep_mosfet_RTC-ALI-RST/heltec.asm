
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
	GOTO       L__Delay_Safe_ms116
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms116:
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
	GOTO       L__Estrai_e_Lampeggia119
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia119:
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
L__Leggi_Batteria_mV122:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV123
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV122
L__Leggi_Batteria_mV123:
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
L__Leggi_Batteria_mV124:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV125
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV124
L__Leggi_Batteria_mV125:
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
	GOTO       L__soglia_batteria128
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria128:
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
;heltec.c,159 :: 		Lampi(5, 100);
	MOVLW      5
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
	GOTO       L__soglia_batteria129
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria129:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria21
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria130
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria130:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
L__soglia_batteria104:
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
;heltec.c,165 :: 		} else {
	GOTO       L_soglia_batteria22
L_soglia_batteria21:
;heltec.c,167 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,168 :: 		Lampi(1, 100);
	MOVLW      1
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,169 :: 		}
L_soglia_batteria22:
;heltec.c,170 :: 		}
L_soglia_batteria18:
;heltec.c,171 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;heltec.c,174 :: 		void Scrivi_Ora_RTC(unsigned char s_g_sett, unsigned char s_g, unsigned char s_m, unsigned char s_a, unsigned char s_ore, unsigned char s_min) {
;heltec.c,175 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,176 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,177 :: 		Soft_I2C_Init();     // Inizializza
	CALL       _Soft_I2C_Init+0
;heltec.c,178 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,179 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,180 :: 		Soft_I2C_Write(0xD0); // Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,181 :: 		Soft_I2C_Write(0x00); // Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,182 :: 		Soft_I2C_Write(0x00); // Secondi (sempre 00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,183 :: 		Soft_I2C_Write(s_min); // Minuti (es. 0x05)
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,184 :: 		Soft_I2C_Write(s_ore); // Ore (es. 0x04)
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,185 :: 		Soft_I2C_Write(s_g_sett); // Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,186 :: 		Soft_I2C_Write(s_g);   // Giorno Mese (es. 0x30)
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,187 :: 		Soft_I2C_Write(s_m);   // Mese (es. 0x03)
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,188 :: 		Soft_I2C_Write(s_a);   // Anno (es. 0x26)
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,189 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,190 :: 		Delay_Safe_ms(800);
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,191 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,192 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,193 :: 		}
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;heltec.c,196 :: 		void Init_Hardware() {
;heltec.c,198 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,199 :: 		OSCCON = 0b01100111;
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,202 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,205 :: 		ANSEL = 0b00010010;
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,208 :: 		TRISIO = 0b00001010;
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,211 :: 		OPTION_REG = 0b00001111;
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,214 :: 		WPU = 0b00000000;
	CLRF       WPU+0
;heltec.c,217 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,220 :: 		IOC.F3 = 1;
	BSF        IOC+0, 3
;heltec.c,223 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,226 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;heltec.c,228 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,229 :: 		attivo = 1;
	BSF        _attivo+0, BitPos(_attivo+0)
;heltec.c,232 :: 		RSTpin = 1; // true
	BSF        _RSTpin+0, BitPos(_RSTpin+0)
;heltec.c,235 :: 		RTC_presente = 1; //se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	BSF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,238 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,239 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,243 :: 		soglia_off   = 3300;  //300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;heltec.c,244 :: 		soglia_on    = 3600;  //(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;heltec.c,245 :: 		taratura_vcc = 5010;  //segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      146
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;heltec.c,246 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,250 :: 		if (RSTpin == 1) {
	BTFSS      _RSTpin+0, BitPos(_RSTpin+0)
	GOTO       L_Init_Hardware23
;heltec.c,251 :: 		attivo = 0;
	BCF        _attivo+0, BitPos(_attivo+0)
;heltec.c,252 :: 		}
L_Init_Hardware23:
;heltec.c,255 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__Init_Hardware133
	BCF        GPIO+0, 4
	GOTO       L__Init_Hardware134
L__Init_Hardware133:
	BSF        GPIO+0, 4
L__Init_Hardware134:
;heltec.c,258 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,263 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_Init_Hardware24
;heltec.c,265 :: 		TRISIO.F0 = 0;    // SDA come Uscita (GP0)
	BCF        TRISIO+0, 0
;heltec.c,266 :: 		TRISIO.F2 = 0;    // SCL come Uscita (GP2)
	BCF        TRISIO+0, 2
;heltec.c,267 :: 		GPIO.F0 = 1;      // SDA Alto (Idle I2C)
	BSF        GPIO+0, 0
;heltec.c,268 :: 		GPIO.F2 = 1;      // SCL Alto (Idle I2C)
	BSF        GPIO+0, 2
;heltec.c,270 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,271 :: 		i = 0;
	CLRF       _i+0
;heltec.c,272 :: 		while ((GPIO.F3 == 0) && (i < 15)) {
L_Init_Hardware25:
	BTFSC      GPIO+0, 3
	GOTO       L_Init_Hardware26
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware26
L__Init_Hardware105:
;heltec.c,273 :: 		GPIO.F5 = 1; // LED su GP5
	BSF        GPIO+0, 5
;heltec.c,274 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,275 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,276 :: 		}
	GOTO       L_Init_Hardware25
L_Init_Hardware26:
;heltec.c,279 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware29
;heltec.c,280 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,287 :: 		Scrivi_Ora_RTC(0x06, 0x04, 0x04, 0x26, 0x20, 0x55);
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
;heltec.c,288 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,289 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,291 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,292 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,293 :: 		}
L_Init_Hardware29:
;heltec.c,294 :: 		} else {
	GOTO       L_Init_Hardware30
L_Init_Hardware24:
;heltec.c,296 :: 		TRISIO.F0 = 1;    // SDA in Alta Impedenza (Input)
	BSF        TRISIO+0, 0
;heltec.c,297 :: 		TRISIO.F2 = 1;    // SCL in Alta Impedenza (Input)
	BSF        TRISIO+0, 2
;heltec.c,298 :: 		GPIO.F0 = 0;
	BCF        GPIO+0, 0
;heltec.c,299 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,300 :: 		}
L_Init_Hardware30:
;heltec.c,301 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,304 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,307 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,310 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,313 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,316 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware135
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware135:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware31
;heltec.c,317 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__Init_Hardware136
	BSF        GPIO+0, 4
	GOTO       L__Init_Hardware137
L__Init_Hardware136:
	BCF        GPIO+0, 4
L__Init_Hardware137:
;heltec.c,318 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,319 :: 		} else {
	GOTO       L_Init_Hardware32
L_Init_Hardware31:
;heltec.c,320 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,321 :: 		}
L_Init_Hardware32:
;heltec.c,324 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,325 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,326 :: 		sveglie_wdt = 0;  // Forza lettura batteria al primo giro
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,329 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,330 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,333 :: 		void main() {
;heltec.c,334 :: 		Init_Hardware();                // Configura il chip
	CALL       _Init_Hardware+0
;heltec.c,336 :: 		while (1) {
L_main33:
;heltec.c,338 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main35
;heltec.c,339 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,340 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,341 :: 		}
L_main35:
;heltec.c,344 :: 		if (GPIO.F3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main36
;heltec.c,345 :: 		i = 0;
	CLRF       _i+0
;heltec.c,346 :: 		while ((GPIO.F3 == 0) && (i < 50)) {
L_main37:
	BTFSC      GPIO+0, 3
	GOTO       L_main38
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main38
L__main114:
;heltec.c,347 :: 		Delay_Safe_ms(100); // Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,348 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,349 :: 		if (i == 10) {
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main41
;heltec.c,350 :: 		GPIO.F5 = 1;     // Accende LED dopo 1 secondo di pressione (GP5)
	BSF        GPIO+0, 5
;heltec.c,351 :: 		}
L_main41:
;heltec.c,352 :: 		if (i == 25) {
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main42
;heltec.c,353 :: 		GPIO.F5 = 0;     // Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 5
;heltec.c,354 :: 		}
L_main42:
;heltec.c,355 :: 		}
	GOTO       L_main37
L_main38:
;heltec.c,358 :: 		if ((i >= 10) && (i < 25)) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main45
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main45
L__main113:
;heltec.c,359 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,360 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,363 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main139
	BCF        GPIO+0, 4
	GOTO       L__main140
L__main139:
	BSF        GPIO+0, 4
L__main140:
;heltec.c,364 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,367 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main141
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main141:
	BTFSC      STATUS+0, 0
	GOTO       L_main46
;heltec.c,368 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main142
	BSF        GPIO+0, 4
	GOTO       L__main143
L__main142:
	BCF        GPIO+0, 4
L__main143:
;heltec.c,369 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,370 :: 		} else {
	GOTO       L_main47
L_main46:
;heltec.c,371 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,372 :: 		}
L_main47:
;heltec.c,373 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,374 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,376 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,377 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,378 :: 		}
L_main45:
;heltec.c,381 :: 		if ((i >= 25) && (i < 50)) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main50
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main50
L__main112:
;heltec.c,382 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,383 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,384 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,387 :: 		val_da_lampeggiare = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,389 :: 		Estrai_e_Lampeggia(1000); // Migliaia
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,390 :: 		Estrai_e_Lampeggia(100);  // Centinaia
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,391 :: 		Estrai_e_Lampeggia(10);   // Decine
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,392 :: 		Lampeggia_Cifra(0);       // Unità fisse
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,395 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main51
;heltec.c,396 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,397 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,398 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,399 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,400 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,401 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,402 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,404 :: 		val_da_lampeggiare = (unsigned int)ore;
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,405 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,406 :: 		Lampeggia_Cifra((unsigned char)val_da_lampeggiare); // Il resto sono le unità
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,408 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,411 :: 		val_da_lampeggiare = (unsigned int)minuti;
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,412 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,413 :: 		Lampeggia_Cifra((unsigned char)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,414 :: 		}
L_main51:
;heltec.c,415 :: 		}
L_main50:
;heltec.c,418 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main52
;heltec.c,419 :: 		GPIO.F4 = attivo;                       // Distacca il carico (Heltec OFF) su GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main144
	BCF        GPIO+0, 4
	GOTO       L__main145
L__main144:
	BSF        GPIO+0, 4
L__main145:
;heltec.c,421 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main53:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main54
;heltec.c,422 :: 		GPIO.F5 = !GPIO.F5;         // Lampeggio veloce di conferma
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,423 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,421 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,424 :: 		}
	GOTO       L_main53
L_main54:
;heltec.c,425 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,426 :: 		in_manutenzione = 1;          // Entra nel loop di blocco
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,427 :: 		while (in_manutenzione == 1) {
L_main56:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main57
;heltec.c,429 :: 		GPIO.F5 = 1;
	BSF        GPIO+0, 5
;heltec.c,430 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,431 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,432 :: 		if (GPIO.F3 == 0) {        // Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L_main58
;heltec.c,433 :: 		i = 0;
	CLRF       _i+0
;heltec.c,434 :: 		while ((GPIO.F3 == 0) && (i < 50)) {
L_main59:
	BTFSC      GPIO+0, 3
	GOTO       L_main60
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main60
L__main111:
;heltec.c,435 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,436 :: 		i = i + 1;
	INCF       _i+0, 1
;heltec.c,437 :: 		}
	GOTO       L_main59
L_main60:
;heltec.c,438 :: 		if (i >= 50) {       // Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main63
;heltec.c,439 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,441 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main64:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main65
;heltec.c,442 :: 		GPIO.F5 = !GPIO.F5;
	MOVLW      32
	XORWF      GPIO+0, 1
;heltec.c,443 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,441 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,444 :: 		}
	GOTO       L_main64
L_main65:
;heltec.c,445 :: 		GPIO.F5 = 0;
	BCF        GPIO+0, 5
;heltec.c,446 :: 		}
L_main63:
;heltec.c,447 :: 		} else {
	GOTO       L_main67
L_main58:
;heltec.c,448 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,449 :: 		}
L_main67:
;heltec.c,450 :: 		asm clrwdt;
	CLRWDT
;heltec.c,451 :: 		}
	GOTO       L_main56
L_main57:
;heltec.c,453 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,454 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main146:
	BTFSC      STATUS+0, 0
	GOTO       L_main68
;heltec.c,455 :: 		GPIO.F4 = !attivo; // Carico ON
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main147
	BSF        GPIO+0, 4
	GOTO       L__main148
L__main147:
	BCF        GPIO+0, 4
L__main148:
;heltec.c,456 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,457 :: 		} else {
	GOTO       L_main69
L_main68:
;heltec.c,458 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,459 :: 		}
L_main69:
;heltec.c,460 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,462 :: 		sveglie_wdt = 13; // Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,463 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,464 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,465 :: 		asm clrwdt;
	CLRWDT
;heltec.c,466 :: 		}
L_main52:
;heltec.c,467 :: 		}
L_main36:
;heltec.c,470 :: 		if (in_manutenzione == 0) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main70
;heltec.c,472 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main149
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main149:
	BTFSS      STATUS+0, 0
	GOTO       L_main71
;heltec.c,473 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,475 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main150
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main150:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
;heltec.c,476 :: 		GPIO.F4 = attivo; // Spegne Heltec su GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main151
	BCF        GPIO+0, 4
	GOTO       L__main152
L__main151:
	BSF        GPIO+0, 4
L__main152:
;heltec.c,477 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,478 :: 		}
L_main72:
;heltec.c,480 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main153:
	BTFSS      STATUS+0, 0
	GOTO       L_main73
;heltec.c,481 :: 		GPIO.F4 = !attivo; // Accende Heltec
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main154
	BSF        GPIO+0, 4
	GOTO       L__main155
L__main154:
	BCF        GPIO+0, 4
L__main155:
;heltec.c,482 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,483 :: 		}
L_main73:
;heltec.c,485 :: 		sveglie_wdt = 0; // Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,487 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main74
;heltec.c,488 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,489 :: 		minuti_count = minuti_count + 1;
	INCF       _minuti_count+0, 1
;heltec.c,490 :: 		} else {
	GOTO       L_main75
L_main74:
;heltec.c,491 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,492 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,493 :: 		}
L_main75:
;heltec.c,496 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main76
;heltec.c,497 :: 		conteggio_cicli = conteggio_cicli + 1;
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
;heltec.c,499 :: 		if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
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
	GOTO       L__main156
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main156
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main156
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main156:
	BTFSS      STATUS+0, 0
	GOTO       L_main77
;heltec.c,500 :: 		GPIO.F4 = attivo;           // Ciclo di spegnimento GP4
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main157
	BCF        GPIO+0, 4
	GOTO       L__main158
L__main157:
	BSF        GPIO+0, 4
L__main158:
;heltec.c,501 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,502 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main159:
	BTFSC      STATUS+0, 0
	GOTO       L_main78
;heltec.c,503 :: 		GPIO.F4 = !attivo;       // Riaccensione
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main160
	BSF        GPIO+0, 4
	GOTO       L__main161
L__main160:
	BCF        GPIO+0, 4
L__main161:
;heltec.c,504 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,505 :: 		} else {
	GOTO       L_main79
L_main78:
;heltec.c,506 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,507 :: 		}
L_main79:
;heltec.c,508 :: 		conteggio_cicli = 0;  // Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,509 :: 		}
L_main77:
;heltec.c,510 :: 		}
L_main76:
;heltec.c,513 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main80
;heltec.c,514 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,517 :: 		if (finestra_oraria == 0) {
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L_main81
;heltec.c,519 :: 		if (ore == 4) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main82
;heltec.c,520 :: 		if (reset_fatto == 0) {
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L_main83
;heltec.c,521 :: 		if ((giorno == 1) || (giorno == 4)) {
	MOVF       _giorno+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__main110
	MOVF       _giorno+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main110
	GOTO       L_main86
L__main110:
;heltec.c,522 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main162
	BCF        GPIO+0, 4
	GOTO       L__main163
L__main162:
	BSF        GPIO+0, 4
L__main163:
;heltec.c,523 :: 		Delay_Safe_ms(10000);
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,524 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) { GPIO.F4 = !attivo; }
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main164
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main164:
	BTFSC      STATUS+0, 0
	GOTO       L_main89
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main89
L__main109:
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main165
	BSF        GPIO+0, 4
	GOTO       L__main166
L__main165:
	BCF        GPIO+0, 4
L__main166:
L_main89:
;heltec.c,525 :: 		reset_fatto = 1;
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,526 :: 		}
L_main86:
;heltec.c,527 :: 		}
L_main83:
;heltec.c,528 :: 		} else {
	GOTO       L_main90
L_main82:
;heltec.c,529 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,530 :: 		}
L_main90:
;heltec.c,531 :: 		} else {
	GOTO       L_main91
L_main81:
;heltec.c,533 :: 		if ((ore >= 7) && (ore < 13)) { //dalle 7 alle 13 accendiamo
	MOVLW      7
	SUBWF      _ore+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main94
	MOVLW      13
	SUBWF      _ore+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main94
L__main108:
;heltec.c,535 :: 		if ((giorno >= 1) && (giorno <= 7)) {
	MOVLW      1
	SUBWF      _giorno+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main97
	MOVF       _giorno+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_main97
L__main107:
;heltec.c,536 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main167
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main167:
	BTFSC      STATUS+0, 0
	GOTO       L_main100
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main100
L__main106:
;heltec.c,538 :: 		GPIO.F4 = !attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main168
	BSF        GPIO+0, 4
	GOTO       L__main169
L__main168:
	BCF        GPIO+0, 4
L__main169:
;heltec.c,539 :: 		} else {
	GOTO       L_main101
L_main100:
;heltec.c,540 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main170
	BCF        GPIO+0, 4
	GOTO       L__main171
L__main170:
	BSF        GPIO+0, 4
L__main171:
;heltec.c,541 :: 		}
L_main101:
;heltec.c,542 :: 		}
L_main97:
;heltec.c,543 :: 		} else {
	GOTO       L_main102
L_main94:
;heltec.c,545 :: 		GPIO.F4 = attivo;
	BTFSC      _attivo+0, BitPos(_attivo+0)
	GOTO       L__main172
	BCF        GPIO+0, 4
	GOTO       L__main173
L__main172:
	BSF        GPIO+0, 4
L__main173:
;heltec.c,546 :: 		}
L_main102:
;heltec.c,547 :: 		}
L_main91:
;heltec.c,548 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,549 :: 		}
L_main80:
;heltec.c,550 :: 		}
L_main71:
;heltec.c,553 :: 		sveglie_wdt = sveglie_wdt + 1;    // Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,554 :: 		asm clrwdt;                       // Pulizia watchdog
	CLRWDT
;heltec.c,555 :: 		asm sleep;                        // Il chip dorme (Risparmio Max)
	SLEEP
;heltec.c,556 :: 		asm nop;                          // Istruzione necessaria dopo lo sleep
	NOP
;heltec.c,557 :: 		} else {
	GOTO       L_main103
L_main70:
;heltec.c,559 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,560 :: 		asm clrwdt;
	CLRWDT
;heltec.c,561 :: 		}
L_main103:
;heltec.c,562 :: 		}
	GOTO       L_main33
;heltec.c,563 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
