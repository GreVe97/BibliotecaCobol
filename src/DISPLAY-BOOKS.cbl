       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-BOOKS.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
        

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
         01 DB-LIBRO.
           03  DB-ISBN                PIC 9(4) VALUE ZERO.
           03 FILLER PIC X.
           03  DB-TITOLO              PIC X(50) VALUE SPACE.
           03 FILLER PIC X.
           03  DB-AUTORE              PIC X(50) VALUE SPACE.
           03 FILLER PIC X.
           03  DB-CodiceCasaEditrice  PIC X(300) VALUE SPACE.
       EXEC SQL END DECLARE SECTION END-EXEC.
       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       DISPLAY "SONO DISPLAY BOOKS".

       EXEC SQL
           DECLARE C1 CURSOR FOR
           SELECT ISBN, TITOLO, AUTORE, CodiceCasaEditrice FROM Libro
       END-EXEC.

       EXEC SQL
           OPEN C1
       END-EXEC.

       EXEC SQL
           FETCH C1 INTO :DB-ISBN, :DB-TITOLO, :DB-AUTORE, 
           :DB-CodiceCasaEditrice
       END-EXEC.

       PERFORM UNTIL SQLCODE NOT = ZERO
           DISPLAY DB-LIBRO
           EXEC SQL
               FETCH C1 INTO :DB-ISBN, :DB-TITOLO, :DB-AUTORE, 
               :DB-CodiceCasaEditrice
           END-EXEC
       END-PERFORM.

       EXEC SQL
           CLOSE C1
       END-EXEC.

       EXIT PROGRAM.
