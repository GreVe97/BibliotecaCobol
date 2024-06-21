       IDENTIFICATION DIVISION.
       PROGRAM-ID. AGGIORNA-ACCESSI.

       ENVIRONMENT DIVISION.
       DATA DIVISION.  
       WORKING-STORAGE SECTION.
          01 USER-INPUT           PIC X(50).
          01 USERNAME             PIC X(50).
          01 NUMERO-ACCESSI       PIC 9(9).

       EXEC SQL INCLUDE SQLCA END-EXEC.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
          DISPLAY "AGGIORNA ACCESSI!".
          ACCEPT USER-INPUT.
          MOVE USER-INPUT TO USERNAME.
          PERFORM AGGIORNA-ACCESSI.
          PERFORM DISPLAY-USER-LOGINS.
          STOP RUN.

       AGGIORNA-ACCESSI.
           EXEC SQL
               UPDATE Accessi
               SET NumeroAccessi = NumeroAccessi + 1
               WHERE Username = :USERNAME
           END-EXEC.
           IF SQLCODE = 100 THEN
               EXEC SQL
                   INSERT INTO Accessi (Username, NumeroAccessi)
                   VALUES (:USERNAME, 1)
               END-EXEC.
           END-IF.
           IF SQLCODE NOT = 0 PERFORM ERROR-RUNTIME.
           DISPLAY "Accessi aggiornati per l'utente: " USERNAME.

       DISPLAY-USER-LOGINS.
           EXEC SQL
               DECLARE CURSOR-ACCESSI CURSOR FOR
               SELECT Username, NumeroAccessi FROM Accessi
           END-EXEC.
           EXEC SQL
               OPEN CURSOR-ACCESSI
           END-EXEC.
           PERFORM UNTIL SQLCODE NOT = 0
               EXEC SQL
                   FETCH CURSOR-ACCESSI INTO :USERNAME, :NUMERO-ACCESSI
               END-EXEC
               IF SQLCODE = 0 THEN
                   DISPLAY "Utente: " USERNAME ", Numero Accessi: " NUMERO-ACCESSI
               END-IF
           END-PERFORM.
           EXEC SQL
               CLOSE CURSOR-ACCESSI
           END-EXEC.

    
           STOP RUN.
