
_Delay_Safe_ms:

;supervisore_energetico.mbas,43 :: 		dim k as word
;supervisore_energetico.mbas,44 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms183
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms183:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,45 :: 		delay_us(978)               ' Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
	MOVLW      2
	MOVWF      R12+0
	MOVLW      67
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
	NOP
	NOP
;supervisore_energetico.mbas,47 :: 		clrwdt                       ' Reset del Watchdog ad ogni millisecondo
	CLRWDT
;supervisore_energetico.mbas,48 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms184
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms184:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,49 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;supervisore_energetico.mbas,53 :: 		dim l as byte
;supervisore_energetico.mbas,54 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra9
;supervisore_energetico.mbas,56 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,57 :: 		delay_safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,58 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
	GOTO       L__Lampeggia_Cifra10
;supervisore_energetico.mbas,59 :: 		else
L__Lampeggia_Cifra9:
;supervisore_energetico.mbas,60 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra11:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra15
;supervisore_energetico.mbas,61 :: 		GPIO.5 = 1              ' Accende LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,62 :: 		delay_safe_ms(250)           ' Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,63 :: 		GPIO.5 = 0              ' Spegne LED
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,64 :: 		delay_safe_ms(250)           ' Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,65 :: 		clrwdt                  ' Mantiene il sistema attivo
	CLRWDT
;supervisore_energetico.mbas,66 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra15
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra11
L__Lampeggia_Cifra15:
;supervisore_energetico.mbas,67 :: 		end if
L__Lampeggia_Cifra10:
;supervisore_energetico.mbas,68 :: 		Delay_Safe_ms(1000)            ' Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,69 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;supervisore_energetico.mbas,74 :: 		dim contatore as byte
;supervisore_energetico.mbas,75 :: 		contatore = 0
	CLRF       Estrai_e_Lampeggia_contatore+0
;supervisore_energetico.mbas,76 :: 		while val_da_lampeggiare >= divisore
L__Estrai_e_Lampeggia18:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia187
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia187:
	BTFSS      STATUS+0, 0
	GOTO       L__Estrai_e_Lampeggia19
;supervisore_energetico.mbas,77 :: 		val_da_lampeggiare = val_da_lampeggiare - divisore
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;supervisore_energetico.mbas,78 :: 		contatore = contatore + 1
	INCF       Estrai_e_Lampeggia_contatore+0, 1
;supervisore_energetico.mbas,79 :: 		wend
	GOTO       L__Estrai_e_Lampeggia18
L__Estrai_e_Lampeggia19:
;supervisore_energetico.mbas,80 :: 		Lampeggia_Cifra(contatore)
	MOVF       Estrai_e_Lampeggia_contatore+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,81 :: 		end sub
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;supervisore_energetico.mbas,86 :: 		dim bcd_temp as byte
;supervisore_energetico.mbas,88 :: 		gpio.5 = 1           ' Accende tutto (LED su GP5)
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,89 :: 		delay_safe_ms(100)   ' Tempo di sveglia
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,92 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,93 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,94 :: 		delay_safe_ms(10)
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,97 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,98 :: 		Soft_I2C_Write(0xD0)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,99 :: 		Soft_I2C_Write(0x01)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,100 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,101 :: 		Soft_I2C_Write(0xD1)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,102 :: 		bcd_temp = Soft_I2C_Read(0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,103 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,105 :: 		minuti = ((bcd_temp >> 4) * 10) + (bcd_temp and 0x0F)
	MOVF       Leggi_Ora_RTC_bcd_temp+0, 0
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
	ANDWF      Leggi_Ora_RTC_bcd_temp+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _minuti+0
;supervisore_energetico.mbas,107 :: 		delay_safe_ms(10)
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,110 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,111 :: 		Soft_I2C_Write(0xD0)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,112 :: 		Soft_I2C_Write(0x02)
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,113 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,114 :: 		Soft_I2C_Write(0xD1)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,115 :: 		bcd_temp = Soft_I2C_Read(0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,116 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,118 :: 		bcd_temp = bcd_temp and 0x3F
	MOVLW      63
	ANDWF      Leggi_Ora_RTC_bcd_temp+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,119 :: 		ore = ((bcd_temp >> 4) * 10) + (bcd_temp and 0x0F)
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
;supervisore_energetico.mbas,121 :: 		gpio.5 = 0           ' Spegne tutto
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,122 :: 		end sub
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,131 :: 		dim media_pulita as word
;supervisore_energetico.mbas,133 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,135 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV25:
;supervisore_energetico.mbas,136 :: 		somma = somma + ADC_Read(1) ' Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,137 :: 		delay_safe_ms(1)                 ' Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,138 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV28
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV25
L__Leggi_Batteria_mV28:
;supervisore_energetico.mbas,141 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV190:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV191
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV190
L__Leggi_Batteria_mV191:
;supervisore_energetico.mbas,144 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV192:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV193
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV192
L__Leggi_Batteria_mV193:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
;supervisore_energetico.mbas,145 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;supervisore_energetico.mbas,150 :: 		sub procedure Lampi(dim n as byte, dim t_on as word)
;supervisore_energetico.mbas,151 :: 		for j = 1 to n
	MOVLW      1
	MOVWF      _j+0
L__Lampi30:
	MOVF       _j+0, 0
	SUBWF      FARG_Lampi_n+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampi34
;supervisore_energetico.mbas,152 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,153 :: 		Delay_Safe_ms(t_on)
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,154 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,155 :: 		Delay_Safe_ms(t_on)
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,156 :: 		next j
	MOVF       _j+0, 0
	XORWF      FARG_Lampi_n+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampi34
	INCF       _j+0, 1
	GOTO       L__Lampi30
L__Lampi34:
;supervisore_energetico.mbas,157 :: 		end sub
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;supervisore_energetico.mbas,161 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,162 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria196
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria196:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria37
;supervisore_energetico.mbas,163 :: 		GPIO.5 = 0                   ' Spegne LED su GP5
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,164 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,166 :: 		lampi(6,100)
	MOVLW      6
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
	GOTO       L__soglia_batteria38
;supervisore_energetico.mbas,167 :: 		else
L__soglia_batteria37:
;supervisore_energetico.mbas,168 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria197
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria197:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria198
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria198:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria40
;supervisore_energetico.mbas,170 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,171 :: 		Lampi(3,100)
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
L__soglia_batteria40:
;supervisore_energetico.mbas,173 :: 		end if
L__soglia_batteria38:
;supervisore_energetico.mbas,174 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;supervisore_energetico.mbas,179 :: 		sub procedure Scrivi_Ora_RTC(dim s_g_sett, s_g, s_m, s_a, s_ore, s_min as byte)
;supervisore_energetico.mbas,181 :: 		gpio.5=1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,182 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,183 :: 		Soft_I2C_Init()     ' Inizializza
	CALL       _Soft_I2C_Init+0
;supervisore_energetico.mbas,184 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,185 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,186 :: 		Soft_I2C_Write(0xD0) ' Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,187 :: 		Soft_I2C_Write(0x00) ' Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,188 :: 		Soft_I2C_Write(0x00)  ' Secondi (sempre 00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,189 :: 		Soft_I2C_Write(s_min) ' Minuti (es. 0x05)
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,190 :: 		Soft_I2C_Write(s_ore) ' Ore (es. 0x04)
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,191 :: 		Soft_I2C_Write(s_g_sett) ' Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,192 :: 		Soft_I2C_Write(s_g)   ' Giorno Mese (es. 0x30)
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,193 :: 		Soft_I2C_Write(s_m)   ' Mese (es. 0x03)
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,194 :: 		Soft_I2C_Write(s_a)   ' Anno (es. 0x26)
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,195 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,196 :: 		Delay_Safe_ms(800)
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,197 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,198 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,199 :: 		end sub
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;supervisore_energetico.mbas,205 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,207 :: 		RTC_presente = 0
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;supervisore_energetico.mbas,208 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,211 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,214 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,217 :: 		TRISIO = %00001010
	MOVLW      10
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,220 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,223 :: 		WPU = %00000000
	CLRF       WPU+0
;supervisore_energetico.mbas,226 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,229 :: 		IOC.3 = 1
	BSF        IOC+0, 3
;supervisore_energetico.mbas,232 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,235 :: 		cicli_per_giorno = 2883
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;supervisore_energetico.mbas,237 :: 		spento=0
	BCF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,244 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;supervisore_energetico.mbas,245 :: 		soglia_on    = 3600  '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;supervisore_energetico.mbas,246 :: 		taratura_vcc = 5050  'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;supervisore_energetico.mbas,247 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,253 :: 		GPIO.4 = 1
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,256 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,261 :: 		RTC_presente = 0 'se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;supervisore_energetico.mbas,262 :: 		finestra_oraria = 0
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;supervisore_energetico.mbas,263 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,269 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__Init_Hardware45
;supervisore_energetico.mbas,271 :: 		TRISIO.0 = 0    ' SDA come Uscita (GP0)
	BCF        TRISIO+0, 0
;supervisore_energetico.mbas,272 :: 		TRISIO.2 = 0    ' SCL come Uscita (GP2)
	BCF        TRISIO+0, 2
;supervisore_energetico.mbas,273 :: 		GPIO.0 = 1      ' SDA Alto (Idle I2C)
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,274 :: 		GPIO.2 = 1      ' SCL Alto (Idle I2C)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,276 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,277 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,278 :: 		while (GPIO.3 = 0) and (i < 15)
L__Init_Hardware48:
	BTFSC      GPIO+0, 3
	GOTO       L__Init_Hardware201
	BSF        114, 0
	GOTO       L__Init_Hardware202
L__Init_Hardware201:
	BCF        114, 0
L__Init_Hardware202:
	MOVLW      15
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      114, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__Init_Hardware49
;supervisore_energetico.mbas,279 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,280 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,281 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,282 :: 		wend
	GOTO       L__Init_Hardware48
L__Init_Hardware49:
;supervisore_energetico.mbas,285 :: 		if (i = 15) then
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware53
;supervisore_energetico.mbas,286 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,294 :: 		Scrivi_Ora_RTC(0x01, 0x30, 0x03, 0x26, 0x04, 0x05)
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
;supervisore_energetico.mbas,295 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,296 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,298 :: 		Lampi(10, 100)
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,299 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
L__Init_Hardware53:
;supervisore_energetico.mbas,300 :: 		end if
	GOTO       L__Init_Hardware46
;supervisore_energetico.mbas,301 :: 		else
L__Init_Hardware45:
;supervisore_energetico.mbas,303 :: 		TRISIO.0 = 1    ' SDA in Alta Impedenza (Input)
	BSF        TRISIO+0, 0
;supervisore_energetico.mbas,304 :: 		TRISIO.2 = 1    ' SCL in Alta Impedenza (Input)
	BSF        TRISIO+0, 2
;supervisore_energetico.mbas,305 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
;supervisore_energetico.mbas,306 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,307 :: 		end if
L__Init_Hardware46:
;supervisore_energetico.mbas,308 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,313 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,316 :: 		Lampi(3, 250)
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,319 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,322 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,325 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware203
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware203:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware56
;supervisore_energetico.mbas,326 :: 		GPIO.4 = 0
	BCF        GPIO+0, 4
;supervisore_energetico.mbas,327 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__Init_Hardware57
;supervisore_energetico.mbas,328 :: 		else
L__Init_Hardware56:
;supervisore_energetico.mbas,329 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,330 :: 		end if
L__Init_Hardware57:
;supervisore_energetico.mbas,333 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,334 :: 		reset_fatto = 0
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;supervisore_energetico.mbas,335 :: 		sveglie_wdt = 0  ' Forza lettura batteria al primo giro
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,340 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,341 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,344 :: 		main:
;supervisore_energetico.mbas,345 :: 		Init_Hardware()                ' Configura il chip
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,347 :: 		while (TRUE)
L__main60:
;supervisore_energetico.mbas,349 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main65
;supervisore_energetico.mbas,350 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,351 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main65:
;supervisore_energetico.mbas,355 :: 		if (GPIO.3 = 0) then
	BTFSC      GPIO+0, 3
	GOTO       L__main68
;supervisore_energetico.mbas,356 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,357 :: 		while (GPIO.3 = 0) and (i < 50)
L__main71:
	BTFSC      GPIO+0, 3
	GOTO       L__main205
	BSF        116, 0
	GOTO       L__main206
L__main205:
	BCF        116, 0
L__main206:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      116, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main72
;supervisore_energetico.mbas,358 :: 		Delay_Safe_ms(100) ' Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,359 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,360 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main76
;supervisore_energetico.mbas,361 :: 		GPIO.5 = 1     ' Accende LED dopo 1 secondo di pressione (GP5)
	BSF        GPIO+0, 5
L__main76:
;supervisore_energetico.mbas,363 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main79
;supervisore_energetico.mbas,364 :: 		GPIO.5 = 0     ' Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 5
L__main79:
;supervisore_energetico.mbas,366 :: 		wend
	GOTO       L__main71
L__main72:
;supervisore_energetico.mbas,369 :: 		if (i >= 10) and (i < 25) then
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
	GOTO       L__main82
;supervisore_energetico.mbas,370 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,371 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,374 :: 		GPIO.4 = 1
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,375 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,379 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main207
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main207:
	BTFSC      STATUS+0, 0
	GOTO       L__main85
;supervisore_energetico.mbas,380 :: 		GPIO.4 = 0
	BCF        GPIO+0, 4
;supervisore_energetico.mbas,381 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main86
;supervisore_energetico.mbas,382 :: 		else
L__main85:
;supervisore_energetico.mbas,383 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,384 :: 		end if
L__main86:
;supervisore_energetico.mbas,385 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,386 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main208
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main208:
	BTFSC      STATUS+0, 0
	GOTO       L__main88
;supervisore_energetico.mbas,387 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main88:
;supervisore_energetico.mbas,389 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,390 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main82:
;supervisore_energetico.mbas,396 :: 		if (i >= 25) and (i < 50) then
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
	GOTO       L__main91
;supervisore_energetico.mbas,397 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,398 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,399 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,402 :: 		val_da_lampeggiare = word(batteria_mv)
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;supervisore_energetico.mbas,404 :: 		Estrai_e_Lampeggia(1000) ' Migliaia
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,405 :: 		Estrai_e_Lampeggia(100)  ' Centinaia
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,406 :: 		Estrai_e_Lampeggia(10)   ' Decine
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,407 :: 		Lampeggia_Cifra(0)       ' Unità fisse
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,410 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__main94
;supervisore_energetico.mbas,411 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,412 :: 		lampi (2,100)
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,413 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,414 :: 		gpio.5=1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,415 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,416 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,417 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,419 :: 		val_da_lampeggiare = word(ore)
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,420 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,421 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare)) ' Il resto sono le unità
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,423 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,426 :: 		val_da_lampeggiare = word(minuti)
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,427 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,428 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare))
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
L__main94:
;supervisore_energetico.mbas,429 :: 		end if
L__main91:
;supervisore_energetico.mbas,434 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main97
;supervisore_energetico.mbas,435 :: 		GPIO.4 = 1                       ' Distacca il carico (Heltec OFF) su GP4
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,437 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main100:
;supervisore_energetico.mbas,438 :: 		GPIO.5 = not GPIO.5         ' Lampeggio veloce di conferma
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,439 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,440 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main103
	INCF       _j+0, 1
	GOTO       L__main100
L__main103:
;supervisore_energetico.mbas,441 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,442 :: 		in_manutenzione = true          ' Entra nel loop di blocco
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,443 :: 		while (in_manutenzione = true)
L__main105:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main106
;supervisore_energetico.mbas,445 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,446 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,447 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,448 :: 		if (GPIO.3 = 0) then        ' Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L__main110
;supervisore_energetico.mbas,449 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,450 :: 		while (GPIO.3 = 0) and (i < 50)
L__main113:
	BTFSC      GPIO+0, 3
	GOTO       L__main209
	BSF        116, 0
	GOTO       L__main210
L__main209:
	BCF        116, 0
L__main210:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      116, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main114
;supervisore_energetico.mbas,451 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,452 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,453 :: 		wend
	GOTO       L__main113
L__main114:
;supervisore_energetico.mbas,454 :: 		if (i >= 50) then       ' Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main118
;supervisore_energetico.mbas,455 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,457 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main121:
;supervisore_energetico.mbas,458 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,459 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,460 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main124
	INCF       _j+0, 1
	GOTO       L__main121
L__main124:
;supervisore_energetico.mbas,461 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main118:
;supervisore_energetico.mbas,462 :: 		end if
	GOTO       L__main111
;supervisore_energetico.mbas,463 :: 		else
L__main110:
;supervisore_energetico.mbas,466 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,467 :: 		end if
L__main111:
;supervisore_energetico.mbas,468 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,469 :: 		wend
	GOTO       L__main105
L__main106:
;supervisore_energetico.mbas,471 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,472 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main211
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main211:
	BTFSC      STATUS+0, 0
	GOTO       L__main126
;supervisore_energetico.mbas,473 :: 		GPIO.4 = 0 ' Carico ON
	BCF        GPIO+0, 4
;supervisore_energetico.mbas,474 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main127
;supervisore_energetico.mbas,475 :: 		else
L__main126:
;supervisore_energetico.mbas,476 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,477 :: 		end if
L__main127:
;supervisore_energetico.mbas,478 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main212
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main212:
	BTFSC      STATUS+0, 0
	GOTO       L__main129
;supervisore_energetico.mbas,479 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main129:
;supervisore_energetico.mbas,481 :: 		sveglie_wdt = 13 ' Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,482 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,483 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,484 :: 		clrwdt
	CLRWDT
L__main97:
;supervisore_energetico.mbas,485 :: 		end if
L__main68:
;supervisore_energetico.mbas,489 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
;supervisore_energetico.mbas,491 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main213
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main213:
	BTFSS      STATUS+0, 0
	GOTO       L__main135
;supervisore_energetico.mbas,492 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,494 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main214
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main214:
	BTFSS      STATUS+0, 0
	GOTO       L__main138
;supervisore_energetico.mbas,495 :: 		GPIO.4 = 1 ' Spegne Heltec su GP4
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,496 :: 		spento=1
	BSF        _spento+0, BitPos(_spento+0)
L__main138:
;supervisore_energetico.mbas,499 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main215:
	BTFSS      STATUS+0, 0
	GOTO       L__main141
;supervisore_energetico.mbas,500 :: 		GPIO.4 = 0 ' Accende Heltec
	BCF        GPIO+0, 4
;supervisore_energetico.mbas,501 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
L__main141:
;supervisore_energetico.mbas,504 :: 		sveglie_wdt = 0 ' Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,506 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__main144
;supervisore_energetico.mbas,507 :: 		giorni_riavvio=0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,508 :: 		minuti_count = minuti_count + 1
	INCF       _minuti_count+0, 1
	GOTO       L__main145
;supervisore_energetico.mbas,509 :: 		else
L__main144:
;supervisore_energetico.mbas,510 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,511 :: 		finestra_oraria=0
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;supervisore_energetico.mbas,512 :: 		end if
L__main145:
;supervisore_energetico.mbas,515 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main147
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
	MOVF       _giorni_riavvio+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      0
	SUBWF      _conteggio_cicli+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVLW      0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main216
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main216:
	BTFSS      STATUS+0, 0
	GOTO       L__main150
;supervisore_energetico.mbas,519 :: 		GPIO.4 = 1           ' Ciclo di spegnimento GP4
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,520 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,521 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main217
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main217:
	BTFSC      STATUS+0, 0
	GOTO       L__main153
;supervisore_energetico.mbas,522 :: 		GPIO.4 = 0       ' Riaccensione
	BCF        GPIO+0, 4
;supervisore_energetico.mbas,523 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main154
;supervisore_energetico.mbas,524 :: 		else
L__main153:
;supervisore_energetico.mbas,525 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,526 :: 		end if
L__main154:
;supervisore_energetico.mbas,527 :: 		conteggio_cicli = 0  ' Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main150:
;supervisore_energetico.mbas,528 :: 		end if
L__main147:
;supervisore_energetico.mbas,532 :: 		if (minuti_count >= 20) then
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main156
;supervisore_energetico.mbas,534 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,537 :: 		if finestra_oraria = 0 then
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L__main159
;supervisore_energetico.mbas,539 :: 		if (ore = 4)  then
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L__main162
;supervisore_energetico.mbas,540 :: 		if (reset_fatto = 0) then
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L__main165
;supervisore_energetico.mbas,541 :: 		if (giorno = 1) or (giorno = 4) then
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
	GOTO       L__main168
;supervisore_energetico.mbas,542 :: 		GPIO.4 = 1
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,543 :: 		Delay_Safe_ms(10000)
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,544 :: 		if ((batteria_mv > soglia_off) and (spento = 0)) then GPIO.4 = 0 end if
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main218
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main218:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L__main219
	BSF        3, 0
	GOTO       L__main220
L__main219:
	BCF        3, 0
L__main220:
	CLRF       R0+0
	BTFSC      3, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main171
	BCF        GPIO+0, 4
L__main171:
;supervisore_energetico.mbas,545 :: 		reset_fatto = 1
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
L__main168:
;supervisore_energetico.mbas,546 :: 		end if
L__main165:
;supervisore_energetico.mbas,547 :: 		end if
	GOTO       L__main163
;supervisore_energetico.mbas,548 :: 		else
L__main162:
;supervisore_energetico.mbas,549 :: 		reset_fatto = 0
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;supervisore_energetico.mbas,550 :: 		end if
L__main163:
	GOTO       L__main160
;supervisore_energetico.mbas,552 :: 		else
L__main159:
;supervisore_energetico.mbas,555 :: 		if (ore >= 7) and (ore < 13) then 'dalle 7 alle 13 accendiamo
	MOVLW      7
	SUBWF      _ore+0, 0
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVLW      13
	SUBWF      _ore+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main174
;supervisore_energetico.mbas,557 :: 		if (giorno = 1) or (giorno = 2) or (giorno = 3) or (giorno = 4) or (giorno = 5) or (giorno = 6) or (giorno = 7)   then
	MOVF       _giorno+0, 0
	XORLW      1
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _giorno+0, 0
	XORLW      2
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 1
	MOVF       _giorno+0, 0
	XORLW      3
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 1
	MOVF       _giorno+0, 0
	XORLW      4
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 1
	MOVF       _giorno+0, 0
	XORLW      5
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 1
	MOVF       _giorno+0, 0
	XORLW      6
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 1
	MOVF       _giorno+0, 0
	XORLW      7
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main177
;supervisore_energetico.mbas,558 :: 		if ((batteria_mv > soglia_off)  and (spento=0))  then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main221
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main221:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L__main222
	BSF        3, 0
	GOTO       L__main223
L__main222:
	BCF        3, 0
L__main223:
	CLRF       R0+0
	BTFSC      3, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main180
;supervisore_energetico.mbas,560 :: 		GPIO.4 = 0
	BCF        GPIO+0, 4
	GOTO       L__main181
;supervisore_energetico.mbas,561 :: 		else
L__main180:
;supervisore_energetico.mbas,562 :: 		GPIO.4 = 1
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,563 :: 		end if
L__main181:
L__main177:
;supervisore_energetico.mbas,564 :: 		end if
	GOTO       L__main175
;supervisore_energetico.mbas,565 :: 		else
L__main174:
;supervisore_energetico.mbas,567 :: 		GPIO.4 = 1
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,568 :: 		end if
L__main175:
;supervisore_energetico.mbas,569 :: 		end if
L__main160:
;supervisore_energetico.mbas,570 :: 		minuti_count = 0
	CLRF       _minuti_count+0
L__main156:
;supervisore_energetico.mbas,571 :: 		end if
L__main135:
;supervisore_energetico.mbas,576 :: 		sveglie_wdt = sveglie_wdt + 1    ' Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,577 :: 		clrwdt                            ' Pulizia watchdog
	CLRWDT
;supervisore_energetico.mbas,578 :: 		sleep                             ' Il chip dorme (Risparmio Max)
	SLEEP
;supervisore_energetico.mbas,579 :: 		nop                               ' Istruzione necessaria dopo lo sleep
	NOP
	GOTO       L__main133
;supervisore_energetico.mbas,581 :: 		else
L__main132:
;supervisore_energetico.mbas,583 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,584 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,585 :: 		end if
L__main133:
;supervisore_energetico.mbas,586 :: 		wend
	GOTO       L__main60
L_end_main:
	GOTO       $+0
; end of _main
