       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSERT-USER.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 N-USERNAME        PIC X(50).
       01 N-PASSW           PIC X(50).
       01 N-NOME            PIC X(50).
       01 N-COGNOME         PIC X(50).
       01 N-INDIRIZZO       PIC X(255).
       01 N-RUOLO-CODICE    PIC 9(1).
       01 N-RUOLO           PIC X(50).

       PROCEDURE DIVISION.
       INSERT-USER-PARA.
           DISPLAY 'Inserisci Username: ' 
           ACCEPT N-USERNAME
           DISPLAY 'Inserisci Password: ' 
           ACCEPT N-PASSW
           DISPLAY 'Inserisci Nome: ' 
           ACCEPT N-NOME
           DISPLAY 'Inserisci Cognome: ' 
           ACCEPT N-COGNOME
           DISPLAY 'Inserisci Indirizzo: ' 
           ACCEPT N-INDIRIZZO
           DISPLAY 'Scegli il Ruolo:'
           DISPLAY '1. Operatore'
           DISPLAY '2. Amministratore'
           ACCEPT N-RUOLO-CODICE
           
           IF N-RUOLO-CODICE = 1
               MOVE "Operatore" TO N-RUOLO
           ELSE
               MOVE "Amministratore" TO N-RUOLO
           END-IF
           
           EXEC SQL
              INSERT INTO UTENTE (USERNAME, PASSW, NOME, COGNOME, 
                                                INDIRIZZO, RUOLO)
              VALUES (TRIM(BOTH ' ' FROM :N-USERNAME), 
               TRIM(BOTH ' ' FROM :N-PASSW),
               TRIM(BOTH ' ' FROM :N-NOME),
               TRIM(BOTH ' ' FROM :N-COGNOME), 
               TRIM(BOTH ' ' FROM :N-INDIRIZZO),
               TRIM(BOTH ' ' FROM :N-RUOLO))
           END-EXEC.
           
           IF SQLCODE = 0 THEN
               DISPLAY 'User inserito con successo.'
           ELSE
               DISPLAY 'Errore: ' SQLERRMC
           END-IF

           EXEC SQL
                   COMMIT
           END-EXEC.

           EXIT PROGRAM.
