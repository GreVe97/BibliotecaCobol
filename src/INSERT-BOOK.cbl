       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSERT-BOOK.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

           01 ISBN        PIC X(13).
           01 TITOLO      PIC X(255).
           01 AUTORE      PIC X(255).
           01 CODICE-EDITRICE PIC 9(9).

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
               INSERT INTO  LIBRO(ISBN, TITOLO, AUTORE, 
                                                   CODICECASAEDITRICE)
               VALUES (TRIM(BOTH ' ' FROM :ISBN), 
                       TRIM(BOTH ' ' FROM :TITOLO), 
                       TRIM(BOTH ' ' FROM :AUTORE), 
                       :CODICE-EDITRICE)
           END-EXEC.
           
           IF SQLCODE = 0 THEN
               DISPLAY 'Libro inserito con successo.'
           ELSE
               DISPLAY 'Errore: ' SQLERRMC
           END-IF

           EXEC SQL
                   COMMIT
           END-EXEC.

           EXIT PROGRAM.
