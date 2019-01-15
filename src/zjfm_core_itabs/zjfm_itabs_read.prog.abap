REPORT ZJFM_ITABS_READ.

* READING TABLE LINES WITH READ TABLE

* READ TABLE reads exaclty one line from an internal table
*   - If more than one line matches the given condition, the first line is returned.
*   - After a successful read the system field sy-tabix gets the index of the first row
*   - After a successful read the system field sy-subrc gets the value 0
*   - if the table is accessed by index and the index is smaller than 0 an runtime error is raised.
*   - if the index value is higher than the number of entries

* Three access methods:
* 1. Access by index (starting with 1)
* 2. Access by free key
* 3. Access by table key

TYPES: BEGIN OF ty_vec,
         x TYPE i,
         y TYPE i,
         z TYPE i,
       END OF ty_vec.

DATA: lt_source TYPE TABLE OF ty_vec,
      " WITH NON-UNIQUE DEFAULT KEY
      " WITH NON-UNIQUE SORTED KEY tail COMPONENTS y z,
      wa_source TYPE ty_vec.

" -> INSERT oder APPEND aus einem WA
lt_source = VALUE #(
    ( x = 1 y = 1 z = 1 )
    ( x = 1 y = 1 z = 2 )
    ( x = 1 y = 2 z = 1 )
    ( x = 1 y = 2 z = 2 )
    ( x = 2 y = 1 z = 1 )
    ( x = 2 y = 1 z = 2 )
    ( x = 2 y = 2 z = 1 )
    ( x = 2 y = 2 z = 2 )
    ( x = 2 y = 2 z = 2 )
  ).

* -----------------------------------------------------------------------------
* ACCESS BY INDEX
READ TABLE lt_source INTO wa_source INDEX 3.
* -> ( x = 1 y = 2 z = 1 )

BREAK-POINT.


* -----------------------------------------------------------------------------
* ACCESS BY FREE KEY
* Free because implicitly created.
* standard table with non-unique default key.

READ TABLE lt_source WITH KEY x = 2 INTO wa_source.
* -> ( x = 2 y = 1 z = 1 )
BREAK-POINT.

READ TABLE lt_source WITH KEY x = 2 y = 2 INTO wa_source.
* -> (x = 2 y = 2 z = 1)
BREAK-POINT.

**READ TABLE lt_source WITH KEY x = 2 y = 2 z = 2 INTO wa_source.
** -> ( x = 2 y = 2 z = 2 )
**BREAK-POINT.
**
**
** ACCESS BY TABLE KEY
**READ TABLE lt_source
**  WITH TABLE KEY tail
**  COMPONENTS y = 2 z = 2
**  INTO wa_source.
** -> ( x = 1 y = 2 z = 2 )
** IST: ( x = 2 y = 2 z = 2 ) warum ist das so?

" BREAK-POINT.


* -----------------------------------------------------------------------------
