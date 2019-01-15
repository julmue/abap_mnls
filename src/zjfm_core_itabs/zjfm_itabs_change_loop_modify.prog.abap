REPORT ZJFM_ITABS_CHANGE_LOOP_MODIFY.

* MODIFY
*
* Modify makes it possible to change multiple rows with the same condition.
* Specify the rows to change with:
*   - index
*   - key
*   - if none of the above is specified the primary key is used.
*
* syntax:
*
* MODIFY TABLE itab {[USING KEY schluessel] | INDEX idx [USING KEY keyname]}
*   FROM structure
*   [TRANSPORTING spalte1 spalte 2 ...].

TYPES: BEGIN OF ty_struct,
         x       TYPE i,
         y       TYPE i,
         payload TYPE string,
       END OF ty_struct,
       ty_table TYPE TABLE OF ty_struct
       WITH KEY primary_key COMPONENTS x.
"   with NON-UNIQUE SORTED KEY secondary_key COMPONENTS x y.

DATA: lt_proto TYPE ty_table,
      lt_test  LIKE lt_proto.

lt_proto = VALUE ty_table(
    ( x = 1 y = 1 payload = 'row 1' )
    ( x = 1 y = 2 payload = 'row 2' )
    ( x = 2 y = 1 payload = 'row 3' )
    ( x = 2 y = 2 payload = 'row 4' )
  ).

lt_test = lt_proto.

WRITE: 'Before mod.', /.
PERFORM print_table USING lt_proto.

DATA(ls_mod) = VALUE ty_struct( x = 2 y = 1 payload = 'mod' ).

MODIFY TABLE lt_test "USING KEY primary_key
  FROM ls_mod. "TRANSPORTING payload.

WRITE: 'After mod.', /.
PERFORM print_table USING lt_proto.



" lt_test

FORM print_table USING i_tab TYPE ty_table.
  LOOP AT i_tab ASSIGNING FIELD-SYMBOL(<fs_row>).
    WRITE: 'row data: ', <fs_row>-payload, /.
  ENDLOOP.
ENDFORM.
