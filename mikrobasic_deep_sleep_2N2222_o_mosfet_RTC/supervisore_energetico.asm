
_Delay_Safe_ms:

;supervisore_energetico.mbas,39 :: 		dim k as word
;supervisore_energetico.mbas,40 :: 		for k = 1 to n
	MOVLW      1
	MOVWF      R1+0
	CLRF       R1+1
L__Delay_Safe_ms1:
	MOVF       R1+1, 0
	SUBWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms168
	MOVF       R1+0, 0
	SUBWF      FARG_Delay_Safe_ms_n+0, 0
L__Delay_Safe_ms168:
	BTFSS      STATUS+0, 0
	GOTO       L__Delay_Safe_ms5
;supervisore_energetico.mbas,41 :: 		delay_us(980)                ' Pausa di 1ms calcolando i tempi della esecuzione altre uistruzioni in sub, si arriva ad arrotondare a 1ms circa...
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
;supervisore_energetico.mbas,42 :: 		clrwdt                       ' Reset del Watchdog ad ogni millisecondo
	CLRWDT
;supervisore_energetico.mbas,43 :: 		next k
	MOVF       R1+1, 0
	XORWF      FARG_Delay_Safe_ms_n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_Safe_ms169
	MOVF       FARG_Delay_Safe_ms_n+0, 0
	XORWF      R1+0, 0
L__Delay_Safe_ms169:
	BTFSC      STATUS+0, 2
	GOTO       L__Delay_Safe_ms5
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L__Delay_Safe_ms1
L__Delay_Safe_ms5:
;supervisore_energetico.mbas,44 :: 		end sub
L_end_Delay_Safe_ms:
	RETURN
; end of _Delay_Safe_ms

_Conv_Dec_To_BCD:

;supervisore_energetico.mbas,48 :: 		dim d as byte
;supervisore_energetico.mbas,49 :: 		d = dec_val div 10
	MOVLW      10
	MOVWF      R4+0
	MOVF       _dec_val+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
;supervisore_energetico.mbas,50 :: 		bcd_val = (d << 4) or (dec_val mod 10)
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
	RLF        _bcd_val+0, 1
	BCF        _bcd_val+0, 0
	RLF        _bcd_val+0, 1
	BCF        _bcd_val+0, 0
	RLF        _bcd_val+0, 1
	BCF        _bcd_val+0, 0
	RLF        _bcd_val+0, 1
	BCF        _bcd_val+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _dec_val+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      _bcd_val+0, 1
;supervisore_energetico.mbas,51 :: 		end sub
L_end_Conv_Dec_To_BCD:
	RETURN
; end of _Conv_Dec_To_BCD

_Conv_BCD_To_Dec:

;supervisore_energetico.mbas,54 :: 		dim d as byte
;supervisore_energetico.mbas,55 :: 		d = bcd_val >> 4
	MOVF       _bcd_val+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
;supervisore_energetico.mbas,56 :: 		dec_val = (d * 10) + (bcd_val and 0x0F)
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVLW      15
	ANDWF      _bcd_val+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      _dec_val+0
;supervisore_energetico.mbas,57 :: 		end sub
L_end_Conv_BCD_To_Dec:
	RETURN
; end of _Conv_BCD_To_Dec

_Leggi_Ora_RTC:

;supervisore_energetico.mbas,60 :: 		sub procedure Leggi_Ora_RTC()
;supervisore_energetico.mbas,61 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,62 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,63 :: 		Soft_I2C_Write(0xD0)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,64 :: 		Soft_I2C_Write(0x01)            ' Punta ai Minuti
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,65 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,66 :: 		Soft_I2C_Write(0xD1)
	MOVLW      209
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,67 :: 		bcd_val = Soft_I2C_Read(1)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,68 :: 		Conv_BCD_To_Dec()
	CALL       _Conv_BCD_To_Dec+0
;supervisore_energetico.mbas,69 :: 		minuti = dec_val
	MOVF       _dec_val+0, 0
	MOVWF      _minuti+0
;supervisore_energetico.mbas,70 :: 		bcd_val = Soft_I2C_Read(0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,71 :: 		Conv_BCD_To_Dec()
	CALL       _Conv_BCD_To_Dec+0
;supervisore_energetico.mbas,72 :: 		ore = dec_val
	MOVF       _dec_val+0, 0
	MOVWF      _ore+0
;supervisore_energetico.mbas,74 :: 		bcd_val = Soft_I2C_Read(0) ' Leggiamo l'ultimo registro che ci serve e chiudiamo (0)
	CLRF       FARG_Soft_I2C_Read_ack+0
	CLRF       FARG_Soft_I2C_Read_ack+1
	CALL       _Soft_I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _bcd_val+0
;supervisore_energetico.mbas,75 :: 		giorno = bcd_val and 0x07  ' Maschera per prendere solo il valore 1-7
	MOVLW      7
	ANDWF      R0+0, 0
	MOVWF      _giorno+0
;supervisore_energetico.mbas,76 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,77 :: 		end sub
L_end_Leggi_Ora_RTC:
	RETURN
; end of _Leggi_Ora_RTC

_Segnale_Triplo:

;supervisore_energetico.mbas,80 :: 		sub procedure Segnale_Triplo()
;supervisore_energetico.mbas,81 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__Segnale_Triplo12:
;supervisore_energetico.mbas,82 :: 		GPIO.2 = 1                 ' Accende LED (Nuovo PIN)
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,83 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,84 :: 		GPIO.2 = 0                 ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,85 :: 		Delay_Safe_ms(250)         ' Attesa 250ms
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,86 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Segnale_Triplo15
	INCF       _j+0, 1
	GOTO       L__Segnale_Triplo12
L__Segnale_Triplo15:
;supervisore_energetico.mbas,87 :: 		end sub
L_end_Segnale_Triplo:
	RETURN
; end of _Segnale_Triplo

_Lampeggia_Cifra:

;supervisore_energetico.mbas,91 :: 		dim l as byte
;supervisore_energetico.mbas,92 :: 		if (c = 0) then
	MOVF       FARG_Lampeggia_Cifra_c+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra18
;supervisore_energetico.mbas,94 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,95 :: 		delay_safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,96 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
	GOTO       L__Lampeggia_Cifra19
;supervisore_energetico.mbas,97 :: 		else
L__Lampeggia_Cifra18:
;supervisore_energetico.mbas,98 :: 		for l = 1 to c
	MOVLW      1
	MOVWF      Lampeggia_Cifra_l+0
L__Lampeggia_Cifra20:
	MOVF       Lampeggia_Cifra_l+0, 0
	SUBWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__Lampeggia_Cifra24
;supervisore_energetico.mbas,99 :: 		GPIO.2 = 1             ' Accende LED
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,100 :: 		delay_safe_ms(250)          ' Pausa accensione
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,101 :: 		GPIO.2 = 0             ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,102 :: 		delay_safe_ms(250)          ' Pausa tra lampi
	MOVLW      250
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,103 :: 		clrwdt                 ' Mantiene il sistema attivo
	CLRWDT
;supervisore_energetico.mbas,104 :: 		next l
	MOVF       Lampeggia_Cifra_l+0, 0
	XORWF      FARG_Lampeggia_Cifra_c+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Lampeggia_Cifra24
	INCF       Lampeggia_Cifra_l+0, 1
	GOTO       L__Lampeggia_Cifra20
L__Lampeggia_Cifra24:
;supervisore_energetico.mbas,105 :: 		end if
L__Lampeggia_Cifra19:
;supervisore_energetico.mbas,106 :: 		Delay_Safe_ms(1000)            ' Pausa lunga tra una cifra e l'altra
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,107 :: 		end sub
L_end_Lampeggia_Cifra:
	RETURN
; end of _Lampeggia_Cifra

_Leggi_Batteria_mV:

;supervisore_energetico.mbas,113 :: 		dim media_pulita as word
;supervisore_energetico.mbas,115 :: 		somma = 0
	CLRF       Leggi_Batteria_mV_somma+0
	CLRF       Leggi_Batteria_mV_somma+1
;supervisore_energetico.mbas,117 :: 		for i = 1 to 64
	MOVLW      1
	MOVWF      Leggi_Batteria_mV_i+0
L__Leggi_Batteria_mV27:
;supervisore_energetico.mbas,118 :: 		somma = somma + ADC_Read(1) ' Legge il valore analogico su AN1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      Leggi_Batteria_mV_somma+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Leggi_Batteria_mV_somma+1, 1
;supervisore_energetico.mbas,119 :: 		delay_safe_ms(1)                 ' Pausa tra letture
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,120 :: 		next i
	MOVF       Leggi_Batteria_mV_i+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV30
	INCF       Leggi_Batteria_mV_i+0, 1
	GOTO       L__Leggi_Batteria_mV27
L__Leggi_Batteria_mV30:
;supervisore_energetico.mbas,123 :: 		media_pulita = somma >> 6
	MOVLW      6
	MOVWF      R2+0
	MOVF       Leggi_Batteria_mV_somma+0, 0
	MOVWF      R0+0
	MOVF       Leggi_Batteria_mV_somma+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Leggi_Batteria_mV176:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV177
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV176
L__Leggi_Batteria_mV177:
;supervisore_energetico.mbas,126 :: 		batteria_mv = (LongWord(media_pulita) * taratura_vcc) >> 10
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
L__Leggi_Batteria_mV178:
	BTFSC      STATUS+0, 2
	GOTO       L__Leggi_Batteria_mV179
	RRF        _batteria_mv+3, 1
	RRF        _batteria_mv+2, 1
	RRF        _batteria_mv+1, 1
	RRF        _batteria_mv+0, 1
	BCF        _batteria_mv+3, 7
	ADDLW      255
	GOTO       L__Leggi_Batteria_mV178
L__Leggi_Batteria_mV179:
;supervisore_energetico.mbas,127 :: 		end sub
L_end_Leggi_Batteria_mV:
	RETURN
; end of _Leggi_Batteria_mV

_soglia_batteria:

;supervisore_energetico.mbas,130 :: 		sub procedure soglia_batteria
;supervisore_energetico.mbas,131 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria181
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria181
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria181
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria181:
	BTFSS      STATUS+0, 0
	GOTO       L__soglia_batteria33
;supervisore_energetico.mbas,132 :: 		GPIO.2 = 0                  ' Spegne LED
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,133 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,135 :: 		for j = 1 to 6
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria36:
;supervisore_energetico.mbas,136 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,137 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,138 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,139 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,140 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,141 :: 		next j
	MOVF       _j+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria39
	INCF       _j+0, 1
	GOTO       L__soglia_batteria36
L__soglia_batteria39:
	GOTO       L__soglia_batteria34
;supervisore_energetico.mbas,142 :: 		else
L__soglia_batteria33:
;supervisore_energetico.mbas,143 :: 		if (batteria_mv > soglia_off) and (batteria_mv <= soglia_on)  then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria182
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria182
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria182
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__soglia_batteria182:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_on+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria183
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_on+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria183
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_on+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__soglia_batteria183
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_on+0, 0
L__soglia_batteria183:
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria41
;supervisore_energetico.mbas,145 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,146 :: 		for j = 1 to 3
	MOVLW      1
	MOVWF      _j+0
L__soglia_batteria44:
;supervisore_energetico.mbas,147 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,148 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,149 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,150 :: 		delay_safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,151 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,152 :: 		next j
	MOVF       _j+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__soglia_batteria47
	INCF       _j+0, 1
	GOTO       L__soglia_batteria44
L__soglia_batteria47:
L__soglia_batteria41:
;supervisore_energetico.mbas,154 :: 		end if
L__soglia_batteria34:
;supervisore_energetico.mbas,155 :: 		end sub
L_end_soglia_batteria:
	RETURN
; end of _soglia_batteria

_Init_Hardware:

;supervisore_energetico.mbas,158 :: 		sub procedure Init_Hardware()
;supervisore_energetico.mbas,160 :: 		RTC_presente = 0
	CLRF       _RTC_presente+0
;supervisore_energetico.mbas,161 :: 		OSCCON = %01100111
	MOVLW      103
	MOVWF      OSCCON+0
;supervisore_energetico.mbas,164 :: 		CMCON0 = 7
	MOVLW      7
	MOVWF      CMCON0+0
;supervisore_energetico.mbas,167 :: 		ANSEL  = %00010010
	MOVLW      18
	MOVWF      ANSEL+0
;supervisore_energetico.mbas,170 :: 		TRISIO = %00001010
	MOVLW      10
	MOVWF      TRISIO+0
;supervisore_energetico.mbas,173 :: 		OPTION_REG = %00001111
	MOVLW      15
	MOVWF      OPTION_REG+0
;supervisore_energetico.mbas,176 :: 		WPU = %00000000
	CLRF       WPU+0
;supervisore_energetico.mbas,179 :: 		INTCON.GPIE = 1
	BSF        INTCON+0, 3
;supervisore_energetico.mbas,182 :: 		IOC.3 = 1
	BSF        IOC+0, 3
;supervisore_energetico.mbas,185 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,188 :: 		cicli_per_giorno = 2883
	MOVLW      67
	MOVWF      _cicli_per_giorno+0
	MOVLW      11
	MOVWF      _cicli_per_giorno+1
	CLRF       _cicli_per_giorno+2
	CLRF       _cicli_per_giorno+3
;supervisore_energetico.mbas,195 :: 		soglia_off   = 3300  '300 mV, ma heltec a me segna 3.40V (3400) quindi 18% batteria, scendo per avere piu tempo in accensione!
	MOVLW      228
	MOVWF      _soglia_off+0
	MOVLW      12
	MOVWF      _soglia_off+1
	CLRF       _soglia_off+2
	CLRF       _soglia_off+3
;supervisore_energetico.mbas,196 :: 		soglia_on    = 3600  '(45%), va piu che bene
	MOVLW      16
	MOVWF      _soglia_on+0
	MOVLW      14
	MOVWF      _soglia_on+1
	CLRF       _soglia_on+2
	CLRF       _soglia_on+3
;supervisore_energetico.mbas,197 :: 		taratura_vcc = 5050  'segnava 5.03, (5030) ma per calibrarlo meglio ho alzato di 20 mV
	MOVLW      186
	MOVWF      _taratura_vcc+0
	MOVLW      19
	MOVWF      _taratura_vcc+1
	CLRF       _taratura_vcc+2
	CLRF       _taratura_vcc+3
;supervisore_energetico.mbas,198 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,204 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,207 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,212 :: 		RTC_presente = 1 'se vogliamo abilitare RTC sulla scheda, altrimenti poniamo variabile a 0
	MOVLW      1
	MOVWF      _RTC_presente+0
;supervisore_energetico.mbas,213 :: 		giorni_riavvio = 3
	MOVLW      3
	MOVWF      _giorni_riavvio+0
;supervisore_energetico.mbas,216 :: 		giorni_riavvio = 0
	CLRF       _giorni_riavvio+0
;supervisore_energetico.mbas,219 :: 		EEPROM_Write(0x00, 0xFF) ' Decommenta per forzare nuova sincronizzazione RTC
	CLRF       FARG_EEPROM_Write_address+0
	MOVLW      255
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,220 :: 		Delay_Safe_ms(50)
	MOVLW      50
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,222 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,224 :: 		stato_eeprom = EEPROM_Read(0x00)
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _stato_eeprom+0
;supervisore_energetico.mbas,225 :: 		if ((stato_eeprom <> 1) and (RTC_presente = 1)) then
	MOVF       R0+0, 0
	XORLW      1
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _RTC_presente+0, 0
	XORLW      1
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__Init_Hardware53
;supervisore_energetico.mbas,227 :: 		TRISIO.4 = 0
	BCF        TRISIO+0, 4
;supervisore_energetico.mbas,228 :: 		GPIO.4 = 1 ' SDA Alto
	BSF        GPIO+0, 4
;supervisore_energetico.mbas,229 :: 		TRISIO.5 = 0
	BCF        TRISIO+0, 5
;supervisore_energetico.mbas,230 :: 		GPIO.5 = 1 ' SCL Alto
	BSF        GPIO+0, 5
;supervisore_energetico.mbas,232 :: 		gpio.2=1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,233 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,235 :: 		Soft_I2C_Init()     ' Inizializza
	CALL       _Soft_I2C_Init+0
;supervisore_energetico.mbas,236 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,237 :: 		Soft_I2C_Start()
	CALL       _Soft_I2C_Start+0
;supervisore_energetico.mbas,238 :: 		Soft_I2C_Write(0xD0) ' Indirizzo DS3231 (Scrittura)
	MOVLW      208
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,239 :: 		Soft_I2C_Write(0x00) ' Inizia dal registro 0 (Secondi)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,242 :: 		Soft_I2C_Write(0x00) ' Secondi (00)
	CLRF       FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,243 :: 		Soft_I2C_Write(0x54) ' Minuti (metti 54 se sono le 10:54)
	MOVLW      84
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,244 :: 		Soft_I2C_Write(0x10) ' Ore (metti 10 se sono le 10)
	MOVLW      16
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,245 :: 		Soft_I2C_Write(0x01) ' Giorno Settimana (1=Lun, 2=Mar...)
	MOVLW      1
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,246 :: 		Soft_I2C_Write(0x30) ' Giorno Mese (30)
	MOVLW      48
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,247 :: 		Soft_I2C_Write(0x03) ' Mese (03 = Marzo)
	MOVLW      3
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,248 :: 		Soft_I2C_Write(0x26) ' Anno (26 = 2026)
	MOVLW      38
	MOVWF      FARG_Soft_I2C_Write_data_+0
	CALL       _Soft_I2C_Write+0
;supervisore_energetico.mbas,250 :: 		Soft_I2C_Stop()
	CALL       _Soft_I2C_Stop+0
;supervisore_energetico.mbas,252 :: 		EEPROM_Write(0x00, 1) ' Segna che abbiamo già sincronizzato
	CLRF       FARG_EEPROM_Write_address+0
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;supervisore_energetico.mbas,253 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__Init_Hardware53:
;supervisore_energetico.mbas,257 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,260 :: 		Segnale_Triplo()
	CALL       _Segnale_Triplo+0
;supervisore_energetico.mbas,263 :: 		delay_safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,266 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,269 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware185
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware185
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Init_Hardware185
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__Init_Hardware185:
	BTFSC      STATUS+0, 0
	GOTO       L__Init_Hardware56
;supervisore_energetico.mbas,270 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
L__Init_Hardware56:
;supervisore_energetico.mbas,274 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,275 :: 		reset_fatto = 0
	CLRF       _reset_fatto+0
;supervisore_energetico.mbas,276 :: 		sveglie_wdt = 13  ' Forza lettura batteria al primo giro
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,278 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,281 :: 		soglia_batteria
	CALL       _soglia_batteria+0
;supervisore_energetico.mbas,282 :: 		end sub
L_end_Init_Hardware:
	RETURN
; end of _Init_Hardware

_main:

;supervisore_energetico.mbas,285 :: 		main:
;supervisore_energetico.mbas,286 :: 		Init_Hardware()                ' Configura il chip
	CALL       _Init_Hardware+0
;supervisore_energetico.mbas,289 :: 		while (TRUE)
L__main60:
;supervisore_energetico.mbas,291 :: 		if (INTCON.GPIF = 1) then
	BTFSS      INTCON+0, 0
	GOTO       L__main65
;supervisore_energetico.mbas,292 :: 		dummy = GPIO
	MOVF       GPIO+0, 0
	MOVWF      _dummy+0
;supervisore_energetico.mbas,293 :: 		INTCON.GPIF = 0
	BCF        INTCON+0, 0
L__main65:
;supervisore_energetico.mbas,297 :: 		if (GPIO.3 = 0) then
	BTFSC      GPIO+0, 3
	GOTO       L__main68
;supervisore_energetico.mbas,298 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,299 :: 		while (GPIO.3 = 0) and (i < 50)
L__main71:
	BTFSC      GPIO+0, 3
	GOTO       L__main187
	BSF        117, 0
	GOTO       L__main188
L__main187:
	BCF        117, 0
L__main188:
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
	GOTO       L__main72
;supervisore_energetico.mbas,300 :: 		Delay_Safe_ms(100) ' Campionamento pressione (100ms * 50 = 5s max)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,301 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,302 :: 		if (i = 10) then
	MOVF       _i+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main76
;supervisore_energetico.mbas,303 :: 		GPIO.2 = 1     ' Accende LED dopo 1 secondo di pressione
	BSF        GPIO+0, 2
L__main76:
;supervisore_energetico.mbas,305 :: 		if (i = 25) then
	MOVF       _i+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L__main79
;supervisore_energetico.mbas,306 :: 		GPIO.2 = 0     ' Spegne LED dopo 2.5 secondi (cambio modalità)
	BCF        GPIO+0, 2
L__main79:
;supervisore_energetico.mbas,308 :: 		wend
	GOTO       L__main71
L__main72:
;supervisore_energetico.mbas,311 :: 		if (i >= 10) and (i < 25) then
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
;supervisore_energetico.mbas,312 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,313 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,316 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main189
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main189
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main189
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main189:
	BTFSC      STATUS+0, 0
	GOTO       L__main85
;supervisore_energetico.mbas,317 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main85:
;supervisore_energetico.mbas,321 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,322 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,325 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main190
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main190
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main190
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main190:
	BTFSC      STATUS+0, 0
	GOTO       L__main88
;supervisore_energetico.mbas,326 :: 		GPIO.0 = 0
	BCF        GPIO+0, 0
L__main88:
;supervisore_energetico.mbas,328 :: 		gpio.2=0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,329 :: 		sveglie_wdt = 0
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,330 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main82:
;supervisore_energetico.mbas,334 :: 		if (i >= 25) and (i < 50) then
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
;supervisore_energetico.mbas,335 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,336 :: 		Leggi_Batteria_mV() ' Legge voltaggio attuale
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,338 :: 		Delay_Safe_ms(1000)
	MOVLW      232
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      3
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,341 :: 		temp_mv = batteria_mv
	MOVF       _batteria_mv+0, 0
	MOVWF      _temp_mv+0
	MOVF       _batteria_mv+1, 0
	MOVWF      _temp_mv+1
	MOVF       _batteria_mv+2, 0
	MOVWF      _temp_mv+2
	MOVF       _batteria_mv+3, 0
	MOVWF      _temp_mv+3
;supervisore_energetico.mbas,342 :: 		cifra = temp_mv div 1000
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
;supervisore_energetico.mbas,343 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,344 :: 		temp_mv = temp_mv mod 1000
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
;supervisore_energetico.mbas,345 :: 		cifra = temp_mv div 100
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,346 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,347 :: 		temp_mv = temp_mv mod 100
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
;supervisore_energetico.mbas,348 :: 		cifra = temp_mv div 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _cifra+0
;supervisore_energetico.mbas,349 :: 		Lampeggia_Cifra(cifra)
	MOVF       R0+0, 0
	MOVWF      FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
;supervisore_energetico.mbas,350 :: 		Lampeggia_Cifra(0)
	CLRF       FARG_Lampeggia_Cifra_c+0
	CALL       _Lampeggia_Cifra+0
L__main91:
;supervisore_energetico.mbas,355 :: 		if (i >= 50) then
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main94
;supervisore_energetico.mbas,356 :: 		GPIO.0 = 1                      ' Distacca il carico (Heltec OFF)
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,358 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main97:
;supervisore_energetico.mbas,359 :: 		GPIO.2 = not GPIO.2         ' Lampeggio veloce di conferma
	MOVLW      4
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,360 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,361 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,362 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main100
	INCF       _j+0, 1
	GOTO       L__main97
L__main100:
;supervisore_energetico.mbas,363 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,364 :: 		in_manutenzione = true          ' Entra nel loop di blocco
	MOVLW      255
	MOVWF      _in_manutenzione+0
;supervisore_energetico.mbas,365 :: 		while (in_manutenzione = true)
L__main102:
	MOVF       _in_manutenzione+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L__main103
;supervisore_energetico.mbas,367 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,368 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,369 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,370 :: 		if (GPIO.3 = 0) then        ' Controlla se si preme di nuovo per uscire
	BTFSC      GPIO+0, 3
	GOTO       L__main107
;supervisore_energetico.mbas,371 :: 		i = 0
	CLRF       _i+0
;supervisore_energetico.mbas,372 :: 		while (GPIO.3 = 0) and (i < 50)
L__main110:
	BTFSC      GPIO+0, 3
	GOTO       L__main191
	BSF        117, 0
	GOTO       L__main192
L__main191:
	BCF        117, 0
L__main192:
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
	GOTO       L__main111
;supervisore_energetico.mbas,373 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,374 :: 		i = i + 1
	INCF       _i+0, 1
;supervisore_energetico.mbas,375 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,376 :: 		wend
	GOTO       L__main110
L__main111:
;supervisore_energetico.mbas,377 :: 		if (i >= 50) then       ' Uscita dopo altri 5 secondi
	MOVLW      50
	SUBWF      _i+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main115
;supervisore_energetico.mbas,378 :: 		in_manutenzione = false
	CLRF       _in_manutenzione+0
;supervisore_energetico.mbas,380 :: 		for j = 1 to 20
	MOVLW      1
	MOVWF      _j+0
L__main118:
;supervisore_energetico.mbas,381 :: 		GPIO.2 = not GPIO.2
	MOVLW      4
	XORWF      GPIO+0, 1
;supervisore_energetico.mbas,382 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,383 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,384 :: 		next j
	MOVF       _j+0, 0
	XORLW      20
	BTFSC      STATUS+0, 2
	GOTO       L__main121
	INCF       _j+0, 1
	GOTO       L__main118
L__main121:
;supervisore_energetico.mbas,385 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
L__main115:
;supervisore_energetico.mbas,386 :: 		end if
	GOTO       L__main108
;supervisore_energetico.mbas,387 :: 		else
L__main107:
;supervisore_energetico.mbas,390 :: 		Delay_Safe_ms(500)
	MOVLW      244
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      1
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,391 :: 		end if
L__main108:
;supervisore_energetico.mbas,392 :: 		clrwdt
	CLRWDT
;supervisore_energetico.mbas,393 :: 		wend
	GOTO       L__main102
L__main103:
;supervisore_energetico.mbas,395 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,396 :: 		if (batteria_mv > soglia_off) then GPIO.0 = 0 end if
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main193
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main193
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main193
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main193:
	BTFSC      STATUS+0, 0
	GOTO       L__main123
	BCF        GPIO+0, 0
L__main123:
;supervisore_energetico.mbas,397 :: 		if (batteria_mv < soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main194
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main194
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main194
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main194:
	BTFSC      STATUS+0, 0
	GOTO       L__main126
;supervisore_energetico.mbas,398 :: 		soglia_batteria
	CALL       _soglia_batteria+0
L__main126:
;supervisore_energetico.mbas,400 :: 		sveglie_wdt = 13 ' Forza controllo batteria subito
	MOVLW      13
	MOVWF      _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,401 :: 		conteggio_cicli = 0
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
;supervisore_energetico.mbas,402 :: 		minuti_count = 0
	CLRF       _minuti_count+0
;supervisore_energetico.mbas,403 :: 		clrwdt
	CLRWDT
L__main94:
;supervisore_energetico.mbas,404 :: 		end if
L__main68:
;supervisore_energetico.mbas,408 :: 		if (in_manutenzione = false) then
	MOVF       _in_manutenzione+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
;supervisore_energetico.mbas,410 :: 		if (sveglie_wdt >= 13) then
	MOVLW      0
	SUBWF      _sveglie_wdt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main195
	MOVLW      13
	SUBWF      _sveglie_wdt+0, 0
L__main195:
	BTFSS      STATUS+0, 0
	GOTO       L__main132
;supervisore_energetico.mbas,411 :: 		Leggi_Batteria_mV()
	CALL       _Leggi_Batteria_mV+0
;supervisore_energetico.mbas,413 :: 		if (batteria_mv <= soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main196
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main196
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main196
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main196:
	BTFSS      STATUS+0, 0
	GOTO       L__main135
;supervisore_energetico.mbas,414 :: 		GPIO.0 = 1 ' Spegne Heltec
	BSF        GPIO+0, 0
L__main135:
;supervisore_energetico.mbas,417 :: 		if (batteria_mv >= soglia_on) then
	MOVF       _soglia_on+3, 0
	SUBWF      _batteria_mv+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main197
	MOVF       _soglia_on+2, 0
	SUBWF      _batteria_mv+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main197
	MOVF       _soglia_on+1, 0
	SUBWF      _batteria_mv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main197
	MOVF       _soglia_on+0, 0
	SUBWF      _batteria_mv+0, 0
L__main197:
	BTFSS      STATUS+0, 0
	GOTO       L__main138
;supervisore_energetico.mbas,418 :: 		GPIO.0 = 0 ' Accende Heltec
	BCF        GPIO+0, 0
L__main138:
;supervisore_energetico.mbas,421 :: 		sveglie_wdt = 0 ' Reset qui dopo il controllo batteria
	CLRF       _sveglie_wdt+0
	CLRF       _sveglie_wdt+1
;supervisore_energetico.mbas,423 :: 		if (RTC_presente = 1) then
	MOVF       _RTC_presente+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main141
;supervisore_energetico.mbas,424 :: 		minuti_count = minuti_count + 1
	INCF       _minuti_count+0, 1
L__main141:
;supervisore_energetico.mbas,428 :: 		if (giorni_riavvio > 0) then
	MOVF       _giorni_riavvio+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main144
;supervisore_energetico.mbas,429 :: 		conteggio_cicli = conteggio_cicli + 1
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
;supervisore_energetico.mbas,431 :: 		if (conteggio_cicli >= (cicli_per_giorno * giorni_riavvio)) then
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
	GOTO       L__main198
	MOVF       R0+2, 0
	SUBWF      _conteggio_cicli+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main198
	MOVF       R0+1, 0
	SUBWF      _conteggio_cicli+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main198
	MOVF       R0+0, 0
	SUBWF      _conteggio_cicli+0, 0
L__main198:
	BTFSS      STATUS+0, 0
	GOTO       L__main147
;supervisore_energetico.mbas,432 :: 		GPIO.0 = 1           ' Ciclo di spegnimento
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,433 :: 		Delay_Safe_ms(2000)
	MOVLW      208
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      7
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,434 :: 		if (batteria_mv > soglia_off) then
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main199
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main199
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main199
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main199:
	BTFSC      STATUS+0, 0
	GOTO       L__main150
;supervisore_energetico.mbas,435 :: 		GPIO.0 = 0       ' Riaccensione
	BCF        GPIO+0, 0
L__main150:
;supervisore_energetico.mbas,437 :: 		conteggio_cicli = 0  ' Reset timer
	CLRF       _conteggio_cicli+0
	CLRF       _conteggio_cicli+1
	CLRF       _conteggio_cicli+2
	CLRF       _conteggio_cicli+3
L__main147:
;supervisore_energetico.mbas,438 :: 		end if
L__main144:
;supervisore_energetico.mbas,442 :: 		if (minuti_count >= 20) then
	MOVLW      20
	SUBWF      _minuti_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main153
;supervisore_energetico.mbas,443 :: 		GPIO.2 = 1
	BSF        GPIO+0, 2
;supervisore_energetico.mbas,444 :: 		Delay_Safe_ms(150)
	MOVLW      150
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,445 :: 		Leggi_Ora_RTC()
	CALL       _Leggi_Ora_RTC+0
;supervisore_energetico.mbas,446 :: 		GPIO.2 = 0
	BCF        GPIO+0, 2
;supervisore_energetico.mbas,449 :: 		if (ore = 4) and (minuti < 11) then
	MOVF       _ore+0, 0
	XORLW      4
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVLW      11
	SUBWF      _minuti+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main156
;supervisore_energetico.mbas,450 :: 		if (reset_fatto = 0) then
	MOVF       _reset_fatto+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
;supervisore_energetico.mbas,451 :: 		if (giorno = 1) or (giorno = 4) then
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
	GOTO       L__main162
;supervisore_energetico.mbas,452 :: 		GPIO.0 = 1
	BSF        GPIO+0, 0
;supervisore_energetico.mbas,453 :: 		Delay_Safe_ms(10000)
	MOVLW      16
	MOVWF      FARG_Delay_Safe_ms_n+0
	MOVLW      39
	MOVWF      FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,454 :: 		if (batteria_mv > soglia_off) then GPIO.0 = 0 end if
	MOVF       _batteria_mv+3, 0
	SUBWF      _soglia_off+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main200
	MOVF       _batteria_mv+2, 0
	SUBWF      _soglia_off+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main200
	MOVF       _batteria_mv+1, 0
	SUBWF      _soglia_off+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main200
	MOVF       _batteria_mv+0, 0
	SUBWF      _soglia_off+0, 0
L__main200:
	BTFSC      STATUS+0, 0
	GOTO       L__main165
	BCF        GPIO+0, 0
L__main165:
;supervisore_energetico.mbas,455 :: 		reset_fatto = 1
	MOVLW      1
	MOVWF      _reset_fatto+0
L__main162:
;supervisore_energetico.mbas,456 :: 		end if
L__main159:
;supervisore_energetico.mbas,457 :: 		end if
	GOTO       L__main157
;supervisore_energetico.mbas,458 :: 		else
L__main156:
;supervisore_energetico.mbas,459 :: 		reset_fatto = 0
	CLRF       _reset_fatto+0
;supervisore_energetico.mbas,460 :: 		end if
L__main157:
;supervisore_energetico.mbas,461 :: 		minuti_count = 0
	CLRF       _minuti_count+0
L__main153:
;supervisore_energetico.mbas,462 :: 		end if
L__main132:
;supervisore_energetico.mbas,466 :: 		sveglie_wdt = sveglie_wdt + 1    ' Incrementa conteggio risvegli
	INCF       _sveglie_wdt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _sveglie_wdt+1, 1
;supervisore_energetico.mbas,467 :: 		clrwdt                            ' Pulizia watchdog
	CLRWDT
;supervisore_energetico.mbas,468 :: 		sleep                             ' Il chip dorme (Risparmio Max)
	SLEEP
;supervisore_energetico.mbas,469 :: 		nop                              ' Istruzione necessaria dopo lo sleep
	NOP
	GOTO       L__main130
;supervisore_energetico.mbas,471 :: 		else
L__main129:
;supervisore_energetico.mbas,473 :: 		Delay_Safe_ms(100)
	MOVLW      100
	MOVWF      FARG_Delay_Safe_ms_n+0
	CLRF       FARG_Delay_Safe_ms_n+1
	CALL       _Delay_Safe_ms+0
;supervisore_energetico.mbas,474 :: 		end if
L__main130:
;supervisore_energetico.mbas,475 :: 		wend
	GOTO       L__main60
L_end_main:
	GOTO       $+0
; end of _main
