*&---------------------------------------------------------------------*
REPORT ZFJM_ABAP_MEMORY_EX_1.

DATA: id type c length 10 value 'TEXTS',
      lv_test_1 TYPE string VALUE 'Testvalue 1',
      lv_test_2 TYPE string VALUE 'Testvalue 2'.

WRITE: 'Content of lv_test_1:', lv_test_1, /,
       'Content of lv_test_2:', lv_test_2, /.

EXPORT lv_test_1 TO MEMORY ID 'testid'.
IMPORT lv_test_1 TO lv_test_2 FROM MEMORY ID 'testid'.

WRITE: 'Export and Import', /,
       'Content of lv_test_1:', lv_test_1, /,
       'Content of lv_test_2:', lv_test_2, /.
