       IDENTIFICATION DIVISION.
       PROGRAM-ID. SEARCH-BOOKS.
       AUTHOR. MARCO.
       DATE-WRITTEN. 21/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 SEARCH-OPTION PIC 9.
       01 SEARCH-VALUE PIC X(100).

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 BOOK-INFO.
           05 ISBN PIC X(13).
           05 TITOLO PIC X(100).
           05 AUTORE PIC X(50).
           05 CODICECASAEDITRICE PIC 9(10).
       EXEC SQL END DECLARE SECTION END-EXEC.

       PROCEDURE DIVISION.
       SEARCH-BOOKS-PARA.
           DISPLAY 'Cerca per: 1.Titolo 2.Autore 3.Codice Casa Editrice'
           ACCEPT SEARCH-OPTION
           IF SEARCH-OPTION = 1 THEN
               DISPLAY 'Inserisci Titolo: ' 
               ACCEPT SEARCH-VALUE
               EXEC SQL DECLARE C1 CURSOR FOR
                   SELECT ISBN, TITOLO, AUTORE, CODICECASAEDITRICE
                   FROM LIBRO
                   WHERE TITOLO LIKE '%' || 
                               TRIM(BOTH ' ' FROM :SEARCH-VALUE) || '%'
               END-EXEC
           ELSE
               IF SEARCH-OPTION = 2 THEN
                   DISPLAY 'Inserisci Autore: ' 
                   ACCEPT SEARCH-VALUE
                   EXEC SQL DECLARE C1 CURSOR FOR
                       SELECT ISBN, TITOLO, AUTORE, CODICECASAEDITRICE
                       FROM LIBRO
                       WHERE AUTORE LIKE '%' || 
                           TRIM(BOTH ' ' FROM :SEARCH-VALUE) || '%'
                   END-EXEC
               ELSE
                   IF SEARCH-OPTION = 3 THEN
                       DISPLAY 'Inserisci CODICE CASA EDITRICE: ' 
                       ACCEPT SEARCH-VALUE
                       EXEC SQL DECLARE C1 CURSOR FOR
                           SELECT ISBN, TITOLO, AUTORE, CODICECASAEDITRICE
                           FROM LIBRO
                           WHERE CODICECASAEDITRICE = :SEARCH-VALUE
                       END-EXEC
                   ELSE
                       DISPLAY 'Opzione non valida.'
                       STOP RUN
                   END-IF
               END-IF
           END-IF

           EXEC SQL OPEN C1 END-EXEC

           PERFORM FETCH-BOOK-INFO UNTIL SQLCODE <> 0

           EXEC SQL CLOSE C1 END-EXEC

           STOP RUN.

       FETCH-BOOK-INFO.
           EXEC SQL FETCH C1 INTO :ISBN, :TITOLO, :AUTORE, 
                       :CODICECASAEDITRICE 
           END-EXEC

           IF SQLCODE = 0 THEN
           DISPLAY 'ISBN: ' ISBN
           DISPLAY 'Titolo: ' TITOLO
           DISPLAY 'Autore: ' AUTORE
           DISPLAY 'Codice Casa Editrice: ' CODICECASAEDITRICE
           END-IF.

           EXIT PROGRAM.