       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-USERS.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 UTENTI-TOTALI PIC 9(3).
        01 CONTATORE PIC 9(3) VALUE 1.
       01 DB-UTENTE.
           03 DB-USERNAME   PIC X(50) VALUE SPACE.
           03 FILLER        PIC X.
           03 DB-NOME       PIC X(50) VALUE SPACE.
           03 FILLER        PIC X.
           03 DB-COGNOME    PIC X(50) VALUE SPACE.
           03 FILLER        PIC X.
           03 DB-INDIRIZZO  PIC X(255) VALUE SPACE.
           03 FILLER        PIC X.
           03 DB-RUOLO      PIC X(50) VALUE SPACE.

           EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       DISPLAY "SONO DISPLAY UTENTI!".

           EXEC SQL
           SELECT COUNT(*) INTO :UTENTI-TOTALI FROM UTENTE
           END-EXEC.

           EXEC SQL
               DECLARE C1 CURSOR FOR
               SELECT USERNAME, NOME, COGNOME, INDIRIZZO, RUOLO
               FROM UTENTE
           END-EXEC.

           EXEC SQL
               OPEN C1
           END-EXEC.

           EXEC SQL
               FETCH C1 INTO :DB-USERNAME, :DB-NOME, :DB-COGNOME,
                      :DB-INDIRIZZO, :DB-RUOLO
           END-EXEC.

       DISPLAY "------- Utenti totali: " UTENTI-TOTALI " -----------"

       PERFORM UNTIL SQLCODE NOT = 0
           DISPLAY "Utente n." CONTATORE
           DISPLAY "Username: " DB-USERNAME
           DISPLAY "Nome: " DB-NOME
           DISPLAY "Cognome: " DB-COGNOME
           DISPLAY "Indirizzo: " DB-INDIRIZZO
           DISPLAY "Ruolo: " DB-RUOLO
           DISPLAY " - "
           
           ADD 1 TO CONTATORE
           
           EXEC SQL
           FETCH C1 INTO :DB-USERNAME, :DB-NOME, :DB-COGNOME,
                          :DB-INDIRIZZO, :DB-RUOLO
           END-EXEC
           END-PERFORM.

           EXEC SQL
               CLOSE C1
           END-EXEC.

           EXIT PROGRAM.
