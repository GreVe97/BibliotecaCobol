       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSERT-USER.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

      
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           01 USERNAME        PIC X(50).
           01 PASSW           PIC X(50).
           01 NOME            PIC X(50).
           01 COGNOME         PIC X(50).
           01 INDIRIZZO       PIC X(255).
           01 RUOLO-CODICE    PIC 9(1).  
           01 RUOLO           PIC X(50).
       
       EXEC SQL END DECLARE SECTION END-EXEC.
      ********************INCLUDO SQLCA*********************************
       EXEC SQL INCLUDE SQLCA END-EXEC.
      ******************************************************************

       PROCEDURE DIVISION.
       
           DISPLAY "Inserisci Username: " 
           ACCEPT USERNAME
           DISPLAY "Inserisci Password: " 
           ACCEPT PASSW
           DISPLAY "Inserisci Nome: " 
           ACCEPT NOME
           DISPLAY "Inserisci Cognome: " 
           ACCEPT COGNOME
           DISPLAY "Inserisci Indirizzo: " 
           ACCEPT INDIRIZZO
           DISPLAY "Scegli il Ruolo:"
           DISPLAY "1. Operatore"
           DISPLAY "2. Amministratore"
           ACCEPT RUOLO-CODICE
           
           IF RUOLO-CODICE = 1
               MOVE "Operatore" TO RUOLO
           ELSE
               MOVE "Amministratore" TO RUOLO
           END-IF
           
           EXEC SQL
               INSERT INTO Utente (Username, Passw, Nome, Cognome, 
                                   Indirizzo, Ruolo)
               VALUES (:USERNAME, :PASSW, :NOME, :COGNOME, :INDIRIZZO, 
                       :RUOLO)
           END-EXEC

           IF SQLCODE = 0
               DISPLAY "Utente inserito con successo."
           ELSE
               DISPLAY "Errore nell'inserimento dell'utente. SQLCODE: " 
               SQLCODE
           END-IF.
      *********************FINISH***************************************
           DISPLAY "Programma finito" 
           STOP RUN.
      ********************VISUALIZZAZIONI ERRORI************************ 
           ERROR-RUNTIME.
               DISPLAY "*********SQL ERROR***********"
               EVALUATE SQLCODE
                 WHEN +10
                      DISPLAY "RECORD NOT FOUND"
                 WHEN -01
                      DISPLAY "CONNESSIONE FALLITA"
                 WHEN -20
                      DISPLAY "INTERNAL ERROR"
                 WHEN -30
                      DISPLAY "ERRORE POSTGRES"
                      DISPLAY "ERRCODE: " SQLSTATE
                      DISPLAY SQLERRMC
                 WHEN OTHER
                      DISPLAY "ERRORE SCONOSCIUTO"
                      DISPLAY "ERRCODE: " SQLSTATE
                      DISPLAY SQLERRMC
           STOP RUN.
