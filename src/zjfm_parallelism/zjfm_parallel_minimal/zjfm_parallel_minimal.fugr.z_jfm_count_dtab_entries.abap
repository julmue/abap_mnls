function z_jfm_count_dtab_entries.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_TABNAME) TYPE  TABNAME
*"  EXPORTING
*"     REFERENCE(EV_LINES) TYPE  INT8
*"  EXCEPTIONS
*"      TABLE_NOT_EXISTS
*"----------------------------------------------------------------------

  try.

      select count( * ) from (iv_tabname) into ev_lines.

    catch cx_sy_dynamic_osql_semantics.

      raise table_not_exists.

  endtry.

endfunction.
