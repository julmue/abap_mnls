REPORT zjfm_abap_string_manipulation.

CLASS lcl_dummy DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      print_world RETURNING VALUE(ret) TYPE string.
ENDCLASS.
CLASS lcl_dummy IMPLEMENTATION.
  METHOD print_world. ret = 'World!'. ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

* CHARACTER LIKE BUILT-IN TYPES (generic type: csequence)
*   - c
*   - string
*   - n
*   - d
*   - t

* -------------------------------------------------------------------------------------------------
* TYPE STRING
*
* STRING is a built-in character like type for the representation character strings of variable length.
*   - arbitrary alphanumeric symbols
*   - initial value is an empty string of length 0
*   - string declarations in singele quotes ' STRING ' drop leading and trailing spaces
*   - Strings in backticks ` <string> ` don't drop leading and trailing spaces.

* STRING DECLARATION
CONSTANTS: lv_emtpy         TYPE string VALUE ' ', " length 0 because trailing spaces are deleted
           lv_space         TYPE string VALUE ` `, " blank of length 1
           lv_prfxinfxpstfx TYPE string VALUE 'Prefix Infix Postfix',
           lv_prfx          TYPE string VALUE 'Prefix',
           lv_infx          TYPE string VALUE 'Infix',
           lv_pstfx         TYPE string VALUE 'Pstfx'.

* -------------------------------------------------------------------------------------------------
* OFFSET OPERATIONS
* Take prefix of length n
DATA(lv_str_1) = lv_prfxinfxpstfx(6).
" lv_str_1 == 'Prefix'

* Take infix of length n2-n1
DATA(lv_str_2) = lv_prfxinfxpstfx+7(5).
" lv_str_2 == 'Infix'

* Take postfix
DATA(lv_str_3) = lv_prfxinfxpstfx+13.
" lv_str_3 == 'Pstfx'

* -------------------------------------------------------------------------------------------------
* STRING CONCATENATION
* short form (Zeichenkettenoperator)
DATA(lv_str_4) = lv_prfx && lv_space && lv_infx && lv_space && lv_pstfx.
DATA(lv_str_5) = 'Hello ' && 'world!'.

* long form
CONCATENATE lv_prfx lv_infx lv_pstfx INTO DATA(lv_str_6) SEPARATED BY lv_space.
CONCATENATE lv_str_6 'something else' INTO DATA(lv_str_7) SEPARATED BY ` go go go `.

* -------------------------------------------------------------------------------------------------
* FIND substring | pattern

* --------------
" find substring
FIND 'Infix' IN lv_prfxinfxpstfx.
" ASSERT sy-subrc = 0.

FIND FIRST OCCURRENCE OF
  SUBSTRING lv_infx
  IN lv_prfxinfxpstfx.

FIND ALL OCCURRENCES OF
  SUBSTRING 'fix'
  IN lv_prfxinfxpstfx
  MATCH COUNT DATA(lv_matchcount).
" lv_matchcount == 3

FIND ALL OCCURRENCES OF
  SUBSTRING 'fix'
  IN lv_prfxinfxpstfx
  RESULTS DATA(lt_substr_findings).
" lt_substr_findings: table with start and endpositions of findings

* ------------------------
" find pattern with regular expression
" -> for list of patterns 'Ausdrücke und Funktionen für die Zeichenkettenverarbeitung'
FIND REGEX 'P*fix' IN lv_prfxinfxpstfx.
" ASSERT sy-subrc = 0.

" TODO: finds something but how does this work?
DATA(lv_pattern) = 'P*fix'.
FIND ALL OCCURRENCES OF
  REGEX lv_pattern
  IN lv_prfxinfxpstfx
  IGNORING CASE
  RESULTS DATA(lt_pattern_findings).

* -------------------------------------------------------------------------------------------------
* REPLACE substring | pattern

DATA(lv_text) = lv_prfxinfxpstfx.

REPLACE ALL OCCURRENCES OF
  SUBSTRING 'fix'
  IN lv_text
  WITH '_replacement_'
  REPLACEMENT COUNT DATA(lv_repcount)
  RESULTS DATA(lv_res).

" lv_text == 'Pre_replacement_ In_replacement_ Post_replacement_'
" lv_repcount == 3
" lv_res: some table with start and endpoints of replacements

* -------------------------------------------------------------------------------------------------
* SPLIT strings

SPLIT lv_prfxinfxpstfx
  AT ' '
  INTO TABLE DATA(it_split).

" content of table it_split:
" 1	| Prefix
" 2 | Infix
" 3 | Postfix

DATA(lv_delim) = 'fix'.
SPLIT lv_prfxinfxpstfx
  AT lv_delim
  INTO TABLE DATA(it_split2).

" content of table it_split2:
" 1	Pre
" 2	 In
" 3	 Post

* -------------------------------------------------------------------------------------------------
* CONDENSE text

DATA(lv_condense_input) = '  hello   World!    '.

CONDENSE lv_condense_input.
" lv_condense_input == 'hello World!'

CONDENSE lv_condense_input NO-GAPS.
" lv_condense_input == 'helloWorld!'

* -------------------------------------------------------------------------------------------------
* TRANSLATE text

DATA(lv_translate_input) = 'HeLlO WoRlD!'.
TRANSLATE lv_translate_input TO UPPER CASE.
" lv_translate_input == 'HELLO WORLD!'

TRANSLATE lv_translate_input TO LOWER CASE.
" lv_translate_input == 'hello world!'

* -------------------------------------------------------------------------------------------------
* String Templates

DATA(lv_template) = |Hello { lcl_dummy=>print_world( ) } and { 1 + 1 } |.
" lv_template = Hello World! and 2

BREAK-POINT.
