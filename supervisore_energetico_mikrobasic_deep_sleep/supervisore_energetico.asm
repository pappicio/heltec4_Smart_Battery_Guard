
_Delay_Safe_ms:

;supervisore_energetico.mbas,12 :: 		dim k as word
;supervisore_energetico.mbas,13 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms83
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms83:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,14 :: 		delay_ms(1)
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
;supervisore_energetico.mbas,15 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,16 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms84
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms84:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,17 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Avvio:

;supervisore_energetico.mbas,19 :: 		sub procedure Segnale_Avvio()
;supervisore_energetico.mbas,20 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Segnale_Avvio9:
;supervisore_energetico.mbas,21 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,22 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,23 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,24 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,25 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Avvio12
	INCF       _i+0, 1
	GOTO       L__Segnale_Avvio9
L__Segnale_Avvio12:
;supervisore_energetico.mbas,26 :: 		end sub
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Salva_EEPROM:

;supervisore_energetico.mbas,28 :: 		sub procedure Salva_EEPROM()
;supervisore_energetico.mbas,29 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,31 :: 		batteria_mv = (LongWord(valore_adc) * 5080) >> 10
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      216
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
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
L__Salva_EEPROM87:
	BTFSC      STATUS+0, 2
	GOTO       L__Salva_EEPROM88
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Salva_EEPROM87
L__Salva_EEPROM88:
;supervisore_energetico.mbas,33 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,34 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,35 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,36 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,37 :: 		EEPROM_Write(2, 0xFF)
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,38 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,39 :: 		EEPROM_Write(3, Highest(batteria_mv))
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+3, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,40 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,41 :: 		EEPROM_Write(4, Higher(batteria_mv))
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+2, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,42 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,43 :: 		EEPROM_Write(5, Hi(batteria_mv))
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,44 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,45 :: 		EEPROM_Write(6, Lo(batteria_mv))
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,46 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,47 :: 		end sub
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;supervisore_energetico.mbas,49 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,50 :: 		OSCCON = %01100111    ' 4MHz internal
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,51 :: 		CMCON0 = 7            ' Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,52 :: 		ANSEL  = %00010010    ' RA1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,53 :: 		TRISIO = %00001011    ' RA0, RA1, RA3 Input | RA2, RA5 Output
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,59 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,60 :: 		WPU = %00000001       ' Pull-up attivo su GP0 (Pin 7)
	MOVLW      1
	MOVWF      WPU+0
;supervisore_energetico.mbas,63 :: 		INTCON.GPIE = 1       ' Abilita interrupt su cambio stato GPIO
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,64 :: 		IOC.0 = 1             ' Sveglia il PIC se GP0 cambia (pressione tasto)
	BSF        IOC+0, 0
;supervisore_energetico.mbas,66 :: 		GPIO.2 = 1            ' Heltec SPENTO al boot
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,67 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,68 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,69 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,70 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,72 :: 		main:
;supervisore_energetico.mbas,73 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,74 :: 		sveglie_wdt = 15 ' Forza lettura immediata
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,76 :: 		while (TRUE)
L__main17:
;supervisore_energetico.mbas,78 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main22
;supervisore_energetico.mbas,79 :: 		dummy = GPIO      ' Lettura necessaria per resettare il mismatch hardware
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,80 :: 		INTCON.GPIF = 0   ' Resetta il flag di interrupt
	BCF        INTCON+0, 0
L__main22:
;supervisore_energetico.mbas,84 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main25
;supervisore_energetico.mbas,85 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,86 :: 		while (GPIO.0 = 0) and (i < 50)
L__main28:
	BTFSC      GPIO+0, 0
	GOTO       L__main91
	BSF        121, 0
	GOTO       L__main92
L__main91:
	BCF        121, 0
L__main92:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      121, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main29
;supervisore_energetico.mbas,87 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,88 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,89 :: 		if (i >= 10) then GPIO.5 = 1 end if
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main33
	BSF        GPIO+0, 5
L__main33:
;supervisore_energetico.mbas,90 :: 		wend
	GOTO       L__main28
L__main29:
;supervisore_energetico.mbas,92 :: 		if (i >= 10) and (i < 50) then
	MOVLW      10
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
	GOTO       L__main36
;supervisore_energetico.mbas,93 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,94 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,95 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,96 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,97 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,98 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main36:
;supervisore_energetico.mbas,101 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main39
;supervisore_energetico.mbas,102 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,103 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,104 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main42:
;supervisore_energetico.mbas,105 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,106 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,107 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main45
	INCF       _i+0, 1
	GOTO       L__main42
L__main45:
;supervisore_energetico.mbas,108 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,109 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,111 :: 		while (in_manutenzione = true)
L__main47:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main48
;supervisore_energetico.mbas,112 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,113 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,114 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,115 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main52
;supervisore_energetico.mbas,116 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,117 :: 		while (GPIO.0 = 0) and (i < 50)
L__main55:
	BTFSC      GPIO+0, 0
	GOTO       L__main93
	BSF        121, 0
	GOTO       L__main94
L__main93:
	BCF        121, 0
L__main94:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      121, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main56
;supervisore_energetico.mbas,118 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,119 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,120 :: 		wend
	GOTO       L__main55
L__main56:
;supervisore_energetico.mbas,121 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main60
;supervisore_energetico.mbas,122 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,123 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,124 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main63:
;supervisore_energetico.mbas,125 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,126 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,127 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main66
	INCF       _i+0, 1
	GOTO       L__main63
L__main66:
;supervisore_energetico.mbas,128 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main60:
;supervisore_energetico.mbas,129 :: 		end if
	GOTO       L__main53
;supervisore_energetico.mbas,130 :: 		else
L__main52:
;supervisore_energetico.mbas,131 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,132 :: 		end if
L__main53:
;supervisore_energetico.mbas,133 :: 		wend
	GOTO       L__main47
L__main48:
;supervisore_energetico.mbas,134 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,135 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,136 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main39:
;supervisore_energetico.mbas,137 :: 		end if
L__main25:
;supervisore_energetico.mbas,141 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
;supervisore_energetico.mbas,142 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main95
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main95:
	BTFSS      STATUS+0, 0
	GOTO       L__main71
;supervisore_energetico.mbas,143 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,144 :: 		Delay_Safe_ms(5)
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,145 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,154 :: 		batteria_mv = (LongWord(valore_adc) * 5010) >> 10
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      146
	MOVWF      R4+0
	MOVLW      19
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
L__main96:
	BTFSC      STATUS+0, 2
	GOTO       L__main97
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__main96
L__main97:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
	MOVF       R4+2, 0
	MOVWF      _batteria_mv+2
	MOVF       R4+3, 0
	MOVWF      _batteria_mv+3
;supervisore_energetico.mbas,157 :: 		if (batteria_mv <= 3340) then
	MOVF       R4+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       R4+1, 0
	SUBLW      13
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       R4+0, 0
	SUBLW      12
L__main98:
	BTFSS      STATUS+0, 0
	GOTO       L__main74
;supervisore_energetico.mbas,158 :: 		GPIO.2 = 1  ' SPEGNI Heltec
	BSF        GPIO+0, 2
L__main74:
;supervisore_energetico.mbas,161 :: 		if (batteria_mv >= 3700) then
	MOVLW      0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVLW      0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVLW      14
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVLW      116
	SUBWF      _batteria_mv+0, 0
L__main99:
	BTFSS      STATUS+0, 0
	GOTO       L__main77
;supervisore_energetico.mbas,162 :: 		GPIO.2 = 0  ' ACCENDI Heltec
	BCF        GPIO+0, 2
L__main77:
;supervisore_energetico.mbas,165 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main71:
;supervisore_energetico.mbas,166 :: 		end if
L__main68:
;supervisore_energetico.mbas,170 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
;supervisore_energetico.mbas,171 :: 		sveglie_wdt = sveglie_wdt + 1
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,172 :: 		clrwdt   ' Pulisce il Watchdog
	CLRWDT
;supervisore_energetico.mbas,173 :: 		sleep    ' Spegne il core. Si sveglia col Tasto o dopo ~2.3s
	SLEEP
;supervisore_energetico.mbas,174 :: 		nop      ' Sicurezza post-risveglio
	NOP
	GOTO       L__main81
;supervisore_energetico.mbas,175 :: 		else
L__main80:
;supervisore_energetico.mbas,176 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,177 :: 		end if
L__main81:
;supervisore_energetico.mbas,178 :: 		wend
	GOTO       L__main17
L_end_main:
	GOTO       $+0
; end of _main
