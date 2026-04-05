
_Delay_Safe_ms:

;heltec.c,39 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,41 :: 		for (k = 0; k < n; k++) {
	CLRF       R1+0
	CLRF       R1+1
L_Delay_Safe_ms0:
	MOVF       FARG_Delay_Safe_ms_n+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms112
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	SUBWF      R1+0, 0
L__Delay_Safe_ms112:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,42 :: 		Delay_us(978);
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
;heltec.c,43 :: 		asm clrwdt; // Reset Watchdog in Assembly per mikroC
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
;heltec.c,52 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,53 :: 		Delay_Safe_ms(50);
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,54 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,55 :: 		} else {
	GOTO       L_Lampeggia_Cifra5
L_Lampeggia_Cifra4:
;heltec.c,56 :: 		for (l = 0; l < c; l++) {
	CLRF       Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra6:
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	SUBWF      Lampeggia_Cifra_l_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra7
;heltec.c,57 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,58 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,59 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,60 :: 		Delay_Safe_ms(250);
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,61 :: 		asm clrwdt;
	CLRWDT
;heltec.c,56 :: 		for (l = 0; l < c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,62 :: 		}
	GOTO       L_Lampeggia_Cifra6
L_Lampeggia_Cifra7:
;heltec.c,63 :: 		}
L_Lampeggia_Cifra5:
;heltec.c,64 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,65 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;heltec.c,68 :: 		void Estrai_e_Lampeggia(unsigned int divisore) {
;heltec.c,69 :: 		unsigned short contatore = 0;
	CLRF       Estrai_e_Lampeggia_contatore_L0+0
;heltec.c,70 :: 		while (val_da_lampeggiare >= divisore) {
L_Estrai_e_Lampeggia9:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia115
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia115:
	BTFSS      STATUS+0, 0
	GOTO       L_Estrai_e_Lampeggia10
;heltec.c,71 :: 		val_da_lampeggiare -= divisore;
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;heltec.c,72 :: 		contatore++;
	INCF       Estrai_e_Lampeggia_contatore_L0+0, 1
;heltec.c,73 :: 		}
	GOTO       L_Estrai_e_Lampeggia9
L_Estrai_e_Lampeggia10:
;heltec.c,74 :: 		Lampeggia_Cifra(contatore);
	MOVF       Estrai_e_Lampeggia_contatore_L0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,75 :: 		}
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;heltec.c,78 :: 		void Leggi_Ora_RTC() {
;heltec.c,81 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,82 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,84 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,85 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,86 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,89 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,90 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,91 :: 		Soft_I2C_Write(0x01);
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,92 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,93 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,94 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,95 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,96 :: 		minuti = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
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
;heltec.c,98 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,101 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,102 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,103 :: 		Soft_I2C_Write(0x02);
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,104 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,105 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,106 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,107 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,108 :: 		bcd_temp &= 0x3F;
	MOVLW      63
	ANDWF      Leggi_Ora_RTC_bcd_temp_L0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,109 :: 		ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
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
;heltec.c,111 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,112 :: 		}
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;heltec.c,115 :: 		void Leggi_Batteria_mV() {
;heltec.c,117 :: 		unsigned long somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
	CLRF       Leggi_Batteria_mV_somma_L0+2
	CLRF       Leggi_Batteria_mV_somma_L0+3
;heltec.c,120 :: 		for (k = 0; k < 64; k++) {
	CLRF       Leggi_Batteria_mV_k_L0+0
L_Leggi_Batteria_mV11:
	MOVLW      64
	SUBWF      Leggi_Batteria_mV_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV12
;heltec.c,121 :: 		somma += ADC_Read(1);
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
;heltec.c,122 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,120 :: 		for (k = 0; k < 64; k++) {
	INCF       Leggi_Batteria_mV_k_L0+0, 1
;heltec.c,123 :: 		}
	GOTO       L_Leggi_Batteria_mV11
L_Leggi_Batteria_mV12:
;heltec.c,124 :: 		media_pulita = (unsigned int)(somma >> 6);
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
L__Leggi_Batteria_mV118:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV119
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV118
L__Leggi_Batteria_mV119:
;heltec.c,125 :: 		batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
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
L__Leggi_Batteria_mV120:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV121
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV120
L__Leggi_Batteria_mV121:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
;heltec.c,126 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;heltec.c,129 :: 		void Lampi(unsigned short n, unsigned int t_on) {
;heltec.c,131 :: 		for (k = 0; k < n; k++) {
	CLRF       Lampi_k_L0+0
L_Lampi14:
	MOVF       FARG_Lampi_n+0, 0
	SUBWF      Lampi_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampi15
;heltec.c,132 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,133 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,134 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,135 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,131 :: 		for (k = 0; k < n; k++) {
	INCF       Lampi_k_L0+0, 1
;heltec.c,136 :: 		}
	GOTO       L_Lampi14
L_Lampi15:
;heltec.c,137 :: 		}
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;heltec.c,140 :: 		void soglia_batteria() {
;heltec.c,141 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria124
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria124:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria17
;heltec.c,142 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,143 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,144 :: 		Lampi(6, 100);
	MOVLW      6
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,145 :: 		} else if (batteria_mv > soglia_off && batteria_mv <= soglia_on) {
	GOTO       L_soglia_batteria18
L_soglia_batteria17:
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria125
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria125:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria21
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria126
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria126:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
L__soglia_batteria101:
;heltec.c,146 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,147 :: 		Lampi(3, 100);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,148 :: 		}
L_soglia_batteria21:
L_soglia_batteria18:
;heltec.c,149 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;heltec.c,152 :: 		void Scrivi_Ora_RTC(short s_g_sett, short s_g, short s_m, short s_a, short s_ore, short s_min) {
;heltec.c,153 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,154 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,155 :: 		Soft_I2C_Init();
	CALL       _Soft_I2C_Init+0
;heltec.c,156 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,157 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,158 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,159 :: 		Soft_I2C_Write(0x00); // Registro secondi
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,160 :: 		Soft_I2C_Write(0x00);
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,161 :: 		Soft_I2C_Write(s_min);
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,162 :: 		Soft_I2C_Write(s_ore);
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,163 :: 		Soft_I2C_Write(s_g_sett);
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,164 :: 		Soft_I2C_Write(s_g);
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,165 :: 		Soft_I2C_Write(s_m);
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,166 :: 		Soft_I2C_Write(s_a);
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,167 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,168 :: 		Delay_Safe_ms(800);
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,169 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,170 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,171 :: 		}
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;heltec.c,174 :: 		void Init_Hardware() {
;heltec.c,175 :: 		OSCCON = 0b01100111;    // 4MHz
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,176 :: 		CMCON0 = 7;             // No comparatori
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,177 :: 		ANSEL  = 0b00010010;    // AN1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,178 :: 		TRISIO = 0b00001010;    // GP1, GP3 Input
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,179 :: 		OPTION_REG = 0b00001111; // WDT 1:128
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,180 :: 		WPU = 0;
	CLRF       WPU+0
;heltec.c,181 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,182 :: 		IOC.B3 = 1;             // Interrupt on change GP3
	BSF        IOC+0, 3
;heltec.c,184 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,185 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;heltec.c,186 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,187 :: 		acceso = 1;
	BSF        _acceso+0, BitPos(_acceso+0)
;heltec.c,188 :: 		RSTpin = 1;
	BSF        _RSTpin+0, BitPos(_RSTpin+0)
;heltec.c,190 :: 		RTC_presente = 1;
	BSF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,191 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,192 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,194 :: 		soglia_off   = 3300;
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;heltec.c,195 :: 		soglia_on    = 3600;
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;heltec.c,196 :: 		taratura_vcc = 5010;
	MOVLW      146
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;heltec.c,198 :: 		if (RSTpin) acceso = 0;
	BTFSS      _RSTpin+0, BitPos(_RSTpin+0)
	GOTO       L_Init_Hardware22
	BCF        _acceso+0, BitPos(_acceso+0)
L_Init_Hardware22:
;heltec.c,200 :: 		GP4_bit = acceso;       // Mosfet
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__Init_Hardware129
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__Init_Hardware130
L__Init_Hardware129:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__Init_Hardware130:
;heltec.c,201 :: 		GP5_bit = 0;            // LED
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,203 :: 		if (RTC_presente) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_Init_Hardware23
;heltec.c,204 :: 		TRISIO0_bit = 0;
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;heltec.c,205 :: 		TRISIO2_bit = 0;
	BCF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;heltec.c,206 :: 		GP0_bit = 1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;heltec.c,207 :: 		GP2_bit = 1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,209 :: 		i = 0;
	CLRF       _i+0
;heltec.c,210 :: 		while (GP3_bit == 0 && i < 15) {
L_Init_Hardware24:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_Init_Hardware25
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware25
L__Init_Hardware102:
;heltec.c,211 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,212 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,213 :: 		i++;
	INCF       _i+0, 1
;heltec.c,214 :: 		}
	GOTO       L_Init_Hardware24
L_Init_Hardware25:
;heltec.c,215 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware28
;heltec.c,216 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,218 :: 		Scrivi_Ora_RTC(0x06, 0x04, 0x04, 0x26, 0x20, 0x55);
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
;heltec.c,219 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,220 :: 		}
L_Init_Hardware28:
;heltec.c,221 :: 		} else {
	GOTO       L_Init_Hardware29
L_Init_Hardware23:
;heltec.c,222 :: 		TRISIO0_bit = 1;
	BSF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;heltec.c,223 :: 		TRISIO2_bit = 1;
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;heltec.c,224 :: 		}
L_Init_Hardware29:
;heltec.c,226 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,227 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,228 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,229 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,231 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware131
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware131:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware30
;heltec.c,232 :: 		GP4_bit = !acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__Init_Hardware132
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__Init_Hardware133
L__Init_Hardware132:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__Init_Hardware133:
;heltec.c,233 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,234 :: 		} else {
	GOTO       L_Init_Hardware31
L_Init_Hardware30:
;heltec.c,235 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,236 :: 		}
L_Init_Hardware31:
;heltec.c,238 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,239 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,240 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,241 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,242 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,245 :: 		void main() {
;heltec.c,246 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,248 :: 		while (1) {
L_main32:
;heltec.c,249 :: 		if (INTCON.GPIF) {
	BTFSS      INTCON+0, 0
	GOTO       L_main34
;heltec.c,250 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,251 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,252 :: 		}
L_main34:
;heltec.c,254 :: 		if (GP3_bit == 0) {
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main35
;heltec.c,255 :: 		i = 0;
	CLRF       _i+0
;heltec.c,256 :: 		while (GP3_bit == 0 && i < 50) {
L_main36:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main37
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main37
L__main110:
;heltec.c,257 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,258 :: 		i++;
	INCF       _i+0, 1
;heltec.c,259 :: 		if (i == 10) GP5_bit = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
L_main40:
;heltec.c,260 :: 		if (i == 25) GP5_bit = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main41
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
L_main41:
;heltec.c,261 :: 		}
	GOTO       L_main36
L_main37:
;heltec.c,264 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main44
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main44
L__main109:
;heltec.c,265 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,266 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,267 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main135
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main136
L__main135:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main136:
;heltec.c,268 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,269 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main137
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main137:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
;heltec.c,270 :: 		GP4_bit = !acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main138
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main139
L__main138:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main139:
;heltec.c,271 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,272 :: 		} else {
	GOTO       L_main46
L_main45:
;heltec.c,273 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,274 :: 		}
L_main46:
;heltec.c,275 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main140
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main140:
	BTFSC      STATUS+0, 0
	GOTO       L_main47
	CALL       _soglia_batteria+0
L_main47:
;heltec.c,276 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,277 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,278 :: 		}
L_main44:
;heltec.c,281 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main50
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main50
L__main108:
;heltec.c,282 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,283 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,284 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,285 :: 		val_da_lampeggiare = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,286 :: 		Estrai_e_Lampeggia(1000);
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,287 :: 		Estrai_e_Lampeggia(100);
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,288 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,289 :: 		Lampeggia_Cifra(0);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,291 :: 		if (RTC_presente) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main51
;heltec.c,292 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,293 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,294 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,295 :: 		val_da_lampeggiare = ore;
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,296 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,297 :: 		Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,298 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,299 :: 		val_da_lampeggiare = minuti;
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,300 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,301 :: 		Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,302 :: 		}
L_main51:
;heltec.c,303 :: 		}
L_main50:
;heltec.c,306 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main52
;heltec.c,307 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main141
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main142
L__main141:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main142:
;heltec.c,308 :: 		for (j = 0; j < 20; j++) {
	CLRF       _j+0
L_main53:
	MOVLW      20
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main54
;heltec.c,309 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,310 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,308 :: 		for (j = 0; j < 20; j++) {
	INCF       _j+0, 1
;heltec.c,311 :: 		}
	GOTO       L_main53
L_main54:
;heltec.c,312 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,313 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,314 :: 		while (in_manutenzione) {
L_main56:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main57
;heltec.c,315 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,316 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,317 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,318 :: 		if (GP3_bit == 0) {
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main58
;heltec.c,319 :: 		i = 0;
	CLRF       _i+0
;heltec.c,320 :: 		while (GP3_bit == 0 && i < 50) {
L_main59:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main60
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main60
L__main107:
;heltec.c,321 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,322 :: 		i++;
	INCF       _i+0, 1
;heltec.c,323 :: 		}
	GOTO       L_main59
L_main60:
;heltec.c,324 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main63
;heltec.c,325 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,326 :: 		for (j = 0; j < 20; j++) {
	CLRF       _j+0
L_main64:
	MOVLW      20
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main65
;heltec.c,327 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,328 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,326 :: 		for (j = 0; j < 20; j++) {
	INCF       _j+0, 1
;heltec.c,329 :: 		}
	GOTO       L_main64
L_main65:
;heltec.c,330 :: 		}
L_main63:
;heltec.c,331 :: 		} else {
	GOTO       L_main67
L_main58:
;heltec.c,332 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,333 :: 		}
L_main67:
;heltec.c,334 :: 		asm clrwdt;
	CLRWDT
;heltec.c,335 :: 		}
	GOTO       L_main56
L_main57:
;heltec.c,336 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,337 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main143:
	BTFSC      STATUS+0, 0
	GOTO       L_main68
;heltec.c,338 :: 		GP4_bit = !acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main144
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main145
L__main144:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main145:
;heltec.c,339 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,340 :: 		} else {
	GOTO       L_main69
L_main68:
;heltec.c,341 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,342 :: 		}
L_main69:
;heltec.c,343 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main146:
	BTFSC      STATUS+0, 0
	GOTO       L_main70
	CALL       _soglia_batteria+0
L_main70:
;heltec.c,344 :: 		sveglie_wdt = 13;
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,345 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,346 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,347 :: 		}
L_main52:
;heltec.c,348 :: 		}
L_main35:
;heltec.c,350 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main71
;heltec.c,351 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main147:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
;heltec.c,352 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,353 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main148
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main148:
	BTFSS      STATUS+0, 0
	GOTO       L_main73
;heltec.c,354 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main149
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main150
L__main149:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main150:
;heltec.c,355 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,356 :: 		}
L_main73:
;heltec.c,357 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main151
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main151:
	BTFSS      STATUS+0, 0
	GOTO       L_main74
;heltec.c,358 :: 		GP4_bit = !acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main152
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main153
L__main152:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main153:
;heltec.c,359 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,360 :: 		}
L_main74:
;heltec.c,361 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,363 :: 		if (RTC_presente) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main75
;heltec.c,364 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,365 :: 		minuti_count++;
	INCF       _minuti_count+0, 1
;heltec.c,366 :: 		} else {
	GOTO       L_main76
L_main75:
;heltec.c,367 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,368 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,369 :: 		}
L_main76:
;heltec.c,371 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main77
;heltec.c,372 :: 		conteggio_cicli++;
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
;heltec.c,373 :: 		if (conteggio_cicli >= (unsigned long)cicli_per_giorno * giorni_riavvio) {
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
	GOTO       L__main154
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main154:
	BTFSS      STATUS+0, 0
	GOTO       L_main78
;heltec.c,374 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main155
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main156
L__main155:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main156:
;heltec.c,375 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,376 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main157:
	BTFSC      STATUS+0, 0
	GOTO       L_main79
;heltec.c,377 :: 		GP4_bit = !acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main158
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main159
L__main158:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main159:
;heltec.c,378 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,379 :: 		}
L_main79:
;heltec.c,380 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,381 :: 		}
L_main78:
;heltec.c,382 :: 		}
L_main77:
;heltec.c,384 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main80
;heltec.c,385 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,386 :: 		if (finestra_oraria == 0) {
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L_main81
;heltec.c,387 :: 		if (ore == 4) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main82
;heltec.c,388 :: 		if (reset_fatto == 0) {
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L_main83
;heltec.c,389 :: 		if (giorno == 1 || giorno == 4) {
	MOVF       _giorno+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__main106
	MOVF       _giorno+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main106
	GOTO       L_main86
L__main106:
;heltec.c,390 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main160
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main161
L__main160:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main161:
;heltec.c,391 :: 		Delay_Safe_ms(10000);
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,392 :: 		if (batteria_mv > soglia_off && spento == 0) GP4_bit = !acceso;
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main162:
	BTFSC      STATUS+0, 0
	GOTO       L_main89
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main89
L__main105:
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main163
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main164
L__main163:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main164:
L_main89:
;heltec.c,393 :: 		reset_fatto = 1;
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,394 :: 		}
L_main86:
;heltec.c,395 :: 		}
L_main83:
;heltec.c,396 :: 		} else {
	GOTO       L_main90
L_main82:
;heltec.c,397 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,398 :: 		}
L_main90:
;heltec.c,399 :: 		} else {
	GOTO       L_main91
L_main81:
;heltec.c,400 :: 		if (ore >= 7 && ore < 13) {
	MOVLW      7
	SUBWF      _ore+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main94
	MOVLW      13
	SUBWF      _ore+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main94
L__main104:
;heltec.c,401 :: 		if (batteria_mv > soglia_off && spento == 0) GP4_bit = !acceso;
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main165:
	BTFSC      STATUS+0, 0
	GOTO       L_main97
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main97
L__main103:
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main166
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main167
L__main166:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L__main167:
	GOTO       L_main98
L_main97:
;heltec.c,402 :: 		else GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main168
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main169
L__main168:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main169:
L_main98:
;heltec.c,403 :: 		} else {
	GOTO       L_main99
L_main94:
;heltec.c,404 :: 		GP4_bit = acceso;
	BTFSC      _acceso+0, BitPos(_acceso+0)
	GOTO       L__main170
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
	GOTO       L__main171
L__main170:
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
L__main171:
;heltec.c,405 :: 		}
L_main99:
;heltec.c,406 :: 		}
L_main91:
;heltec.c,407 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,408 :: 		}
L_main80:
;heltec.c,409 :: 		}
L_main72:
;heltec.c,410 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,411 :: 		asm clrwdt;
	CLRWDT
;heltec.c,412 :: 		asm sleep;
	SLEEP
;heltec.c,413 :: 		asm nop;
	NOP
;heltec.c,414 :: 		} else {
	GOTO       L_main100
L_main71:
;heltec.c,415 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,416 :: 		asm clrwdt;
	CLRWDT
;heltec.c,417 :: 		}
L_main100:
;heltec.c,418 :: 		}
	GOTO       L_main32
;heltec.c,419 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
