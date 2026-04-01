
_Delay_Safe_ms:

;heltec.c,39 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,41 :: 		for (k = 0; k < n; k++) {
	CLRF       R1+0
	CLRF       R1+1
L_Delay_Safe_ms0:
	MOVF       FARG_Delay_Safe_ms_n+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms97
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	SUBWF      R1+0, 0
L__Delay_Safe_ms97:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,42 :: 		delay_us(980);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      68
	MOVWF      R13+0
L_Delay_Safe_ms3:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_Safe_ms3
	DECFSZ     R12+0, 1
	GOTO       L_Delay_Safe_ms3
	NOP
;heltec.c,43 :: 		asm clrwdt; // Reset del Watchdog via Assembly
	CLRWDT
;heltec.c,41 :: 		for (k = 0; k < n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,44 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,45 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;heltec.c,48 :: 		void Lampeggia_Cifra(unsigned short c) {
;heltec.c,50 :: 		if (c == 0) {
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Lampeggia_Cifra4
;heltec.c,51 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,52 :: 		Delay_Safe_ms(50);
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,53 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,54 :: 		} else {
	GOTO       L_Lampeggia_Cifra5
L_Lampeggia_Cifra4:
;heltec.c,55 :: 		for (l = 0; l < c; l++) {
	CLRF       Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra6:
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	SUBWF      Lampeggia_Cifra_l_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra7
;heltec.c,56 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,57 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,58 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,59 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,55 :: 		for (l = 0; l < c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,60 :: 		}
	GOTO       L_Lampeggia_Cifra6
L_Lampeggia_Cifra7:
;heltec.c,61 :: 		}
L_Lampeggia_Cifra5:
;heltec.c,62 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,63 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;heltec.c,66 :: 		void Estrai_e_Lampeggia(unsigned int divisore) {
;heltec.c,67 :: 		unsigned short contatore = 0;
	CLRF       Estrai_e_Lampeggia_contatore_L0+0
;heltec.c,68 :: 		while (val_da_lampeggiare >= divisore) {
L_Estrai_e_Lampeggia9:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia100
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia100:
	BTFSS      STATUS+0, 0
	GOTO       L_Estrai_e_Lampeggia10
;heltec.c,69 :: 		val_da_lampeggiare -= divisore;
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;heltec.c,70 :: 		contatore++;
	INCF       Estrai_e_Lampeggia_contatore_L0+0, 1
;heltec.c,71 :: 		}
	GOTO       L_Estrai_e_Lampeggia9
L_Estrai_e_Lampeggia10:
;heltec.c,72 :: 		Lampeggia_Cifra(contatore);
	MOVF       Estrai_e_Lampeggia_contatore_L0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,73 :: 		}
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;heltec.c,76 :: 		void Leggi_Ora_RTC() {
;heltec.c,77 :: 		GPIO.F2 = 1; // LED Acceso durante I2C
	BSF        GPIO+0, 2
;heltec.c,78 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,79 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,80 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,83 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,84 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,85 :: 		Soft_I2C_Write(0x01); // Punta ai minuti
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,88 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,89 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,91 :: 		bcd_val = Soft_I2C_Read(1); // Minuti
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	MOVLW      0
	MOVWF      FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;heltec.c,92 :: 		minuti = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);
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
	MOVWF      _minuti+0
;heltec.c,94 :: 		bcd_val = Soft_I2C_Read(1); // Ore
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	MOVLW      0
	MOVWF      FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;heltec.c,95 :: 		bcd_val &= 0x3F;            // Pulizia bit 12/24h
	MOVLW      63
	ANDWF      R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;heltec.c,96 :: 		ore = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);
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
;heltec.c,98 :: 		bcd_val = Soft_I2C_Read(0); // Giorno Settimana
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;heltec.c,99 :: 		giorno = bcd_val & 0x07;
	MOVLW      7
	ANDWF      R0+0, 0
	MOVWF      _giorno+0
;heltec.c,101 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,102 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,103 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,104 :: 		}
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;heltec.c,107 :: 		void Leggi_Batteria_mV() {
;heltec.c,109 :: 		unsigned long somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
	CLRF       Leggi_Batteria_mV_somma_L0+2
	CLRF       Leggi_Batteria_mV_somma_L0+3
;heltec.c,112 :: 		for (k = 0; k < 64; k++) {
	CLRF       Leggi_Batteria_mV_k_L0+0
L_Leggi_Batteria_mV11:
	MOVLW      64
	SUBWF      Leggi_Batteria_mV_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV12
;heltec.c,113 :: 		somma += ADC_Read(1);
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
;heltec.c,114 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,112 :: 		for (k = 0; k < 64; k++) {
	INCF       Leggi_Batteria_mV_k_L0+0, 1
;heltec.c,115 :: 		}
	GOTO       L_Leggi_Batteria_mV11
L_Leggi_Batteria_mV12:
;heltec.c,116 :: 		media_pulita = (unsigned int)(somma >> 6);
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
L__Leggi_Batteria_mV103:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV104
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV103
L__Leggi_Batteria_mV104:
;heltec.c,117 :: 		batteria_mv = ((unsigned long)media_pulita * taratura_vcc) >> 10;
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
L__Leggi_Batteria_mV105:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV106
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV105
L__Leggi_Batteria_mV106:
;heltec.c,118 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;heltec.c,121 :: 		void Lampi(unsigned short n, unsigned int t_on) {
;heltec.c,123 :: 		for (k = 0; k < n; k++) {
	CLRF       Lampi_k_L0+0
L_Lampi14:
	MOVF       FARG_Lampi_n+0, 0
	SUBWF      Lampi_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampi15
;heltec.c,124 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,125 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,126 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,127 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,123 :: 		for (k = 0; k < n; k++) {
	INCF       Lampi_k_L0+0, 1
;heltec.c,128 :: 		}
	GOTO       L_Lampi14
L_Lampi15:
;heltec.c,129 :: 		}
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;heltec.c,132 :: 		void soglia_batteria() {
;heltec.c,133 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria109
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria109
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria109
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria109:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria17
;heltec.c,134 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,135 :: 		Lampi(6, 100);
	MOVLW      6
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,136 :: 		} else if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
	GOTO       L_soglia_batteria18
L_soglia_batteria17:
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria110
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria110
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria110
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria110:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria21
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria111
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria111
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria111
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria111:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
L__soglia_batteria87:
;heltec.c,137 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,138 :: 		Lampi(3, 100);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,139 :: 		}
L_soglia_batteria21:
L_soglia_batteria18:
;heltec.c,140 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;heltec.c,143 :: 		void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
;heltec.c,144 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,145 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,146 :: 		Soft_I2C_Init();
	CALL       _Soft_I2C_Init+0
;heltec.c,147 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,148 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,149 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,150 :: 		Soft_I2C_Write(0x00); // Inizia dai secondi
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,152 :: 		Soft_I2C_Write(0x00);  // Sec
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,153 :: 		Soft_I2C_Write(s_min); // Min
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,154 :: 		Soft_I2C_Write(s_ore); // Ore
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,155 :: 		Soft_I2C_Write(s_g_sett);
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,156 :: 		Soft_I2C_Write(s_g);
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,157 :: 		Soft_I2C_Write(s_m);
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,158 :: 		Soft_I2C_Write(s_a);
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,159 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,160 :: 		Delay_Safe_ms(800);
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,161 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,162 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,163 :: 		}
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;heltec.c,166 :: 		void Init_Hardware() {
;heltec.c,167 :: 		OSCCON = 0b01100111; // 4MHz
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,168 :: 		CMCON0 = 7;          // No comparatori
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,169 :: 		ANSEL  = 0b00010010; // AN1 analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,170 :: 		TRISIO = 0b00001010; // GP1, GP3 Input
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,171 :: 		OPTION_REG = 0b00001111; // WDT 1:128 (~2.3s)
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,172 :: 		WPU = 0;
	CLRF       WPU+0
;heltec.c,173 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,174 :: 		IOC.B3 = 1;
	BSF        IOC+0, 3
;heltec.c,177 :: 		TRISIO.B4 = 0; GPIO.B4 = 1;
	BCF        TRISIO+0, 4
	BSF        GPIO+0, 4
;heltec.c,178 :: 		TRISIO.B5 = 0; GPIO.B5 = 1;
	BCF        TRISIO+0, 5
	BSF        GPIO+0, 5
;heltec.c,181 :: 		soglia_off   = 3300;
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;heltec.c,182 :: 		soglia_on    = 3600;
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;heltec.c,183 :: 		taratura_vcc = 5050;
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;heltec.c,184 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,186 :: 		GPIO.F0 = 1; // Spegne carico (MOSFET P)
	BSF        GPIO+0, 0
;heltec.c,187 :: 		GPIO.F2 = 0; // LED Off
	BCF        GPIO+0, 2
;heltec.c,189 :: 		RTC_presente = 0; // Cambiare a 1 se RTC montato
	CLRF       _RTC_presente+0
;heltec.c,190 :: 		if (RTC_presente && giorni_riavvio > 0) giorni_riavvio = 0;
L_Init_Hardware24:
;heltec.c,193 :: 		if (RTC_presente) {
	MOVF       _RTC_presente+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Init_Hardware25
;heltec.c,194 :: 		i = 0;
	CLRF       _i+0
;heltec.c,195 :: 		while (GPIO.B3 == 0 && i < 15) {
L_Init_Hardware26:
	BTFSC      GPIO+0, 3
	GOTO       L_Init_Hardware27
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware27
L__Init_Hardware88:
;heltec.c,196 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,197 :: 		i++;
	INCF       _i+0, 1
;heltec.c,198 :: 		}
	GOTO       L_Init_Hardware26
L_Init_Hardware27:
;heltec.c,199 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware30
;heltec.c,201 :: 		Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
	MOVLW      1
	MOVWF      FARG_Scrivi_Ora_RTC_s_g_sett+0
	MOVLW      48
	MOVWF      FARG_Scrivi_Ora_RTC_s_g+0
	MOVLW      3
	MOVWF      FARG_Scrivi_Ora_RTC_s_m+0
	MOVLW      38
	MOVWF      FARG_Scrivi_Ora_RTC_s_a+0
	MOVLW      4
	MOVWF      FARG_Scrivi_Ora_RTC_s_ore+0
	MOVLW      5
	MOVWF      FARG_Scrivi_Ora_RTC_s_min+0
	CALL       _Scrivi_Ora_RTC+0
;heltec.c,202 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,203 :: 		}
L_Init_Hardware30:
;heltec.c,204 :: 		}
L_Init_Hardware25:
;heltec.c,206 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,207 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,208 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,209 :: 		if (batteria_mv > soglia_off) GPIO.F0 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware114
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware114
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware114
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware114:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware31
	BCF        GPIO+0, 0
L_Init_Hardware31:
;heltec.c,211 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,212 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,213 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,214 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,217 :: 		void main() {
;heltec.c,218 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,220 :: 		while (1) {
L_main32:
;heltec.c,221 :: 		if (INTCON.GPIF) {
	BTFSS      INTCON+0, 0
	GOTO       L_main34
;heltec.c,222 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,223 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,224 :: 		}
L_main34:
;heltec.c,227 :: 		if (GPIO.B3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main35
;heltec.c,228 :: 		i = 0;
	CLRF       _i+0
;heltec.c,229 :: 		while (GPIO.B3 == 0 && i < 50) {
L_main36:
	BTFSC      GPIO+0, 3
	GOTO       L_main37
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main37
L__main95:
;heltec.c,230 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,231 :: 		i++;
	INCF       _i+0, 1
;heltec.c,232 :: 		if (i == 10) GPIO.F2 = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	BSF        GPIO+0, 2
L_main40:
;heltec.c,233 :: 		if (i == 25) GPIO.F2 = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main41
	BCF        GPIO+0, 2
L_main41:
;heltec.c,234 :: 		}
	GOTO       L_main36
L_main37:
;heltec.c,237 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main44
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main44
L__main94:
;heltec.c,238 :: 		GPIO.F0 = 1;
	BSF        GPIO+0, 0
;heltec.c,239 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,240 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,241 :: 		if (batteria_mv > soglia_off) GPIO.F0 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main116
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main116
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main116
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main116:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
	BCF        GPIO+0, 0
L_main45:
;heltec.c,242 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main117
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main117
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main117
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main117:
	BTFSC      STATUS+0, 0
	GOTO       L_main46
	CALL       _soglia_batteria+0
L_main46:
;heltec.c,243 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,244 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,245 :: 		}
L_main44:
;heltec.c,248 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main49
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main49
L__main93:
;heltec.c,249 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,250 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,251 :: 		val_da_lampeggiare = (unsigned int)batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,252 :: 		Estrai_e_Lampeggia(1000);
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,253 :: 		Estrai_e_Lampeggia(100);
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,254 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,255 :: 		Lampeggia_Cifra(0);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,257 :: 		if (RTC_presente) {
	MOVF       _RTC_presente+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main50
;heltec.c,258 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,259 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,260 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,261 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,262 :: 		val_da_lampeggiare = ore;
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,263 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,264 :: 		Lampeggia_Cifra(val_da_lampeggiare % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      R0+0
	MOVF       _val_da_lampeggiare+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,265 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,266 :: 		val_da_lampeggiare = minuti;
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,267 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,268 :: 		Lampeggia_Cifra(val_da_lampeggiare % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      R0+0
	MOVF       _val_da_lampeggiare+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,269 :: 		}
L_main50:
;heltec.c,270 :: 		}
L_main49:
;heltec.c,273 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main51
;heltec.c,274 :: 		GPIO.F0 = 1;
	BSF        GPIO+0, 0
;heltec.c,275 :: 		for (j = 0; j < 20; j++) { GPIO.F2 = !GPIO.F2; Delay_Safe_ms(100); }
	CLRF       _j+0
L_main52:
	MOVLW      20
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main53
	MOVLW      4
	XORWF      GPIO+0, 1
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	INCF       _j+0, 1
	GOTO       L_main52
L_main53:
;heltec.c,276 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,277 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,278 :: 		while (in_manutenzione) {
L_main55:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main56
;heltec.c,279 :: 		GPIO.F2 = 1; Delay_Safe_ms(500); GPIO.F2 = 0;
	BSF        GPIO+0, 2
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	BCF        GPIO+0, 2
;heltec.c,280 :: 		if (GPIO.B3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main57
;heltec.c,281 :: 		i = 0;
	CLRF       _i+0
;heltec.c,282 :: 		while (GPIO.B3 == 0 && i < 50) { Delay_Safe_ms(100); i++; }
L_main58:
	BTFSC      GPIO+0, 3
	GOTO       L_main59
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main59
L__main92:
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	INCF       _i+0, 1
	GOTO       L_main58
L_main59:
;heltec.c,283 :: 		if (i >= 50) in_manutenzione = 0;
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main62
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
L_main62:
;heltec.c,284 :: 		} else { Delay_Safe_ms(500); }
	GOTO       L_main63
L_main57:
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
L_main63:
;heltec.c,285 :: 		asm clrwdt;
	CLRWDT
;heltec.c,286 :: 		}
	GOTO       L_main55
L_main56:
;heltec.c,287 :: 		for (j = 0; j < 20; j++) { GPIO.F2 = !GPIO.F2; Delay_Safe_ms(100); }
	CLRF       _j+0
L_main64:
	MOVLW      20
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main65
	MOVLW      4
	XORWF      GPIO+0, 1
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	INCF       _j+0, 1
	GOTO       L_main64
L_main65:
;heltec.c,288 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,289 :: 		if (batteria_mv > soglia_off) GPIO.F0 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main118:
	BTFSC      STATUS+0, 0
	GOTO       L_main67
	BCF        GPIO+0, 0
L_main67:
;heltec.c,290 :: 		sveglie_wdt = 13;
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,291 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,292 :: 		}
L_main51:
;heltec.c,293 :: 		}
L_main35:
;heltec.c,296 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main68
;heltec.c,297 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main119
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main119:
	BTFSS      STATUS+0, 0
	GOTO       L_main69
;heltec.c,298 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,299 :: 		if (batteria_mv <= soglia_off) GPIO.F0 = 1;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main120
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main120
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main120
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main120:
	BTFSS      STATUS+0, 0
	GOTO       L_main70
	BSF        GPIO+0, 0
L_main70:
;heltec.c,300 :: 		if (batteria_mv >= soglia_on)  GPIO.F0 = 0;
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main121
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main121
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main121
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main121:
	BTFSS      STATUS+0, 0
	GOTO       L_main71
	BCF        GPIO+0, 0
L_main71:
;heltec.c,302 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,303 :: 		if (RTC_presente) minuti_count++;
	MOVF       _RTC_presente+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main72
	INCF       _minuti_count+0, 1
L_main72:
;heltec.c,306 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main73
;heltec.c,307 :: 		conteggio_cicli++;
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
;heltec.c,308 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) {
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
	GOTO       L__main122
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main122
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main122
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main122:
	BTFSS      STATUS+0, 0
	GOTO       L_main74
;heltec.c,309 :: 		GPIO.F0 = 1; Delay_Safe_ms(2000);
	BSF        GPIO+0, 0
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,310 :: 		if (batteria_mv > soglia_off) GPIO.F0 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main123
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main123
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main123
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main123:
	BTFSC      STATUS+0, 0
	GOTO       L_main75
	BCF        GPIO+0, 0
L_main75:
;heltec.c,311 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,312 :: 		}
L_main74:
;heltec.c,313 :: 		}
L_main73:
;heltec.c,316 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main76
;heltec.c,317 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,318 :: 		if (ore == 4 && minuti < 11) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main79
	MOVLW      11
	SUBWF      _minuti+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main79
L__main91:
;heltec.c,319 :: 		if (!reset_fatto) {
	MOVF       _reset_fatto+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main80
;heltec.c,320 :: 		if (giorno == 1 || giorno == 4) {
	MOVF       _giorno+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__main90
	MOVF       _giorno+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main90
	GOTO       L_main83
L__main90:
;heltec.c,321 :: 		GPIO.F0 = 1; Delay_Safe_ms(10000);
	BSF        GPIO+0, 0
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,322 :: 		if (batteria_mv > soglia_off) GPIO.F0 = 0;
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main124:
	BTFSC      STATUS+0, 0
	GOTO       L_main84
	BCF        GPIO+0, 0
L_main84:
;heltec.c,323 :: 		reset_fatto = 1;
	MOVLW      1
	MOVWF      _reset_fatto+0
;heltec.c,324 :: 		}
L_main83:
;heltec.c,325 :: 		}
L_main80:
;heltec.c,326 :: 		} else { reset_fatto = 0; }
	GOTO       L_main85
L_main79:
	CLRF       _reset_fatto+0
L_main85:
;heltec.c,327 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,328 :: 		}
L_main76:
;heltec.c,329 :: 		}
L_main69:
;heltec.c,330 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,331 :: 		asm clrwdt;
	CLRWDT
;heltec.c,332 :: 		asm sleep;
	SLEEP
;heltec.c,333 :: 		asm nop;
	NOP
;heltec.c,334 :: 		} else {
	GOTO       L_main86
L_main68:
;heltec.c,335 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,336 :: 		}
L_main86:
;heltec.c,337 :: 		}
	GOTO       L_main32
;heltec.c,338 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
