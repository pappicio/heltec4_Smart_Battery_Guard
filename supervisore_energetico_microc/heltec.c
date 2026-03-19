// --- Dichiarazione Variabili ---
unsigned int valore_adc;
unsigned long batteria_mv; // Usiamo Long per i calcoli dei millivolt
unsigned char i;
unsigned int secondi_contatore;
bit in_manutenzione;

// --- Procedure ---
void Salva_EEPROM() {
    valore_adc = ADC_Read(1);
    // Calcoliamo i millivolt (Assumendo alimentazione PIC = 5.1V precisi)
    batteria_mv = (unsigned long)valore_adc * 5100 >> 10;

    // Byte 0-1: ADC Grezzo
    EEPROM_Write(0, (unsigned char)(valore_adc >> 8)); Delay_ms(20);
    EEPROM_Write(1, (unsigned char)(valore_adc & 0xFF)); Delay_ms(20);
    
    // Byte 2: Il tuo SEPARATORE FF
    EEPROM_Write(2, 0xFF); Delay_ms(20);

    // Byte 3-6: Millivolt (4 byte per un Long)
    EEPROM_Write(3, (unsigned char)(batteria_mv >> 24)); Delay_ms(20);
    EEPROM_Write(4, (unsigned char)(batteria_mv >> 16)); Delay_ms(20);
    EEPROM_Write(5, (unsigned char)(batteria_mv >> 8));  Delay_ms(20);
    EEPROM_Write(6, (unsigned char)(batteria_mv & 0xFF)); Delay_ms(20);
}

// ... (Procedura Segnale_Avvio e Init_Hardware rimangono uguali) ...

void main() {
    Init_Hardware();
    secondi_contatore = 300; // Forza lettura immediata all'avvio

    while (1) {
        // --- GESTIONE TASTO (Logica Manutenzione) ---
        if (GPIO.F0 == 0) {
            i = 0;
            while (GPIO.F0 == 0 && i < 50) { Delay_ms(100); i++; if (i >= 10) GPIO.F5 = 1; }

            if (i >= 10 && i < 50) { // Reset rapido
                Salva_EEPROM();
                GPIO.F2 = 1; Delay_ms(1000); GPIO.F2 = 0; // Spegne e riaccende
                secondi_contatore = 0;
            }

            if (i >= 50) { // Entra in Manutenzione
                Salva_EEPROM();
                GPIO.F2 = 1; // FORZA SPEGNIMENTO (Logica inversa: 1 = OFF)
                // ... (Loop manutenzione uguale a prima) ...
                in_manutenzione = 1;
                while(in_manutenzione) { 
                    // Gestione uscita manutenzione (omessa per brevità, uguale al tuo)
                }
                GPIO.F2 = 0; // Torna ON
            }
        }

        // --- LOGICA ADC MILLIVOLT ---
        if (!in_manutenzione) {
            secondi_contatore++;
            if (secondi_contatore >= 300) { // Ogni 30 secondi (se delay_ms è 100)
                valore_adc = ADC_Read(1);
              
             // 5000=5000mv=5V, se fosse 50.1, scriveremmo: 5010
                batteria_mv = (unsigned long)valore_adc * 5000 >> 10;

                // LOGICA ISTERESI INVERTITA (1 = OFF, 0 = ON)
                if (batteria_mv <= 3300) {
                    GPIO.F2 = 1; // BATTERIA SCARICA -> SPEGNE (Sollecita pin)
                }
                if (batteria_mv >= 3700) {
                    GPIO.F2 = 0; // BATTERIA CARICA -> ACCENDE (Rilascia pin)
                }
                
                secondi_contatore = 0;
            }
        }
        Delay_ms(100);
    }
}
