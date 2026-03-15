
_Init_Hardware:

;supervisore_energetico.mbas,7 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,8 :: 		OSCCON = %01100000    ' 4MHz
	MOVLW      96
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,9 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,10 :: 		ANSEL  = %00000010    ' RA1 Analogico
	MOVLW      2
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,11 :: 		TRISIO = %00001011    ' RA0, RA1, RA3 In | RA2, RA5 Out
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,12 :: 		OPTION_REG.7 = 0
	BCF        OPTION_REG+0, 7
;supervisore_energetico.mbas,13 :: 		WPU.0 = 1             ' Pull-up Pin 7
	BSF        WPU+0, 0
;supervisore_energetico.mbas,15 :: 		GPIO.2 = 1            ' Heltec SPENTO al boot
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,17 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Init_Hardware2:
;supervisore_energetico.mbas,18 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,19 :: 		delay_ms(150)
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L__Init_Hardware6:
	DECFSZ     R13+0, 1
	GOTO       L__Init_Hardware6
	DECFSZ     R12+0, 1
	GOTO       L__Init_Hardware6
;supervisore_energetico.mbas,20 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,21 :: 		delay_ms(150)
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L__Init_Hardware7:
	DECFSZ     R13+0, 1
	GOTO       L__Init_Hardware7
	DECFSZ     R12+0, 1
	GOTO       L__Init_Hardware7
;supervisore_energetico.mbas,22 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Init_Hardware5
	INCF       _i+0, 1
	GOTO       L__Init_Hardware2
L__Init_Hardware5:
;supervisore_energetico.mbas,23 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,25 :: 		main:
;supervisore_energetico.mbas,26 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,27 :: 		secondi_contatore = 300
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
;supervisore_energetico.mbas,29 :: 		while (TRUE)
L__main10:
;supervisore_energetico.mbas,32 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main15
;supervisore_energetico.mbas,33 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,34 :: 		while (GPIO.0 = 0) and (i < 10)
L__main18:
	BTFSC      GPIO+0, 0
	GOTO       L__main46
	BSF        115, 0
	GOTO       L__main47
L__main46:
	BCF        115, 0
L__main47:
	MOVLW      10
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
	GOTO       L__main19
;supervisore_energetico.mbas,35 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main22:
	DECFSZ     R13+0, 1
	GOTO       L__main22
	DECFSZ     R12+0, 1
	GOTO       L__main22
	NOP
	NOP
;supervisore_energetico.mbas,36 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,37 :: 		wend
	GOTO       L__main18
L__main19:
;supervisore_energetico.mbas,39 :: 		if (i >= 10) then
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main24
;supervisore_energetico.mbas,41 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,45 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,46 :: 		delay_ms(20) ' Ritardo obbligatorio per scrittura EEPROM
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__main26:
	DECFSZ     R13+0, 1
	GOTO       L__main26
	DECFSZ     R12+0, 1
	GOTO       L__main26
	NOP
;supervisore_energetico.mbas,47 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,48 :: 		delay_ms(20)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L__main27:
	DECFSZ     R13+0, 1
	GOTO       L__main27
	DECFSZ     R12+0, 1
	GOTO       L__main27
	NOP
;supervisore_energetico.mbas,51 :: 		GPIO.2 = 1 ' Spegne Heltec
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,52 :: 		GPIO.5 = 1 ' Accende LED fisso (Conferma salvataggio e spegnimento)
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,54 :: 		while (GPIO.0 = 0)
L__main29:
	BTFSC      GPIO+0, 0
	GOTO       L__main30
;supervisore_energetico.mbas,55 :: 		delay_ms(10)
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L__main33:
	DECFSZ     R13+0, 1
	GOTO       L__main33
	DECFSZ     R12+0, 1
	GOTO       L__main33
	NOP
	NOP
;supervisore_energetico.mbas,56 :: 		wend
	GOTO       L__main29
L__main30:
;supervisore_energetico.mbas,58 :: 		GPIO.5 = 0 ' Spegne LED al rilascio
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,59 :: 		secondi_contatore = 300 ' Forza rilettura al rilascio
	MOVLW      44
	MOVWF      _secondi_contatore+0
	MOVLW      1
	MOVWF      _secondi_contatore+1
L__main24:
;supervisore_energetico.mbas,60 :: 		end if
L__main15:
;supervisore_energetico.mbas,64 :: 		secondi_contatore = secondi_contatore + 1
	INCF       _secondi_contatore+0, 1
	BTFSC      STATUS+0, 2
	INCF       _secondi_contatore+1, 1
;supervisore_energetico.mbas,65 :: 		if (secondi_contatore >= 300) then
	MOVLW      1
	SUBWF      _secondi_contatore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVLW      44
	SUBWF      _secondi_contatore+0, 0
L__main48:
	BTFSS      STATUS+0, 0
	GOTO       L__main35
;supervisore_energetico.mbas,66 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,68 :: 		if (valore_adc < 582) then
	MOVLW      2
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVLW      70
	SUBWF      R0+0, 0
L__main49:
	BTFSC      STATUS+0, 0
	GOTO       L__main38
;supervisore_energetico.mbas,69 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
L__main38:
;supervisore_energetico.mbas,72 :: 		if (valore_adc > 651) then
	MOVF       _valore_adc+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVF       _valore_adc+0, 0
	SUBLW      139
L__main50:
	BTFSC      STATUS+0, 0
	GOTO       L__main41
;supervisore_energetico.mbas,73 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main41:
;supervisore_energetico.mbas,76 :: 		secondi_contatore = 0
	CLRF       _secondi_contatore+0
	CLRF       _secondi_contatore+1
L__main35:
;supervisore_energetico.mbas,79 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main43:
	DECFSZ     R13+0, 1
	GOTO       L__main43
	DECFSZ     R12+0, 1
	GOTO       L__main43
	NOP
	NOP
;supervisore_energetico.mbas,80 :: 		wend
	GOTO       L__main10
L_end_main:
	GOTO       $+0
; end of _main
