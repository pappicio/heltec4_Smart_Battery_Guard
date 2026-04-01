
_Delay_Safe_ms:

;supervisore_energetico.mbas,40 :: 		dim k as word
;supervisore_energetico.mbas,41 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms192
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms192:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,42 :: 		delay_us(980)                ' Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
	MOVLW      2
	MOVWF      R12+0
	MOVLW      68
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
	NOP
;supervisore_energetico.mbas,43 :: 		clrwdt                       ' Reset del Watchdog ad ogni millisecondo
	CLRWDT
;supervisore_energetico.mbas,44 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms193
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms193:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,45 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;supervisore_energetico.mbas,49 :: 		dim l as byte
;supervisore_energetico.mbas,50 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra9
;supervisore_energetico.mbas,52 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,53 :: 		delay_safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,54 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
	GOTO       L__Lampeggia_Cifra10
;supervisore_energetico.mbas,55 :: 		else
L__Lampeggia_Cifra9:
;supervisore_energetico.mbas,56 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra11:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra15
;supervisore_energetico.mbas,57 :: 		GPIO.2 = 1             ' Accende LED
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,58 :: 		delay_safe_ms(250)          ' Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,59 :: 		GPIO.2 = 0             ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,60 :: 		delay_safe_ms(250)          ' Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,61 :: 		clrwdt                 ' Mantiene il sistema attivo
	CLRWDT
;supervisore_energetico.mbas,62 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra15
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra11
L__Lampeggia_Cifra15:
;supervisore_energetico.mbas,63 :: 		end if
L__Lampeggia_Cifra10:
;supervisore_energetico.mbas,64 :: 		Delay_Safe_ms(1000)            ' Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,65 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;supervisore_energetico.mbas,70 :: 		dim contatore as byte
;supervisore_energetico.mbas,71 :: 		contatore = 0
	CLRF       Estrai_e_Lampeggia_contatore+0
;supervisore_energetico.mbas,72 :: 		while val_da_lampeggiare >= divisore
L__Estrai_e_Lampeggia18:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia196
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia196:
	BTFSS      STATUS+0, 0
	GOTO       L__Estrai_e_Lampeggia19
;supervisore_energetico.mbas,73 :: 		val_da_lampeggiare = val_da_lampeggiare - divisore
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;supervisore_energetico.mbas,74 :: 		contatore = contatore + 1
	INCF       Estrai_e_Lampeggia_contatore+0, 1
;supervisore_energetico.mbas,75 :: 		wend
	GOTO       L__Estrai_e_Lampeggia18
L__Estrai_e_Lampeggia19:
;supervisore_energetico.mbas,76 :: 		Lampeggia_Cifra(contatore)
	MOVF       Estrai_e_Lampeggia_contatore+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,77 :: 		end sub
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;supervisore_energetico.mbas,80 :: 		sub procedure Leggi_Ora_RTC()
;supervisore_energetico.mbas,82 :: 		gpio.2 = 1           ' Accende il LED (Segnale di attività I2C)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,85 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,86 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,87 :: 		delay_safe_ms(1)        ' Piccola pausa di assestamento
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,90 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,91 :: 		Soft_I2C_Write(0xD0) ' Indirizzo RTC (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,92 :: 		Soft_I2C_Write(0x01) ' Punta al registro 0x01 (Minuti)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,95 :: 		Soft_I2C_Start()     ' Segnale di Restart
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,96 :: 		Soft_I2C_Write(0xD1) ' Indirizzo RTC (Lettura)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,99 :: 		bcd_val = Soft_I2C_Read(1) ' Manda ACK (1) per continuare a leggere
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,100 :: 		minuti = ((bcd_val >> 4) * 10) + (bcd_val and 0x0F)
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
	CALL       _Mul_8x8_U+0
	MOVLW      15
	ANDWF      FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _minuti+0
;supervisore_energetico.mbas,103 :: 		bcd_val = Soft_I2C_Read(1) ' Manda ACK (1) per continuare
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,105 :: 		bcd_val = bcd_val and 0x3F ' <--- Questo garantisce che 04 sia 04 e non 68!
	MOVLW      63
	ANDWF      R0+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,106 :: 		ore = ((bcd_val >> 4) * 10) + (bcd_val and 0x0F)
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
	CALL       _Mul_8x8_U+0
	MOVLW      15
	ANDWF      FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _ore+0
;supervisore_energetico.mbas,109 :: 		bcd_val = Soft_I2C_Read(0) ' Manda NACK (0) per chiudere la lettura
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,110 :: 		giorno = bcd_val and 0x07 ' Isola solo i primi 3 bit (1-7)
	MOVLW      7
	ANDWF      R0+0, 0
	MOVWF      _giorno+0
;supervisore_energetico.mbas,113 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,114 :: 		delay_safe_ms(1)
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,115 :: 		gpio.2 = 0           ' Spegne il LED (Lettura completata)
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,116 :: 		end sub
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Segnale_Triplo:

;supervisore_energetico.mbas,119 :: 		sub procedure Segnale_Triplo()
;supervisore_energetico.mbas,120 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__Segnale_Triplo25:
;supervisore_energetico.mbas,121 :: 		GPIO.2 = 1                 ' Accende LED (Nuovo PIN)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,122 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,123 :: 		GPIO.2 = 0                 ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,124 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,125 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Triplo28
	INCF       _j+0, 1
	GOTO       L__Segnale_Triplo25
L__Segnale_Triplo28:
;supervisore_energetico.mbas,126 :: 		end sub
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,132 :: 		dim media_pulita as word
;supervisore_energetico.mbas,134 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,136 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV31:
;supervisore_energetico.mbas,137 :: 		somma = somma + ADC_Read(1) ' Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,138 :: 		delay_safe_ms(1)                 ' Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,139 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV34
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV31
L__Leggi_Batteria_mV34:
;supervisore_energetico.mbas,142 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV200:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV201
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV200
L__Leggi_Batteria_mV201:
;supervisore_energetico.mbas,145 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV202:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV203
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV202
L__Leggi_Batteria_mV203:
;supervisore_energetico.mbas,146 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_soglia_batteria:

;supervisore_energetico.mbas,149 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,150 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria205
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria205
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria205
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria205:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria37
;supervisore_energetico.mbas,151 :: 		GPIO.2 = 0                  ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,152 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,154 :: 		for j = 1 to 6
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria40:
;supervisore_energetico.mbas,155 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,156 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,157 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,158 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,160 :: 		next j
	MOVF       _j+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria43
	INCF       _j+0, 1
	GOTO       L__soglia_batteria40
L__soglia_batteria43:
	GOTO       L__soglia_batteria38
;supervisore_energetico.mbas,161 :: 		else
L__soglia_batteria37:
;supervisore_energetico.mbas,162 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria206
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria206
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria206
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria206:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria207
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria207
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria207
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria207:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria45
;supervisore_energetico.mbas,164 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,165 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria48:
;supervisore_energetico.mbas,166 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,167 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,168 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,169 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,171 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria51
	INCF       _j+0, 1
	GOTO       L__soglia_batteria48
L__soglia_batteria51:
L__soglia_batteria45:
;supervisore_energetico.mbas,173 :: 		end if
L__soglia_batteria38:
;supervisore_energetico.mbas,174 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_scrivi_ora_RTC:

;supervisore_energetico.mbas,178 :: 		sub procedure scrivi_ora_RTC
;supervisore_energetico.mbas,180 :: 		gpio.2=1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,181 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,182 :: 		Soft_I2C_Init()     ' Inizializza
	CALL       _Soft_I2C_Init+0
;supervisore_energetico.mbas,183 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,184 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,185 :: 		Soft_I2C_Write(0xD0) ' Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,186 :: 		Soft_I2C_Write(0x00) ' Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,189 :: 		Soft_I2C_Write(0x00) ' Secondi (00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,190 :: 		Soft_I2C_Write(0x05) ' Minuti (metti 54 se sono le 10:54)
	MOVLW      5
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,191 :: 		Soft_I2C_Write(0x04) ' Ore (metti 10 se sono le 10)
	MOVLW      4
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,192 :: 		Soft_I2C_Write(0x01) ' Giorno Settimana (1=Lun, 2=Mar...)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,193 :: 		Soft_I2C_Write(0x30) ' Giorno Mese (30)
	MOVLW      48
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,194 :: 		Soft_I2C_Write(0x03) ' Mese (03 = Marzo)
	MOVLW      3
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,195 :: 		Soft_I2C_Write(0x26) ' Anno (26 = 2026)
	MOVLW      38
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,197 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,199 :: 		EEPROM_Write(0x00, 1) ' Segna che abbiamo già sincronizzato
	CLRF       FARG_EEPROM_Write_address+0
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,200 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,201 :: 		end sub
L_end_scrivi_ora_RTC:
	RETURN
; end of _scrivi_ora_RTC

_Visualizza_Ora_RTC:

;supervisore_energetico.mbas,206 :: 		sub procedure Visualizza_Ora_RTC()
;supervisore_energetico.mbas,208 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,211 :: 		for j = 1 to 2
	MOVLW      1
	MOVWF      _j+0
L__Visualizza_Ora_RTC55:
;supervisore_energetico.mbas,212 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,213 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,214 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,215 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,216 :: 		next j
	MOVF       _j+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Visualizza_Ora_RTC58
	INCF       _j+0, 1
	GOTO       L__Visualizza_Ora_RTC55
L__Visualizza_Ora_RTC58:
;supervisore_energetico.mbas,217 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,220 :: 		Lampeggia_Cifra(ore / 10)
	MOVLW      10
	MOVWF      R4+0
	MOVF       _ore+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,221 :: 		Lampeggia_Cifra(ore mod 10)
	MOVLW      10
	MOVWF      R4+0
	MOVF       _ore+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,224 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,227 :: 		Lampeggia_Cifra(minuti / 10)
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minuti+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,228 :: 		Lampeggia_Cifra(minuti mod 10)
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minuti+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,231 :: 		for j = 1 to 2
	MOVLW      1
	MOVWF      _j+0
L__Visualizza_Ora_RTC60:
;supervisore_energetico.mbas,232 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,233 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,234 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,235 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,236 :: 		next j
	MOVF       _j+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Visualizza_Ora_RTC63
	INCF       _j+0, 1
	GOTO       L__Visualizza_Ora_RTC60
L__Visualizza_Ora_RTC63:
;supervisore_energetico.mbas,237 :: 		end sub
L_end_Visualizza_Ora_RTC:
	RETURN
; end of _Visualizza_Ora_RTC

_Init_Hardware:

;supervisore_energetico.mbas,242 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,244 :: 		RTC_presente = 0
	CLRF       _RTC_presente+0
;supervisore_energetico.mbas,245 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,248 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,251 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,254 :: 		TRISIO = %00001010
	MOVLW      10
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,257 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,260 :: 		WPU = %00000000
	CLRF       WPU+0
;supervisore_energetico.mbas,263 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,266 :: 		IOC.3 = 1
	BSF        IOC+0, 3
;supervisore_energetico.mbas,269 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,272 :: 		cicli_per_giorno = 2883
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;supervisore_energetico.mbas,276 :: 		TRISIO.4 = 0
	BCF        TRISIO+0, 4
;supervisore_energetico.mbas,277 :: 		GPIO.4 = 1 ' SDA Alto
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,278 :: 		TRISIO.5 = 0
	BCF        TRISIO+0, 5
;supervisore_energetico.mbas,279 :: 		GPIO.5 = 1 ' SCL Alto
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,285 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,286 :: 		soglia_on    = 3600  '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,287 :: 		taratura_vcc = 5050  'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,288 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,294 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,297 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,302 :: 		RTC_presente = 1 'se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	MOVLW      1
	MOVWF      _RTC_presente+0
;supervisore_energetico.mbas,303 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,306 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,310 :: 		Delay_Safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,312 :: 		minuti_count = 20
	MOVLW      20
	MOVWF      _minuti_count+0
;supervisore_energetico.mbas,314 :: 		stato_eeprom = EEPROM_Read(0x00)
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _stato_eeprom+0
;supervisore_energetico.mbas,315 :: 		if ((stato_eeprom <> 1) and (RTC_presente = 1)) then
	MOVF       R0+0, 0
	XORLW      1
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _RTC_presente+0, 0
	XORLW      1
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__Init_Hardware69
;supervisore_energetico.mbas,316 :: 		Scrivi_ora_RTC
	CALL       _scrivi_ora_RTC+0
L__Init_Hardware69:
;supervisore_energetico.mbas,319 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,322 :: 		Segnale_Triplo()
	CALL       _Segnale_Triplo+0
;supervisore_energetico.mbas,325 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,328 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,331 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware211
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware211
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware211
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware211:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware72
;supervisore_energetico.mbas,332 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
L__Init_Hardware72:
;supervisore_energetico.mbas,336 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,337 :: 		reset_fatto = 0
	CLRF       _reset_fatto+0
;supervisore_energetico.mbas,338 :: 		sveglie_wdt = 0  ' Forza lettura batteria al primo giro
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,343 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,344 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,347 :: 		main:
;supervisore_energetico.mbas,348 :: 		Init_Hardware()                ' Configura il chip
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,351 :: 		while (TRUE)
L__main76:
;supervisore_energetico.mbas,353 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main81
;supervisore_energetico.mbas,354 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,355 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main81:
;supervisore_energetico.mbas,359 :: 		if (GPIO.3 = 0) then
	BTFSC      GPIO+0, 3
	GOTO       L__main84
;supervisore_energetico.mbas,360 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,361 :: 		while (GPIO.3 = 0) and (i < 50)
L__main87:
	BTFSC      GPIO+0, 3
	GOTO       L__main213
	BSF        117, 0
	GOTO       L__main214
L__main213:
	BCF        117, 0
L__main214:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      117, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main88
;supervisore_energetico.mbas,362 :: 		Delay_Safe_ms(100) ' Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,363 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,364 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main92
;supervisore_energetico.mbas,365 :: 		GPIO.2 = 1     ' Accende LED dopo 1 secondo di pressione
	BSF        GPIO+0, 2
L__main92:
;supervisore_energetico.mbas,367 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main95
;supervisore_energetico.mbas,368 :: 		GPIO.2 = 0     ' Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 2
L__main95:
;supervisore_energetico.mbas,370 :: 		wend
	GOTO       L__main87
L__main88:
;supervisore_energetico.mbas,373 :: 		if (i >= 10) and (i < 25) then
	MOVLW      10
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVLW      25
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main98
;supervisore_energetico.mbas,374 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,375 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,380 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,381 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,385 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main215:
	BTFSC      STATUS+0, 0
	GOTO       L__main101
;supervisore_energetico.mbas,386 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
L__main101:
;supervisore_energetico.mbas,388 :: 		gpio.2=0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,389 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main216:
	BTFSC      STATUS+0, 0
	GOTO       L__main104
;supervisore_energetico.mbas,390 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main104:
;supervisore_energetico.mbas,392 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,393 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main98:
;supervisore_energetico.mbas,399 :: 		if (i >= 25) and (i < 50) then
	MOVLW      25
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main107
;supervisore_energetico.mbas,400 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,401 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,402 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,405 :: 		val_da_lampeggiare = word(batteria_mv)
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;supervisore_energetico.mbas,407 :: 		Estrai_e_Lampeggia(1000) ' Migliaia
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,408 :: 		Estrai_e_Lampeggia(100)  ' Centinaia
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,409 :: 		Estrai_e_Lampeggia(10)   ' Decine
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,410 :: 		Lampeggia_Cifra(0)       ' Unità fisse
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,413 :: 		if (RTC_presente = 1) then
	MOVF       _RTC_presente+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main110
;supervisore_energetico.mbas,414 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,415 :: 		for j = 1 to 2
	MOVLW      1
	MOVWF      _j+0
L__main113:
;supervisore_energetico.mbas,416 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,417 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,418 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,419 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,420 :: 		next j
	MOVF       _j+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__main116
	INCF       _j+0, 1
	GOTO       L__main113
L__main116:
;supervisore_energetico.mbas,421 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,422 :: 		gpio.2=1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,423 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,424 :: 		gpio.2=0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,425 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,427 :: 		val_da_lampeggiare = word(ore)
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,428 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,429 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare)) ' Il resto sono le unità
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,431 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,434 :: 		val_da_lampeggiare = word(minuti)
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,435 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,436 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare))
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
L__main110:
;supervisore_energetico.mbas,437 :: 		end if
L__main107:
;supervisore_energetico.mbas,442 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main118
;supervisore_energetico.mbas,443 :: 		GPIO.0 = 1                      ' Distacca il carico (Heltec OFF)
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,445 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main121:
;supervisore_energetico.mbas,446 :: 		GPIO.2 = not GPIO.2         ' Lampeggio veloce di conferma
	MOVLW      4
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,447 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,449 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main124
	INCF       _j+0, 1
	GOTO       L__main121
L__main124:
;supervisore_energetico.mbas,450 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,451 :: 		in_manutenzione = true          ' Entra nel loop di blocco
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,452 :: 		while (in_manutenzione = true)
L__main126:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main127
;supervisore_energetico.mbas,454 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,455 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,456 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,457 :: 		if (GPIO.3 = 0) then        ' Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L__main131
;supervisore_energetico.mbas,458 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,459 :: 		while (GPIO.3 = 0) and (i < 50)
L__main134:
	BTFSC      GPIO+0, 3
	GOTO       L__main217
	BSF        117, 0
	GOTO       L__main218
L__main217:
	BCF        117, 0
L__main218:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      117, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main135
;supervisore_energetico.mbas,460 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,461 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,463 :: 		wend
	GOTO       L__main134
L__main135:
;supervisore_energetico.mbas,464 :: 		if (i >= 50) then       ' Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main139
;supervisore_energetico.mbas,465 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,467 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main142:
;supervisore_energetico.mbas,468 :: 		GPIO.2 = not GPIO.2
	MOVLW      4
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,469 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,471 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main145
	INCF       _j+0, 1
	GOTO       L__main142
L__main145:
;supervisore_energetico.mbas,472 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main139:
;supervisore_energetico.mbas,473 :: 		end if
	GOTO       L__main132
;supervisore_energetico.mbas,474 :: 		else
L__main131:
;supervisore_energetico.mbas,477 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,478 :: 		end if
L__main132:
;supervisore_energetico.mbas,479 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,480 :: 		wend
	GOTO       L__main126
L__main127:
;supervisore_energetico.mbas,482 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,483 :: 		if (batteria_mv > soglia_off) then GPIO.0 = 0 end if
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main219
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main219
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main219
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main219:
	BTFSC      STATUS+0, 0
	GOTO       L__main147
	BCF        GPIO+0, 0
L__main147:
;supervisore_energetico.mbas,484 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main220
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main220
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main220
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main220:
	BTFSC      STATUS+0, 0
	GOTO       L__main150
;supervisore_energetico.mbas,485 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main150:
;supervisore_energetico.mbas,487 :: 		sveglie_wdt = 13 ' Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,488 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,489 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,490 :: 		clrwdt
	CLRWDT
L__main118:
;supervisore_energetico.mbas,491 :: 		end if
L__main84:
;supervisore_energetico.mbas,495 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
;supervisore_energetico.mbas,497 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main221
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main221:
	BTFSS      STATUS+0, 0
	GOTO       L__main156
;supervisore_energetico.mbas,498 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,500 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main222
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main222
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main222
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main222:
	BTFSS      STATUS+0, 0
	GOTO       L__main159
;supervisore_energetico.mbas,501 :: 		GPIO.0 = 1 ' Spegne Heltec
	BSF        GPIO+0, 0
L__main159:
;supervisore_energetico.mbas,504 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main223
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main223
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main223
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main223:
	BTFSS      STATUS+0, 0
	GOTO       L__main162
;supervisore_energetico.mbas,505 :: 		GPIO.0 = 0 ' Accende Heltec
	BCF        GPIO+0, 0
L__main162:
;supervisore_energetico.mbas,508 :: 		sveglie_wdt = 0 ' Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,510 :: 		if (RTC_presente = 1) then
	MOVF       _RTC_presente+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main165
;supervisore_energetico.mbas,511 :: 		minuti_count = minuti_count + 1
	INCF       _minuti_count+0, 1
L__main165:
;supervisore_energetico.mbas,515 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main168
;supervisore_energetico.mbas,516 :: 		conteggio_cicli = conteggio_cicli + 1
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
;supervisore_energetico.mbas,518 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) then
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
	GOTO       L__main224
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main224
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main224
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main224:
	BTFSS      STATUS+0, 0
	GOTO       L__main171
;supervisore_energetico.mbas,519 :: 		GPIO.0 = 1           ' Ciclo di spegnimento
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,520 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,521 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main225
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main225
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main225
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main225:
	BTFSC      STATUS+0, 0
	GOTO       L__main174
;supervisore_energetico.mbas,522 :: 		GPIO.0 = 0       ' Riaccensione
	BCF        GPIO+0, 0
L__main174:
;supervisore_energetico.mbas,524 :: 		conteggio_cicli = 0  ' Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main171:
;supervisore_energetico.mbas,525 :: 		end if
L__main168:
;supervisore_energetico.mbas,529 :: 		if (minuti_count >= 20) then
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main177
;supervisore_energetico.mbas,530 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,533 :: 		if (ore = 4) and (minuti < 11) then
	MOVF       _ore+0, 0
	XORLW      4
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVLW      11
	SUBWF      _minuti+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main180
;supervisore_energetico.mbas,534 :: 		if (reset_fatto = 0) then
	MOVF       _reset_fatto+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main183
;supervisore_energetico.mbas,535 :: 		if (giorno = 1) or (giorno = 4) then
	MOVF       _giorno+0, 0
	XORLW      1
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _giorno+0, 0
	XORLW      4
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main186
;supervisore_energetico.mbas,536 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,537 :: 		Delay_Safe_ms(10000)
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,538 :: 		if (batteria_mv > soglia_off) then GPIO.0 = 0 end if
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main226
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main226
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main226
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main226:
	BTFSC      STATUS+0, 0
	GOTO       L__main189
	BCF        GPIO+0, 0
L__main189:
;supervisore_energetico.mbas,539 :: 		reset_fatto = 1
	MOVLW      1
	MOVWF      _reset_fatto+0
L__main186:
;supervisore_energetico.mbas,540 :: 		end if
L__main183:
;supervisore_energetico.mbas,541 :: 		end if
	GOTO       L__main181
;supervisore_energetico.mbas,542 :: 		else
L__main180:
;supervisore_energetico.mbas,543 :: 		reset_fatto = 0
	CLRF       _reset_fatto+0
;supervisore_energetico.mbas,544 :: 		end if
L__main181:
;supervisore_energetico.mbas,545 :: 		minuti_count = 0
	CLRF       _minuti_count+0
L__main177:
;supervisore_energetico.mbas,546 :: 		end if
L__main156:
;supervisore_energetico.mbas,550 :: 		sveglie_wdt = sveglie_wdt + 1    ' Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,551 :: 		clrwdt                            ' Pulizia watchdog
	CLRWDT
;supervisore_energetico.mbas,552 :: 		sleep                             ' Il chip dorme (Risparmio Max)
	SLEEP
;supervisore_energetico.mbas,553 :: 		nop                              ' Istruzione necessaria dopo lo sleep
	NOP
	GOTO       L__main154
;supervisore_energetico.mbas,555 :: 		else
L__main153:
;supervisore_energetico.mbas,557 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,558 :: 		end if
L__main154:
;supervisore_energetico.mbas,559 :: 		wend
	GOTO       L__main76
L_end_main:
	GOTO       $+0
; end of _main
