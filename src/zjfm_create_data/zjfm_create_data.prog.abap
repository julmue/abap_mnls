" =============================================================================
" DYNAMIC DATA CREATION

REPORT zjfm_create_data.

START-OF-SELECTION.
  PERFORM main.

FORM main.
  PERFORM dyn_generic_data_gen_1
    USING 'mara'.

  PERFORM dyn_generic_data_gen_2.

ENDFORM.


FORM dyn_generic_data_gen_1
  USING VALUE(lv_tabtype) TYPE string.

  " field symbol with generic typing
  FIELD-SYMBOLS: <lt_generic> TYPE ANY TABLE.

  " generic reference
  DATA: ref_generic TYPE REF TO data.

  " dynamic data creation with dynamic typing
  CREATE DATA ref_generic TYPE TABLE OF (lv_tabtype).

  " pointing field-symbol to generic reference
  ASSIGN ref_generic->* TO <lt_generic>.

  " using dynamic data structure
  SELECT * FROM mara INTO TABLE <lt_generic>
    UP TO 5 ROWS.

  " generic traversal
  FIELD-SYMBOLS: <ls_generic> TYPE any.

  LOOP AT <lt_generic> ASSIGNING <ls_generic>.
    GET TIME.
  ENDLOOP.

  GET TIME.

ENDFORM.


FORM dyn_generic_data_gen_2.
  TYPES: g_tabmara TYPE TABLE OF mara.

  DATA: ls_mara TYPE REF TO mara.

  " data generation first ... without that results in short dump!!!
  CREATE DATA ls_mara.

  SELECT SINGLE * FROM mara INTO ls_test->*.

  BREAK-POINT.

ENDFORM.

" =============================================================================
" STATIC DATA CREATION
