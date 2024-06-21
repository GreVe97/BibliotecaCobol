       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE-USER.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 DEL-USERNAME PIC X(20).

       PROCEDURE DIVISION.
       DELETE-USER-PARA.
           DISPLAY 'Inserisci username da eliminare: ' 
           ACCEPT DEL-USERNAME
           IF DEL-USERNAME = "Super Amministratore" THEN
               DISPLAY 'NON PUOI ELIMINARE SUPER Admin.'
           ELSE
               EXEC SQL
                   DELETE FROM UTENTE
                   WHERE USERNAME = (TRIM(BOTH ' ' FROM :DEL-USERNAME))
               END-EXEC

           IF SQLCODE = 0 THEN
               DISPLAY 'Utente Eliminato con successo.' 
           ELSE
               DISPLAY 'ERRORE: ' SQLERRMC
               END-IF
           END-IF.

           EXEC SQL
                   COMMIT
           END-EXEC.

           EXIT PROGRAM.
