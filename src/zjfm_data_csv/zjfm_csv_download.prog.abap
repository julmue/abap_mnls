REPORT zjfm_csv_download.

" which table
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE title1.
PARAMETERS:
  i_tabn TYPE tabname OBLIGATORY,
  i_sep  TYPE char1 DEFAULT ';'.
SELECTION-SCREEN END OF BLOCK b1.

" where to put
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE title2.
PARAMETERS:
  i_fpath  TYPE string OBLIGATORY LOWER CASE,
  i_fname  TYPE string OBLIGATORY LOWER CASE,
  i_gui    RADIOBUTTON GROUP actn,
  i_server RADIOBUTTON GROUP actn.
SELECTION-SCREEN END OF BLOCK b3.

INITIALIZATION.
  title1 = 'what and how'.
  title2 = 'where'.
  PERFORM get_download_path.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR i_fpath.
  PERFORM f4_path.

START-OF-SELECTION.

  DATA: ref_it_tab TYPE REF TO data.
  DATA: lt_iout   TYPE TABLE OF string.
  DATA: ls_str   TYPE string.
  DATA: lv_filepath TYPE string.
  DATA: ls_xout   TYPE string.

  FIELD-SYMBOLS: <fs_it_tab> TYPE ANY TABLE.
  FIELD-SYMBOLS: <fs_wa_tab> TYPE any.
  FIELD-SYMBOLS: <fs> TYPE any.

  " TODO: this is not cross plattform ...
  CONCATENATE i_fpath i_fname INTO lv_filepath SEPARATED BY '\'.

  CREATE DATA ref_it_tab TYPE STANDARD TABLE OF (i_tabn)
  WITH DEFAULT KEY.

  ASSIGN ref_it_tab->* TO <fs_it_tab>.

  SELECT * INTO TABLE <fs_it_tab> FROM (i_tabn).

  LOOP AT <fs_it_tab> ASSIGNING <fs_wa_tab>.

    CLEAR ls_xout.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa_tab> TO <fs>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      IF sy-index = 1.
        ls_str = <fs>.
        ls_xout = ls_str.
      ELSE.
        ls_str = <fs>.
        CONCATENATE ls_xout ls_str INTO ls_xout SEPARATED BY i_sep.
      ENDIF.
    ENDDO.

    APPEND ls_xout TO lt_iout.

  ENDLOOP.

  IF i_gui = abap_true.
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename = lv_filepath
      CHANGING
        data_tab = lt_iout
      EXCEPTIONS
        OTHERS   = 1.
  ENDIF.

  IF i_server = abap_true.
    " i_path = '/tmp/output.csv'.
    OPEN DATASET lv_filepath FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
    LOOP AT lt_iout ASSIGNING <fs>.
      TRANSFER <fs> TO lv_filepath.
    ENDLOOP.
    CLOSE DATASET i_fpath.
  ENDIF.

FORM get_download_path.

*== local data
  DATA lv_upload_path    TYPE string.
  DATA lv_download_path  TYPE string.

*== get current download path
  CALL METHOD cl_gui_frontend_services=>get_upload_download_path
    CHANGING
      upload_path   = lv_upload_path
      download_path = lv_download_path.

*== set parameter
  i_fpath = lv_download_path.

ENDFORM.

FORM f4_path.

*== local data
  DATA lv_out    TYPE string.
  DATA lv_in     TYPE string.
  DATA lt_fields TYPE TABLE OF dynpread.
  DATA ls_field  TYPE dynpread.

*== get current value for path
  ls_field = 'P_PATH'.
  APPEND ls_field TO lt_fields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-cprog
      dynumb     = sy-dynnr
    TABLES
      dynpfields = lt_fields
    EXCEPTIONS
      OTHERS     = 1.

  IF sy-subrc = 0.
    READ TABLE lt_fields INTO ls_field INDEX 1.
    lv_in = ls_field-fieldvalue.
  ENDIF.

*== call popup for directory selection
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      initial_folder  = lv_in
    CHANGING
      selected_folder = lv_out
    EXCEPTIONS
      OTHERS          = 4.

  IF sy-subrc = 0 AND lv_out IS NOT INITIAL.
*== set selected path
    i_fpath = lv_out.
  ELSE.
*== set origin path
    i_fpath = lv_in.
  ENDIF.

ENDFORM.
