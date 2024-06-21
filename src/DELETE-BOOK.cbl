       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE-BOOK.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION.
       
           01 ISBN        PIC X(13).
           01 ROW-COUNT   PIC 9(9) USAGE BINARY.
       EXEC SQL END DECLARE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           DISPLAY "Inserisci ISBN del libro da cancellare: ".
           ACCEPT ISBN.

           EXEC SQL
               SELECT COUNT(*) INTO :ROW-COUNT
               FROM Prenotazione
               WHERE codiceISBN = :ISBN
           END-EXEC.

           IF SQLCODE = 0 THEN
               IF ROW-COUNT = 0 THEN
                   EXEC SQL
                       DELETE FROM Libro WHERE ISBN = :ISBN
                   END-EXEC.

                   IF SQLCODE = 0 THEN
                       DISPLAY "Libro cancellato con successo."
                   ELSE
                       DISPLAY "Errore nella cancellazione del libro."
                       DISPLAY "Codice errore SQL: " SQLCODE
                       DISPLAY "Messaggio di errore: " SQLERRM
                   END-IF
               ELSE
                   DISPLAY "Il libro è prenotato e non può essere cancellato."
               END-IF
           ELSE
               DISPLAY "Errore nel controllo delle prenotazioni."
               DISPLAY "Codice errore SQL: " SQLCODE
               DISPLAY "Messaggio di errore: " SQLERRM
           END-IF.

           EXEC SQL
               COMMIT WORK
           END-EXEC.

           STOP RUN.
