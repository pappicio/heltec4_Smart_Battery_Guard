
_Delay_Safe_ms:

;supervisore_energetico.mbas,16 :: 		dim k as word
;supervisore_energetico.mbas,17 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms110
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms110:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,18 :: 		delay_ms(1)
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
;supervisore_energetico.mbas,19 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,20 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms111
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms111:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,21 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Avvio:

;supervisore_energetico.mbas,25 :: 		sub procedure Segnale_Avvio()
;supervisore_energetico.mbas,26 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Segnale_Avvio9:
;supervisore_energetico.mbas,27 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,28 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,29 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,30 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,31 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Avvio12
	INCF       _i+0, 1
	GOTO       L__Segnale_Avvio9
L__Segnale_Avvio12:
;supervisore_energetico.mbas,32 :: 		end sub
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,36 :: 		sub procedure Leggi_Batteria_mV()
;supervisore_energetico.mbas,37 :: 		valore_adc = ADC_Read(1)      ' Prima lettura (scarto per stabilizzare l'ADC)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,38 :: 		Delay_Safe_ms(5)
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,39 :: 		valore_adc = ADC_Read(1)      ' Seconda lettura reale
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,42 :: 		batteria_mv = (LongWord(valore_adc) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV114:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV115
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV114
L__Leggi_Batteria_mV115:
;supervisore_energetico.mbas,43 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Init_Hardware:

;supervisore_energetico.mbas,44 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,45 :: 		OSCCON = %01100111    ' 4MHz interno
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,46 :: 		CMCON0 = 7            ' Comparatori OFF
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,47 :: 		ANSEL  = %00010010    ' RA1 Analogico
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,50 :: 		acceso = 0
	CLRF       _acceso+0
;supervisore_energetico.mbas,51 :: 		spento = 1
	MOVLW      1
	MOVWF      _spento+0
;supervisore_energetico.mbas,53 :: 		GPIO.2 = acceso
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,57 :: 		TRISIO = %00001011    ' RA0, RA1, RA3 Input | RA2, RA5 Output
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,59 :: 		OPTION_REG = %00001111 ' WDT 1:128 (~2.3s)
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,60 :: 		WPU = %00000001        ' Pull-up su GP0
	MOVLW      1
	MOVWF      WPU+0
;supervisore_energetico.mbas,62 :: 		INTCON.GPIE = 1        ' Abilita interrupt GPIO
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,63 :: 		IOC.0 = 1              ' Sveglia su GP0
	BSF        IOC+0, 0
;supervisore_energetico.mbas,67 :: 		soglia_off   = 3330   '''03340 è il 10% Batteria stiamo sotto cosi sotto i 10% si spegne!!!!!
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,68 :: 		soglia_on    = 3700   ' 50% Batteria
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,69 :: 		taratura_vcc = 5070   '5070 = 5.07V misurati al pin1 (VCC) e pin8 (GND) del PIC MICRO
	MOVLW      206
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,71 :: 		GPIO.2 = spento
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,74 :: 		Leggi_Batteria_mV()   ' Leggiamo subito lo stato della batteria
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,76 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware117
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware117
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware117
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware117:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware16
;supervisore_energetico.mbas,77 :: 		GPIO.2 = acceso    ' ACCENDI Heltec subito se la batteria è OK
	BTFSC      _acceso+0, 0
	GOTO       L__Init_Hardware118
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware119
L__Init_Hardware118:
	BSF        GPIO+0, 2
L__Init_Hardware119:
	GOTO       L__Init_Hardware17
;supervisore_energetico.mbas,78 :: 		else
L__Init_Hardware16:
;supervisore_energetico.mbas,79 :: 		GPIO.2 = spento    ' Resta SPENTO se troppo scarica
	BTFSC      _spento+0, 0
	GOTO       L__Init_Hardware120
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware121
L__Init_Hardware120:
	BSF        GPIO+0, 2
L__Init_Hardware121:
;supervisore_energetico.mbas,80 :: 		end if
L__Init_Hardware17:
;supervisore_energetico.mbas,82 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,83 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,84 :: 		Segnale_Avvio()       ' Il LED segnala che il PIC è partito
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,85 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_Salva_EEPROM:

;supervisore_energetico.mbas,87 :: 		sub procedure Salva_EEPROM()
;supervisore_energetico.mbas,88 :: 		Leggi_Batteria_mV() ' Aggiorna i valori prima di scrivere
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,90 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,91 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,92 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,93 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,94 :: 		EEPROM_Write(2, 0xFF)
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,95 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,96 :: 		EEPROM_Write(3, Highest(batteria_mv))
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+3, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,97 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,98 :: 		EEPROM_Write(4, Higher(batteria_mv))
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+2, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,99 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,100 :: 		EEPROM_Write(5, Hi(batteria_mv))
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,101 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,102 :: 		EEPROM_Write(6, Lo(batteria_mv))
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,103 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,104 :: 		end sub
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_main:

;supervisore_energetico.mbas,107 :: 		main:
;supervisore_energetico.mbas,108 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,109 :: 		sveglie_wdt = 15
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,111 :: 		while (TRUE)
L__main21:
;supervisore_energetico.mbas,113 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main26
;supervisore_energetico.mbas,114 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,115 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main26:
;supervisore_energetico.mbas,119 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main29
;supervisore_energetico.mbas,120 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,121 :: 		while (GPIO.0 = 0) and (i < 50)
L__main32:
	BTFSC      GPIO+0, 0
	GOTO       L__main124
	BSF        114, 0
	GOTO       L__main125
L__main124:
	BCF        114, 0
L__main125:
	MOVLW      50
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
	GOTO       L__main33
;supervisore_energetico.mbas,122 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,123 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,124 :: 		if (i >= 10) then GPIO.5 = 1 end if
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main37
	BSF        GPIO+0, 5
L__main37:
;supervisore_energetico.mbas,125 :: 		wend
	GOTO       L__main32
L__main33:
;supervisore_energetico.mbas,128 :: 		if (i >= 10) and (i < 50) then
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
	GOTO       L__main40
;supervisore_energetico.mbas,129 :: 		Salva_EEPROM() ' Aggiorna batteria_mv e valore_adc
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,132 :: 		if (batteria_mv > soglia_off) and (batteria_mv < soglia_on) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main126:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main127:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main43
;supervisore_energetico.mbas,133 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__main46:
;supervisore_energetico.mbas,134 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,135 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main50:
	DECFSZ     R13+0, 1
	GOTO       L__main50
	DECFSZ     R12+0, 1
	GOTO       L__main50
	NOP
	NOP
;supervisore_energetico.mbas,136 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,137 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main51:
	DECFSZ     R13+0, 1
	GOTO       L__main51
	DECFSZ     R12+0, 1
	GOTO       L__main51
	NOP
	NOP
;supervisore_energetico.mbas,138 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,139 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__main49
	INCF       _i+0, 1
	GOTO       L__main46
L__main49:
L__main43:
;supervisore_energetico.mbas,143 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main128:
	BTFSS      STATUS+0, 0
	GOTO       L__main53
;supervisore_energetico.mbas,144 :: 		for i = 1 to 6
	MOVLW      1
	MOVWF      _i+0
L__main56:
;supervisore_energetico.mbas,145 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,146 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main60:
	DECFSZ     R13+0, 1
	GOTO       L__main60
	DECFSZ     R12+0, 1
	GOTO       L__main60
	NOP
	NOP
;supervisore_energetico.mbas,147 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,148 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main61:
	DECFSZ     R13+0, 1
	GOTO       L__main61
	DECFSZ     R12+0, 1
	GOTO       L__main61
	NOP
	NOP
;supervisore_energetico.mbas,149 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,150 :: 		next i
	MOVF       _i+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__main59
	INCF       _i+0, 1
	GOTO       L__main56
L__main59:
L__main53:
;supervisore_energetico.mbas,154 :: 		GPIO.2 = spento      ' Spegni l'Heltec
	BTFSC      _spento+0, 0
	GOTO       L__main129
	BCF        GPIO+0, 2
	GOTO       L__main130
L__main129:
	BSF        GPIO+0, 2
L__main130:
;supervisore_energetico.mbas,155 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,156 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,159 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main131:
	BTFSC      STATUS+0, 0
	GOTO       L__main63
;supervisore_energetico.mbas,160 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__main132
	BCF        GPIO+0, 2
	GOTO       L__main133
L__main132:
	BSF        GPIO+0, 2
L__main133:
	GOTO       L__main64
;supervisore_energetico.mbas,161 :: 		else
L__main63:
;supervisore_energetico.mbas,162 :: 		GPIO.2 = spento  ' Conferma spegnimento se scarica
	BTFSC      _spento+0, 0
	GOTO       L__main134
	BCF        GPIO+0, 2
	GOTO       L__main135
L__main134:
	BSF        GPIO+0, 2
L__main135:
;supervisore_energetico.mbas,163 :: 		end if
L__main64:
;supervisore_energetico.mbas,165 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main40:
;supervisore_energetico.mbas,168 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main66
;supervisore_energetico.mbas,169 :: 		GPIO.2 = spento
	BTFSC      _spento+0, 0
	GOTO       L__main136
	BCF        GPIO+0, 2
	GOTO       L__main137
L__main136:
	BSF        GPIO+0, 2
L__main137:
;supervisore_energetico.mbas,170 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main69:
;supervisore_energetico.mbas,171 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,172 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,173 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main72
	INCF       _i+0, 1
	GOTO       L__main69
L__main72:
;supervisore_energetico.mbas,174 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,175 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,177 :: 		while (in_manutenzione = true)
L__main74:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main75
;supervisore_energetico.mbas,178 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,179 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,180 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,181 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main79
;supervisore_energetico.mbas,182 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,183 :: 		while (GPIO.0 = 0) and (i < 50)
L__main82:
	BTFSC      GPIO+0, 0
	GOTO       L__main138
	BSF        114, 0
	GOTO       L__main139
L__main138:
	BCF        114, 0
L__main139:
	MOVLW      50
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
	GOTO       L__main83
;supervisore_energetico.mbas,184 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,185 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,186 :: 		wend
	GOTO       L__main82
L__main83:
;supervisore_energetico.mbas,187 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main87
;supervisore_energetico.mbas,188 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,189 :: 		for i = 1 to 20
	MOVLW      1
	MOVWF      _i+0
L__main90:
;supervisore_energetico.mbas,190 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,191 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,192 :: 		next i
	MOVF       _i+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main93
	INCF       _i+0, 1
	GOTO       L__main90
L__main93:
;supervisore_energetico.mbas,193 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main87:
;supervisore_energetico.mbas,194 :: 		end if
	GOTO       L__main80
;supervisore_energetico.mbas,195 :: 		else
L__main79:
;supervisore_energetico.mbas,196 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,197 :: 		end if
L__main80:
;supervisore_energetico.mbas,198 :: 		wend
	GOTO       L__main74
L__main75:
;supervisore_energetico.mbas,199 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,200 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__main140
	BCF        GPIO+0, 2
	GOTO       L__main141
L__main140:
	BSF        GPIO+0, 2
L__main141:
;supervisore_energetico.mbas,201 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main66:
;supervisore_energetico.mbas,202 :: 		end if
L__main29:
;supervisore_energetico.mbas,206 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main95
;supervisore_energetico.mbas,207 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main142
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main142:
	BTFSS      STATUS+0, 0
	GOTO       L__main98
;supervisore_energetico.mbas,208 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,210 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main143:
	BTFSS      STATUS+0, 0
	GOTO       L__main101
;supervisore_energetico.mbas,211 :: 		GPIO.2 = spento  ' SPEGNI
	BTFSC      _spento+0, 0
	GOTO       L__main144
	BCF        GPIO+0, 2
	GOTO       L__main145
L__main144:
	BSF        GPIO+0, 2
L__main145:
L__main101:
;supervisore_energetico.mbas,214 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main146:
	BTFSS      STATUS+0, 0
	GOTO       L__main104
;supervisore_energetico.mbas,215 :: 		GPIO.2 = acceso  ' ACCENDI
	BTFSC      _acceso+0, 0
	GOTO       L__main147
	BCF        GPIO+0, 2
	GOTO       L__main148
L__main147:
	BSF        GPIO+0, 2
L__main148:
L__main104:
;supervisore_energetico.mbas,218 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main98:
;supervisore_energetico.mbas,219 :: 		end if
L__main95:
;supervisore_energetico.mbas,223 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main107
;supervisore_energetico.mbas,224 :: 		sveglie_wdt = sveglie_wdt + 1
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,225 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,226 :: 		sleep
	SLEEP
;supervisore_energetico.mbas,227 :: 		nop
	NOP
	GOTO       L__main108
;supervisore_energetico.mbas,228 :: 		else
L__main107:
;supervisore_energetico.mbas,229 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,230 :: 		end if
L__main108:
;supervisore_energetico.mbas,231 :: 		wend
	GOTO       L__main21
L_end_main:
	GOTO       $+0
; end of _main
