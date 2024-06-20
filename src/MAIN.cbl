       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       AUTHOR. .
       INSTALLATION.  where.
       DATE-WRITTEN.  20/06/2024.
       DATE-COMPILED. 20/06/2024.
       SECURITY.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. pc.
       OBJECT-COMPUTER. pc.
       SPECIAL-NAMES.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
        FILE SECTION.
        WORKING-STORAGE SECTION.
        01 CREDENZIALI.
           05 PASSWORD-INPUT PIC X(50).
           05 USER-INPUT PIC X(50).
        01 UTENTE.
           05 USER PIC X(50).
           05 ROLE PIC X(30).
        01 SCELTA-MENU PIC 9(1).

      *****************************************************************
      *****************INIZIO DEI COMANDI SQL**************************
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DBNAME                PIC X(30) VALUE SPACE.
       01 USERNAME              PIC X(30) VALUE SPACE.
       01 PASSWORD              PIC X(30) VALUE SPACE.
       01 UTENTE-DB.
            03 USER-DB  PIC 9(4) VALUE ZERO.
            03 PASSWORD-DB  PIC X(20).
       EXEC SQL END DECLARE SECTION END-EXEC.
      ********************INCLUDO SQLCA********************************
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       INIZIO.
      ********************CONNESSIONE AL DB*****************************    
           DISPLAY "Mi connetto al database.".
           MOVE "biblioteca"             TO DBNAME
           MOVE "postgres"               TO USERNAME
           MOVE SPACE                    TO PASSWORD
           EXEC SQL
               CONNECT :USERNAME IDENTIFIED BY :PASSWORD USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RUNTIME STOP RUN.       
           DISPLAY "Conessione al database riuscita!".
          

       LOGIN.
           DISPLAY "INSERISCI USERNAME: ".
           ACCEPT USER.  
           DISPLAY "INSERISCI PASSWORD: "     
           ACCEPT PASSWORD.
           EXEC SQL 
               SELECT RUOLO INTO :ROLE FROM USER
                WHERE USER = :USER-INPUT AND PASSWORD = :PASSWORD-INPUT       
           END-EXEC. 
           IF SQLCODE NOT = ZERO PERFORM ERROR-RUNTIME. 
           DISPLAY "ROLE: "ROLE.
           EVALUATE ROLE
               WHEN "AMMINISTRATORE"
                   DISPLAY "SEI AMMINISTRATORE"
               WHEN "OPERATORE"
                   DISPLAY "SEI OPERATORE"
               WHEN "SUPER AMMINISTRATORE"
                   DISPLAY "SEI SUPER AMMINISTRATORE"
               WHEN OTHER
                   DISPLAY "LOGIN NON RIUSCITO, RIPROVA"
                   PERFORM LOGIN
           END-EVALUATE.                                                          
             STOP RUN.      

       ADMIN-MENU.



       SUPEADMIN-MENU.
           DISPLAY "1. Inserisci nuovo utente"
           DISPLAY "2. Cancella utente"
           DISPLAY "3. Visualizza Utenti"
           DISPLAY "4. Inserisci Libro"
           DISPLAY "5. Cancellare Libro"
           DISPLAY "6. Visualizza libri"
           DISPLAY "7. Inserire nuove case editrici"
           DISPLAY "8. Cancellare case editrici"
           DISPLAY "9. Vedere tutte le case editrici"
           DISPLAY "10. Vedere tutte le prenotazioni"
           DISPLAY "11. Visualizza numero di accessi"
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 CALL 'INSERT-USER'
               WHEN 2 CALL 'DELETE-USER'
               WHEN 3 CALL 'DISPLAY-USERS'
               WHEN 4 CALL 'INSERT-BOOK'
               WHEN 5 CALL 'DELETE-BOOK'
               WHEN 6 CALL 'DISPLAY-BOOKS'
               WHEN 7 CALL 'INSERT-PUBLISHER' 
               WHEN 8 CALL 'DELETE-PUBLISHER' 
               WHEN 9 CALL 'DISPLAY-PUBLISHERS' 
               WHEN 10 CALL 'DISPLAY-RESERVATIONS' 
               WHEN 11 CALL 'DISPLAY-USER-LOGINS' 
               WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM SUPEADMIN-MENU
           END-EVALUATE.




       OPERATORE-MENU.





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
