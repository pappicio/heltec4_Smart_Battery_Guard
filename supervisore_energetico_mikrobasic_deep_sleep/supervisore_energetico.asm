
_Delay_Safe_ms:

;supervisore_energetico.mbas,22 :: 		dim k as word
;supervisore_energetico.mbas,23 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms97
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms97:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,24 :: 		delay_ms(1)
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
;supervisore_energetico.mbas,25 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,26 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms98
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms98:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,27 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Avvio:

;supervisore_energetico.mbas,30 :: 		sub procedure Segnale_Avvio()
;supervisore_energetico.mbas,31 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__Segnale_Avvio9:
;supervisore_energetico.mbas,32 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,33 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,34 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,35 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,36 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Avvio12
	INCF       _i+0, 1
	GOTO       L__Segnale_Avvio9
L__Segnale_Avvio12:
;supervisore_energetico.mbas,37 :: 		end sub
L_end_Segnale_Avvio:
	RETURN
; end of _Segnale_Avvio

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,40 :: 		sub procedure Leggi_Batteria_mV()
;supervisore_energetico.mbas,41 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,42 :: 		Delay_Safe_ms(5)
	MOVLW      5
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,43 :: 		valore_adc = ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valore_adc+0
	MOVF       R0+1, 0
	MOVWF      _valore_adc+1
;supervisore_energetico.mbas,44 :: 		batteria_mv = (LongWord(valore_adc) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV101:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV102
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV101
L__Leggi_Batteria_mV102:
;supervisore_energetico.mbas,45 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_Gestione_Stato_Sistema:

;supervisore_energetico.mbas,48 :: 		sub procedure Gestione_Stato_Sistema()
;supervisore_energetico.mbas,50 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,53 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema104
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema104
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema104
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Gestione_Stato_Sistema104:
	BTFSS      STATUS+0, 0
	GOTO       L__Gestione_Stato_Sistema16
;supervisore_energetico.mbas,54 :: 		GPIO.2 = spento
	BTFSC      _spento+0, 0
	GOTO       L__Gestione_Stato_Sistema105
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema106
L__Gestione_Stato_Sistema105:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema106:
L__Gestione_Stato_Sistema16:
;supervisore_energetico.mbas,57 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema107
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema107
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema107
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__Gestione_Stato_Sistema107:
	BTFSS      STATUS+0, 0
	GOTO       L__Gestione_Stato_Sistema19
;supervisore_energetico.mbas,58 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__Gestione_Stato_Sistema108
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema109
L__Gestione_Stato_Sistema108:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema109:
L__Gestione_Stato_Sistema19:
;supervisore_energetico.mbas,62 :: 		if (giorni_per_reset > 0) then
	MOVF       _giorni_per_reset+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema110
	MOVF       _giorni_per_reset+0, 0
	SUBLW      0
L__Gestione_Stato_Sistema110:
	BTFSC      STATUS+0, 0
	GOTO       L__Gestione_Stato_Sistema22
;supervisore_energetico.mbas,64 :: 		soglia_reset_giorni = LongWord(giorni_per_reset) * RISVEGLI_AL_GIORNO
	MOVF       _giorni_per_reset+0, 0
	MOVWF      R0+0
	MOVF       _giorni_per_reset+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      189
	MOVWF      R4+0
	MOVLW      146
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _soglia_reset_giorni+0
	MOVF       R0+1, 0
	MOVWF      _soglia_reset_giorni+1
	MOVF       R0+2, 0
	MOVWF      _soglia_reset_giorni+2
	MOVF       R0+3, 0
	MOVWF      _soglia_reset_giorni+3
;supervisore_energetico.mbas,66 :: 		if (conteggio_giorni >= soglia_reset_giorni) then
	MOVF       R0+3, 0
	SUBWF      _conteggio_giorni+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema111
	MOVF       R0+2, 0
	SUBWF      _conteggio_giorni+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema111
	MOVF       R0+1, 0
	SUBWF      _conteggio_giorni+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema111
	MOVF       R0+0, 0
	SUBWF      _conteggio_giorni+0, 0
L__Gestione_Stato_Sistema111:
	BTFSS      STATUS+0, 0
	GOTO       L__Gestione_Stato_Sistema25
;supervisore_energetico.mbas,68 :: 		if (GPIO.2 = acceso) then
	CLRF       R1+0
	BTFSC      GPIO+0, 2
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORWF      _acceso+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema28
;supervisore_energetico.mbas,69 :: 		GPIO.2 = spento       ' Forza OFF
	BTFSC      _spento+0, 0
	GOTO       L__Gestione_Stato_Sistema112
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema113
L__Gestione_Stato_Sistema112:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema113:
;supervisore_energetico.mbas,70 :: 		Delay_Safe_ms(10000)  ' 10 secondi scarica
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,71 :: 		GPIO.2 = acceso       ' Riavvio
	BTFSC      _acceso+0, 0
	GOTO       L__Gestione_Stato_Sistema114
	BCF        GPIO+0, 2
	GOTO       L__Gestione_Stato_Sistema115
L__Gestione_Stato_Sistema114:
	BSF        GPIO+0, 2
L__Gestione_Stato_Sistema115:
L__Gestione_Stato_Sistema28:
;supervisore_energetico.mbas,73 :: 		conteggio_giorni = 0      ' Azzera il ciclo giorni
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
L__Gestione_Stato_Sistema25:
;supervisore_energetico.mbas,74 :: 		end if
	GOTO       L__Gestione_Stato_Sistema23
;supervisore_energetico.mbas,75 :: 		else
L__Gestione_Stato_Sistema22:
;supervisore_energetico.mbas,78 :: 		if (conteggio_giorni > RISVEGLI_AL_GIORNO) then
	MOVF       _conteggio_giorni+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema116
	MOVF       _conteggio_giorni+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema116
	MOVF       _conteggio_giorni+1, 0
	SUBLW      146
	BTFSS      STATUS+0, 2
	GOTO       L__Gestione_Stato_Sistema116
	MOVF       _conteggio_giorni+0, 0
	SUBLW      189
L__Gestione_Stato_Sistema116:
	BTFSC      STATUS+0, 0
	GOTO       L__Gestione_Stato_Sistema31
;supervisore_energetico.mbas,79 :: 		conteggio_giorni = 0
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
L__Gestione_Stato_Sistema31:
;supervisore_energetico.mbas,81 :: 		end if
L__Gestione_Stato_Sistema23:
;supervisore_energetico.mbas,82 :: 		end sub
L_end_Gestione_Stato_Sistema:
	RETURN
; end of _Gestione_Stato_Sistema

_Init_Hardware:

;supervisore_energetico.mbas,84 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,85 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,86 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,87 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,89 :: 		acceso = 0
	CLRF       _acceso+0
;supervisore_energetico.mbas,90 :: 		spento = 1
	MOVLW      1
	MOVWF      _spento+0
;supervisore_energetico.mbas,94 :: 		giorni_per_reset = 7  ' IMPOSTA QUI IL VALORE DI DEFAULT cosi si riavvia ogni 7 gg, 2, ogni 2 gg ecc, 0 disabilita riavvio cadenzato!!!
	MOVLW      7
	MOVWF      _giorni_per_reset+0
	CLRF       _giorni_per_reset+1
;supervisore_energetico.mbas,95 :: 		conteggio_giorni = 0
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
;supervisore_energetico.mbas,96 :: 		soglia_off   = 3330
	MOVLW      2
	MOVWF      _soglia_off+0
	MOVLW      13
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,97 :: 		soglia_on    = 3700
	MOVLW      116
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,98 :: 		taratura_vcc = 5070
	MOVLW      206
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,101 :: 		GPIO.2 = acceso
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,102 :: 		TRISIO = %00001011
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,104 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,105 :: 		WPU = %00000001
	MOVLW      1
	MOVWF      WPU+0
;supervisore_energetico.mbas,106 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,107 :: 		IOC.0 = 1
	BSF        IOC+0, 0
;supervisore_energetico.mbas,109 :: 		GPIO.2 = spento
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,110 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,112 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware118
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware118
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware118
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware118:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware35
;supervisore_energetico.mbas,113 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__Init_Hardware119
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware120
L__Init_Hardware119:
	BSF        GPIO+0, 2
L__Init_Hardware120:
	GOTO       L__Init_Hardware36
;supervisore_energetico.mbas,114 :: 		else
L__Init_Hardware35:
;supervisore_energetico.mbas,115 :: 		GPIO.2 = spento
	BTFSC      _spento+0, 0
	GOTO       L__Init_Hardware121
	BCF        GPIO+0, 2
	GOTO       L__Init_Hardware122
L__Init_Hardware121:
	BSF        GPIO+0, 2
L__Init_Hardware122:
;supervisore_energetico.mbas,116 :: 		end if
L__Init_Hardware36:
;supervisore_energetico.mbas,118 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,119 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,120 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,121 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_Salva_EEPROM:

;supervisore_energetico.mbas,124 :: 		sub procedure Salva_EEPROM()
;supervisore_energetico.mbas,125 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,126 :: 		EEPROM_Write(0, Hi(valore_adc))
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,127 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,128 :: 		EEPROM_Write(1, Lo(valore_adc))
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _valore_adc+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,129 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,130 :: 		EEPROM_Write(2, 0xFF)
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,131 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,132 :: 		EEPROM_Write(3, Highest(batteria_mv))
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+3, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,133 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,134 :: 		EEPROM_Write(4, Higher(batteria_mv))
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+2, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,135 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,136 :: 		EEPROM_Write(5, Hi(batteria_mv))
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,137 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,138 :: 		EEPROM_Write(6, Lo(batteria_mv))
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_address+0
	MOVF       _batteria_mv+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,139 :: 		Delay_Safe_ms(20)
	MOVLW      20
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,140 :: 		end sub
L_end_Salva_EEPROM:
	RETURN
; end of _Salva_EEPROM

_main:

;supervisore_energetico.mbas,143 :: 		main:
;supervisore_energetico.mbas,144 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,145 :: 		sveglie_wdt = 15
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,147 :: 		while (TRUE)
L__main40:
;supervisore_energetico.mbas,148 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main45
;supervisore_energetico.mbas,149 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,150 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main45:
;supervisore_energetico.mbas,154 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main48
;supervisore_energetico.mbas,155 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,156 :: 		while (GPIO.0 = 0) and (i < 50)
L__main51:
	BTFSC      GPIO+0, 0
	GOTO       L__main125
	BSF        116, 0
	GOTO       L__main126
L__main125:
	BCF        116, 0
L__main126:
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
	GOTO       L__main52
;supervisore_energetico.mbas,157 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,158 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,159 :: 		if (i >= 10) then GPIO.5 = 1 end if
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main56
	BSF        GPIO+0, 5
L__main56:
;supervisore_energetico.mbas,160 :: 		wend
	GOTO       L__main51
L__main52:
;supervisore_energetico.mbas,162 :: 		if (i >= 10) and (i < 50) then
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
	GOTO       L__main59
;supervisore_energetico.mbas,163 :: 		Salva_EEPROM()
	CALL       _Salva_EEPROM+0
;supervisore_energetico.mbas,165 :: 		if (batteria_mv > soglia_off) and (batteria_mv < soglia_on) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main127:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main128:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main62
;supervisore_energetico.mbas,166 :: 		for i = 1 to 3
	MOVLW      1
	MOVWF      _i+0
L__main65:
;supervisore_energetico.mbas,167 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,168 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main69:
	DECFSZ     R13+0, 1
	GOTO       L__main69
	DECFSZ     R12+0, 1
	GOTO       L__main69
	NOP
	NOP
;supervisore_energetico.mbas,169 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,170 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main70:
	DECFSZ     R13+0, 1
	GOTO       L__main70
	DECFSZ     R12+0, 1
	GOTO       L__main70
	NOP
	NOP
;supervisore_energetico.mbas,171 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,172 :: 		next i
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__main68
	INCF       _i+0, 1
	GOTO       L__main65
L__main68:
L__main62:
;supervisore_energetico.mbas,174 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main129:
	BTFSS      STATUS+0, 0
	GOTO       L__main72
;supervisore_energetico.mbas,175 :: 		for i = 1 to 6
	MOVLW      1
	MOVWF      _i+0
L__main75:
;supervisore_energetico.mbas,176 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,177 :: 		delay_ms(100)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main79:
	DECFSZ     R13+0, 1
	GOTO       L__main79
	DECFSZ     R12+0, 1
	GOTO       L__main79
	NOP
	NOP
;supervisore_energetico.mbas,178 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,179 :: 		delay_ms(100)
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
;supervisore_energetico.mbas,180 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,181 :: 		next i
	MOVF       _i+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__main78
	INCF       _i+0, 1
	GOTO       L__main75
L__main78:
L__main72:
;supervisore_energetico.mbas,184 :: 		GPIO.2 = spento
	BTFSC      _spento+0, 0
	GOTO       L__main130
	BCF        GPIO+0, 2
	GOTO       L__main131
L__main130:
	BSF        GPIO+0, 2
L__main131:
;supervisore_energetico.mbas,185 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,186 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,188 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main132:
	BTFSC      STATUS+0, 0
	GOTO       L__main82
;supervisore_energetico.mbas,189 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__main133
	BCF        GPIO+0, 2
	GOTO       L__main134
L__main133:
	BSF        GPIO+0, 2
L__main134:
	GOTO       L__main83
;supervisore_energetico.mbas,190 :: 		else
L__main82:
;supervisore_energetico.mbas,191 :: 		GPIO.2 = spento
	BTFSC      _spento+0, 0
	GOTO       L__main135
	BCF        GPIO+0, 2
	GOTO       L__main136
L__main135:
	BSF        GPIO+0, 2
L__main136:
;supervisore_energetico.mbas,192 :: 		end if
L__main83:
;supervisore_energetico.mbas,194 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,195 :: 		conteggio_giorni = 0
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
L__main59:
;supervisore_energetico.mbas,198 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main85
;supervisore_energetico.mbas,200 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,202 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,203 :: 		Segnale_Avvio()
	CALL       _Segnale_Avvio+0
;supervisore_energetico.mbas,204 :: 		GPIO.2 = acceso
	BTFSC      _acceso+0, 0
	GOTO       L__main137
	BCF        GPIO+0, 2
	GOTO       L__main138
L__main137:
	BSF        GPIO+0, 2
L__main138:
;supervisore_energetico.mbas,205 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,206 :: 		conteggio_giorni = 0
	CLRF       _conteggio_giorni+0
	CLRF       _conteggio_giorni+1
	CLRF       _conteggio_giorni+2
	CLRF       _conteggio_giorni+3
L__main85:
;supervisore_energetico.mbas,207 :: 		end if
L__main48:
;supervisore_energetico.mbas,211 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main88
;supervisore_energetico.mbas,212 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main139
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main139:
	BTFSS      STATUS+0, 0
	GOTO       L__main91
;supervisore_energetico.mbas,214 :: 		Gestione_Stato_Sistema()
	CALL       _Gestione_Stato_Sistema+0
;supervisore_energetico.mbas,215 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main91:
;supervisore_energetico.mbas,216 :: 		end if
L__main88:
;supervisore_energetico.mbas,220 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main94
;supervisore_energetico.mbas,221 :: 		sveglie_wdt = sveglie_wdt + 1
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,222 :: 		conteggio_giorni = conteggio_giorni + 1
	MOVF       _conteggio_giorni+0, 0
	MOVWF      R0+0
	MOVF       _conteggio_giorni+1, 0
	MOVWF      R0+1
	MOVF       _conteggio_giorni+2, 0
	MOVWF      R0+2
	MOVF       _conteggio_giorni+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _conteggio_giorni+0
	MOVF       R0+1, 0
	MOVWF      _conteggio_giorni+1
	MOVF       R0+2, 0
	MOVWF      _conteggio_giorni+2
	MOVF       R0+3, 0
	MOVWF      _conteggio_giorni+3
;supervisore_energetico.mbas,223 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,224 :: 		sleep
	SLEEP
;supervisore_energetico.mbas,225 :: 		nop
	NOP
	GOTO       L__main95
;supervisore_energetico.mbas,226 :: 		else
L__main94:
;supervisore_energetico.mbas,227 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,228 :: 		end if
L__main95:
;supervisore_energetico.mbas,229 :: 		wend
	GOTO       L__main40
L_end_main:
	GOTO       $+0
; end of _main
