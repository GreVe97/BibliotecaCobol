       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE-PUBLISHER.

       ENVIRONMENT DIVISION.
       DATA DIVISION.      
 
       WORKING-STORAGE SECTION.
           01 LIBRI PIC 9(5) VALUE ZERO.
           01 MENU-SCELTA PIC 9(1).
           01 CODICE PIC 9(3).   
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       DISPLAY "SONO DELETE PUBLISHER!".

       INIZIO.
           DISPLAY "Queste sono tutte le case editrici: "
           CALL "DISPLAY-PUBLISHERS"
           DISPLAY "Inserire il codice del Publisher da eliminare:"
           ACCEPT CODICE.       
           EXEC SQL
               SELECT COUNT(*) INTO :LIBRI FROM Libro
               WHERE CodiceCasaEditrice =:CODICE
           END-EXEC.
           IF LIBRI = 0
              EXEC SQL
                   DELETE FROM CasaEditrice WHERE Codice = :CODICE
               END-EXEC
               IF SQLCODE = 0
                   DISPLAY 'Casa editrice eliminata con successo.'
                   EXEC SQL
                       COMMIT
                   END-EXEC
               ELSE
                   DISPLAY 'Si è verificato un errore'
                   DISPLAY SQLERRMC
               END-IF
           ELSE           
               DISPLAY "ERRORE: Il publisher ha "LIBRI" libri associati"
           END-IF.
       EXIT PROGRAM.
