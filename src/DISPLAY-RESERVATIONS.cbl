       IDENTIFICATION DIVISION.
       PROGRAM-ID. DISPLAY-RESERVATIONS.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
           01 PRENOTAZIONI-TOTALI PIC 9(3).
           01 CONTATORE PIC 9(3) VALUE 1.
           01  PRENOTAZIONI.
               05  CODICE-ISBN         PIC X(50).
               05  USERNAME            PIC X(50).
               05  DATA-PRENOTAZIONE   PIC X(50).
               05  TITOLO              PIC X(50).
               05  AUTORE              PIC X(50).      
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       
       PROCEDURE DIVISION.
       DISPLAY "------ SONO DISPLAY RESERVATIONS!".
       INIZIO.   
       
           EXEC SQL
               SELECT COUNT(*) INTO :PRENOTAZIONI-TOTALI 
                   FROM Prenotazione
           END-EXEC.

           EXEC SQL
               DECLARE C1 CURSOR FOR
               SELECT p.codiceISBN, p.Username, p.data_prenotazione, 
                      l.Titolo, l.Autore
               FROM Prenotazione p
               JOIN Libro l ON p.codiceISBN = l.ISBN
           END-EXEC.

           EXEC SQL
               OPEN C1
           END-EXEC.
       
           EXEC SQL
               FETCH C1 INTO
               :CODICE-ISBN, :USERNAME, :DATA-PRENOTAZIONE, :TITOLO, 
                   :AUTORE
           END-EXEC.

       DISPLAY "-------Prenotazioni totali: "PRENOTAZIONI-TOTALI.
       DISPLAY " "
           PERFORM UNTIL SQLCODE NOT = ZERO
               DISPLAY "Prenotazione n. "CONTATORE
               DISPLAY 'ISBN: ' CODICE-ISBN
               DISPLAY 'Username: ' USERNAME
               DISPLAY 'Data Prenotazione: ' DATA-PRENOTAZIONE
               DISPLAY 'Titolo Libro: ' TITOLO
               DISPLAY 'Autore: ' AUTORE
               DISPLAY " - "
               ADD 1 TO CONTATORE
               EXEC SQL
               FETCH C1 INTO
                   :CODICE-ISBN, :USERNAME, :DATA-PRENOTAZIONE, :TITOLO, 
                       :AUTORE
               END-EXEC
           END-PERFORM.
           
           EXEC SQL
               CLOSE C1
           END-EXEC.
           
       EXIT PROGRAM.
