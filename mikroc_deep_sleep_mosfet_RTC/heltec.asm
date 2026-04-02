
_Delay_Safe_ms:

;heltec.c,40 :: 		void Delay_Safe_ms(unsigned int n) {
;heltec.c,42 :: 		for (k = 0; k < n; k++) {
	CLRF       R1+0
	CLRF       R1+1
L_Delay_Safe_ms0:
	MOVF       FARG_Delay_Safe_ms_n+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms105
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	SUBWF      R1+0, 0
L__Delay_Safe_ms105:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_Safe_ms1
;heltec.c,43 :: 		delay_us(980);              // Pausa di 1ms circa
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
;heltec.c,44 :: 		asm clrwdt;                 // Reset del Watchdog ad ogni millisecondo
	CLRWDT
;heltec.c,42 :: 		for (k = 0; k < n; k++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;heltec.c,45 :: 		}
	GOTO       L_Delay_Safe_ms0
L_Delay_Safe_ms1:
;heltec.c,46 :: 		}
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;heltec.c,49 :: 		void Lampeggia_Cifra(unsigned short c) {
;heltec.c,51 :: 		if (c == 0) {
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Lampeggia_Cifra4
;heltec.c,53 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,54 :: 		Delay_Safe_ms(50);
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,55 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,56 :: 		} else {
	GOTO       L_Lampeggia_Cifra5
L_Lampeggia_Cifra4:
;heltec.c,57 :: 		for (l = 0; l < c; l++) {
	CLRF       Lampeggia_Cifra_l_L0+0
L_Lampeggia_Cifra6:
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	SUBWF      Lampeggia_Cifra_l_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampeggia_Cifra7
;heltec.c,58 :: 		GPIO.F2 = 1;            // Accende LED
	BSF        GPIO+0, 2
;heltec.c,59 :: 		Delay_Safe_ms(250);     // Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,60 :: 		GPIO.F2 = 0;            // Spegne LED
	BCF        GPIO+0, 2
;heltec.c,61 :: 		Delay_Safe_ms(250);     // Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,62 :: 		asm clrwdt;
	CLRWDT
;heltec.c,57 :: 		for (l = 0; l < c; l++) {
	INCF       Lampeggia_Cifra_l_L0+0, 1
;heltec.c,63 :: 		}
	GOTO       L_Lampeggia_Cifra6
L_Lampeggia_Cifra7:
;heltec.c,64 :: 		}
L_Lampeggia_Cifra5:
;heltec.c,65 :: 		Delay_Safe_ms(1000);            // Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,66 :: 		}
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;heltec.c,69 :: 		void Estrai_e_Lampeggia(unsigned int divisore) {
;heltec.c,70 :: 		unsigned short contatore = 0;
	CLRF       Estrai_e_Lampeggia_contatore_L0+0
;heltec.c,71 :: 		while (val_da_lampeggiare >= divisore) {
L_Estrai_e_Lampeggia9:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia108
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia108:
	BTFSS      STATUS+0, 0
	GOTO       L_Estrai_e_Lampeggia10
;heltec.c,72 :: 		val_da_lampeggiare -= divisore;
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;heltec.c,73 :: 		contatore++;
	INCF       Estrai_e_Lampeggia_contatore_L0+0, 1
;heltec.c,74 :: 		}
	GOTO       L_Estrai_e_Lampeggia9
L_Estrai_e_Lampeggia10:
;heltec.c,75 :: 		Lampeggia_Cifra(contatore);
	MOVF       Estrai_e_Lampeggia_contatore_L0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,76 :: 		}
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;heltec.c,79 :: 		void Leggi_Ora_RTC() {
;heltec.c,81 :: 		GPIO.F2 = 1;           // Accende il LED (Segnale di attività I2C)
	BSF        GPIO+0, 2
;heltec.c,84 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,85 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,86 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,89 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;heltec.c,90 :: 		Soft_I2C_Write(0xD0); // Indirizzo RTC (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,91 :: 		Soft_I2C_Write(0x01); // Punta al registro 0x01 (Minuti)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,94 :: 		Soft_I2C_Start();     // Segnale di Restart
	CALL       _Soft_I2C_Start+0
;heltec.c,95 :: 		Soft_I2C_Write(0xD1); // Indirizzo RTC (Lettura)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,98 :: 		bcd_val = Soft_I2C_Read(1); // ACK
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	MOVLW      0
	MOVWF      FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;heltec.c,99 :: 		minuti = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);
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
;heltec.c,102 :: 		bcd_val = Soft_I2C_Read(1); // ACK
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	MOVLW      0
	MOVWF      FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;heltec.c,103 :: 		bcd_val &= 0x3F;            // CRITICAL FIX: PULIZIA BIT 6 E 7
	MOVLW      63
	ANDWF      R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;heltec.c,104 :: 		ore = ((bcd_val >> 4) * 10) + (bcd_val & 0x0F);
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
;heltec.c,107 :: 		bcd_val = Soft_I2C_Read(0); // NACK
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;heltec.c,108 :: 		giorno = bcd_val & 0x07;
	MOVLW      7
	ANDWF      R0+0, 0
	MOVWF      _giorno+0
;heltec.c,110 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;heltec.c,111 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,112 :: 		GPIO.F2 = 0;           // Spegne il LED
	BCF        GPIO+0, 2
;heltec.c,113 :: 		}
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;heltec.c,116 :: 		void Leggi_Batteria_mV() {
;heltec.c,118 :: 		unsigned long somma = 0;
	CLRF       Leggi_Batteria_mV_somma_L0+0
	CLRF       Leggi_Batteria_mV_somma_L0+1
	CLRF       Leggi_Batteria_mV_somma_L0+2
	CLRF       Leggi_Batteria_mV_somma_L0+3
;heltec.c,121 :: 		for (k = 0; k < 64; k++) {
	CLRF       Leggi_Batteria_mV_k_L0+0
L_Leggi_Batteria_mV11:
	MOVLW      64
	SUBWF      Leggi_Batteria_mV_k_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Leggi_Batteria_mV12
;heltec.c,122 :: 		somma += ADC_Read(1);
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
;heltec.c,123 :: 		Delay_Safe_ms(1);
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,121 :: 		for (k = 0; k < 64; k++) {
	INCF       Leggi_Batteria_mV_k_L0+0, 1
;heltec.c,124 :: 		}
	GOTO       L_Leggi_Batteria_mV11
L_Leggi_Batteria_mV12:
;heltec.c,125 :: 		media_pulita = (unsigned int)(somma >> 6);
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
L__Leggi_Batteria_mV111:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV112
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV111
L__Leggi_Batteria_mV112:
;heltec.c,126 :: 		batteria_mv = (unsigned int)(( (unsigned long)media_pulita * taratura_vcc ) >> 10);
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
L__Leggi_Batteria_mV113:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV114
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV113
L__Leggi_Batteria_mV114:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
;heltec.c,127 :: 		}
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;heltec.c,130 :: 		void Lampi(unsigned short n, unsigned int t_on) {
;heltec.c,131 :: 		for (j = 0; j < n; j++) {
	CLRF       _j+0
L_Lampi14:
	MOVF       FARG_Lampi_n+0, 0
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Lampi15
;heltec.c,132 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,133 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,134 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,135 :: 		Delay_Safe_ms(t_on);
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,131 :: 		for (j = 0; j < n; j++) {
	INCF       _j+0, 1
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
	GOTO       L__soglia_batteria117
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria117:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria17
;heltec.c,142 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
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
	GOTO       L__soglia_batteria118
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria118:
	BTFSC      STATUS+0, 0
	GOTO       L_soglia_batteria21
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria119
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria119:
	BTFSS      STATUS+0, 0
	GOTO       L_soglia_batteria21
L__soglia_batteria94:
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

;heltec.c,152 :: 		void Scrivi_Ora_RTC(unsigned short s_g_sett, unsigned short s_g, unsigned short s_m, unsigned short s_a, unsigned short s_ore, unsigned short s_min) {
;heltec.c,153 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
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
;heltec.c,159 :: 		Soft_I2C_Write(0x00);
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;heltec.c,160 :: 		Soft_I2C_Write(0x00);   // Secondi
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
;heltec.c,169 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
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
;heltec.c,175 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,176 :: 		OSCCON = 0x67;      // 4MHz interno
	MOVLW      103
	MOVWF      OSCCON+0
;heltec.c,177 :: 		CMCON0 = 7;         // No comparatori
	MOVLW      7
	MOVWF      CMCON0+0
;heltec.c,178 :: 		ANSEL  = 0x12;      // AN1 analogico
	MOVLW      18
	MOVWF      ANSEL+0
;heltec.c,179 :: 		TRISIO = 0x0A;      // GP1, GP3 Input; altri Output
	MOVLW      10
	MOVWF      TRISIO+0
;heltec.c,180 :: 		OPTION_REG = 0x0F;  // Prescaler WDT 1:128
	MOVLW      15
	MOVWF      OPTION_REG+0
;heltec.c,181 :: 		WPU = 0x00;
	CLRF       WPU+0
;heltec.c,182 :: 		INTCON.GPIE = 1;
	BSF        INTCON+0, 3
;heltec.c,183 :: 		IOC.B3 = 1;         // Interrupt on change GP3
	BSF        IOC+0, 3
;heltec.c,185 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,186 :: 		cicli_per_giorno = 2883;
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;heltec.c,187 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,189 :: 		TRISIO.F4 = 0; GPIO.F4 = 1; // SDA
	BCF        TRISIO+0, 4
	BSF        GPIO+0, 4
;heltec.c,190 :: 		TRISIO.F5 = 0; GPIO.F5 = 1; // SCL
	BCF        TRISIO+0, 5
	BSF        GPIO+0, 5
;heltec.c,193 :: 		soglia_off   = 3300;
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;heltec.c,194 :: 		soglia_on    = 3600;
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;heltec.c,195 :: 		taratura_vcc = 5050;
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;heltec.c,196 :: 		giorni_riavvio = 3;
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;heltec.c,198 :: 		GPIO.F0 = 1; // OFF carico
	BSF        GPIO+0, 0
;heltec.c,199 :: 		GPIO.F2 = 0; // LED OFF
	BCF        GPIO+0, 2
;heltec.c,201 :: 		RTC_presente = 0;
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;heltec.c,202 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,205 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_Init_Hardware22
;heltec.c,206 :: 		minuti_count = 20;
	MOVLW      20
	MOVWF      _minuti_count+0
;heltec.c,207 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,208 :: 		i = 0;
	CLRF       _i+0
;heltec.c,209 :: 		while (GPIO.F3 == 0 && i < 15) {
L_Init_Hardware23:
	BTFSC      GPIO+0, 3
	GOTO       L_Init_Hardware24
	MOVLW      15
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware24
L__Init_Hardware95:
;heltec.c,210 :: 		GPIO.F2 = 1;
	BSF        GPIO+0, 2
;heltec.c,211 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,212 :: 		i++;
	INCF       _i+0, 1
;heltec.c,213 :: 		}
	GOTO       L_Init_Hardware23
L_Init_Hardware24:
;heltec.c,214 :: 		if (i == 15) {
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L_Init_Hardware27
;heltec.c,215 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,216 :: 		Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05);
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
;heltec.c,217 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,218 :: 		}
L_Init_Hardware27:
;heltec.c,219 :: 		}
L_Init_Hardware22:
;heltec.c,220 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,222 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,223 :: 		Lampi(3, 250);
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,224 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,225 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,227 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware122
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware122:
	BTFSC      STATUS+0, 0
	GOTO       L_Init_Hardware28
;heltec.c,228 :: 		GPIO.F0 = 0;
	BCF        GPIO+0, 0
;heltec.c,229 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,230 :: 		} else {
	GOTO       L_Init_Hardware29
L_Init_Hardware28:
;heltec.c,231 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,232 :: 		}
L_Init_Hardware29:
;heltec.c,234 :: 		in_manutenzione = 0;
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,235 :: 		reset_fatto = 0;
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,236 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,237 :: 		soglia_batteria();
	CALL       _soglia_batteria+0
;heltec.c,238 :: 		}
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;heltec.c,241 :: 		void main() {
;heltec.c,242 :: 		Init_Hardware();
	CALL       _Init_Hardware+0
;heltec.c,244 :: 		while (1) {
L_main30:
;heltec.c,245 :: 		if (INTCON.GPIF == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_main32
;heltec.c,246 :: 		dummy = GPIO;
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;heltec.c,247 :: 		INTCON.GPIF = 0;
	BCF        INTCON+0, 0
;heltec.c,248 :: 		}
L_main32:
;heltec.c,251 :: 		if (GPIO.F3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main33
;heltec.c,252 :: 		i = 0;
	CLRF       _i+0
;heltec.c,253 :: 		while (GPIO.F3 == 0 && i < 50) {
L_main34:
	BTFSC      GPIO+0, 3
	GOTO       L_main35
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main35
L__main103:
;heltec.c,254 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,255 :: 		i++;
	INCF       _i+0, 1
;heltec.c,256 :: 		if (i == 10) GPIO.F2 = 1;
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main38
	BSF        GPIO+0, 2
L_main38:
;heltec.c,257 :: 		if (i == 25) GPIO.F2 = 0;
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main39
	BCF        GPIO+0, 2
L_main39:
;heltec.c,258 :: 		}
	GOTO       L_main34
L_main35:
;heltec.c,261 :: 		if (i >= 10 && i < 25) {
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main42
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main42
L__main102:
;heltec.c,262 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,263 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,264 :: 		GPIO.F0 = 1;
	BSF        GPIO+0, 0
;heltec.c,265 :: 		Delay_Safe_ms(2000);
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,266 :: 		if (batteria_mv > soglia_off) {
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main124:
	BTFSC      STATUS+0, 0
	GOTO       L_main43
;heltec.c,267 :: 		GPIO.F0 = 0;
	BCF        GPIO+0, 0
;heltec.c,268 :: 		spento = 0;
	BCF        _spento+0, BitPos(_spento+0)
;heltec.c,269 :: 		} else {
	GOTO       L_main44
L_main43:
;heltec.c,270 :: 		spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
;heltec.c,271 :: 		}
L_main44:
;heltec.c,272 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,273 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main125
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main125:
	BTFSC      STATUS+0, 0
	GOTO       L_main45
	CALL       _soglia_batteria+0
L_main45:
;heltec.c,274 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,275 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,276 :: 		}
L_main42:
;heltec.c,279 :: 		if (i >= 25 && i < 50) {
	MOVLW      25
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main48
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main48
L__main101:
;heltec.c,280 :: 		GPIO.F2 = 0;
	BCF        GPIO+0, 2
;heltec.c,281 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,282 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,283 :: 		val_da_lampeggiare = batteria_mv;
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;heltec.c,284 :: 		Estrai_e_Lampeggia(1000);
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,285 :: 		Estrai_e_Lampeggia(100);
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,286 :: 		Estrai_e_Lampeggia(10);
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      0
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;heltec.c,287 :: 		Lampeggia_Cifra(0);
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;heltec.c,289 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main49
;heltec.c,290 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,291 :: 		Lampi(2, 100);
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,292 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,293 :: 		GPIO.F2 = 1; Delay_Safe_ms(100); GPIO.F2 = 0;
	BSF        GPIO+0, 2
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	BCF        GPIO+0, 2
;heltec.c,294 :: 		Delay_Safe_ms(1000);
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
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
L_main49:
;heltec.c,303 :: 		}
L_main48:
;heltec.c,306 :: 		if (i >= 50) {
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main50
;heltec.c,307 :: 		GPIO.F0 = 1;
	BSF        GPIO+0, 0
;heltec.c,308 :: 		Lampi(10, 100); // Sostituisce il ciclo manuale per brevità
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,309 :: 		in_manutenzione = 1;
	BSF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
;heltec.c,310 :: 		while (in_manutenzione) {
L_main51:
	BTFSS      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main52
;heltec.c,311 :: 		GPIO.F2 = 1; Delay_Safe_ms(500); GPIO.F2 = 0;
	BSF        GPIO+0, 2
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	BCF        GPIO+0, 2
;heltec.c,312 :: 		if (GPIO.F3 == 0) {
	BTFSC      GPIO+0, 3
	GOTO       L_main53
;heltec.c,313 :: 		i = 0;
	CLRF       _i+0
;heltec.c,314 :: 		while (GPIO.F3 == 0 && i < 50) { Delay_Safe_ms(100); i++; }
L_main54:
	BTFSC      GPIO+0, 3
	GOTO       L_main55
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main55
L__main100:
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
	INCF       _i+0, 1
	GOTO       L_main54
L_main55:
;heltec.c,315 :: 		if (i >= 50) in_manutenzione = 0;
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main58
	BCF        _in_manutenzione+0, BitPos(_in_manutenzione+0)
L_main58:
;heltec.c,316 :: 		} else {
	GOTO       L_main59
L_main53:
;heltec.c,317 :: 		Delay_Safe_ms(500);
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,318 :: 		}
L_main59:
;heltec.c,319 :: 		asm clrwdt;
	CLRWDT
;heltec.c,320 :: 		}
	GOTO       L_main51
L_main52:
;heltec.c,321 :: 		Lampi(10, 100);
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	MOVLW      0
	MOVWF      FARG_Lampi_t_on+1
	CALL       _Lampi+0
;heltec.c,322 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,323 :: 		if (batteria_mv > soglia_off) { GPIO.F0 = 0; spento = 0; }
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main126:
	BTFSC      STATUS+0, 0
	GOTO       L_main60
	BCF        GPIO+0, 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L_main61
L_main60:
;heltec.c,324 :: 		else spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
L_main61:
;heltec.c,325 :: 		if (batteria_mv < soglia_on) soglia_batteria();
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main127:
	BTFSC      STATUS+0, 0
	GOTO       L_main62
	CALL       _soglia_batteria+0
L_main62:
;heltec.c,326 :: 		sveglie_wdt = 13;
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	MOVLW      0
	MOVWF      _sveglie_wdt+1
;heltec.c,327 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,328 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,329 :: 		}
L_main50:
;heltec.c,330 :: 		}
L_main33:
;heltec.c,333 :: 		if (!in_manutenzione) {
	BTFSC      _in_manutenzione+0, BitPos(_in_manutenzione+0)
	GOTO       L_main63
;heltec.c,334 :: 		if (sveglie_wdt >= 13) {
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main128:
	BTFSS      STATUS+0, 0
	GOTO       L_main64
;heltec.c,335 :: 		Leggi_Batteria_mV();
	CALL       _Leggi_Batteria_mV+0
;heltec.c,336 :: 		if (batteria_mv <= soglia_off) { GPIO.F0 = 1; spento = 1; }
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main129:
	BTFSS      STATUS+0, 0
	GOTO       L_main65
	BSF        GPIO+0, 0
	BSF        _spento+0, BitPos(_spento+0)
L_main65:
;heltec.c,337 :: 		if (batteria_mv >= soglia_on) { GPIO.F0 = 0; spento = 0; }
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main130:
	BTFSS      STATUS+0, 0
	GOTO       L_main66
	BCF        GPIO+0, 0
	BCF        _spento+0, BitPos(_spento+0)
L_main66:
;heltec.c,339 :: 		sveglie_wdt = 0;
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;heltec.c,341 :: 		if (RTC_presente == 1) {
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L_main67
;heltec.c,342 :: 		giorni_riavvio = 0;
	CLRF       _giorni_riavvio+0
;heltec.c,343 :: 		minuti_count++;
	INCF       _minuti_count+0, 1
;heltec.c,344 :: 		} else {
	GOTO       L_main68
L_main67:
;heltec.c,345 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,346 :: 		finestra_oraria = 0;
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;heltec.c,347 :: 		}
L_main68:
;heltec.c,350 :: 		if (giorni_riavvio > 0) {
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main69
;heltec.c,351 :: 		conteggio_cicli++;
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
;heltec.c,352 :: 		if (conteggio_cicli >= ((unsigned long)cicli_per_giorno * giorni_riavvio)) {
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
	GOTO       L__main131
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main131:
	BTFSS      STATUS+0, 0
	GOTO       L_main70
;heltec.c,353 :: 		GPIO.F0 = 1; Delay_Safe_ms(2000);
	BSF        GPIO+0, 0
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,354 :: 		if (batteria_mv > soglia_off) { GPIO.F0 = 0; spento = 0; }
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main132:
	BTFSC      STATUS+0, 0
	GOTO       L_main71
	BCF        GPIO+0, 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L_main72
L_main71:
;heltec.c,355 :: 		else spento = 1;
	BSF        _spento+0, BitPos(_spento+0)
L_main72:
;heltec.c,356 :: 		conteggio_cicli = 0;
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;heltec.c,357 :: 		}
L_main70:
;heltec.c,358 :: 		}
L_main69:
;heltec.c,361 :: 		if (minuti_count >= 20) {
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main73
;heltec.c,362 :: 		Leggi_Ora_RTC();
	CALL       _Leggi_Ora_RTC+0
;heltec.c,363 :: 		if (!finestra_oraria) {
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L_main74
;heltec.c,364 :: 		if (ore == 4) {
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main75
;heltec.c,365 :: 		if (!reset_fatto) {
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L_main76
;heltec.c,366 :: 		if (giorno == 1 || giorno == 4) {
	MOVF       _giorno+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__main99
	MOVF       _giorno+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main99
	GOTO       L_main79
L__main99:
;heltec.c,367 :: 		GPIO.F0 = 1; Delay_Safe_ms(10000);
	BSF        GPIO+0, 0
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,368 :: 		if (batteria_mv > soglia_off && !spento) GPIO.F0 = 0;
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main133
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main133:
	BTFSC      STATUS+0, 0
	GOTO       L_main82
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main82
L__main98:
	BCF        GPIO+0, 0
L_main82:
;heltec.c,369 :: 		reset_fatto = 1;
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
;heltec.c,370 :: 		}
L_main79:
;heltec.c,371 :: 		}
L_main76:
;heltec.c,372 :: 		} else { reset_fatto = 0; }
	GOTO       L_main83
L_main75:
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
L_main83:
;heltec.c,373 :: 		} else {
	GOTO       L_main84
L_main74:
;heltec.c,375 :: 		if (ore >= 7 && ore < 13) {
	MOVLW      7
	SUBWF      _ore+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main87
	MOVLW      13
	SUBWF      _ore+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main87
L__main97:
;heltec.c,376 :: 		if (batteria_mv > soglia_off && !spento) GPIO.F0 = 0;
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main134
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main134:
	BTFSC      STATUS+0, 0
	GOTO       L_main90
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L_main90
L__main96:
	BCF        GPIO+0, 0
	GOTO       L_main91
L_main90:
;heltec.c,377 :: 		else GPIO.F0 = 1;
	BSF        GPIO+0, 0
L_main91:
;heltec.c,378 :: 		} else { GPIO.F0 = 1; }
	GOTO       L_main92
L_main87:
	BSF        GPIO+0, 0
L_main92:
;heltec.c,379 :: 		}
L_main84:
;heltec.c,380 :: 		minuti_count = 0;
	CLRF       _minuti_count+0
;heltec.c,381 :: 		}
L_main73:
;heltec.c,382 :: 		}
L_main64:
;heltec.c,383 :: 		sveglie_wdt++;
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;heltec.c,384 :: 		asm clrwdt;
	CLRWDT
;heltec.c,385 :: 		asm sleep;
	SLEEP
;heltec.c,386 :: 		asm nop;
	NOP
;heltec.c,387 :: 		} else {
	GOTO       L_main93
L_main63:
;heltec.c,388 :: 		Delay_Safe_ms(100);
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;heltec.c,389 :: 		asm clrwdt;
	CLRWDT
;heltec.c,390 :: 		}
L_main93:
;heltec.c,391 :: 		}
	GOTO       L_main30
;heltec.c,392 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
