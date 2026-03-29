
_Delay_Safe_ms:

;supervisore_energetico.mbas,23 :: 		dim k as word
;supervisore_energetico.mbas,24 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms135
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms135:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,25 :: 		delay_us(980)                ' Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
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
;supervisore_energetico.mbas,26 :: 		clrwdt                       ' Reset del Watchdog ad ogni millisecondo
	CLRWDT
;supervisore_energetico.mbas,27 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms136
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms136:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,28 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Segnale_Triplo:

;supervisore_energetico.mbas,31 :: 		sub procedure Segnale_Triplo()
;supervisore_energetico.mbas,32 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__Segnale_Triplo9:
;supervisore_energetico.mbas,33 :: 		GPIO.5 = 1                 ' Accende LED
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,34 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,35 :: 		GPIO.5 = 0                 ' Spegne LED
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,36 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,37 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Triplo12
	INCF       _j+0, 1
	GOTO       L__Segnale_Triplo9
L__Segnale_Triplo12:
;supervisore_energetico.mbas,38 :: 		end sub
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Lampeggia_Cifra:

;supervisore_energetico.mbas,42 :: 		dim l as byte
;supervisore_energetico.mbas,43 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra15
;supervisore_energetico.mbas,45 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,46 :: 		delay_safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,47 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
	GOTO       L__Lampeggia_Cifra16
;supervisore_energetico.mbas,48 :: 		else
L__Lampeggia_Cifra15:
;supervisore_energetico.mbas,49 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra17:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra21
;supervisore_energetico.mbas,50 :: 		GPIO.5 = 1             ' Accende LED
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,51 :: 		delay_safe_ms(250)          ' Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,52 :: 		GPIO.5 = 0             ' Spegne LED
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,53 :: 		delay_safe_ms(250)          ' Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,54 :: 		clrwdt                 ' Mantiene il sistema attivo
	CLRWDT
;supervisore_energetico.mbas,55 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra21
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra17
L__Lampeggia_Cifra21:
;supervisore_energetico.mbas,56 :: 		end if
L__Lampeggia_Cifra16:
;supervisore_energetico.mbas,57 :: 		Delay_Safe_ms(1000)            ' Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,58 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,64 :: 		dim media_pulita as word
;supervisore_energetico.mbas,66 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,68 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV24:
;supervisore_energetico.mbas,69 :: 		somma = somma + ADC_Read(1) ' Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,70 :: 		delay_safe_ms(1)                 ' Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,71 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV27
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV24
L__Leggi_Batteria_mV27:
;supervisore_energetico.mbas,74 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV140:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV141
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV140
L__Leggi_Batteria_mV141:
;supervisore_energetico.mbas,77 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV142:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV143
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV142
L__Leggi_Batteria_mV143:
;supervisore_energetico.mbas,78 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_soglia_batteria:

;supervisore_energetico.mbas,81 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,82 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria145
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria145
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria145
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria145:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria30
;supervisore_energetico.mbas,83 :: 		GPIO.5 = 0                  ' Spegne LED
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,84 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,86 :: 		for j = 1 to 6
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria33:
;supervisore_energetico.mbas,87 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,88 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,89 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,90 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,91 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,92 :: 		next j
	MOVF       _j+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria36
	INCF       _j+0, 1
	GOTO       L__soglia_batteria33
L__soglia_batteria36:
	GOTO       L__soglia_batteria31
;supervisore_energetico.mbas,93 :: 		else
L__soglia_batteria30:
;supervisore_energetico.mbas,94 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria146
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria146
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria146
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria146:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria147
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria147
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria147
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria147:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria38
;supervisore_energetico.mbas,96 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,97 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria41:
;supervisore_energetico.mbas,98 :: 		GPIO.5 = 1
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,99 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,100 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,101 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,102 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,103 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria44
	INCF       _j+0, 1
	GOTO       L__soglia_batteria41
L__soglia_batteria44:
L__soglia_batteria38:
;supervisore_energetico.mbas,105 :: 		end if
L__soglia_batteria31:
;supervisore_energetico.mbas,106 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Init_Hardware:

;supervisore_energetico.mbas,109 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,111 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,114 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,117 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,120 :: 		TRISIO = %00001011
	MOVLW      11
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,123 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,126 :: 		WPU = %00000001
	MOVLW      1
	MOVWF      WPU+0
;supervisore_energetico.mbas,129 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,132 :: 		IOC.0 = 1
	BSF        IOC+0, 0
;supervisore_energetico.mbas,138 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,139 :: 		soglia_on    = 3600  '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,140 :: 		taratura_vcc = 5050  'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,141 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,147 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,150 :: 		cicli_per_giorno = 2883
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;supervisore_energetico.mbas,153 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,156 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,159 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,162 :: 		Segnale_Triplo()
	CALL       _Segnale_Triplo+0
;supervisore_energetico.mbas,165 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,168 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,171 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware149
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware149
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware149
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware149:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware47
;supervisore_energetico.mbas,172 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__Init_Hardware47:
;supervisore_energetico.mbas,176 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,179 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,182 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,183 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,186 :: 		main:
;supervisore_energetico.mbas,187 :: 		Init_Hardware()                ' Configura il chip
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,188 :: 		sveglie_wdt = 15               ' Forza un controllo immediato della batteria al primo loop
	MOVLW      15
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,190 :: 		while (TRUE)
L__main51:
;supervisore_energetico.mbas,192 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main56
;supervisore_energetico.mbas,193 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,194 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main56:
;supervisore_energetico.mbas,198 :: 		if (GPIO.0 = 0) then
	BTFSC      GPIO+0, 0
	GOTO       L__main59
;supervisore_energetico.mbas,199 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,200 :: 		while (GPIO.0 = 0) and (i < 50)
L__main62:
	BTFSC      GPIO+0, 0
	GOTO       L__main151
	BSF        117, 0
	GOTO       L__main152
L__main151:
	BCF        117, 0
L__main152:
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
	GOTO       L__main63
;supervisore_energetico.mbas,201 :: 		Delay_Safe_ms(100) ' Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,202 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,203 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main67
;supervisore_energetico.mbas,204 :: 		GPIO.5 = 1     ' Accende LED dopo 1 secondo di pressione
	BSF        GPIO+0, 5
L__main67:
;supervisore_energetico.mbas,206 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main70
;supervisore_energetico.mbas,207 :: 		GPIO.5 = 0     ' Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 5
L__main70:
;supervisore_energetico.mbas,209 :: 		wend
	GOTO       L__main62
L__main63:
;supervisore_energetico.mbas,212 :: 		if (i >= 10) and (i < 25) then
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
	GOTO       L__main73
;supervisore_energetico.mbas,213 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,214 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,217 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main153:
	BTFSC      STATUS+0, 0
	GOTO       L__main76
;supervisore_energetico.mbas,218 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main76:
;supervisore_energetico.mbas,222 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,223 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,226 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main154:
	BTFSC      STATUS+0, 0
	GOTO       L__main79
;supervisore_energetico.mbas,227 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main79:
;supervisore_energetico.mbas,230 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,231 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main73:
;supervisore_energetico.mbas,235 :: 		if (i >= 25) and (i < 50) then
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
	GOTO       L__main82
;supervisore_energetico.mbas,236 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,237 :: 		Leggi_Batteria_mV() ' Legge voltaggio attuale
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,239 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,242 :: 		temp_mv = batteria_mv
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;supervisore_energetico.mbas,243 :: 		cifra = temp_mv / 1000          ' Migliaia (Volt)
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
;supervisore_energetico.mbas,244 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,245 :: 		temp_mv = temp_mv mod 1000
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
;supervisore_energetico.mbas,247 :: 		cifra = temp_mv / 100           ' Centinaia (decimi di Volt)
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,248 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,249 :: 		temp_mv = temp_mv mod 100
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
;supervisore_energetico.mbas,251 :: 		cifra = temp_mv / 10            ' Decine (centesimi di Volt)
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,252 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,254 :: 		cifra = 0                       ' Forza sempre a 0 l'ultimo decimale
	CLRF       _cifra+0
;supervisore_energetico.mbas,255 :: 		Lampeggia_Cifra(cifra)
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,257 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
L__main82:
;supervisore_energetico.mbas,261 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main85
;supervisore_energetico.mbas,262 :: 		GPIO.2 = 1                      ' Distacca il carico (Heltec OFF)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,263 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main88:
;supervisore_energetico.mbas,264 :: 		GPIO.5 = not GPIO.5         ' Lampeggio veloce di conferma
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,265 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,266 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main91
	INCF       _j+0, 1
	GOTO       L__main88
L__main91:
;supervisore_energetico.mbas,267 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,268 :: 		in_manutenzione = true          ' Entra nel loop di blocco
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,269 :: 		while (in_manutenzione = true)
L__main93:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main94
;supervisore_energetico.mbas,270 :: 		GPIO.5 = 1                  ' LED acceso fisso o lampeggio lento
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,271 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,272 :: 		GPIO.5 = 0
	BCF        GPIO+0, 5
;supervisore_energetico.mbas,273 :: 		if (GPIO.0 = 0) then        ' Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 0
	GOTO       L__main98
;supervisore_energetico.mbas,274 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,275 :: 		while (GPIO.0 = 0) and (i < 50)
L__main101:
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
	GOTO       L__main102
;supervisore_energetico.mbas,276 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,277 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,278 :: 		wend
	GOTO       L__main101
L__main102:
;supervisore_energetico.mbas,279 :: 		if (i >= 50) then       ' Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main106
;supervisore_energetico.mbas,280 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,281 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main109:
;supervisore_energetico.mbas,282 :: 		GPIO.5 = not GPIO.5
	MOVLW      32
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,283 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,284 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main112
	INCF       _j+0, 1
	GOTO       L__main109
L__main112:
L__main106:
;supervisore_energetico.mbas,285 :: 		end if
	GOTO       L__main99
;supervisore_energetico.mbas,286 :: 		else
L__main98:
;supervisore_energetico.mbas,287 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,288 :: 		end if
L__main99:
;supervisore_energetico.mbas,289 :: 		wend
	GOTO       L__main93
L__main94:
;supervisore_energetico.mbas,290 :: 		GPIO.2 = 0                      ' Riaccende il carico
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,291 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,292 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main85:
;supervisore_energetico.mbas,293 :: 		end if
L__main59:
;supervisore_energetico.mbas,297 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main114
;supervisore_energetico.mbas,299 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main157:
	BTFSS      STATUS+0, 0
	GOTO       L__main117
;supervisore_energetico.mbas,300 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,302 :: 		if (batteria_mv <= soglia_off) then
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
	BTFSS      STATUS+0, 0
	GOTO       L__main120
;supervisore_energetico.mbas,303 :: 		GPIO.2 = 1 ' Spegne Heltec
	BSF        GPIO+0, 2
L__main120:
;supervisore_energetico.mbas,306 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main159:
	BTFSS      STATUS+0, 0
	GOTO       L__main123
;supervisore_energetico.mbas,307 :: 		GPIO.2 = 0 ' Accende Heltec
	BCF        GPIO+0, 2
L__main123:
;supervisore_energetico.mbas,311 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main126
;supervisore_energetico.mbas,312 :: 		conteggio_cicli = conteggio_cicli + 1
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
;supervisore_energetico.mbas,314 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) then
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
	GOTO       L__main160
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main160
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main160
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main160:
	BTFSS      STATUS+0, 0
	GOTO       L__main129
;supervisore_energetico.mbas,315 :: 		GPIO.2 = 1           ' Ciclo di spegnimento
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,316 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,317 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main161
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main161
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main161
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main161:
	BTFSC      STATUS+0, 0
	GOTO       L__main132
;supervisore_energetico.mbas,318 :: 		GPIO.2 = 0       ' Riaccensione
	BCF        GPIO+0, 2
L__main132:
;supervisore_energetico.mbas,320 :: 		conteggio_cicli = 0  ' Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main129:
;supervisore_energetico.mbas,321 :: 		end if
L__main126:
;supervisore_energetico.mbas,323 :: 		sveglie_wdt = 0              ' Reset contatore risvegli
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
L__main117:
;supervisore_energetico.mbas,326 :: 		sveglie_wdt = sveglie_wdt + 1    ' Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,327 :: 		clrwdt                           ' Pulizia watchdog
	CLRWDT
;supervisore_energetico.mbas,328 :: 		sleep                            ' Il chip dorme (Risparmio Max)
	SLEEP
;supervisore_energetico.mbas,329 :: 		nop                              ' Istruzione necessaria dopo lo sleep
	NOP
	GOTO       L__main115
;supervisore_energetico.mbas,330 :: 		else
L__main114:
;supervisore_energetico.mbas,332 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,333 :: 		end if
L__main115:
;supervisore_energetico.mbas,334 :: 		wend
	GOTO       L__main51
L_end_main:
	GOTO       $+0
; end of _main
