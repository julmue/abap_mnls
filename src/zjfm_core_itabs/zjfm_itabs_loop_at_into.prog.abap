REPORT ZJFM_ITABS_LOOP_AT_INTO.

* LOOP AT is a classic iterator over an internal table and allows to read data row-wise
*   - With every step a row gets assigned to a structure or field-symbol;
*     and thus is accessible within the body of the LOOP ... ENDLOOP construct.
*   - If row can be read the statements within the body of the loop are skipped.
*   - Two possibilities
*     1. LOOP AT i_tab INTO structure [FROM index1 TO index2] [WHERE ...].
*         Pass-By-Value: Copy the row into a local structure
*     2. LOOP AT i_tab ASSIGNING <field-symbol>
*         Pass-By-Reference: Set a pointer (field-symbol) to a specific row.
*
* IMPORTANT LESSON:
* - structures declared with data in the head of a loop are not local to the loop!!!!!

TYPES: BEGIN OF ty_vec,
         x       TYPE i,
         y       TYPE i,
         payload TYPE string,
       END OF ty_vec,
       ty_table TYPE TABLE OF ty_vec WITH NON-UNIQUE DEFAULT KEY.

DATA(lt_test) = VALUE ty_table(
    ( x = 1 y = 1 payload = '1st row' )
    ( x = 1 y = 2 payload = '2nd row' )
    ( x = 2 y = 1 payload = '3rd row' )
    ( x = 2 y = 2 payload = '4th row' )
    ( x = 2 y = 2 payload = '5th row' )
  ).

START-OF-SELECTION.

  WRITE: 'Using LOOP AT ... INTO ...', /.

* Important:
* - Changes to values apply to the local structure only and, because it is a copy,
*   are not propagated back to the internal table.

* testing the loop construct.
  LOOP AT lt_test INTO DATA(wa_test).
    WRITE: 'row: ', wa_test-payload, /.

    " changes to internal values are not propagated back ...
    wa_test-payload = 'update'.
  ENDLOOP.

  " ... as can be seen here
  SKIP.

  LOOP AT lt_test INTO wa_test.
    WRITE: 'row: ', wa_test-payload, /.
  ENDLOOP.

  ULINE.
  SKIP.

  WRITE: 'Using LOOP AT ... INTO ... WHERE ...', /.

  LOOP AT lt_test INTO wa_test WHERE y EQ 2.
    WRITE: 'row: ', wa_test-payload, /.

  ENDLOOP.

  " Changing internal tables from within a LOOP AT ... INTO ...-loop.
  " modify can be used to change the content of one or more rows in an internal table
  ULINE.
  WRITE: 'Modifying internal tables from with LOOP AT ... INTO and work area', /.

  write: 'Values to be changed ...', /.
  LOOP AT lt_test INTO wa_test WHERE y EQ 2.
    WRITE: 'row: ', wa_test-payload, /.
    wa_test-payload = 'modification'.
    MODIFY lt_test FROM wa_test. " or modify
  ENDLOOP.

  SKIP.
  " the updated loop.
  Write: 'Table with updated content ...', /.
  LOOP AT lt_test INTO wa_test.
    WRITE: 'row: ', wa_test-payload, /.
  ENDLOOP.
