
_Delay_Safe_ms:

;supervisore_energetico.mbas,24 :: 		dim k as word
;supervisore_energetico.mbas,25 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms139
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms139:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,26 :: 		delay_ms(1)
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L__Delay_Safe_ms6:
	DECFSZ     R13+0, 1
	GOTO       L__Delay_Safe_ms6
	DECFSZ     R12+0, 1
	GOTO       L__Delay_Safe_ms6
;supervisore_energetico.mbas,27 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,28 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms140
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms140:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,29 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Triplo:

;supervisore_energetico.mbas,32 :: 		sub procedure Segnale_Triplo()
;supervisore_energetico.mbas,33 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__Segnale_Triplo9:
;supervisore_energetico.mbas,34 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,35 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,36 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,37 :: 		Delay_Safe_ms(250)
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,38 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Triplo12
	INCF       _j+0, 1
	GOTO       L__Segnale_Triplo9
L__Segnale_Triplo12:
;supervisore_energetico.mbas,39 :: 		end sub
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Lampeggia_Cifra:

;supervisore_energetico.mbas,43 :: 		dim l as byte
;supervisore_energetico.mbas,44 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra15
;supervisore_energetico.mbas,46 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,47 :: 		delay_ms(50)
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L__Lampeggia_Cifra17:
	DECFSZ     R13+0, 1
	GOTO       L__Lampeggia_Cifra17
	DECFSZ     R12+0, 1
	GOTO       L__Lampeggia_Cifra17
	NOP
;supervisore_energetico.mbas,48 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
	GOTO       L__Lampeggia_Cifra16
;supervisore_energetico.mbas,49 :: 		else
L__Lampeggia_Cifra15:
;supervisore_energetico.mbas,50 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra18:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra22
;supervisore_energetico.mbas,51 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,52 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__Lampeggia_Cifra23:
	DECFSZ     R13+0, 1
	GOTO       L__Lampeggia_Cifra23
	DECFSZ     R12+0, 1
	GOTO       L__Lampeggia_Cifra23
	DECFSZ     R11+0, 1
	GOTO       L__Lampeggia_Cifra23
	NOP
	NOP
;supervisore_energetico.mbas,53 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,54 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__Lampeggia_Cifra24:
	DECFSZ     R13+0, 1
	GOTO       L__Lampeggia_Cifra24
	DECFSZ     R12+0, 1
	GOTO       L__Lampeggia_Cifra24
	DECFSZ     R11+0, 1
	GOTO       L__Lampeggia_Cifra24
	NOP
	NOP
;supervisore_energetico.mbas,55 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,56 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra22
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra18
L__Lampeggia_Cifra22:
;supervisore_energetico.mbas,57 :: 		end if
L__Lampeggia_Cifra16:
;supervisore_energetico.mbas,58 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,59 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,65 :: 		dim media_pulita as word
;supervisore_energetico.mbas,67 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,70 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV27:
;supervisore_energetico.mbas,71 :: 		somma = somma + ADC_Read(1)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,72 :: 		delay_ms(1)
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L__Leggi_Batteria_mV31:
	DECFSZ     R13+0, 1
	GOTO       L__Leggi_Batteria_mV31
	DECFSZ     R12+0, 1
	GOTO       L__Leggi_Batteria_mV31
;supervisore_energetico.mbas,73 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV30
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV27
L__Leggi_Batteria_mV30:
;supervisore_energetico.mbas,77 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV144:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV145
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV144
L__Leggi_Batteria_mV145:
;supervisore_energetico.mbas,81 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV146:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV147
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV146
L__Leggi_Batteria_mV147:
;supervisore_energetico.mbas,82 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_soglia_batteria:

;supervisore_energetico.mbas,84 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,85 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria149
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria149
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria149
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria149:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria34
;supervisore_energetico.mbas,86 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,87 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,89 :: 		for j = 1 to 6
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria37:
;supervisore_energetico.mbas,90 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,91 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,92 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,93 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,94 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,95 :: 		next j
	MOVF       _j+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria40
	INCF       _j+0, 1
	GOTO       L__soglia_batteria37
L__soglia_batteria40:
	GOTO       L__soglia_batteria35
;supervisore_energetico.mbas,96 :: 		else
L__soglia_batteria34:
;supervisore_energetico.mbas,97 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria150
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria150
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria150
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria150:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria151
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria151
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria151
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria151:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria42
;supervisore_energetico.mbas,99 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,100 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria45:
;supervisore_energetico.mbas,101 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,102 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,103 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,104 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,105 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,106 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria48
	INCF       _j+0, 1
	GOTO       L__soglia_batteria45
L__soglia_batteria48:
L__soglia_batteria42:
;supervisore_energetico.mbas,108 :: 		end if
L__soglia_batteria35:
;supervisore_energetico.mbas,110 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Init_Hardware:

;supervisore_energetico.mbas,113 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,114 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,115 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,116 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,117 :: 		TRISIO = %00001011
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,118 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,119 :: 		WPU = %00000001
	MOVLW      1
	MOVWF      WPU+0
;supervisore_energetico.mbas,120 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,121 :: 		IOC.0 = 1
	BSF        IOC+0, 0
;supervisore_energetico.mbas,127 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,128 :: 		soglia_on    = 3600 '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,129 :: 		taratura_vcc = 5050 'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,130 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,136 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,137 :: 		cicli_per_giorno = 2880
	MOVLW      64
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;supervisore_energetico.mbas,139 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,140 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,141 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,142 :: 		Segnale_Triplo()
	CALL       _Segnale_Triplo+0
;supervisore_energetico.mbas,143 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,144 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,147 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware153
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware153
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware153
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware153:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware51
;supervisore_energetico.mbas,148 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__Init_Hardware51:
;supervisore_energetico.mbas,151 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,152 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,154 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,155 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,158 :: 		main:
;supervisore_energetico.mbas,159 :: 		Init_Hardware()
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,160 :: 		sveglie_wdt = 15
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,162 :: 		while (TRUE)
L__main55:
;supervisore_energetico.mbas,163 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main60
;supervisore_energetico.mbas,164 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,165 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main60:
;supervisore_energetico.mbas,168 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main63
;supervisore_energetico.mbas,169 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,170 :: 		while (GPIO.0 = 0) and (i < 50)
L__main66:
	BTFSC      GPIO+0, 0
	GOTO       L__main155
	BSF        117, 0
	GOTO       L__main156
L__main155:
	BCF        117, 0
L__main156:
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
	GOTO       L__main67
;supervisore_energetico.mbas,171 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,172 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,173 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main71
;supervisore_energetico.mbas,174 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
L__main71:
;supervisore_energetico.mbas,176 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main74
;supervisore_energetico.mbas,177 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
L__main74:
;supervisore_energetico.mbas,179 :: 		wend
	GOTO       L__main66
L__main67:
;supervisore_energetico.mbas,183 :: 		if (i >= 10) and (i < 25) then
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
	GOTO       L__main77
;supervisore_energetico.mbas,184 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,185 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,188 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main157:
	BTFSC      STATUS+0, 0
	GOTO       L__main80
;supervisore_energetico.mbas,189 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main80:
;supervisore_energetico.mbas,193 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,194 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,197 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main158
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main158
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main158
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main158:
	BTFSC      STATUS+0, 0
	GOTO       L__main83
;supervisore_energetico.mbas,198 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main83:
;supervisore_energetico.mbas,201 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,202 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main77:
;supervisore_energetico.mbas,206 :: 		if (i >= 25) and (i < 50) then
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
	GOTO       L__main86
;supervisore_energetico.mbas,207 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,208 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,210 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,212 :: 		temp_mv = batteria_mv
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;supervisore_energetico.mbas,213 :: 		cifra = temp_mv / 1000
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _batteria_mv+0, 0
	MOVWF      R0+0
	MOVF       _batteria_mv+1, 0
	MOVWF      R0+1
	MOVF       _batteria_mv+2, 0
	MOVWF      R0+2
	MOVF       _batteria_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,214 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,215 :: 		temp_mv = temp_mv mod 1000
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _temp_mv+0
	MOVF       R0+1, 0
	MOVWF      _temp_mv+1
	MOVF       R0+2, 0
	MOVWF      _temp_mv+2
	MOVF       R0+3, 0
	MOVWF      _temp_mv+3
;supervisore_energetico.mbas,217 :: 		cifra = temp_mv / 100
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,218 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,219 :: 		temp_mv = temp_mv mod 100
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _temp_mv+0
	MOVF       R0+1, 0
	MOVWF      _temp_mv+1
	MOVF       R0+2, 0
	MOVWF      _temp_mv+2
	MOVF       R0+3, 0
	MOVWF      _temp_mv+3
;supervisore_energetico.mbas,221 :: 		cifra = temp_mv / 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,222 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,224 :: 		cifra = temp_mv mod 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _temp_mv+0, 0
	MOVWF      R0+0
	MOVF       _temp_mv+1, 0
	MOVWF      R0+1
	MOVF       _temp_mv+2, 0
	MOVWF      R0+2
	MOVF       _temp_mv+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,226 :: 		cifra=0
	CLRF       _cifra+0
;supervisore_energetico.mbas,227 :: 		Lampeggia_Cifra(cifra)
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,229 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
L__main86:
;supervisore_energetico.mbas,234 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main89
;supervisore_energetico.mbas,235 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,236 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main92:
;supervisore_energetico.mbas,237 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,238 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,239 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main95
	INCF       _j+0, 1
	GOTO       L__main92
L__main95:
;supervisore_energetico.mbas,240 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,241 :: 		in_manutenzione = true
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,242 :: 		while (in_manutenzione = true)
L__main97:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main98
;supervisore_energetico.mbas,243 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,244 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,245 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,246 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main102
;supervisore_energetico.mbas,247 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,248 :: 		while (GPIO.0 = 0) and (i < 50)
L__main105:
	BTFSC      GPIO+0, 0
	GOTO       L__main159
	BSF        117, 0
	GOTO       L__main160
L__main159:
	BCF        117, 0
L__main160:
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
	GOTO       L__main106
;supervisore_energetico.mbas,249 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,250 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,251 :: 		wend
	GOTO       L__main105
L__main106:
;supervisore_energetico.mbas,252 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main110
;supervisore_energetico.mbas,253 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,254 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main113:
;supervisore_energetico.mbas,255 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,256 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,257 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main116
	INCF       _j+0, 1
	GOTO       L__main113
L__main116:
L__main110:
;supervisore_energetico.mbas,258 :: 		end if
	GOTO       L__main103
;supervisore_energetico.mbas,259 :: 		else
L__main102:
;supervisore_energetico.mbas,260 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,261 :: 		end if
L__main103:
;supervisore_energetico.mbas,262 :: 		wend
	GOTO       L__main97
L__main98:
;supervisore_energetico.mbas,263 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,264 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,265 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main89:
;supervisore_energetico.mbas,266 :: 		end if
L__main63:
;supervisore_energetico.mbas,269 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
;supervisore_energetico.mbas,270 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main161
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main161:
	BTFSS      STATUS+0, 0
	GOTO       L__main121
;supervisore_energetico.mbas,271 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,272 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main162:
	BTFSS      STATUS+0, 0
	GOTO       L__main124
;supervisore_energetico.mbas,273 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
L__main124:
;supervisore_energetico.mbas,275 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main163
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main163
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main163
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main163:
	BTFSS      STATUS+0, 0
	GOTO       L__main127
;supervisore_energetico.mbas,276 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main127:
;supervisore_energetico.mbas,279 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main130
;supervisore_energetico.mbas,280 :: 		conteggio_cicli = conteggio_cicli + 1
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
;supervisore_energetico.mbas,281 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) then
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
	GOTO       L__main164
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main164
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main164
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main164:
	BTFSS      STATUS+0, 0
	GOTO       L__main133
;supervisore_energetico.mbas,282 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,283 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,284 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main165:
	BTFSC      STATUS+0, 0
	GOTO       L__main136
;supervisore_energetico.mbas,285 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main136:
;supervisore_energetico.mbas,287 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main133:
;supervisore_energetico.mbas,288 :: 		end if
L__main130:
;supervisore_energetico.mbas,290 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main121:
;supervisore_energetico.mbas,292 :: 		sveglie_wdt = sveglie_wdt + 1
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,293 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,294 :: 		sleep
	SLEEP
;supervisore_energetico.mbas,295 :: 		nop
	NOP
	GOTO       L__main119
;supervisore_energetico.mbas,296 :: 		else
L__main118:
;supervisore_energetico.mbas,297 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,298 :: 		end if
L__main119:
;supervisore_energetico.mbas,299 :: 		wend
	GOTO       L__main55
L_end_main:
	GOTO       $+0
; end of _main
