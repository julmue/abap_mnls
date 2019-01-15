*&---------------------------------------------------------------------*
REPORT ZJFM_ITAB_SORT_1.

TYPES: BEGIN OF ty_struct,
         x TYPE i,
         y TYPE i,
         p TYPE string,
       END OF ty_struct.

TYPES ty_itab TYPE STANDARD TABLE OF ty_struct
   WITH NON-UNIQUE KEY x y.

DATA(itab) = VALUE ty_itab(
  ( x = 2 y = 1 p = 'B')
  ( x = 5 y = 1 p = 'G')
  ( x = 3 y = 1 p = 'D')
  ( x = 4 y = 1 p = 'E')
  ( x = 4 y = 2 p = 'F')
  ( x = 2 y = 3 p = 'C')
  ( x = 1 y = 1 p = 'A')
  ).

SORT itab BY x ASCENDING
             y ASCENDING.

BREAK-POINT.
