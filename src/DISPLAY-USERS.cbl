       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-USERS.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

           01 USERNAME        PIC X(50).
           01 NOME            PIC X(50).
           01 COGNOME         PIC X(50).
           01 INDIRIZZO       PIC X(255).
           01 RUOLO           PIC X(50).
       
           EXEC SQL INCLUDE SQLCA END-EXEC.
       
           PROCEDURE DIVISION.
       
           EXEC SQL DECLARE C1 CURSOR FOR
               SELECT Username, Nome, Cognome, Indirizzo, Ruolo FROM 
               Utente
           END-EXEC.
       
           EXEC SQL OPEN C1 END-EXEC.
       
           DISPLAY "Utenti registrati:"
       
           PERFORM UNTIL SQLCODE = 100
               EXEC SQL FETCH C1 INTO :USERNAME, :NOME, :COGNOME, 
               :INDIRIZZO, :RUOLO 
           END-EXEC
           IF SQLCODE = 0
           DISPLAY "User: " USERNAME " Nome: " NOME " Cognome: " COGNOME 
           " Indirizzo: " INDIRIZZO " Ruolo: " RUOLO
           END-IF
           END-PERFORM.
       
           EXEC SQL CLOSE C1 END-EXEC.
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
