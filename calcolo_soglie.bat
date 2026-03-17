@echo off
setlocal enabledelayedexpansion
title Calcolatore Dual-Mode (Basic/C) - Precisione 2 Decimali

:start
cls
echo ==================================================
echo      GENERATORE SOGLIE: MIKROBASIC e MIKROC
echo ==================================================
echo.
echo Inserisci il valore con il punto (es. 2.95 o 3.00)
echo.
set /p VDD="Inserisci V-LDO misurata: "

:: Pulizia spazi
set "VDD=%VDD: =%"

:: Check del punto
set "TEST_POINT=%VDD:.=%"
if "%TEST_POINT%"=="%VDD%" (
    echo.
    echo [ERRORE] MANCA IL PUNTO! Esempio: 3.00
    pause
    goto start
)

:: Gestione 2 decimali (es. 3.2 -> 320, 3 -> 300)
set "P1=" & set "P2="
for /f "tokens=1,2 delims=." %%a in ("%VDD%") do (
    set "P1=%%a"
    set "P2=%%b"
)
set "P2=%P2%00"
set "P2=%P2:~0,2%"
set "VDD_C=%P1%%P2%"

:: --- CALCOLO ADC ---
:: (1.65 * 1024) * 100 / VDD_C
set /a soglia_off=168960 / %VDD_C%
:: (1.85 * 1024) * 100 / VDD_C
set /a soglia_on=189440 / %VDD_C%

echo.
echo ==================================================
echo   PER MIKROBASIC
echo ==================================================
echo ' Alimentazione PIC: %P1%.%P2%V
echo if (valore_adc ^< %soglia_off%) then GPIO.2 = 1 end if  ' OFF (3.3V)
echo if (valore_adc ^> %soglia_on%) then GPIO.2 = 0 end if  ' ON  (3.7V)
echo.
echo ==================================================
echo   PER MIKROC
echo ==================================================
echo // Alimentazione PIC: %P1%.%P2%V
echo if (valore_adc ^< %soglia_off%) GPIO.F2 = 1; // OFF (3.3V)
echo if (valore_adc ^> %soglia_on%)  GPIO.F2 = 0; // ON  (3.7V)
echo ==================================================
echo.
echo Premi [Invio] per un nuovo calcolo...
pause > nul
goto start