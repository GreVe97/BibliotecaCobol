       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE-USER.
       AUTHOR. MARCO.
       DATE-WRITTEN. 20/06/2024.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           01 USERNAME PIC X(50).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.

           DISPLAY "Inserisci l'username da cancellare: ".
           ACCEPT USERNAME.

           IF USERNAME = 'Super Amministratore'
           THEN
               DISPLAY "Non è possibile cancellare il Super Amministratore."
               STOP RUN.
           END-IF.

           EXEC SQL
               DELETE FROM Utente
               Where Username :USERNAME
           END-EXEC.

           DISPLAY "Programma finito."     
           STOP RUN.

