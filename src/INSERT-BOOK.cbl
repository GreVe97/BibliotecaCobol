       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSERT-BOOK.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           01 ISBN        PIC X(13).
           01 TITOLO      PIC X(255).
           01 AUTORE      PIC X(255).
           01 CODICE-EDITRICE PIC 9(9).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           DISPLAY "Inserisci ISBN del libro: ".
           ACCEPT ISBN.
           DISPLAY "Inserisci Titolo del libro: ".
           ACCEPT TITOLO.
           DISPLAY "Inserisci Autore del libro: ".
           ACCEPT AUTORE.
           DISPLAY "Inserisci Codice della Casa Editrice: ".
           ACCEPT CODICE-EDITRICE.

           EXEC SQL
               INSERT INTO Libro (ISBN, Titolo, Autore, CodiceCasaEditrice)
               VALUES (:ISBN, :TITOLO, :AUTORE, :CODICE-EDITRICE)
           END-EXEC.

           IF SQLCODE = 0 THEN
               DISPLAY "Libro inserito con successo."
           ELSE
               DISPLAY "Errore nell'inserimento del libro."
               DISPLAY "Codice errore SQL: " SQLCODE
               DISPLAY "Messaggio di errore: " SQLERRM
           END-IF.

           EXEC SQL
               COMMIT WORK
           END-EXEC.

           STOP RUN.
