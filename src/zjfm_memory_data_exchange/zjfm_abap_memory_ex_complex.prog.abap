*&---------------------------------------------------------------------*
* ACHTUNG ... das funktioniert so nicht!!!!


REPORT ZJFM_ABAP_MEMORY_EX_COMPLEX.

TYPES: BEGIN OF ty_complex_struct,
         field_1 TYPE i,
         field_2 TYPE string,
       END OF ty_complex_struct.

DATA: ls_test_1 TYPE ty_complex_struct,
      lv_i TYPE i VALUE 666,
      lv_string TYPE string VALUE 'Initial value'.

ls_test_1-field_1 = 42.
ls_test_1-field_2 = 'Field value'.

EXPORT ls_test_1 TO MEMORY ID 'testid'.

WRITE: 'Value of lv_i: ', lv_i, /,
       'Value of lv_string: ', lv_string, /.

IMPORT lv_test_1-field_1 TO lv_i FROM MEMORY ID 'testid'.
IMPORT lv_test_2-field_2 TO lv_string FROM MEMORY ID 'testid'.

WRITE: 'Value of lv_i: ', lv_i, /,
       'Value of lv_string: ', lv_string, /.

* Freeing the ABAP memory id
* Equivalent to FREE MEMORY ID id.
DELETE FROM MEMORY ID 'testid'.
