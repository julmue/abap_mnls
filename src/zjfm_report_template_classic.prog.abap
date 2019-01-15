REPORT zjfm_report_template_classic.

" global definitions
CONSTANTS: gc_baz TYPE string VALUE 'baz'.

DATA: gv_result TYPE string.

" selection screen definition
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
PARAMETERS:
  " input parameters
  p_prefix TYPE string OBLIGATORY LOWER CASE DEFAULT 'foo', "initialization with defaults possible
  p_pstfix TYPE string OBLIGATORY LOWER CASE.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-001. "text element in title
  PARAMETERS:
  " radiobutton group
  p_one    RADIOBUTTON GROUP actn,
  " create directory
  p_two    RADIOBUTTON GROUP actn.
SELECTION-SCREEN END OF BLOCK b2.


* event:
* program constructor - called each time a program is loaded into an internal session
LOAD-OF-PROGRAM.


* event:
* initialization of selection screen variables
INITIALIZATION.
  input = 'report template input'(002).

  " initialization logic could be more dynamic of course
  p_pstfix = 'bar'.


* event:
* start of standard execution block of program
START-OF-SELECTION.
  PERFORM main.


* main
* spine - main orchestration routine
FORM main.
  PERFORM dispatch.
  PERFORM output USING gv_result.
ENDFORM.


" action dispatcher
" parameters are global variables
FORM dispatch.
  " action dispatcher
  IF p_one = abap_true.
    PERFORM subroutine1
      USING p_prefix p_pstfix
      CHANGING gv_result.
  ELSE.
    PERFORM subroutine2
      USING p_prefix
      CHANGING gv_result.
  ENDIF.
ENDFORM.


FORM output
  USING VALUE(iv_input) TYPE csequence.
  WRITE iv_input.
ENDFORM.


FORM subroutine1
  USING VALUE(iv_s11) TYPE csequence
        VALUE(iv_s12) TYPE csequence
  CHANGING cv_s11 TYPE csequence.

  CLEAR cv_s11.
  CONCATENATE iv_s11 iv_s12 INTO cv_s11.
ENDFORM.


FORM subroutine2
  USING VALUE(iv_s21) TYPE csequence
  CHANGING cv_s21 TYPE csequence.

  iv_s21 = cv_s21.

  TRANSLATE cv_s21 TO UPPER CASE.
ENDFORM.
