
_Delay_Safe_ms:

;heltec.c,39 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,41 :: 		for (k = 1; k <= n; k++) {
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Delay_Safe_ms0:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms112
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms112:
	BTFSS      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,42 :: 		Delay_us(978); // Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni...
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
;heltec.c,43 :: 		asm clrwdt;    // Reset del Watchdog ad ogni millisecondo
	CLRWDT
;heltec.c,41 :: 		for (k = 1; k <= n; k++) {
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
;heltec.c,52 :: 		GP5_bit = 1; // LED su GP5
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
;heltec.c,56 :: 		for (l = 1; l <= c; l++) {
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra6:
	MOVF       Lampeggia_Cifra_l_L0+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra7
;heltec.c,57 :: 		GP5_bit = 1;        // Accende LED su GP5
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,58 :: 		Delay_Safe_ms(250); // Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,59 :: 		GP5_bit = 0;        // Spegne LED
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,60 :: 		Delay_Safe_ms(250); // Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,61 :: 		asm clrwdt;         // Mantiene il sistema attivo
	CLRWDT
;heltec.c,56 :: 		for (l = 1; l <= c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,62 :: 		}
	GOTO       L_Lampeggia_Cifra6
L_Lampeggia_Cifra7:
;heltec.c,63 :: 		}
L_Lampeggia_Cifra5:
;heltec.c,64 :: 		Delay_Safe_ms(1000); // Pausa lunga tra una cifra e l'altra
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
;heltec.c,81 :: 		GP5_bit = 1;         // Accende tutto (LED su GP5)
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,82 :: 		Delay_Safe_ms(100);  // Tempo di sveglia
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,85 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,86 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,87 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,90 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,91 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,92 :: 		Soft_I2C_Write(0x01);
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,93 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,94 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,95 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,96 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,98 :: 		minuti = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
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
;heltec.c,100 :: 		Delay_Safe_ms(10);
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,103 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,104 :: 		Soft_I2C_Write(0xD0);
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,105 :: 		Soft_I2C_Write(0x02);
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,106 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,107 :: 		Soft_I2C_Write(0xD1);
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,108 :: 		bcd_temp = Soft_I2C_Read(0);
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,109 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,111 :: 		bcd_temp &= 0x3F;
	MOVLW      63
	ANDWF      Leggi_Ora_RTC_bcd_temp_L0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp_L0+0
;heltec.c,112 :: 		ore = ((bcd_temp >> 4) * 10) + (bcd_temp & 0x0F);
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
;heltec.c,114 :: 		GP5_bit = 0; // Spegne tutto
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,115 :: 		}
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;heltec.c,118 :: 		void Leggi_Batteria_mV() {
;heltec.c,120 :: 		unsigned long somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
	CLRF       Leggi_Batteria_mV_somma_L0+2
	CLRF       Leggi_Batteria_mV_somma_L0+3
;heltec.c,124 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i_adc_L0+0
L_Leggi_Batteria_mV11:
	MOVF       Leggi_Batteria_mV_i_adc_L0+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV12
;heltec.c,125 :: 		somma += ADC_Read(1); // Legge il valore analogico su AN1
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
;heltec.c,126 :: 		Delay_Safe_ms(1);     // Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,124 :: 		for (i_adc = 1; i_adc <= 64; i_adc++) {
	INCF       Leggi_Batteria_mV_i_adc_L0+0, 1
;heltec.c,127 :: 		}
	GOTO       L_Leggi_Batteria_mV11
L_Leggi_Batteria_mV12:
;heltec.c,130 :: 		media_pulita = (unsigned int)(somma >> 6);
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
;heltec.c,133 :: 		batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
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
;heltec.c,134 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;heltec.c,137 :: 		void Lampi(unsigned short n, unsigned int t_on) {
;heltec.c,138 :: 		for (j = 1; j <= n; j++) {
	MOVLW      1
	MOVWF      _j+0
L_Lampi14:
	MOVF       _j+0, 0
	SUBWF      FARG_Lampi_n+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Lampi15
;heltec.c,139 :: 		GP5_bit = 1; // LED su GP5
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,140 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,141 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,142 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,138 :: 		for (j = 1; j <= n; j++) {
	INCF       _j+0, 1
;heltec.c,143 :: 		}
	GOTO       L_Lampi14
L_Lampi15:
;heltec.c,144 :: 		}
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;heltec.c,147 :: 		void soglia_batteria() {
;heltec.c,148 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria124
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria124:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria17
;heltec.c,149 :: 		GP5_bit = 0; // Spegne LED su GP5
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,150 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,152 :: 		Lampi(6, 100);
	MOVLW      6
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,153 :: 		} else {
	GOTO       L_soglia_batteria18
L_soglia_batteria17:
;heltec.c,154 :: 		if ((batteria_mv > soglia_off) && (batteria_mv <= soglia_on)) {
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
;heltec.c,156 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,157 :: 		Lampi(3, 100);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,158 :: 		}
L_soglia_batteria21:
;heltec.c,159 :: 		}
L_soglia_batteria18:
;heltec.c,160 :: 		}
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;heltec.c,163 :: 		void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
;heltec.c,164 :: 		GP5_bit = 1; // LED su GP5
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,165 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,166 :: 		Soft_I2C_Init(); // Inizializza
	CALL       _Soft_I2C_Init+0
;heltec.c,167 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,168 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,169 :: 		Soft_I2C_Write(0xD0); // Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,170 :: 		Soft_I2C_Write(0x00); // Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,171 :: 		Soft_I2C_Write(0x00); // Secondi (sempre 00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,172 :: 		Soft_I2C_Write(s_min); // Minuti (es. 0x05)
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,173 :: 		Soft_I2C_Write(s_ore); // Ore (es. 0x04)
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,174 :: 		Soft_I2C_Write(s_g_sett); // Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,175 :: 		Soft_I2C_Write(s_g);   // Giorno Mese (es. 0x30)
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,176 :: 		Soft_I2C_Write(s_m);   // Mese (es. 0x03)
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,177 :: 		Soft_I2C_Write(s_a);   // Anno (es. 0x26)
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,178 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,179 :: 		Delay_Safe_ms(800);
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,180 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,181 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,182 :: 		}
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;heltec.c,185 :: 		void Init_Hardware() {
;heltec.c,187 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,188 :: 		OSCCON = 0b01100111;
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,191 :: 		CMCON0 = 7;
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,194 :: 		ANSEL = 0b00010010;
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,197 :: 		TRISIO = 0b00001010;
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,200 :: 		OPTION_REG = 0b00001111;
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,203 :: 		WPU = 0b00000000;
	CLRF       WPU+0
;heltec.c,206 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,209 :: 		IOC.B3 = 1;
	BSF        IOC+0, 3
;heltec.c,212 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,215 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;heltec.c,217 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,220 :: 		soglia_off   = 3300;
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;heltec.c,221 :: 		soglia_on    = 3600;
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;heltec.c,222 :: 		taratura_vcc = 5050;
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;heltec.c,223 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,226 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,229 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,231 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,232 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,233 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,236 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_Init_Hardware22
;heltec.c,237 :: 		TRISIO.B0 = 0; // SDA come Uscita
	BCF        TRISIO+0, 0
;heltec.c,238 :: 		TRISIO.B2 = 0; // SCL come Uscita
	BCF        TRISIO+0, 2
;heltec.c,239 :: 		GP0_bit = 1;   // SDA Alto (Idle)
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;heltec.c,240 :: 		GP2_bit = 1;   // SCL Alto (Idle)
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,242 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,243 :: 		i = 0;
	CLRF       _i+0
;heltec.c,244 :: 		while ((GP3_bit == 0) && (i < 15)) {
L_Init_Hardware23:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_Init_Hardware24
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware24
L__Init_Hardware102:
;heltec.c,245 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,246 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,247 :: 		i++;
	INCF       _i+0, 1
;heltec.c,248 :: 		}
	GOTO       L_Init_Hardware23
L_Init_Hardware24:
;heltec.c,250 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware27
;heltec.c,251 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,253 :: 		Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
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
;heltec.c,254 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,255 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,256 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,257 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,258 :: 		}
L_Init_Hardware27:
;heltec.c,259 :: 		} else {
	GOTO       L_Init_Hardware28
L_Init_Hardware22:
;heltec.c,260 :: 		TRISIO.B0 = 1; // SDA in Alta Impedenza
	BSF        TRISIO+0, 0
;heltec.c,261 :: 		TRISIO.B2 = 1; // SCL in Alta Impedenza
	BSF        TRISIO+0, 2
;heltec.c,262 :: 		GP0_bit = 0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;heltec.c,263 :: 		GP2_bit = 0;
	BCF        GP2_bit+0, BitPos(GP2_bit+0)
;heltec.c,264 :: 		}
L_Init_Hardware28:
;heltec.c,266 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,267 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,268 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,269 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,270 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,272 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware129
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware129:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware29
;heltec.c,273 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,274 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,275 :: 		} else {
	GOTO       L_Init_Hardware30
L_Init_Hardware29:
;heltec.c,276 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,277 :: 		}
L_Init_Hardware30:
;heltec.c,279 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,280 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,281 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,283 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,284 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,287 :: 		void main() {
;heltec.c,288 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,290 :: 		while (1) {
L_main31:
;heltec.c,292 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main33
;heltec.c,293 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,294 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,295 :: 		}
L_main33:
;heltec.c,298 :: 		if (GP3_bit == 0) {
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main34
;heltec.c,299 :: 		i = 0;
	CLRF       _i+0
;heltec.c,300 :: 		while ((GP3_bit == 0) && (i < 50)) {
L_main35:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main36
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main36
L__main110:
;heltec.c,301 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,302 :: 		i++;
	INCF       _i+0, 1
;heltec.c,303 :: 		if (i == 10) GP5_bit = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
L_main39:
;heltec.c,304 :: 		if (i == 25) GP5_bit = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
L_main40:
;heltec.c,305 :: 		}
	GOTO       L_main35
L_main36:
;heltec.c,308 :: 		if ((i >= 10) && (i < 25)) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main43
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
L__main109:
;heltec.c,309 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,310 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,311 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,312 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,314 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main131:
	BTFSC      STATUS+0, 0
	GOTO       L_main44
;heltec.c,315 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,316 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,317 :: 		} else {
	GOTO       L_main45
L_main44:
;heltec.c,318 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,319 :: 		}
L_main45:
;heltec.c,320 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,321 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main132:
	BTFSC      STATUS+0, 0
	GOTO       L_main46
	CALL       _soglia_batteria+0
L_main46:
;heltec.c,322 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,323 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,324 :: 		}
L_main43:
;heltec.c,327 :: 		if ((i >= 25) && (i < 50)) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main49
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main49
L__main108:
;heltec.c,328 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,329 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,330 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,332 :: 		val_da_lampeggiare = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,333 :: 		Estrai_e_Lampeggia(1000);
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,334 :: 		Estrai_e_Lampeggia(100);
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,335 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,336 :: 		Lampeggia_Cifra(0);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,338 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main50
;heltec.c,339 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,340 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,341 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,342 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,343 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,344 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,345 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,346 :: 		val_da_lampeggiare = ore;
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,347 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,348 :: 		Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,349 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,350 :: 		val_da_lampeggiare = minuti;
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;heltec.c,351 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,352 :: 		Lampeggia_Cifra((unsigned short)val_da_lampeggiare);
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,353 :: 		}
L_main50:
;heltec.c,354 :: 		}
L_main49:
;heltec.c,357 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main51
;heltec.c,358 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,359 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main52:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main53
;heltec.c,360 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,361 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,359 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,362 :: 		}
	GOTO       L_main52
L_main53:
;heltec.c,363 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,364 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,365 :: 		while (in_manutenzione) {
L_main55:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main56
;heltec.c,366 :: 		GP5_bit = 1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,367 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,368 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,369 :: 		if (GP3_bit == 0) {
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main57
;heltec.c,370 :: 		i = 0;
	CLRF       _i+0
;heltec.c,371 :: 		while ((GP3_bit == 0) && (i < 50)) {
L_main58:
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main59
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main59
L__main107:
;heltec.c,372 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,373 :: 		i++;
	INCF       _i+0, 1
;heltec.c,374 :: 		}
	GOTO       L_main58
L_main59:
;heltec.c,375 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main62
;heltec.c,376 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,377 :: 		for (j = 1; j <= 20; j++) {
	MOVLW      1
	MOVWF      _j+0
L_main63:
	MOVF       _j+0, 0
	SUBLW      20
	BTFSS      STATUS+0, 0
	GOTO       L_main64
;heltec.c,378 :: 		GP5_bit = !GP5_bit;
	MOVLW
	XORWF      GP5_bit+0, 1
;heltec.c,379 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,377 :: 		for (j = 1; j <= 20; j++) {
	INCF       _j+0, 1
;heltec.c,380 :: 		}
	GOTO       L_main63
L_main64:
;heltec.c,381 :: 		GP5_bit = 0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;heltec.c,382 :: 		}
L_main62:
;heltec.c,383 :: 		} else {
	GOTO       L_main66
L_main57:
;heltec.c,384 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,385 :: 		}
L_main66:
;heltec.c,386 :: 		asm clrwdt;
	CLRWDT
;heltec.c,387 :: 		}
	GOTO       L_main55
L_main56:
;heltec.c,388 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,389 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main133
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main133:
	BTFSC      STATUS+0, 0
	GOTO       L_main67
;heltec.c,390 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,391 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,392 :: 		} else {
	GOTO       L_main68
L_main67:
;heltec.c,393 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,394 :: 		}
L_main68:
;heltec.c,395 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main134
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main134:
	BTFSC      STATUS+0, 0
	GOTO       L_main69
	CALL       _soglia_batteria+0
L_main69:
;heltec.c,396 :: 		sveglie_wdt = 13;
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,397 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,398 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,399 :: 		asm clrwdt;
	CLRWDT
;heltec.c,400 :: 		}
L_main51:
;heltec.c,401 :: 		}
L_main34:
;heltec.c,404 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main70
;heltec.c,405 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main135
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main135:
	BTFSS      STATUS+0, 0
	GOTO       L_main71
;heltec.c,406 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,407 :: 		if (batteria_mv <= soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main136
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main136:
	BTFSS      STATUS+0, 0
	GOTO       L_main72
;heltec.c,408 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,409 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,410 :: 		}
L_main72:
;heltec.c,411 :: 		if (batteria_mv >= soglia_on) {
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main137
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main137:
	BTFSS      STATUS+0, 0
	GOTO       L_main73
;heltec.c,412 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,413 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,414 :: 		}
L_main73:
;heltec.c,416 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,418 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main74
;heltec.c,419 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,420 :: 		minuti_count++;
	INCF       _minuti_count+0, 1
;heltec.c,421 :: 		} else {
	GOTO       L_main75
L_main74:
;heltec.c,422 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,423 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,424 :: 		}
L_main75:
;heltec.c,426 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main76
;heltec.c,427 :: 		conteggio_cicli++;
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
;heltec.c,428 :: 		if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
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
	GOTO       L__main138
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main138
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main138
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main138:
	BTFSS      STATUS+0, 0
	GOTO       L_main77
;heltec.c,429 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,430 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,431 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main139
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main139:
	BTFSC      STATUS+0, 0
	GOTO       L_main78
;heltec.c,432 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,433 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,434 :: 		} else {
	GOTO       L_main79
L_main78:
;heltec.c,435 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,436 :: 		}
L_main79:
;heltec.c,437 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,438 :: 		}
L_main77:
;heltec.c,439 :: 		}
L_main76:
;heltec.c,441 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main80
;heltec.c,442 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,443 :: 		if (finestra_oraria == 0) {
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L_main81
;heltec.c,444 :: 		if (ore == 4) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main82
;heltec.c,445 :: 		if (reset_fatto == 0) {
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L_main83
;heltec.c,446 :: 		if ((giorno == 1) || (giorno == 4)) {
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
;heltec.c,447 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,448 :: 		Delay_Safe_ms(10000);
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,449 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) GP4_bit = 0;
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main140
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main140:
	BTFSC      STATUS+0, 0
	GOTO       L_main89
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main89
L__main105:
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
L_main89:
;heltec.c,450 :: 		reset_fatto = 1;
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,451 :: 		}
L_main86:
;heltec.c,452 :: 		}
L_main83:
;heltec.c,453 :: 		} else {
	GOTO       L_main90
L_main82:
;heltec.c,454 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,455 :: 		}
L_main90:
;heltec.c,456 :: 		} else {
	GOTO       L_main91
L_main81:
;heltec.c,457 :: 		if ((ore >= 7) && (ore < 13)) {
	MOVLW      7
	SUBWF      _ore+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main94
	MOVLW      13
	SUBWF      _ore+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main94
L__main104:
;heltec.c,458 :: 		if ((batteria_mv > soglia_off) && (spento == 0)) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main141
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main141:
	BTFSC      STATUS+0, 0
	GOTO       L_main97
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main97
L__main103:
;heltec.c,459 :: 		GP4_bit = 0;
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,460 :: 		} else {
	GOTO       L_main98
L_main97:
;heltec.c,461 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,462 :: 		}
L_main98:
;heltec.c,463 :: 		} else {
	GOTO       L_main99
L_main94:
;heltec.c,464 :: 		GP4_bit = 1;
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;heltec.c,465 :: 		}
L_main99:
;heltec.c,466 :: 		}
L_main91:
;heltec.c,467 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,468 :: 		}
L_main80:
;heltec.c,469 :: 		}
L_main71:
;heltec.c,471 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,472 :: 		asm clrwdt;
	CLRWDT
;heltec.c,473 :: 		asm sleep;
	SLEEP
;heltec.c,474 :: 		asm nop;
	NOP
;heltec.c,476 :: 		} else {
	GOTO       L_main100
L_main70:
;heltec.c,477 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,478 :: 		asm clrwdt;
	CLRWDT
;heltec.c,479 :: 		}
L_main100:
;heltec.c,480 :: 		}
	GOTO       L_main31
;heltec.c,481 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
