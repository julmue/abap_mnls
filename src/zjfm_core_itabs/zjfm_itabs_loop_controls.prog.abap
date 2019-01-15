*&---------------------------------------------------------------------*
*& Report ZJFM_ITABS_LOOP_CONTROLS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZJFM_ITABS_LOOP_CONTROLS.

* Breaking out of a loop is possible with three commands:
*   1. EXIT:
*      Completly cancels the current looping procedure.
*   2. CHECK:
*      Checks exits the current iteration if a value satisfies a gvien condition
*      - the loop continues with the next iteration.
*      The same as:
*         IF NOT log_condition.
*            CONTINUE.
*         ENDIF.
*   3. CONTINUE:
*      Continues with the next procedure.

TYPES: BEGIN OF ty_struct,
         x       TYPE i,
         y       TYPE i,
         payload TYPE string,
       END OF ty_struct,
       ty_table TYPE TABLE OF ty_struct WITH DEFAULT KEY.

FIELD-SYMBOLS: <fs_table> TYPE LINE OF ty_table.

DATA(lt_table) = VALUE ty_table(
    ( x = 1 y = 1 payload = '1st row' )
    ( x = 1 y = 2 payload = '2nd row' )
    ( x = 2 y = 1 payload = '3rd row' )
    ( x = 2 y = 2 payload = '4th row' )
    ( x = 2 y = 2 payload = '5th row' )
  ).

START-OF-SELECTION.

* -----------------------------------------------------------------------------
* CHECK: break the loop if a given condition holds and continues with the next iteration
  WRITE: 'Entering the loop', /.
  LOOP AT lt_table ASSIGNING <fs_table>.
    CHECK ( NOT sy-tabix EQ 3 ).
    WRITE: 'row: ', <fs_table>-payload, /.
  ENDLOOP.
  WRITE: 'Out of the loop; Continuing with next procedure', /.

  SKIP.
* equivalent formulation.
  WRITE: 'Entering the loop.', /.
  LOOP AT lt_table ASSIGNING <fs_table>.
    IF NOT ( NOT sy-tabix EQ 3 ).
      CONTINUE.
    ENDIF.
    WRITE: 'row: ', <fs_table>-payload, /.
  ENDLOOP.

  SKIP.

* -----------------------------------------------------------------------------
* EXIT: Completly exits the loop.

  WRITE: 'Entering the loop.', /.
  LOOP AT lt_table ASSIGNING <fs_table>.
    IF sy-tabix EQ 3.
      EXIT.
    ENDIF.
    WRITE: 'row: ', <fs_table>-payload, /.
  ENDLOOP.

* -----------------------------------------------------------------------------
* CONTINUE: Break the loop and continue with the next iteration if a certain condition holds.

  WRITE: 'Entering the loop.', /.
  LOOP AT lt_table ASSIGNING <fs_table>.
    IF sy-tabix EQ 3.
      CONTINUE.
    ENDIF.
    WRITE: 'row: ', <fs_table>-payload, /.
  ENDLOOP.
