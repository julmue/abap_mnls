report zjfm_itab_def.

types: begin of ty_struct,
         x type i,            " Primary Key Component 1
         y type i,            " Primary Key Component 2
         z type i,            " Secondary Key
         p type string,       " Payload field
       end of ty_struct.

" Defining a primary key
" Primay keys turn a table into a (finite) function.
types ty_itab type standard table of ty_struct
      with key x y " Alternative: WITH KEY primary_key COMPONENTS x y => 'primary_key' gets created
      with non-unique sorted key secondary_key components z.

types ty_binary_itab type sorted table of ty_struct
      with unique key primary_key components x y
      with non-unique sorted key secondary_key components z.

types ty_hashed_itab type HASHED TABLE OF ty_struct
      with UNIQUE key PRIMARY_KEY COMPONENTS x y
      with NON-UNIQUE SORTED KEY secondary_key COMPONENTS z.

" -------------------------------------------------------------------------------------------------
" Data Definition

data(itab) = value ty_itab(
  ( x = 1 y = 1 z = 1 p = 'A' )
  ( x = 1 y = 2 z = 2 p = 'B' )
  ( x = 1 y = 3 z = 3 p = 'C' )
  ).

get time.

data(binary_itab) = value ty_itab(
  ( x = 1 y = 1 z = 1 p = 'A' )
  ( x = 1 y = 2 z = 2 p = 'B' )
  ( x = 1 y = 3 z = 3 p = 'C' )
  ).

get time.

data(hashed_itab) = value ty_itab(
  ( x = 1 y = 1 z = 1 p = 'A' )
  ( x = 1 y = 2 z = 2 p = 'B' )
  ( x = 1 y = 3 z = 3 p = 'C' )
  ).

get time.

" -------------------------------------------------------------------------------------------------
" TABLE Filling

insert value #( x = 1 y = 4 z = 4 p = 'E' ) into table itab.

get time.

insert value #( x = 1 y = 4 z = 4 p = 'E' ) into table binary_itab.

get time.


" -------------------------------------------------------------------------------------------------
" Reading data

" using primary key
data(target_1) = itab[ x = 1 y = 2 ].
" Equivalent: READ TABLE itab INTO DATA(target) WITH TABLE KEY x = 1 y = 2.
"             READ TABLE itab INTO DATA(target) WITH TABLE KEY primary_key COMPONENTS x = 1 y = 1.

" using secondary key
data(target_2) = itab[ key secondary_key z = 3 ].
" Equivalent: READ TABLE itab INTO DATA(target) WITH TABLE KEY secondary_key COMPONENTS z = 3.


" -------------------------------------------------------------------------------------------------
" Changing Data

" ONE LINE - MODIFY TABLE itab

" using primary key
modify table itab from value #( x = 1 y = 2 p = 'Z' ) transporting p.
" MODIFY TABLE itab USING KEY primary_key FROM VALUE #( x = 1 y = 2 p = 'Z' ) TRANSPORTING p.

" using secondary key
modify table itab using key secondary_key from value #( z = 3 p = 'Z' ) transporting p.

" MULTIPLE LINES - ONLY MODITY itab
modify itab from value #( p = 'z' ) transporting p where x eq 1.


get time.

" -------------------------------------------------------------------------------------------------
" Deleting Data

" Delete one line with primary key
delete table itab from value #( x = 1 y = 1 ).

" Delete one line with secondary key
delete table itab from value #( z = 3 ) using key secondary_key.
