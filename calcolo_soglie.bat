@echo off
setlocal enabledelayedexpansion
title Calcolatore MikroBasic (VERSIONE CORRETTA)

:start
cls
echo ==================================================
echo      GENERATORE CODICE MIKROBASIC (SOGLIE)
echo ==================================================
echo.
set /p VDD="Inserisci V-LDO (es. 2.9 o 3.0): "

:: Pulizia spazi
set "VDD=%VDD: =%"

:: Check del punto
set "TEST_POINT=%VDD:.=%"
if "%TEST_POINT%"=="%VDD%" (
    echo [ERRORE] Manca il punto!
    pause
    goto start
)

:: Estraiamo i decimi (es: 3.0 -> 30)
set "VDD_C=%TEST_POINT%"

:: --- CALCOLO CORRETTO (SENZA ZERI EXTRA) ---
:: Formula: (V_pin * 1024) / VDD
:: Per 3.3V batteria (1.65V pin): 1.65 * 1024 = 1689.6
:: In Batch usiamo: (16896 / VDD_C) -> 16896 / 30 = 563
set /a soglia_off=16896 / %VDD_C%

:: Per 3.7V batteria (1.85V pin): 1.85 * 1024 = 1894.4
:: In Batch usiamo: (18944 / VDD_C) -> 18944 / 30 = 631
set /a soglia_on=18944 / %VDD_C%

echo.
echo COPIA E INCOLLA:
echo --------------------------------------------------
echo ' Alimentazione PIC misurata: %VDD%V
echo if (valore_adc ^< %soglia_off%) then GPIO.2 = 1 end if  ' OFF (Batt ^< 3.3V)
echo if (valore_adc ^> %soglia_on%) then GPIO.2 = 0 end if  ' ON (Batt ^> 3.7V)
echo --------------------------------------------------
echo.
echo Premi [Invio] per riprovare...
pause > nul
goto start