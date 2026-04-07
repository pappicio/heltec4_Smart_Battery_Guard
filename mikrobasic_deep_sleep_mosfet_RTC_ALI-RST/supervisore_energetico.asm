
_Delay_Safe_ms:

;supervisore_energetico.mbas,46 :: 		dim k as word
;supervisore_energetico.mbas,47 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms180
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms180:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,48 :: 		delay_us(978)               ' Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
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
;supervisore_energetico.mbas,50 :: 		clrwdt                       ' Reset del Watchdog ad ogni millisecondo
	CLRWDT
;supervisore_energetico.mbas,51 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms181
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms181:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,52 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Lampeggia_Cifra:

;supervisore_energetico.mbas,56 :: 		dim l as byte
;supervisore_energetico.mbas,57 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra9
;supervisore_energetico.mbas,59 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,60 :: 		delay_safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,61 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
	GOTO       L__Lampeggia_Cifra10
;supervisore_energetico.mbas,62 :: 		else
L__Lampeggia_Cifra9:
;supervisore_energetico.mbas,63 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra11:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra15
;supervisore_energetico.mbas,64 :: 		GPIO.5 = 1              ' Accende LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,65 :: 		delay_safe_ms(250)           ' Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,66 :: 		GPIO.5 = 0              ' Spegne LED
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,67 :: 		delay_safe_ms(250)           ' Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,68 :: 		clrwdt                  ' Mantiene il sistema attivo
	CLRWDT
;supervisore_energetico.mbas,69 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra15
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra11
L__Lampeggia_Cifra15:
;supervisore_energetico.mbas,70 :: 		end if
L__Lampeggia_Cifra10:
;supervisore_energetico.mbas,71 :: 		Delay_Safe_ms(1000)            ' Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,72 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Estrai_e_Lampeggia:

;supervisore_energetico.mbas,77 :: 		dim contatore as byte
;supervisore_energetico.mbas,78 :: 		contatore = 0
	CLRF       Estrai_e_Lampeggia_contatore+0
;supervisore_energetico.mbas,79 :: 		while val_da_lampeggiare >= divisore
L__Estrai_e_Lampeggia18:
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Estrai_e_Lampeggia184
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 0
L__Estrai_e_Lampeggia184:
	BTFSS      STATUS+0, 0
	GOTO       L__Estrai_e_Lampeggia19
;supervisore_energetico.mbas,80 :: 		val_da_lampeggiare = val_da_lampeggiare - divisore
	MOVF       FARG_Estrai_e_Lampeggia_divisore+0, 0
	SUBWF      _val_da_lampeggiare+0, 1
	BTFSS      STATUS+0, 0
	DECF       _val_da_lampeggiare+1, 1
	MOVF       FARG_Estrai_e_Lampeggia_divisore+1, 0
	SUBWF      _val_da_lampeggiare+1, 1
;supervisore_energetico.mbas,81 :: 		contatore = contatore + 1
	INCF       Estrai_e_Lampeggia_contatore+0, 1
;supervisore_energetico.mbas,82 :: 		wend
	GOTO       L__Estrai_e_Lampeggia18
L__Estrai_e_Lampeggia19:
;supervisore_energetico.mbas,83 :: 		Lampeggia_Cifra(contatore)
	MOVF       Estrai_e_Lampeggia_contatore+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,84 :: 		end sub
L_end_Estrai_e_Lampeggia:
	RETURN
; end of _Estrai_e_Lampeggia

_Leggi_Ora_RTC:

;supervisore_energetico.mbas,89 :: 		dim bcd_temp as byte
;supervisore_energetico.mbas,91 :: 		gpio.5 = 1           ' Accende tutto (LED su GP5)
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,92 :: 		delay_safe_ms(100)   ' Tempo di sveglia
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,95 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,96 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,97 :: 		delay_safe_ms(10)
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,100 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,101 :: 		Soft_I2C_Write(0xD0)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,102 :: 		Soft_I2C_Write(0x01)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,103 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,104 :: 		Soft_I2C_Write(0xD1)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,105 :: 		bcd_temp = Soft_I2C_Read(0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,106 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,108 :: 		minuti = ((bcd_temp >> 4) * 10) + (bcd_temp and 0x0F)
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
;supervisore_energetico.mbas,110 :: 		delay_safe_ms(10)
	MOVLW      10
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,113 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,114 :: 		Soft_I2C_Write(0xD0)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,115 :: 		Soft_I2C_Write(0x02)
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,116 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,117 :: 		Soft_I2C_Write(0xD1)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,118 :: 		bcd_temp = Soft_I2C_Read(0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,119 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,121 :: 		bcd_temp = bcd_temp and 0x3F
	MOVLW      63
	ANDWF      Leggi_Ora_RTC_bcd_temp+0, 0
	MOVWF      FLOC__Leggi_Ora_RTC+0
	MOVF       FLOC__Leggi_Ora_RTC+0, 0
	MOVWF      Leggi_Ora_RTC_bcd_temp+0
;supervisore_energetico.mbas,122 :: 		ore = ((bcd_temp >> 4) * 10) + (bcd_temp and 0x0F)
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
;supervisore_energetico.mbas,124 :: 		gpio.5 = 0           ' Spegne tutto
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,125 :: 		end sub
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,134 :: 		dim media_pulita as word
;supervisore_energetico.mbas,136 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,138 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV25:
;supervisore_energetico.mbas,139 :: 		somma = somma + ADC_Read(1) ' Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,140 :: 		delay_safe_ms(1)                 ' Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,141 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV28
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV25
L__Leggi_Batteria_mV28:
;supervisore_energetico.mbas,144 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV187:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV188
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV187
L__Leggi_Batteria_mV188:
;supervisore_energetico.mbas,147 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV189:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV190
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV189
L__Leggi_Batteria_mV190:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
;supervisore_energetico.mbas,148 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Lampi:

;supervisore_energetico.mbas,153 :: 		sub procedure Lampi(dim n as byte, dim t_on as word)
;supervisore_energetico.mbas,154 :: 		for j = 1 to n
	MOVLW      1
	MOVWF      _j+0
L__Lampi30:
	MOVF       _j+0, 0
	SUBWF      FARG_Lampi_n+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampi34
;supervisore_energetico.mbas,155 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,156 :: 		Delay_Safe_ms(t_on)
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,157 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,158 :: 		Delay_Safe_ms(t_on)
	MOVF       FARG_Lampi_t_on+0, 0
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVF       FARG_Lampi_t_on+1, 0
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,159 :: 		next j
	MOVF       _j+0, 0
	XORWF      FARG_Lampi_n+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampi34
	INCF       _j+0, 1
	GOTO       L__Lampi30
L__Lampi34:
;supervisore_energetico.mbas,160 :: 		end sub
L_end_Lampi:
	RETURN
; end of _Lampi

_soglia_batteria:

;supervisore_energetico.mbas,164 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,165 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria193
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria193:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria37
;supervisore_energetico.mbas,166 :: 		GPIO.5 = 0                   ' Spegne LED su GP5
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,167 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,169 :: 		lampi(5,100)
	MOVLW      5
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
	GOTO       L__soglia_batteria38
;supervisore_energetico.mbas,170 :: 		else
L__soglia_batteria37:
;supervisore_energetico.mbas,171 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria194
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria194:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria195
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria195:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria40
;supervisore_energetico.mbas,173 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,174 :: 		Lampi(3,100)
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
	GOTO       L__soglia_batteria41
;supervisore_energetico.mbas,175 :: 		else
L__soglia_batteria40:
;supervisore_energetico.mbas,177 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,178 :: 		Lampi(1,100)
	MOVLW      1
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,179 :: 		end if
L__soglia_batteria41:
;supervisore_energetico.mbas,180 :: 		end if
L__soglia_batteria38:
;supervisore_energetico.mbas,181 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Scrivi_Ora_RTC:

;supervisore_energetico.mbas,186 :: 		sub procedure Scrivi_Ora_RTC(dim s_g_sett, s_g, s_m, s_a, s_ore, s_min as byte)
;supervisore_energetico.mbas,188 :: 		gpio.5=1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,189 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,190 :: 		Soft_I2C_Init()     ' Inizializza
	CALL       _Soft_I2C_Init+0
;supervisore_energetico.mbas,191 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,192 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,193 :: 		Soft_I2C_Write(0xD0) ' Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,194 :: 		Soft_I2C_Write(0x00) ' Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,195 :: 		Soft_I2C_Write(0x00)  ' Secondi (sempre 00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,196 :: 		Soft_I2C_Write(s_min) ' Minuti (es. 0x05)
	MOVF       FARG_Scrivi_Ora_RTC_s_min+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,197 :: 		Soft_I2C_Write(s_ore) ' Ore (es. 0x04)
	MOVF       FARG_Scrivi_Ora_RTC_s_ore+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,198 :: 		Soft_I2C_Write(s_g_sett) ' Giorno Settimana (1=Lun, 2=Mar... 7=Dom)
	MOVF       FARG_Scrivi_Ora_RTC_s_g_sett+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,199 :: 		Soft_I2C_Write(s_g)   ' Giorno Mese (es. 0x30)
	MOVF       FARG_Scrivi_Ora_RTC_s_g+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,200 :: 		Soft_I2C_Write(s_m)   ' Mese (es. 0x03)
	MOVF       FARG_Scrivi_Ora_RTC_s_m+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,201 :: 		Soft_I2C_Write(s_a)   ' Anno (es. 0x26)
	MOVF       FARG_Scrivi_Ora_RTC_s_a+0, 0
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,202 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,203 :: 		Delay_Safe_ms(800)
	MOVLW      32
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,204 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,205 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,206 :: 		end sub
L_end_Scrivi_Ora_RTC:
	RETURN
; end of _Scrivi_Ora_RTC

_Init_Hardware:

;supervisore_energetico.mbas,212 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,214 :: 		RTC_presente = 0
	BCF        _RTC_presente+0, BitPos(_RTC_presente+0)
;supervisore_energetico.mbas,215 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,218 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,221 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,224 :: 		TRISIO = %00001010
	MOVLW      10
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,227 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,230 :: 		WPU = %00000000
	CLRF       WPU+0
;supervisore_energetico.mbas,233 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,236 :: 		IOC.3 = 1
	BSF        IOC+0, 3
;supervisore_energetico.mbas,239 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,242 :: 		cicli_per_giorno = 2883
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
;supervisore_energetico.mbas,244 :: 		spento=0
	BCF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,245 :: 		attivo=1
	MOVLW      1
	MOVWF      _attivo+0
;supervisore_energetico.mbas,253 :: 		RSTpin=true
	MOVLW      255
	MOVWF      _RSTpin+0
;supervisore_energetico.mbas,258 :: 		RTC_presente = 1 'se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	BSF        _RTC_presente+0, BitPos(_RTC_presente+0)
;supervisore_energetico.mbas,259 :: 		finestra_oraria = 0
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;supervisore_energetico.mbas,260 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,264 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
;supervisore_energetico.mbas,265 :: 		soglia_on    = 3600  '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
;supervisore_energetico.mbas,266 :: 		taratura_vcc = 5010  'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      146
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
;supervisore_energetico.mbas,267 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,274 :: 		GPIO.4 = attivo
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,277 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,288 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__Init_Hardware45
;supervisore_energetico.mbas,290 :: 		TRISIO.0 = 0    ' SDA come Uscita (GP0)
	BCF        TRISIO+0, 0
;supervisore_energetico.mbas,291 :: 		TRISIO.2 = 0    ' SCL come Uscita (GP2)
	BCF        TRISIO+0, 2
;supervisore_energetico.mbas,292 :: 		GPIO.0 = 1      ' SDA Alto (Idle I2C)
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,293 :: 		GPIO.2 = 1      ' SCL Alto (Idle I2C)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,295 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,296 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,297 :: 		while (GPIO.3 = 0) and (i < 15)
L__Init_Hardware48:
	BTFSC      GPIO+0, 3
	GOTO       L__Init_Hardware198
	BSF        114, 0
	GOTO       L__Init_Hardware199
L__Init_Hardware198:
	BCF        114, 0
L__Init_Hardware199:
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
;supervisore_energetico.mbas,298 :: 		GPIO.5 = 1 ' LED su GP5
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,299 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,300 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,301 :: 		wend
	GOTO       L__Init_Hardware48
L__Init_Hardware49:
;supervisore_energetico.mbas,304 :: 		if (i = 15) then
	MOVF       _i+0, 0
	XORLW      15
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware53
;supervisore_energetico.mbas,305 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,313 :: 		Scrivi_Ora_RTC(0x06,    0x04, 0x04, 0x26,    0x20, 0x55)
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
;supervisore_energetico.mbas,314 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,315 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,317 :: 		Lampi(10, 100)
	MOVLW      10
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,318 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
L__Init_Hardware53:
;supervisore_energetico.mbas,319 :: 		end if
	GOTO       L__Init_Hardware46
;supervisore_energetico.mbas,320 :: 		else
L__Init_Hardware45:
;supervisore_energetico.mbas,322 :: 		TRISIO.0 = 1    ' SDA in Alta Impedenza (Input)
	BSF        TRISIO+0, 0
;supervisore_energetico.mbas,323 :: 		TRISIO.2 = 1    ' SCL in Alta Impedenza (Input)
	BSF        TRISIO+0, 2
;supervisore_energetico.mbas,324 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
;supervisore_energetico.mbas,325 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,326 :: 		end if
L__Init_Hardware46:
;supervisore_energetico.mbas,327 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,332 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,334 :: 		if RSTpin=true then
	MOVF       _RSTpin+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware56
;supervisore_energetico.mbas,335 :: 		attivo=0
	CLRF       _attivo+0
;supervisore_energetico.mbas,337 :: 		Lampi(3, 100)
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
	GOTO       L__Init_Hardware57
;supervisore_energetico.mbas,338 :: 		else
L__Init_Hardware56:
;supervisore_energetico.mbas,340 :: 		Lampi(3, 250)
	MOVLW      3
	MOVWF      FARG_Lampi_n+0
	MOVLW      250
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,341 :: 		end if
L__Init_Hardware57:
;supervisore_energetico.mbas,346 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,349 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,352 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware200
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware200:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware59
;supervisore_energetico.mbas,353 :: 		GPIO.4 = not  attivo
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__Init_Hardware201
	BCF        GPIO+0, 4
	GOTO       L__Init_Hardware202
L__Init_Hardware201:
	BSF        GPIO+0, 4
L__Init_Hardware202:
;supervisore_energetico.mbas,354 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__Init_Hardware60
;supervisore_energetico.mbas,355 :: 		else
L__Init_Hardware59:
;supervisore_energetico.mbas,356 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,357 :: 		end if
L__Init_Hardware60:
;supervisore_energetico.mbas,360 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,361 :: 		reset_fatto = 0
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;supervisore_energetico.mbas,362 :: 		sveglie_wdt = 0  ' Forza lettura batteria al primo giro
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,367 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,368 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,371 :: 		main:
;supervisore_energetico.mbas,372 :: 		Init_Hardware()                ' Configura il chip
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,374 :: 		while (TRUE)
L__main63:
;supervisore_energetico.mbas,376 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main68
;supervisore_energetico.mbas,377 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,378 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main68:
;supervisore_energetico.mbas,382 :: 		if (GPIO.3 = 0) then
	BTFSC      GPIO+0, 3
	GOTO       L__main71
;supervisore_energetico.mbas,383 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,384 :: 		while (GPIO.3 = 0) and (i < 50)
L__main74:
	BTFSC      GPIO+0, 3
	GOTO       L__main204
	BSF        116, 0
	GOTO       L__main205
L__main204:
	BCF        116, 0
L__main205:
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
	GOTO       L__main75
;supervisore_energetico.mbas,385 :: 		Delay_Safe_ms(100) ' Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,386 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,387 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main79
;supervisore_energetico.mbas,388 :: 		GPIO.5 = 1     ' Accende LED dopo 1 secondo di pressione (GP5)
	BSF        GPIO+0, 5
L__main79:
;supervisore_energetico.mbas,390 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main82
;supervisore_energetico.mbas,391 :: 		GPIO.5 = 0     ' Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 5
L__main82:
;supervisore_energetico.mbas,393 :: 		wend
	GOTO       L__main74
L__main75:
;supervisore_energetico.mbas,396 :: 		if (i >= 10) and (i < 25) then
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
	GOTO       L__main85
;supervisore_energetico.mbas,397 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,398 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,401 :: 		GPIO.4 =  attivo
	BTFSC      _attivo+0, 0
	GOTO       L__main206
	BCF        GPIO+0, 4
	GOTO       L__main207
L__main206:
	BSF        GPIO+0, 4
L__main207:
;supervisore_energetico.mbas,402 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,406 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main208
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main208:
	BTFSC      STATUS+0, 0
	GOTO       L__main88
;supervisore_energetico.mbas,407 :: 		GPIO.4 = not  attivo
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main209
	BCF        GPIO+0, 4
	GOTO       L__main210
L__main209:
	BSF        GPIO+0, 4
L__main210:
;supervisore_energetico.mbas,408 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main89
;supervisore_energetico.mbas,409 :: 		else
L__main88:
;supervisore_energetico.mbas,410 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,411 :: 		end if
L__main89:
;supervisore_energetico.mbas,412 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,413 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,414 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,415 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main85:
;supervisore_energetico.mbas,421 :: 		if (i >= 25) and (i < 50) then
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
;supervisore_energetico.mbas,422 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,423 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,424 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,427 :: 		val_da_lampeggiare = word(batteria_mv)
	MOVF       _batteria_mv+0, 0
	MOVWF      _val_da_lampeggiare+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _val_da_lampeggiare+1
;supervisore_energetico.mbas,429 :: 		Estrai_e_Lampeggia(1000) ' Migliaia
	MOVLW      232
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	MOVLW      3
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,430 :: 		Estrai_e_Lampeggia(100)  ' Centinaia
	MOVLW      100
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,431 :: 		Estrai_e_Lampeggia(10)   ' Decine
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,432 :: 		Lampeggia_Cifra(0)       ' Unità fisse
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,435 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__main94
;supervisore_energetico.mbas,436 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,437 :: 		lampi (2,100)
	MOVLW      2
	MOVWF      FARG_Lampi_n+0
	MOVLW      100
	MOVWF      FARG_Lampi_t_on+0
	CLRF       FARG_Lampi_t_on+1
	CALL       _Lampi+0
;supervisore_energetico.mbas,438 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,439 :: 		gpio.5=1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,440 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,441 :: 		gpio.5=0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,442 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,444 :: 		val_da_lampeggiare = word(ore)
	MOVF       _ore+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,445 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,446 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare)) ' Il resto sono le unità
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,448 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,451 :: 		val_da_lampeggiare = word(minuti)
	MOVF       _minuti+0, 0
	MOVWF      _val_da_lampeggiare+0
	CLRF       _val_da_lampeggiare+1
;supervisore_energetico.mbas,452 :: 		Estrai_e_Lampeggia(10)
	MOVLW      10
	MOVWF      FARG_Estrai_e_Lampeggia_divisore+0
	CLRF       FARG_Estrai_e_Lampeggia_divisore+1
	CALL       _Estrai_e_Lampeggia+0
;supervisore_energetico.mbas,453 :: 		Lampeggia_Cifra(byte(val_da_lampeggiare))
	MOVF       _val_da_lampeggiare+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
L__main94:
;supervisore_energetico.mbas,454 :: 		end if
L__main91:
;supervisore_energetico.mbas,459 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main97
;supervisore_energetico.mbas,460 :: 		GPIO.4 = attivo                       ' Distacca il carico (Heltec OFF) su GP4
	BTFSC      _attivo+0, 0
	GOTO       L__main211
	BCF        GPIO+0, 4
	GOTO       L__main212
L__main211:
	BSF        GPIO+0, 4
L__main212:
;supervisore_energetico.mbas,462 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main100:
;supervisore_energetico.mbas,463 :: 		GPIO.5 = not GPIO.5         ' Lampeggio veloce di conferma
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,464 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,465 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main103
	INCF       _j+0, 1
	GOTO       L__main100
L__main103:
;supervisore_energetico.mbas,466 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,467 :: 		in_manutenzione = true          ' Entra nel loop di blocco
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,468 :: 		while (in_manutenzione = true)
L__main105:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main106
;supervisore_energetico.mbas,470 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,471 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,472 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,473 :: 		if (GPIO.3 = 0) then        ' Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L__main110
;supervisore_energetico.mbas,474 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,475 :: 		while (GPIO.3 = 0) and (i < 50)
L__main113:
	BTFSC      GPIO+0, 3
	GOTO       L__main213
	BSF        116, 0
	GOTO       L__main214
L__main213:
	BCF        116, 0
L__main214:
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
;supervisore_energetico.mbas,476 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,477 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,478 :: 		wend
	GOTO       L__main113
L__main114:
;supervisore_energetico.mbas,479 :: 		if (i >= 50) then       ' Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main118
;supervisore_energetico.mbas,480 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,482 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main121:
;supervisore_energetico.mbas,483 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,484 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,485 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main124
	INCF       _j+0, 1
	GOTO       L__main121
L__main124:
;supervisore_energetico.mbas,486 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main118:
;supervisore_energetico.mbas,487 :: 		end if
	GOTO       L__main111
;supervisore_energetico.mbas,488 :: 		else
L__main110:
;supervisore_energetico.mbas,491 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,492 :: 		end if
L__main111:
;supervisore_energetico.mbas,493 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,494 :: 		wend
	GOTO       L__main105
L__main106:
;supervisore_energetico.mbas,496 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,497 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main215:
	BTFSC      STATUS+0, 0
	GOTO       L__main126
;supervisore_energetico.mbas,498 :: 		GPIO.4 = not attivo ' Carico ON
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main216
	BCF        GPIO+0, 4
	GOTO       L__main217
L__main216:
	BSF        GPIO+0, 4
L__main217:
;supervisore_energetico.mbas,499 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main127
;supervisore_energetico.mbas,500 :: 		else
L__main126:
;supervisore_energetico.mbas,501 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,502 :: 		end if
L__main127:
;supervisore_energetico.mbas,503 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,504 :: 		sveglie_wdt = 13 ' Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,505 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,506 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,507 :: 		clrwdt
	CLRWDT
L__main97:
;supervisore_energetico.mbas,508 :: 		end if
L__main71:
;supervisore_energetico.mbas,512 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
;supervisore_energetico.mbas,514 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main218
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main218:
	BTFSS      STATUS+0, 0
	GOTO       L__main132
;supervisore_energetico.mbas,515 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,517 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main219
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main219:
	BTFSS      STATUS+0, 0
	GOTO       L__main135
;supervisore_energetico.mbas,518 :: 		GPIO.4 =  attivo ' Spegne Heltec su GP4
	BTFSC      _attivo+0, 0
	GOTO       L__main220
	BCF        GPIO+0, 4
	GOTO       L__main221
L__main220:
	BSF        GPIO+0, 4
L__main221:
;supervisore_energetico.mbas,519 :: 		spento=1
	BSF        _spento+0, BitPos(_spento+0)
L__main135:
;supervisore_energetico.mbas,522 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main222
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main222:
	BTFSS      STATUS+0, 0
	GOTO       L__main138
;supervisore_energetico.mbas,523 :: 		GPIO.4 = not  attivo ' Accende Heltec
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main223
	BCF        GPIO+0, 4
	GOTO       L__main224
L__main223:
	BSF        GPIO+0, 4
L__main224:
;supervisore_energetico.mbas,524 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
L__main138:
;supervisore_energetico.mbas,527 :: 		sveglie_wdt = 0 ' Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,529 :: 		if (RTC_presente = 1) then
	BTFSS      _RTC_presente+0, BitPos(_RTC_presente+0)
	GOTO       L__main141
;supervisore_energetico.mbas,530 :: 		giorni_riavvio=0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,531 :: 		minuti_count = minuti_count + 1
	INCF       _minuti_count+0, 1
	GOTO       L__main142
;supervisore_energetico.mbas,532 :: 		else
L__main141:
;supervisore_energetico.mbas,533 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,534 :: 		finestra_oraria=0
	BCF        _finestra_oraria+0, BitPos(_finestra_oraria+0)
;supervisore_energetico.mbas,535 :: 		end if
L__main142:
;supervisore_energetico.mbas,538 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main144
;supervisore_energetico.mbas,539 :: 		conteggio_cicli = conteggio_cicli + 1
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
;supervisore_energetico.mbas,541 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) then
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
	GOTO       L__main225
	MOVLW      0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main225
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main225
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main225:
	BTFSS      STATUS+0, 0
	GOTO       L__main147
;supervisore_energetico.mbas,542 :: 		GPIO.4 = attivo           ' Ciclo di spegnimento GP4
	BTFSC      _attivo+0, 0
	GOTO       L__main226
	BCF        GPIO+0, 4
	GOTO       L__main227
L__main226:
	BSF        GPIO+0, 4
L__main227:
;supervisore_energetico.mbas,543 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,544 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main228
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main228:
	BTFSC      STATUS+0, 0
	GOTO       L__main150
;supervisore_energetico.mbas,545 :: 		GPIO.4 = not attivo       ' Riaccensione
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main229
	BCF        GPIO+0, 4
	GOTO       L__main230
L__main229:
	BSF        GPIO+0, 4
L__main230:
;supervisore_energetico.mbas,546 :: 		spento = 0
	BCF        _spento+0, BitPos(_spento+0)
	GOTO       L__main151
;supervisore_energetico.mbas,547 :: 		else
L__main150:
;supervisore_energetico.mbas,548 :: 		spento = 1
	BSF        _spento+0, BitPos(_spento+0)
;supervisore_energetico.mbas,549 :: 		end if
L__main151:
;supervisore_energetico.mbas,550 :: 		conteggio_cicli = 0  ' Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main147:
;supervisore_energetico.mbas,551 :: 		end if
L__main144:
;supervisore_energetico.mbas,555 :: 		if (minuti_count >= 20) then
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main153
;supervisore_energetico.mbas,557 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,560 :: 		if finestra_oraria = 0 then
	BTFSC      _finestra_oraria+0, BitPos(_finestra_oraria+0)
	GOTO       L__main156
;supervisore_energetico.mbas,562 :: 		if (ore = 4)  then
	MOVF       _ore+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L__main159
;supervisore_energetico.mbas,563 :: 		if (reset_fatto = 0) then
	BTFSC      _reset_fatto+0, BitPos(_reset_fatto+0)
	GOTO       L__main162
;supervisore_energetico.mbas,564 :: 		if (giorno = 1) or (giorno = 4) then
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
	GOTO       L__main165
;supervisore_energetico.mbas,565 :: 		GPIO.4 = attivo
	BTFSC      _attivo+0, 0
	GOTO       L__main231
	BCF        GPIO+0, 4
	GOTO       L__main232
L__main231:
	BSF        GPIO+0, 4
L__main232:
;supervisore_energetico.mbas,566 :: 		Delay_Safe_ms(10000)
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,567 :: 		if ((batteria_mv > soglia_off) and (spento = 0)) then GPIO.4 = not attivo end if
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main233
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main233:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L__main234
	BSF        3, 0
	GOTO       L__main235
L__main234:
	BCF        3, 0
L__main235:
	CLRF       R0+0
	BTFSC      3, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main168
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main236
	BCF        GPIO+0, 4
	GOTO       L__main237
L__main236:
	BSF        GPIO+0, 4
L__main237:
L__main168:
;supervisore_energetico.mbas,568 :: 		reset_fatto = 1
	BSF        _reset_fatto+0, BitPos(_reset_fatto+0)
L__main165:
;supervisore_energetico.mbas,569 :: 		end if
L__main162:
;supervisore_energetico.mbas,570 :: 		end if
	GOTO       L__main160
;supervisore_energetico.mbas,571 :: 		else
L__main159:
;supervisore_energetico.mbas,572 :: 		reset_fatto = 0
	BCF        _reset_fatto+0, BitPos(_reset_fatto+0)
;supervisore_energetico.mbas,573 :: 		end if
L__main160:
	GOTO       L__main157
;supervisore_energetico.mbas,575 :: 		else
L__main156:
;supervisore_energetico.mbas,578 :: 		if (ore >= 7) and (ore < 13) then 'dalle 7 alle 13 accendiamo
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
	GOTO       L__main171
;supervisore_energetico.mbas,580 :: 		if (giorno = 1) or (giorno = 2) or (giorno = 3) or (giorno = 4) or (giorno = 5) or (giorno = 6) or (giorno = 7)   then
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
	GOTO       L__main174
;supervisore_energetico.mbas,581 :: 		if ((batteria_mv > soglia_off)  and (spento=0))  then
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main238
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main238:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	BTFSC      _spento+0, BitPos(_spento+0)
	GOTO       L__main239
	BSF        3, 0
	GOTO       L__main240
L__main239:
	BCF        3, 0
L__main240:
	CLRF       R0+0
	BTFSC      3, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main177
;supervisore_energetico.mbas,583 :: 		GPIO.4 = not attivo
	COMF       _attivo+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__main241
	BCF        GPIO+0, 4
	GOTO       L__main242
L__main241:
	BSF        GPIO+0, 4
L__main242:
	GOTO       L__main178
;supervisore_energetico.mbas,584 :: 		else
L__main177:
;supervisore_energetico.mbas,585 :: 		GPIO.4 = attivo
	BTFSC      _attivo+0, 0
	GOTO       L__main243
	BCF        GPIO+0, 4
	GOTO       L__main244
L__main243:
	BSF        GPIO+0, 4
L__main244:
;supervisore_energetico.mbas,586 :: 		end if
L__main178:
L__main174:
;supervisore_energetico.mbas,587 :: 		end if
	GOTO       L__main172
;supervisore_energetico.mbas,588 :: 		else
L__main171:
;supervisore_energetico.mbas,590 :: 		GPIO.4 = attivo
	BTFSC      _attivo+0, 0
	GOTO       L__main245
	BCF        GPIO+0, 4
	GOTO       L__main246
L__main245:
	BSF        GPIO+0, 4
L__main246:
;supervisore_energetico.mbas,591 :: 		end if
L__main172:
;supervisore_energetico.mbas,592 :: 		end if
L__main157:
;supervisore_energetico.mbas,593 :: 		minuti_count = 0
	CLRF       _minuti_count+0
L__main153:
;supervisore_energetico.mbas,594 :: 		end if
L__main132:
;supervisore_energetico.mbas,599 :: 		sveglie_wdt = sveglie_wdt + 1    ' Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,600 :: 		clrwdt                            ' Pulizia watchdog
	CLRWDT
;supervisore_energetico.mbas,601 :: 		sleep                             ' Il chip dorme (Risparmio Max)
	SLEEP
;supervisore_energetico.mbas,602 :: 		nop                               ' Istruzione necessaria dopo lo sleep
	NOP
	GOTO       L__main130
;supervisore_energetico.mbas,604 :: 		else
L__main129:
;supervisore_energetico.mbas,606 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,607 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,608 :: 		end if
L__main130:
;supervisore_energetico.mbas,609 :: 		wend
	GOTO       L__main63
L_end_main:
	GOTO       $+0
; end of _main
