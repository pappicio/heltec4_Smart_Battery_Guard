
_Segnale_Avvio:

;supervisore_energetico.mbas,11 :: 		sub procedure Segnale_Avvio()
;supervisore_energetico.mbas,12 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Segnale_Avvio2:
;supervisore_energetico.mbas,13 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,14 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__Segnale_Avvio6:
	DECFSZ     R13+0, 1
	GOTO       L__Segnale_Avvio6
	DECFSZ     R12+0, 1
	GOTO       L__Segnale_Avvio6
	DECFSZ     R11+0, 1
	GOTO       L__Segnale_Avvio6
	NOP
	NOP
;supervisore_energetico.mbas,15 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,16 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__Segnale_Avvio7:
	DECFSZ     R13+0, 1
	GOTO       L__Segnale_Avvio7
	DECFSZ     R12+0, 1
	GOTO       L__Segnale_Avvio7
	DECFSZ     R11+0, 1
	GOTO       L__Segnale_Avvio7
	NOP
	NOP
;supervisore_energetico.mbas,17 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Avvio5
	INCF       _i+0, 1
	GOTO       L__Segnale_Avvio2
L__Segnale_Avvio5:
;supervisore_energetico.mbas,18 :: 		end sub
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Salva_EEPROM:

;supervisore_energetico.mbas,20 :: 		sub procedure Salva_EEPROM()
;supervisore_energetico.mbas,22 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,23 :: 		batteria_mv = (LongWord(valore_adc) * 5100) >> 10
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      236
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
L__Salva_EEPROM89:
	BTFSC      STATUS+0, 2
	GOTO       L__Salva_EEPROM90
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Salva_EEPROM89
L__Salva_EEPROM90:
;supervisore_energetico.mbas,26 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,27 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM9:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM9
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM9
	NOP
;supervisore_energetico.mbas,28 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,29 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM10:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM10
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM10
	NOP
;supervisore_energetico.mbas,32 :: 		EEPROM_Write(2, 0xFF)
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,33 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM11:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM11
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM11
	NOP
;supervisore_energetico.mbas,37 :: 		EEPROM_Write(3, Highest(batteria_mv)) ' Byte 4 (MSB)
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+3, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,38 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM12:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM12
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM12
	NOP
;supervisore_energetico.mbas,39 :: 		EEPROM_Write(4, Higher(batteria_mv))  ' Byte 3
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+2, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,40 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM13:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM13
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM13
	NOP
;supervisore_energetico.mbas,41 :: 		EEPROM_Write(5, Hi(batteria_mv))      ' Byte 2
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,42 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM14:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM14
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM14
	NOP
;supervisore_energetico.mbas,43 :: 		EEPROM_Write(6, Lo(batteria_mv))      ' Byte 1 (LSB)
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,44 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__Salva_EEPROM15:
	DECFSZ     R13+0, 1
	GOTO       L__Salva_EEPROM15
	DECFSZ     R12+0, 1
	GOTO       L__Salva_EEPROM15
	NOP
;supervisore_energetico.mbas,45 :: 		end sub
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;supervisore_energetico.mbas,47 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,48 :: 		OSCCON = %01100000    ' 4MHz internal
	MOVLW      96
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,49 :: 		CMCON0 = 7            ' Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,50 :: 		ANSEL  = %00000010    ' RA1 Analogico (ANS1)
	MOVLW      2
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,51 :: 		TRISIO = %00001011    ' RA0, RA1, RA3 Input | RA2, RA5 Output
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,52 :: 		OPTION_REG.7 = 0      ' Abilita Pull-ups
	BCF        OPTION_REG+0, 7
;supervisore_energetico.mbas,53 :: 		WPU.0 = 1             ' Pull-up su tasto RA0
	BSF        WPU+0, 0
;supervisore_energetico.mbas,54 :: 		GPIO.2 = 1            ' Heltec SPENTO al boot (Logica Inversa)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,55 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,56 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,57 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,59 :: 		main:
;supervisore_energetico.mbas,60 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,61 :: 		secondi_contatore = 300 ' Forza lettura immediata al boot
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;supervisore_energetico.mbas,63 :: 		while (TRUE)
L__main19:
;supervisore_energetico.mbas,65 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main24
;supervisore_energetico.mbas,66 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,67 :: 		while (GPIO.0 = 0) and (i < 50)
L__main27:
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
	GOTO       L__main28
;supervisore_energetico.mbas,68 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main31:
	DECFSZ     R13+0, 1
	GOTO       L__main31
	DECFSZ     R12+0, 1
	GOTO       L__main31
	NOP
	NOP
;supervisore_energetico.mbas,69 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,70 :: 		if (i >= 10) then GPIO.5 = 1 end if
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main33
	BSF        GPIO+0, 5
L__main33:
;supervisore_energetico.mbas,71 :: 		wend
	GOTO       L__main27
L__main28:
;supervisore_energetico.mbas,74 :: 		if (i >= 10) and (i < 50) then
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
;supervisore_energetico.mbas,75 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,76 :: 		GPIO.2 = 1 ' Spegne
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,77 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,78 :: 		delay_ms(1000)
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L__main38:
	DECFSZ     R13+0, 1
	GOTO       L__main38
	DECFSZ     R12+0, 1
	GOTO       L__main38
	DECFSZ     R11+0, 1
	GOTO       L__main38
	NOP
	NOP
;supervisore_energetico.mbas,79 :: 		GPIO.2 = 0 ' Riaccende
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,80 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main36:
;supervisore_energetico.mbas,84 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main40
;supervisore_energetico.mbas,85 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,86 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,87 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main43:
;supervisore_energetico.mbas,88 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,89 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main47:
	DECFSZ     R13+0, 1
	GOTO       L__main47
	DECFSZ     R12+0, 1
	GOTO       L__main47
	NOP
	NOP
;supervisore_energetico.mbas,90 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main46
	INCF       _i+0, 1
	GOTO       L__main43
L__main46:
;supervisore_energetico.mbas,91 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,92 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,94 :: 		while (in_manutenzione = true)
L__main49:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main50
;supervisore_energetico.mbas,95 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,96 :: 		delay_ms(500)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L__main53:
	DECFSZ     R13+0, 1
	GOTO       L__main53
	DECFSZ     R12+0, 1
	GOTO       L__main53
	DECFSZ     R11+0, 1
	GOTO       L__main53
	NOP
	NOP
;supervisore_energetico.mbas,97 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,98 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main55
;supervisore_energetico.mbas,99 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;supervisore_energetico.mbas,100 :: 		while (GPIO.0 = 0) and (secondi_contatore < 50)
L__main58:
	BTFSC      GPIO+0, 0
	GOTO       L__main95
	BSF        121, 0
	GOTO       L__main96
L__main95:
	BCF        121, 0
L__main96:
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main97:
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
	GOTO       L__main59
;supervisore_energetico.mbas,101 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main62:
	DECFSZ     R13+0, 1
	GOTO       L__main62
	DECFSZ     R12+0, 1
	GOTO       L__main62
	NOP
	NOP
;supervisore_energetico.mbas,102 :: 		secondi_contatore = secondi_contatore + 1
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;supervisore_energetico.mbas,103 :: 		wend
	GOTO       L__main58
L__main59:
;supervisore_energetico.mbas,104 :: 		if (secondi_contatore >= 50) then
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main98:
	BTFSS      STATUS+0, 0
	GOTO       L__main64
;supervisore_energetico.mbas,105 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,106 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,107 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main67:
;supervisore_energetico.mbas,108 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,109 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main71:
	DECFSZ     R13+0, 1
	GOTO       L__main71
	DECFSZ     R12+0, 1
	GOTO       L__main71
	NOP
	NOP
;supervisore_energetico.mbas,110 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main70
	INCF       _i+0, 1
	GOTO       L__main67
L__main70:
;supervisore_energetico.mbas,111 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main64:
;supervisore_energetico.mbas,112 :: 		end if
	GOTO       L__main56
;supervisore_energetico.mbas,113 :: 		else
L__main55:
;supervisore_energetico.mbas,114 :: 		delay_ms(500)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L__main72:
	DECFSZ     R13+0, 1
	GOTO       L__main72
	DECFSZ     R12+0, 1
	GOTO       L__main72
	DECFSZ     R11+0, 1
	GOTO       L__main72
	NOP
	NOP
;supervisore_energetico.mbas,115 :: 		end if
L__main56:
;supervisore_energetico.mbas,116 :: 		wend
	GOTO       L__main49
L__main50:
;supervisore_energetico.mbas,117 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,118 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,119 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main40:
;supervisore_energetico.mbas,121 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main24:
;supervisore_energetico.mbas,125 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
;supervisore_energetico.mbas,126 :: 		secondi_contatore = secondi_contatore + 1
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;supervisore_energetico.mbas,127 :: 		if (secondi_contatore >= 300) then
	MOVLW      1
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main99
	MOVLW      44
	SUBWF      _secondi_contatore+0, 0
L__main99:
	BTFSS      STATUS+0, 0
	GOTO       L__main77
;supervisore_energetico.mbas,129 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,130 :: 		delay_us(50)
	MOVLW      16
	MOVWF      R13+0
L__main79:
	DECFSZ     R13+0, 1
	GOTO       L__main79
	NOP
;supervisore_energetico.mbas,131 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,134 :: 		batteria_mv = (LongWord(valore_adc) * 5000) >> 10 ' Lo shift >> 10 equivale a diviso 1024, più veloce!
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      136
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
L__main100:
	BTFSC      STATUS+0, 2
	GOTO       L__main101
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	ADDLW      255
	GOTO       L__main100
L__main101:
	MOVF       R4+0, 0
	MOVWF      _batteria_mv+0
	MOVF       R4+1, 0
	MOVWF      _batteria_mv+1
	MOVF       R4+2, 0
	MOVWF      _batteria_mv+2
	MOVF       R4+3, 0
	MOVWF      _batteria_mv+3
;supervisore_energetico.mbas,140 :: 		if (batteria_mv <= 3300) then
	MOVF       R4+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       R4+1, 0
	SUBLW      12
	BTFSS      STATUS+0, 2
	GOTO       L__main102
	MOVF       R4+0, 0
	SUBLW      228
L__main102:
	BTFSS      STATUS+0, 0
	GOTO       L__main81
;supervisore_energetico.mbas,141 :: 		GPIO.2 = 1  ' SPEGNI (Logica Inversa)
	BSF        GPIO+0, 2
L__main81:
;supervisore_energetico.mbas,144 :: 		if (batteria_mv >= 3700) then
	MOVLW      0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVLW      0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVLW      14
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main103
	MOVLW      116
	SUBWF      _batteria_mv+0, 0
L__main103:
	BTFSS      STATUS+0, 0
	GOTO       L__main84
;supervisore_energetico.mbas,145 :: 		GPIO.2 = 0  ' ACCENDI
	BCF        GPIO+0, 2
L__main84:
;supervisore_energetico.mbas,148 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main77:
;supervisore_energetico.mbas,149 :: 		end if
L__main74:
;supervisore_energetico.mbas,152 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main86:
	DECFSZ     R13+0, 1
	GOTO       L__main86
	DECFSZ     R12+0, 1
	GOTO       L__main86
	NOP
	NOP
;supervisore_energetico.mbas,153 :: 		wend
	GOTO       L__main19
L_end_main:
	GOTO       $+0
; end of _main
