       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-BOOKS.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
           01 LIBRI-TOTALI PIC 9(3).
           01 CONTATORE PIC 9(3) VALUE 1.
           01 DB-LIBRO.
             03  DB-ISBN                PIC 9(4) VALUE ZERO.
             03 FILLER PIC X.
             03  DB-TITOLO              PIC X(50) VALUE SPACE.
             03 FILLER PIC X(1).
             03  DB-AUTORE              PIC X(50) VALUE SPACE.
             03 FILLER PIC X.
             03  DB-CodiceCasaEditrice  PIC X(50) VALUE SPACE.       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       DISPLAY "SONO DISPLAY BOOKS!".

        EXEC SQL
           SELECT COUNT(*) INTO :LIBRI-TOTALI FROM Libro
       END-EXEC.

       EXEC SQL
           DECLARE C1 CURSOR FOR
           SELECT ISBN, TITOLO, AUTORE, CodiceCasaEditrice 
            FROM Libro
       END-EXEC.

       EXEC SQL
           OPEN C1
       END-EXEC.

       EXEC SQL
           FETCH C1 INTO :DB-ISBN, :DB-TITOLO, :DB-AUTORE, 
           :DB-CodiceCasaEditrice
       END-EXEC.
       DISPLAY "-------Libri totali: "LIBRI-TOTALI" -----------"
       PERFORM UNTIL SQLCODE NOT = ZERO
           DISPLAY "Libro n."CONTATORE
           DISPLAY "ISBN: " DB-ISBN
           DISPLAY "TITOLO: " DB-TITOLO
           DISPLAY "AUTORE: " DB-AUTORE
           DISPLAY "CodiceCasaEditrice: " DB-CodiceCasaEditrice 
           DISPLAY " - "
           ADD 1 TO CONTATORE
           EXEC SQL
               FETCH C1 INTO :DB-ISBN, :DB-TITOLO, :DB-AUTORE, 
               :DB-CodiceCasaEditrice
           END-EXEC
       END-PERFORM.

       EXEC SQL
           CLOSE C1
       END-EXEC.

       EXIT PROGRAM.
