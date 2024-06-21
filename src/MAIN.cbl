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
        01 PARAGRAFO-PRECEDENTE PIC X(1).
        01 CREDENZIALI.
           05 PASSWORD-INPUT PIC X(50).
           05 USER-INPUT PIC X(50).
        01 WS-UTENTE.
           05 USER PIC X(50).
           05 ROLE PIC X(30).
        01 SCELTA-MENU PIC 9(3).

      *****************************************************************
      *****************INIZIO DEI COMANDI SQL**************************
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DBNAME                PIC X(30) VALUE SPACE.
       01 USERNAME-DB              PIC X(30) VALUE SPACE.
       01 PASSWORD              PIC X(30) VALUE SPACE.
       01 UTENTE.
            03 USERNAME  PIC X(20).
            03 PASSW PIC X(20).
            03 RUOLO PIC X(20).
       EXEC SQL END DECLARE SECTION END-EXEC.
      ********************INCLUDO SQLCA********************************
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       INIZIO.
      ********************CONNESSIONE AL DB*****************************    
           DISPLAY "Mi connetto al database.".
           MOVE "biblioteca@db"          TO DBNAME
           MOVE "postgres"               TO USERNAME-DB
           MOVE SPACE                    TO PASSWORD
           EXEC SQL
               CONNECT :USERNAME-DB IDENTIFIED BY :PASSWORD 
               USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RUNTIME STOP RUN.       
           DISPLAY "Conessione al database riuscita!".
          
     
       LOGIN.
           DISPLAY "INSERISCI USERNAME: ".
           ACCEPT USER-INPUT.  
           DISPLAY "INSERISCI PASSWORD: "     
           ACCEPT PASSWORD-INPUT.
           EXEC SQL 
               SELECT RUOLO INTO :ROLE FROM Utente
                WHERE USERNAME = TRIM(BOTH ' ' FROM :USER-INPUT) AND
                   PASSW = TRIM(BOTH ' ' FROM :PASSWORD-INPUT)
           END-EXEC. 
           IF SQLCODE NOT = ZERO PERFORM ERROR-RUNTIME. 
           DISPLAY "ROLE: "ROLE.
           EVALUATE ROLE
               WHEN "Amministratore"
                   DISPLAY "Sei amministratore"
               WHEN "Operatore"
                   DISPLAY "Sei Operatore"
                   PERFORM OPERATORE-MENU
               WHEN "Super Amministratore"
                   DISPLAY "SEI SUPER AMMINISTRATORE"
                   PERFORM SUPEADMIN-MENU
               WHEN OTHER
                   DISPLAY "LOGIN NON RIUSCITO, RIPROVA"
                   PERFORM LOGIN
           END-EVALUATE.                                                          
             STOP RUN.      

       ADMIN-MENU.
           MOVE "A" TO PARAGRAFO-PRECEDENTE
           DISPLAY "------ ADMIN MENU ------"
           DISPLAY "1. Gestione Utente "
           DISPLAY "2. Gestione Libro"
           DISPLAY "3. Gestione Publisher" 
           DISPLAY "10. Vedere tutte le prenotazioni" 
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 PERFORM GESTIONE-UTENTE-MENU
               WHEN 2 PERFORM GESTIONE-LIBRI-MENU 
               WHEN 7 CALL 'INSERT-PUBLISHER' 
               WHEN 8 CALL 'DELETE-PUBLISHER' 
               WHEN 9 CALL 'DISPLAY-PUBLISHERS' 
               WHEN 10 CALL 'DISPLAY-RESERVATIONS' 
               WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM ADMIN-MENU
           END-EVALUATE.
       SUPEADMIN-MENU.
           MOVE "S" TO PARAGRAFO-PRECEDENTE
           DISPLAY "------SUPER ADMIN MENU ------"
           DISPLAY "1. Gestione Utente "
           DISPLAY "2. Gestione Libro"
           DISPLAY "3. Gestione Publisher"
           DISPLAY "4. Vedere tutte le prenotazioni"
           DISPLAY "5. Visualizza numero di accessi"
           DISPLAY "0. Esci dal programma"
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 PERFORM GESTIONE-UTENTE-MENU
               WHEN 2 PERFORM GESTIONE-LIBRI-MENU
               WHEN 3 PERFORM GESTIONE-PUBLISHER-MENU 
               WHEN 4 CALL 'DISPLAY-RESERVATIONS' 
               WHEN 5 CALL 'DISPLAY-USER-LOGINS'
               WHEN 0 STOP RUN 
               WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM SUPEADMIN-MENU
           END-EVALUATE.
       OPERATORE-MENU.
            DISPLAY "------OPERATORE MENU ------"
            DISPLAY "1. Visualizza libri" 
            DISPLAY "2. Visualizza case editrici" 
            DISPLAY "3. Visualizza libri per chiave di ricerca" 
            DISPLAY "4. Prenotare un libro" 
            DISPLAY "Scegli un'opzione: " 
            ACCEPT SCELTA-MENU.
            EVALUATE SCELTA-MENU 
               WHEN 1 CALL 'DISPLAY-BOOKS' 
               WHEN 2 CALL 'DISPLAY-PUBLISHERS' 
               WHEN 3 CALL 'SEARCH-BOOKS' 
               WHEN 4 CALL 'RESERVE-BOOK'USING BY CONTENT USER-INPUT
                WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM OPERATORE-MENU 
            END-EVALUATE.

       GESTIONE-UTENTE-MENU.
           DISPLAY "----- Menu' gestione Utente"
           DISPLAY "1. Inserisci nuovo utente" 
           DISPLAY "2. Cancella utente" 
           DISPLAY "3. Visualizza Utenti"
           DISPLAY "0. Torna indietro"
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 CALL 'INSERT-USER' 
               WHEN 2 CALL 'DELETE-USER' 
               WHEN 3 CALL 'DISPLAY-USERS'
               WHEN 0 PERFORM INDIETRO
               WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM GESTIONE-UTENTE-MENU 
            END-EVALUATE.

       GESTIONE-LIBRI-MENU.
           DISPLAY "----- Menu' gestione Libri"
           DISPLAY "1. Inserisci Libro"
           DISPLAY "2. Cancellare Libro"
           DISPLAY "3. Visualizza libri"
           DISPLAY "0. Torna indietro"
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 CALL 'INSERT-BOOK' 
               WHEN 2 CALL 'DELETE-BOOK' 
               WHEN 3 CALL 'DISPLAY-BOOKS'
               WHEN 0 PERFORM INDIETRO
           WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM GESTIONE-LIBRI-MENU 
            END-EVALUATE.

       GESTIONE-PUBLISHER-MENU.
           DISPLAY "1. Inserire nuove case editrici"
           DISPLAY "2. Cancellare case editrici"
           DISPLAY "3. Vedere tutte le case editrici"
           DISPLAY "0. Torna indietro"
           DISPLAY "Scegli un'opzione: " 
           ACCEPT SCELTA-MENU.
           EVALUATE SCELTA-MENU
               WHEN 1 CALL 'INSERT-PUBLISHER' 
               WHEN 2 CALL 'DELETE-PUBLISHER' 
               WHEN 3 CALL 'DISPLAY-PUBLISHER'
               WHEN 0 PERFORM INDIETRO
           WHEN OTHER 
                   DISPLAY "Invalid option." 
                   PERFORM GESTIONE-PUBLISHER-MENU 
            END-EVALUATE.
            
       INDIETRO.
           EVALUATE PARAGRAFO-PRECEDENTE
               WHEN "S" PERFORM SUPEADMIN-MENU
               WHEN "A" PERFORM ADMIN-MENU
           END-EVALUATE.

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
