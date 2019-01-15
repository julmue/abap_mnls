*&---------------------------------------------------------------------*
REPORT ZJFM_ITABS_READ_TABLE_EXPRS.

* table expressions are a different (shorter) syntax for READ TABLE statements.
*
*   - Default:
*       By default the result of a table expression is a field symbol like
*         READ TABLE ... ASSIGNING
*       If a table expression is used within a method call,
*       a field symbol is returned.
*   - VALUE:
*     VALUE forces return by value. It works like READ TABLE ... INTO

TYPES: BEGIN OF ty_vec,
         x TYPE i,
         y TYPE i,
         z TYPE i,
       END OF ty_vec.

DATA: lt_source TYPE TABLE OF ty_vec
      WITH DEFAULT KEY " this line is optional
      WITH NON-UNIQUE SORTED KEY tail COMPONENTS y z,
      wa_source TYPE ty_vec.

* this does not work.
TYPES: ty_test TYPE TABLE OF ty_vec.
* this works.
TYPES: ty_tab type standard table of ty_vec with default key.

lt_source = VALUE #(
    ( x = 1 y = 1 z = 1 )
    ( x = 1 y = 1 z = 2 )
    ( x = 1 y = 2 z = 1 )
    ( x = 1 y = 2 z = 2 )
  ).

* ACCESS VIA INDEX
wa_source = lt_source[ 2 ].
* -> ( x = 1 y = 1 z = 2 )
BREAK-POINT.

* ACCESS VIA FREE KEY
wa_source = lt_source[ y = 2 z = 2 ].
* -> ( x = 1 y = 2 z = 2 )
BREAK-POINT.

* ACCESS VIA TABLE KEY
wa_source = lt_source[ KEY tail y = 2 z = 2 ].
* -> ( x = 1 y = 2 z = 2 )
BREAK-POINT.

* obviously table expressions can be assigned to field symbols.
FIELD-SYMBOLS: <fs_vec> TYPE ty_vec.
<fs_vec> = lt_source[ 1 ].
