*&---------------------------------------------------------------------*
REPORT ZJFM_ITABS_READ_EXISTS_CHECK.

* READ TABLE can be used for existence checks of table entries:
*   - TRANSPORTING NO FIELDS: no data is moved.
*   - check return code of "subrc"
*     - EQ 0 if value exists
*     - NE 0 if value doesn't exist

TYPES: BEGIN OF ty_vec,
         x TYPE i,
         y TYPE i,
         z TYPE i,
       END OF ty_vec.

DATA: lt_source TYPE TABLE OF ty_vec,
      wa_source TYPE ty_vec.

lt_source = VALUE #(
    ( x = 1 y = 1 z = 1 )
    ( x = 1 y = 1 z = 2 )
  ).

READ TABLE lt_source WITH KEY x = 1 y = 1 z = 2 TRANSPORTING NO FIELDS.
BREAK-POINT.
* sy-subrc = 0
* sy-tabix = 2

READ TABLE lt_source WITH KEY x = 3 y = 3 z = 3 TRANSPORTING NO FIELDS.
BREAK-POINT.
* sy-subrc = 4
* sy-tabix = 0
