       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSERT-PUBLISHER.
       ENVIRONMENT DIVISION.
       DATA DIVISION.      
       WORKING-STORAGE SECTION.
           01 SCELTA PIC 9(1).
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           01 CASA-EDITRICE.
               03 NOME PIC X(50).
               03 INDIRIZZO PIC X(50).    
       EXEC SQL END DECLARE SECTION END-EXEC.
       EXEC SQL INCLUDE SQLCA END-EXEC. 
       PROCEDURE DIVISION.
       DISPLAY " ".
       DISPLAY "------SONO INSERT PUBLISHER!".
       INIZIO.
           DISPLAY "Inserire il nome della casa editrice"
           ACCEPT NOME.
           DISPLAY "INSERIRE L'INDIRIZZO"
           ACCEPT INDIRIZZO.
           
           EXEC SQL
               INSERT INTO CasaEditrice (Nome, Indirizzo)
               VALUES (TRIM(BOTH ' ' FROM :NOME), 
                   TRIM(BOTH ' ' FROM :INDIRIZZO))
           END-EXEC.    
            IF SQLCODE = 0
                   DISPLAY 'Casa editrice inserita con successo.'
            ELSE
               DISPLAY "Si è verificato un errore." 
            END-IF.        
           EXEC SQL
               COMMIT
           END-EXEC.        
           EXIT PROGRAM.
