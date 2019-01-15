REPORT ZJFM_ITABS_DELETE_OBJECTS.

* Deleting from a table with object references
* - objects can be used can be used as a primary key.
* - first occurence of an object is deleted.

CLASS lc_test DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_val TYPE i.
    DATA val TYPE i.
ENDCLASS.

CLASS lc_test IMPLEMENTATION.
  METHOD constructor.
    val = i_val.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: lt_table TYPE TABLE OF REF TO lc_test,
        or_1     TYPE REF TO lc_test,
        or_2     TYPE REF TO lc_test,
        or_3     TYPE REF TO lc_test,
        or_4     TYPE REF TO lc_test.

  CREATE: OBJECT or_1 EXPORTING i_val = 1,
          OBJECT or_2 EXPORTING i_val = 2,
          OBJECT or_3 EXPORTING i_val = 3.

  or_4 = or_1.

  APPEND: or_1 TO lt_table,
          or_2 TO lt_table,
          or_3 TO lt_table,
          or_4 TO lt_table.

  LOOP AT lt_table INTO DATA(ro).
    WRITE: 'Object ', ro->val, /.
  ENDLOOP.

  BREAK-POINT.

  " this deletes the first occurence of obj 1.
  DELETE TABLE lt_table FROM or_1.

  BREAK-POINT.
  SKIP.

  LOOP AT lt_table INTO ro.
    WRITE: 'Object ', ro->val, /.
  ENDLOOP.

  BREAK-POINT.

  " this deletes the second occurence of obj 1.
  DELETE TABLE lt_table FROM or_1.

  BREAK-POINT.
  SKIP.

  LOOP AT lt_table INTO ro.
    WRITE: 'Object ', ro->val, /.
  ENDLOOP.
