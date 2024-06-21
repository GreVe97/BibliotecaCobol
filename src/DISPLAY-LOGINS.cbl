       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-LOGINS.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
        01 ACCESSO.
           03 USERNAME PIC X(50).
           03 NUMERO-ACCESSI PIC 9(5).    
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       DISPLAY "SONO DISPLAY LOGINS!".

        EXEC SQL
               DECLARE C1 CURSOR FOR
               SELECT Username, NumeroAccessi FROM Accessi
        END-EXEC.
           EXEC SQL
               OPEN C1
           END-EXEC.

               EXEC SQL
                   FETCH C1 INTO :USERNAME, :NUMERO-ACCESSI
               END-EXEC
            DISPLAY "-------Numero Accessi per utente"
           PERFORM UNTIL SQLCODE NOT = 0
              
              
                   DISPLAY "Utente: " USERNAME 
                   DISPLAY "Numero Accessi: " NUMERO-ACCESSI
                   DISPLAY " - "
                EXEC SQL
                   FETCH C1 INTO :USERNAME, :NUMERO-ACCESSI
               END-EXEC
              
           END-PERFORM.
           EXEC SQL
               CLOSE C1
           END-EXEC.

       EXIT PROGRAM.



              
         