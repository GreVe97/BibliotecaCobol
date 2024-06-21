       IDENTIFICATION DIVISION.
       PROGRAM-ID. RESERVE-BOOK.

       ENVIRONMENT DIVISION.
       DATA DIVISION.     

       

       WORKING-STORAGE SECTION.
           01 PRENOTAZIONI PIC 9(5).
           01 NUOVA-PRENOTAZIONE.
               03 ISBN PIC X(50).
               03 DATA-PRENOTAZIONE PIC X(50).   
       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
          01 USER-INPUT PIC X(50).

       
       
       PROCEDURE DIVISION USING USER-INPUT.
       DISPLAY "------- SONO RESERVE-BOOK!".
       DISPLAY "Questa è la lista dei libri disponibili: "
       CALL "LIBRI-DISPONIBILI".
       DISPLAY " "
       DISPLAY "Inserisci il codice di un libro che vuoi prenotare"
       ACCEPT ISBN.

       EXEC SQL
            SELECT COUNT(*) INTO :PRENOTAZIONI FROM Prenotazione
               WHERE codiceISBN =TRIM(" " BOTH FROM :ISBN)
       END-EXEC.

           IF PRENOTAZIONI = 0
               DISPLAY "Iserisci la data della prenotazione"
               ACCEPT DATA-PRENOTAZIONE
               EXEC SQL
                   INSERT INTO Prenotazione (codiceISBN, Username, 
                      data_prenotazione)
                   VALUES (TRIM(BOTH ' ' FROM :ISBN), 
                       TRIM(BOTH ' ' FROM :USER-INPUT), 
                       TRIM(BOTH ' ' FROM :DATA-PRENOTAZIONE))
               END-EXEC
              
               IF SQLCODE = 0
                   DISPLAY 'Prenotazione effettuata con successo.'
                   EXEC SQL
                       COMMIT
                   END-EXEC
               ELSE
                   DISPLAY 'Si è verificato un errore'
                   DISPLAY SQLERRMC
               END-IF
           ELSE           
               DISPLAY "ERRORE: Il libro è gia' prenotato"
           END-IF.

       EXIT PROGRAM.
