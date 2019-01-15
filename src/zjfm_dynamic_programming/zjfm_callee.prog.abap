REPORT zjfm_callee.

CONSTANTS: gc_test TYPE string VALUE 'testvariable'.

DATA: gv_uzeit_load TYPE sy-uzeit.
DATA: gv_uzeit_init TYPE sy-uzeit.

" event: program constructor
" run every time program is loaded in internal session
" like for every SUBMIT <program>
parameters:
  pv_input type string default 'foo'.

LOAD-OF-PROGRAM.
  gv_uzeit_load = sy-uzeit.

" event: initialization of selection fields
INITIALIZATION.
  gv_uzeit_init = sy-uzeit.

START-OF-SELECTION.
  PERFORM main.

FORM main.
  " we are in main.
  GET TIME.
ENDFORM.

FORM print_hello_world.
  " we are in hello world.
  GET TIME.
ENDFORM.

FORM print
  USING iv_input TYPE csequence.

  " we are in print
  GET TIME.
ENDFORM.
