
_Segnale_Avvio:

;supervisore_energetico.mbas,8 :: 		sub procedure Segnale_Avvio()
;supervisore_energetico.mbas,9 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Segnale_Avvio2:
;supervisore_energetico.mbas,10 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,11 :: 		delay_ms(250)
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
;supervisore_energetico.mbas,12 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,13 :: 		delay_ms(250)
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
;supervisore_energetico.mbas,14 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Avvio5
	INCF       _i+0, 1
	GOTO       L__Segnale_Avvio2
L__Segnale_Avvio5:
;supervisore_energetico.mbas,15 :: 		end sub
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Salva_EEPROM:

;supervisore_energetico.mbas,17 :: 		sub procedure Salva_EEPROM()
;supervisore_energetico.mbas,18 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,19 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,20 :: 		delay_ms(20)
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
;supervisore_energetico.mbas,21 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,22 :: 		delay_ms(20)
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
;supervisore_energetico.mbas,23 :: 		end sub
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_Init_Hardware:

;supervisore_energetico.mbas,25 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,26 :: 		OSCCON = %01100000    ' 4MHz
	MOVLW      96
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,27 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,28 :: 		ANSEL  = %00000010    ' RA1 Analogico
	MOVLW      2
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,29 :: 		TRISIO = %00001011    ' RA0, RA1, RA3 In | RA2, RA5 Out
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,30 :: 		OPTION_REG.7 = 0
	BCF        OPTION_REG+0, 7
;supervisore_energetico.mbas,31 :: 		WPU.0 = 1
	BSF        WPU+0, 0
;supervisore_energetico.mbas,32 :: 		GPIO.2 = 1            ' Heltec SPENTO al boot
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,33 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,34 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,35 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,37 :: 		main:
;supervisore_energetico.mbas,38 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,39 :: 		secondi_contatore = 300
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;supervisore_energetico.mbas,41 :: 		while (TRUE)
L__main14:
;supervisore_energetico.mbas,43 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main19
;supervisore_energetico.mbas,44 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,46 :: 		while (GPIO.0 = 0) and (i < 50)
L__main22:
	BTFSC      GPIO+0, 0
	GOTO       L__main85
	BSF        115, 0
	GOTO       L__main86
L__main85:
	BCF        115, 0
L__main86:
	MOVLW      50
	SUBWF      _i+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      115, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main23
;supervisore_energetico.mbas,47 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main26:
	DECFSZ     R13+0, 1
	GOTO       L__main26
	DECFSZ     R12+0, 1
	GOTO       L__main26
	NOP
	NOP
;supervisore_energetico.mbas,48 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,49 :: 		if (i >= 10) then GPIO.5 = 1 end if ' Accende LED dopo 1 secondo
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main28
	BSF        GPIO+0, 5
L__main28:
;supervisore_energetico.mbas,50 :: 		wend
	GOTO       L__main22
L__main23:
;supervisore_energetico.mbas,54 :: 		if (i >= 10) and (i < 50) then
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
	GOTO       L__main31
;supervisore_energetico.mbas,55 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,56 :: 		GPIO.2 = 1 ' riavvia heltec
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,58 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,59 :: 		delay_ms(1000)
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L__main33:
	DECFSZ     R13+0, 1
	GOTO       L__main33
	DECFSZ     R12+0, 1
	GOTO       L__main33
	DECFSZ     R11+0, 1
	GOTO       L__main33
	NOP
	NOP
;supervisore_energetico.mbas,60 :: 		GPIO.2 = 0 ' riavvia heltec
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,62 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main31:
;supervisore_energetico.mbas,66 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main35
;supervisore_energetico.mbas,67 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,68 :: 		GPIO.2 = 1 ' Spegne Heltec per manutenzione
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,71 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main38:
;supervisore_energetico.mbas,72 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,73 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main42:
	DECFSZ     R13+0, 1
	GOTO       L__main42
	DECFSZ     R12+0, 1
	GOTO       L__main42
	NOP
	NOP
;supervisore_energetico.mbas,74 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main41
	INCF       _i+0, 1
	GOTO       L__main38
L__main41:
;supervisore_energetico.mbas,75 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,77 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,80 :: 		while (in_manutenzione = true)
L__main44:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main45
;supervisore_energetico.mbas,81 :: 		GPIO.5 = 1 ' Blink lento: 500ms ON
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,82 :: 		delay_ms(500)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L__main48:
	DECFSZ     R13+0, 1
	GOTO       L__main48
	DECFSZ     R12+0, 1
	GOTO       L__main48
	DECFSZ     R11+0, 1
	GOTO       L__main48
	NOP
	NOP
;supervisore_energetico.mbas,83 :: 		GPIO.5 = 0 ' 500ms OFF
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,86 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main50
;supervisore_energetico.mbas,87 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
;supervisore_energetico.mbas,88 :: 		while (GPIO.0 = 0) and (secondi_contatore < 50)
L__main53:
	BTFSC      GPIO+0, 0
	GOTO       L__main87
	BSF        115, 0
	GOTO       L__main88
L__main87:
	BCF        115, 0
L__main88:
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main89:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	CLRF       R0+0
	BTFSC      115, 0
	INCF       R0+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main54
;supervisore_energetico.mbas,89 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main57:
	DECFSZ     R13+0, 1
	GOTO       L__main57
	DECFSZ     R12+0, 1
	GOTO       L__main57
	NOP
	NOP
;supervisore_energetico.mbas,90 :: 		secondi_contatore = secondi_contatore + 1
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;supervisore_energetico.mbas,91 :: 		wend
	GOTO       L__main53
L__main54:
;supervisore_energetico.mbas,93 :: 		if (secondi_contatore >= 50) then
	MOVLW      0
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main90
	MOVLW      50
	SUBWF      _secondi_contatore+0, 0
L__main90:
	BTFSS      STATUS+0, 0
	GOTO       L__main59
;supervisore_energetico.mbas,94 :: 		Salva_EEPROM()    ' Salva anche all'uscita
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,95 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,97 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main62:
;supervisore_energetico.mbas,98 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,99 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main66:
	DECFSZ     R13+0, 1
	GOTO       L__main66
	DECFSZ     R12+0, 1
	GOTO       L__main66
	NOP
	NOP
;supervisore_energetico.mbas,100 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main65
	INCF       _i+0, 1
	GOTO       L__main62
L__main65:
;supervisore_energetico.mbas,101 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main59:
;supervisore_energetico.mbas,102 :: 		end if
	GOTO       L__main51
;supervisore_energetico.mbas,103 :: 		else
L__main50:
;supervisore_energetico.mbas,104 :: 		delay_ms(500) ' Se non premo, finisco il ciclo del secondo
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L__main67:
	DECFSZ     R13+0, 1
	GOTO       L__main67
	DECFSZ     R12+0, 1
	GOTO       L__main67
	DECFSZ     R11+0, 1
	GOTO       L__main67
	NOP
	NOP
;supervisore_energetico.mbas,105 :: 		end if
L__main51:
;supervisore_energetico.mbas,106 :: 		wend
	GOTO       L__main44
L__main45:
;supervisore_energetico.mbas,109 :: 		Segnale_Avvio() ' I 3 lampeggi di boot
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,110 :: 		GPIO.2 = 0      ' Riaccende Heltec
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,111 :: 		secondi_contatore = 300
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
L__main35:
;supervisore_energetico.mbas,115 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main19:
;supervisore_energetico.mbas,119 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
;supervisore_energetico.mbas,120 :: 		secondi_contatore = secondi_contatore + 1
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;supervisore_energetico.mbas,121 :: 		if (secondi_contatore >= 300) then
	MOVLW      1
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main91
	MOVLW      44
	SUBWF      _secondi_contatore+0, 0
L__main91:
	BTFSS      STATUS+0, 0
	GOTO       L__main72
;supervisore_energetico.mbas,122 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,123 :: 		if (valore_adc < 582) then GPIO.2 = 1 end if
	MOVLW      2
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main92
	MOVLW      70
	SUBWF      R0+0, 0
L__main92:
	BTFSC      STATUS+0, 0
	GOTO       L__main75
	BSF        GPIO+0, 2
L__main75:
;supervisore_energetico.mbas,124 :: 		if (valore_adc > 651) then GPIO.2 = 0 end if
	MOVF       _valore_adc+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main93
	MOVF       _valore_adc+0, 0
	SUBLW      139
L__main93:
	BTFSC      STATUS+0, 0
	GOTO       L__main78
	BCF        GPIO+0, 2
L__main78:
;supervisore_energetico.mbas,125 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main72:
;supervisore_energetico.mbas,126 :: 		end if
L__main69:
;supervisore_energetico.mbas,129 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main80:
	DECFSZ     R13+0, 1
	GOTO       L__main80
	DECFSZ     R12+0, 1
	GOTO       L__main80
	NOP
	NOP
;supervisore_energetico.mbas,130 :: 		wend
	GOTO       L__main14
L_end_main:
	GOTO       $+0
; end of _main
