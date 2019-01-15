*&---------------------------------------------------------------------*
REPORT ZJFM_ITABS_DELETE.

TYPES: BEGIN OF ty_struct,
         x       TYPE i,
         y       TYPE i,
         payload TYPE string,
       END OF ty_struct,
       ty_table TYPE TABLE OF ty_struct
       WITH NON-UNIQUE DEFAULT KEY. " the whole table is the primary key

DATA(lt_table) = VALUE ty_table(
    ( x = 1 y = 1 payload = '1st row' )
    ( x = 1 y = 2 payload = '2nd row' )
    ( x = 2 y = 1 payload = '3rd row' )
    ( x = 2 y = 2 payload = '4th row' )
    ( x = 2 y = 2 payload = '5th row' )
  ).

DATA(ls_struct) = VALUE ty_struct( x = 2 y = 1 payload = '3rd row' ).

START-OF-SELECTION.

  WRITE: 'The table before deletion:', /.
  PERFORM print_table USING lt_table.

  SKIP.

  DELETE TABLE lt_table FROM ls_struct.

  WRITE: 'The table after deletion:', /.
  PERFORM print_table USING lt_table.


* ---------------------------------------------------------------------*
* DELETING WITH KEYS
* IMPORTANT:
* Obviously deleting an entry with a key only deletes the first occurence
* for non-unique keys.

  TYPES: ty_table_2 TYPE TABLE OF ty_struct WITH NON-UNIQUE KEY x.

  DATA(lt_table_2) = VALUE ty_table_2(
      ( x = 1 y = 1 payload = '1st row' )
      ( x = 1 y = 2 payload = '2nd row' )
      ( x = 2 y = 1 payload = '3rd row' )
      ( x = 2 y = 2 payload = '4th row' )
      ( x = 2 y = 2 payload = '5th row' )
    ).

  WRITE: 'The table before deletion:', /.
  PERFORM print_table_2 USING lt_table_2.

  DELETE TABLE lt_table_2 FROM VALUE #( x = 1 ).

  WRITE: 'The table after deletion', /.
  PERFORM print_table_2 USING lt_table_2.

  DELETE TABLE lt_table_2 FROM VALUE #( x = 1 ).

  WRITE: 'The table after deletion', /.
  PERFORM print_table_2 USING lt_table_2.

  DELETE TABLE lt_table_2 FROM VALUE #( x = 1 ).

  WRITE: 'The table after deletion', /.
  PERFORM print_table_2 USING lt_table_2.



* ---------------------------------------------------------------------*
* Test with plain types
  DATA: lt_ints TYPE TABLE OF i.

  lt_ints = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ( 6 ) ).

  WRITE: 'integers before deletion', /.

  LOOP AT lt_ints INTO DATA(i).
    WRITE: 'ints', i, /.
  ENDLOOP.

  DELETE TABLE lt_ints FROM 3.

  WRITE: 'integers after deletion', /.

  LOOP AT lt_ints INTO i.
    WRITE: 'ints', i, /.
  ENDLOOP.



* -----------------------------------------------------------------------------

FORM print_table USING it_table TYPE ty_table.
  LOOP AT it_table ASSIGNING FIELD-SYMBOL(<fs_struct>).
    WRITE: 'Row-data: ', <fs_struct>-payload, /.
  ENDLOOP.
ENDFORM.



FORM print_table_2 USING it_table TYPE ty_table_2.
  LOOP AT it_table ASSIGNING FIELD-SYMBOL(<fs_struct>).
    WRITE: 'Row-data: ', <fs_struct>-payload, /.
  ENDLOOP.
ENDFORM.
