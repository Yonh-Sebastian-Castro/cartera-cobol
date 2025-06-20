       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARTERA.                                             *> Programa principal de la prueba

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT DET-FILE ASSIGN TO "DET.DET"                          *> Archivo con documentos
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT NIT-FILE ASSIGN TO "NIT.DET"                          *> Archivo con nombres de cliente
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT LISTADO-FILE ASSIGN TO "LISTADO.DET"                  *> Archivo de salida
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD DET-FILE.
       01 DET-REC.
           05 NIT3-DET        PIC X(10).
           05 SUC3-DET        PIC X(4).
           05 TIP-DET         PIC X(2).
           05 COM-DET         PIC X(4).
           05 DCTO-DET        PIC X(4).
           05 FECHA-VCTO-DET  PIC 9(8).
           05 SALDO-DET       PIC X(10).

       FD NIT-FILE.
       01 NIT-REC.
           05 NIT3-NIT        PIC X(10).
           05 SUC3-NIT        PIC X(4).
           05 NOMBRE-NIT      PIC X(30).

       FD LISTADO-FILE.
       01 LIST-REC         PIC X(120).

       WORKING-STORAGE SECTION.
       *> Variables de control
       01 WS-NOMBRE         PIC X(30).
       01 EOF-DET           PIC X VALUE "N".
       01 EOF-NIT           PIC X VALUE "N".
       01 WS-SALDO-REAL     PIC 9(7)V99.
       01 WS-SALDO-TXT      PIC Z(7)9.99.
       01 WS-FECHA-ANT      PIC 9(8) VALUE ZERO.
       01 WS-SUBTOTAL       PIC 9(9)V99 VALUE ZERO.
       01 WS-TOTAL          PIC 9(9)V99 VALUE ZERO.
       01 WS-LINE           PIC X(120).
       01 WS-END            PIC X VALUE "N".
       01 WS-FECHA-TEMP     PIC 9(8).
       01 WS-IDX            PIC 9(4).
       01 TMP-REG.
           05 TMP-NIT       PIC X(10).
           05 TMP-SUC       PIC X(4).
           05 TMP-NOMBRE    PIC X(30).
           05 TMP-TIP       PIC X(2).
           05 TMP-COM       PIC X(4).
           05 TMP-DCTO      PIC X(4).
           05 TMP-FECHA     PIC 9(8).
           05 TMP-SALDO     PIC 9(7)V99.
       01 WS-J              PIC 9(4).
       01 WS-J-INICIO       PIC 9(4).

       *> Tabla en memoria para almacenar registros completos
       01 TABLA-REGISTROS.
           05 REGISTRO OCCURS 100 TIMES.
               10 T-NIT          PIC X(10).
               10 T-SUC          PIC X(4).
               10 T-NOMBRE       PIC X(30).
               10 T-TIP          PIC X(2).
               10 T-COM          PIC X(4).
               10 T-DCTO         PIC X(4).
               10 T-FECHA        PIC 9(8).
               10 T-SALDO        PIC 9(7)V99.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM CARGAR-TABLA
           PERFORM ORDENAR-TABLA
           PERFORM GENERAR-REPORTE
           STOP RUN.

       *> Carga datos de archivos DET.DET y NIT.DET a la tabla
       CARGAR-TABLA.
           OPEN INPUT DET-FILE
           OPEN INPUT NIT-FILE
           MOVE 1 TO WS-IDX
           PERFORM UNTIL EOF-DET = "S"
               READ DET-FILE
                   AT END MOVE "S" TO EOF-DET
                   NOT AT END
                       MOVE SPACES TO WS-NOMBRE
                       MOVE "N"    TO EOF-NIT
                       PERFORM UNTIL EOF-NIT = "S"
                           READ NIT-FILE
                               AT END MOVE "S" TO EOF-NIT
                               NOT AT END
                                   IF NIT3-DET = NIT3-NIT AND
                                      SUC3-DET = SUC3-NIT
                                       MOVE NOMBRE-NIT TO WS-NOMBRE
                                       MOVE "S"      TO EOF-NIT
                                   END-IF
                           END-READ
                       END-PERFORM
                       MOVE NIT3-DET       TO T-NIT(WS-IDX)
                       MOVE SUC3-DET       TO T-SUC(WS-IDX)
                       MOVE WS-NOMBRE      TO T-NOMBRE(WS-IDX)
                       MOVE TIP-DET        TO T-TIP(WS-IDX)
                       MOVE COM-DET        TO T-COM(WS-IDX)
                       MOVE DCTO-DET       TO T-DCTO(WS-IDX)
                       MOVE FECHA-VCTO-DET TO T-FECHA(WS-IDX)
                       MOVE FUNCTION NUMVAL(SALDO-DET) TO
                                              T-SALDO(WS-IDX)
                       ADD 1 TO WS-IDX
                       CLOSE NIT-FILE
                       OPEN INPUT NIT-FILE
               END-READ
           END-PERFORM
           CLOSE DET-FILE
           CLOSE NIT-FILE
           EXIT.

       *> Ordenamiento burbuja por fecha descendente
       ORDENAR-TABLA.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX >= 99
               MOVE WS-IDX TO WS-J-INICIO
               ADD 1 TO WS-J-INICIO
               PERFORM VARYING WS-J FROM WS-J-INICIO BY 1 UNTIL WS-J>100
                   IF T-FECHA(WS-IDX) < T-FECHA(WS-J)
                       PERFORM INTERCAMBIAR-REGISTROS
                   END-IF
               END-PERFORM
           END-PERFORM.

       *> Intercambio de registros entre posiciones de la tabla
       INTERCAMBIAR-REGISTROS.
           MOVE T-NIT(WS-IDX)    TO TMP-NIT
           MOVE T-SUC(WS-IDX)    TO TMP-SUC
           MOVE T-NOMBRE(WS-IDX) TO TMP-NOMBRE
           MOVE T-TIP(WS-IDX)    TO TMP-TIP
           MOVE T-COM(WS-IDX)    TO TMP-COM
           MOVE T-DCTO(WS-IDX)   TO TMP-DCTO
           MOVE T-FECHA(WS-IDX)  TO TMP-FECHA
           MOVE T-SALDO(WS-IDX)  TO TMP-SALDO

           MOVE T-NIT(WS-J)      TO T-NIT(WS-IDX)
           MOVE T-SUC(WS-J)      TO T-SUC(WS-IDX)
           MOVE T-NOMBRE(WS-J)   TO T-NOMBRE(WS-IDX)
           MOVE T-TIP(WS-J)      TO T-TIP(WS-IDX)
           MOVE T-COM(WS-J)      TO T-COM(WS-IDX)
           MOVE T-DCTO(WS-J)     TO T-DCTO(WS-IDX)
           MOVE T-FECHA(WS-J)    TO T-FECHA(WS-IDX)
           MOVE T-SALDO(WS-J)    TO T-SALDO(WS-IDX)

           MOVE TMP-NIT          TO T-NIT(WS-J)
           MOVE TMP-SUC          TO T-SUC(WS-J)
           MOVE TMP-NOMBRE       TO T-NOMBRE(WS-J)
           MOVE TMP-TIP          TO T-TIP(WS-J)
           MOVE TMP-COM          TO T-COM(WS-J)
           MOVE TMP-DCTO         TO T-DCTO(WS-J)
           MOVE TMP-FECHA        TO T-FECHA(WS-J)
           MOVE TMP-SALDO        TO T-SALDO(WS-J).

       *> Genera el listado de salida con subtotales y total general
       GENERAR-REPORTE.
           OPEN OUTPUT LISTADO-FILE
           MOVE SPACES TO WS-LINE
           STRING "NIT         | SUC  | NOMBRE                         "
           "| DOCUMENTO                         | FECHA VCTO | SALDO"
               DELIMITED BY SIZE INTO WS-LINE
           END-STRING
           WRITE LIST-REC FROM WS-LINE
           MOVE 1 TO WS-IDX
           MOVE ZERO TO WS-FECHA-ANT WS-SUBTOTAL WS-TOTAL
           PERFORM UNTIL WS-IDX > 100 OR T-FECHA(WS-IDX) = ZERO
               IF T-FECHA(WS-IDX) NOT = WS-FECHA-ANT AND
                                        WS-FECHA-ANT NOT = ZERO
                   PERFORM IMPRIMIR-SUBTOTAL
                   MOVE ZERO TO WS-SUBTOTAL
               END-IF
               MOVE T-FECHA(WS-IDX) TO WS-FECHA-ANT
               ADD T-SALDO(WS-IDX)  TO WS-SUBTOTAL
               ADD T-SALDO(WS-IDX)  TO WS-TOTAL
               MOVE T-SALDO(WS-IDX) TO WS-SALDO-REAL
               MOVE WS-SALDO-REAL   TO WS-SALDO-TXT
               MOVE SPACES          TO WS-LINE
               STRING
                   T-NIT(WS-IDX)    "  | " T-SUC(WS-IDX) " | "
                   T-NOMBRE(WS-IDX) " | " T-TIP(WS-IDX) " "
                   T-COM(WS-IDX) " " T-DCTO(WS-IDX) " "
                   T-FECHA(WS-IDX) "             | "
                   T-FECHA(WS-IDX) "   | " WS-SALDO-TXT
                   DELIMITED BY SIZE INTO WS-LINE
               END-STRING
               WRITE LIST-REC FROM WS-LINE
               ADD 1 TO WS-IDX
           END-PERFORM
           PERFORM IMPRIMIR-SUBTOTAL
           MOVE WS-TOTAL      TO WS-SALDO-REAL
           MOVE WS-SALDO-REAL TO WS-SALDO-TXT
           MOVE SPACES        TO WS-LINE
           STRING "                         TOTAL GENERAL: "
           WS-SALDO-TXT
               DELIMITED BY SIZE INTO WS-LINE
           END-STRING
           WRITE LIST-REC FROM WS-LINE
           CLOSE LISTADO-FILE
           EXIT.

       *> Imprime subtotal por fecha vencimiento
       IMPRIMIR-SUBTOTAL.
           MOVE WS-SUBTOTAL   TO WS-SALDO-REAL
           MOVE WS-SALDO-REAL TO WS-SALDO-TXT
           MOVE SPACES        TO WS-LINE
           STRING "                         SUBTOTAL FECHA "
           WS-FECHA-ANT ": " WS-SALDO-TXT " "
               DELIMITED BY SIZE INTO WS-LINE
           END-STRING
           WRITE LIST-REC FROM WS-LINE.
