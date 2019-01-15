REPORT zjfm_call_report_form.

START-OF-SELECTION.

  PERFORM main.

FORM main.
  PERFORM call_form_from_dif_rep.
  PERFORM call_form_from_dif_rep_w_pars.
ENDFORM.

FORM call_form_from_dif_rep.
  " perform form in different program
  " execution gets handed back to caller
  " global variables in other program can be accessed
  PERFORM main
    IN PROGRAM zjfm_callee.
ENDFORM.

FORM call_form_from_dif_rep_w_pars.
  PERFORM print
    IN PROGRAM zjfm_callee
    USING 'hello world'.
ENDFORM.
