       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-PUBLISHERS.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
           01 PUBLISHER-TOTALI PIC 9(3).
           01 CONTATORE PIC 9(3) VALUE 1.
           01 DB-PUBLISHER.
             03  DB-CODICE                PIC 9(4) VALUE ZERO.
             03 FILLER PIC X.
             03  DB-NOME              PIC X(50) VALUE SPACE.
             03 FILLER PIC X(1).
             03  DB-INDIRIZZO              PIC X(50) VALUE SPACE.      
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       DISPLAY "SONO DISPLAY PUBLISHERS!".

        EXEC SQL
           SELECT COUNT(*) INTO :PUBLISHER-TOTALI FROM CasaEditrice
       END-EXEC.

       EXEC SQL
           DECLARE C1 CURSOR FOR
           SELECT CODICE, NOME, INDIRIZZO 
            FROM CasaEditrice
       END-EXEC.

       EXEC SQL
           OPEN C1
       END-EXEC.

       EXEC SQL
           FETCH C1 INTO :DB-CODICE, :DB-NOME, :DB-INDIRIZZO           
       END-EXEC.
       DISPLAY "-------Publisher totali: "PUBLISHER-TOTALI" -----------"
       PERFORM UNTIL SQLCODE NOT = ZERO
           DISPLAY "CasaEditrice n."CONTATORE
           DISPLAY "CODICE: " DB-CODICE
           DISPLAY "NOME: " DB-NOME
           DISPLAY "INDIRIZZO: " DB-INDIRIZZO
           DISPLAY " - "
           ADD 1 TO CONTATORE
           EXEC SQL
               FETCH C1 INTO :DB-CODICE, :DB-NOME, :DB-INDIRIZZO
           END-EXEC
       END-PERFORM.

       EXEC SQL
           CLOSE C1
       END-EXEC.

       EXIT PROGRAM.
