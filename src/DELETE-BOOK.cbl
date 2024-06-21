       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE-BOOK.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 DEL-ISBN PIC X(20).
       01 BOOK-COUNT PIC 9(5).

       PROCEDURE DIVISION.
       DELETE-BOOK-PARA.
           CALL 'DISPLAY-BOOKS'
           DISPLAY 'Inserire ISBN del libro da eliminare: ' 
           ACCEPT DEL-ISBN
           EXEC SQL
              SELECT COUNT(*)
              INTO :BOOK-COUNT
              FROM PRENOTAZIONE
              WHERE CODICEISBN = (TRIM(BOTH ' ' FROM :DEL-ISBN))
           END-EXEC

           IF BOOK-COUNT = 0 THEN
               EXEC SQL
                  DELETE FROM LIBRO
                  WHERE ISBN = (TRIM(BOTH ' ' FROM :DEL-ISBN))
               END-EXEC
           
           IF SQLCODE = 0 THEN
               DISPLAY 'libro Eliminato con successo.' 
           ELSE
               DISPLAY 'ERRORE: ' SQLERRMC
               END-IF
           END-IF.

           EXEC SQL
                   COMMIT
           END-EXEC.

           EXIT PROGRAM.
