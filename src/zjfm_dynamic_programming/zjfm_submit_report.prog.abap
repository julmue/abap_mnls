REPORT zjfm_submit_report.

START-OF-SELECTION.
  PERFORM main.

FORM main.
  PERFORM submit_static_name_return.
  PERFORM submit_dynamic_name_return
    USING 'ZJFM_CALLEE'.
  PERFORM submit_static_input.
  PERFORM submit_static_variant.
  PERFORM submit_static_name_no_return.
ENDFORM.

FORM submit_static_name_return.
  " AND RETURN: return execution to caller after callee finished
  SUBMIT zjfm_callee AND RETURN.
ENDFORM.

FORM submit_dynamic_name_return
  USING VALUE(iv_report_name) TYPE csequence.

  SUBMIT (iv_report_name) AND RETURN.

ENDFORM.

FORM submit_static_name_no_return.
  " SUBMIT without AND RETURN.
  " this will hand over the internal session to the callee
  " terminates with the callee
  SUBMIT  zjfm_callee.
ENDFORM.

FORM submit_static_input.
  SUBMIT zjfm_callee
    WITH pv_input = 'input value'
    AND RETURN.
ENDFORM.

FORM submit_static_variant.
  SUBMIT zjfm_callee
    USING SELECTION-SET 'TESTVARIANTE2'
          " WITH [par] = '[par_value]'
          AND RETURN.
ENDFORM.
