*&---------------------------------------------------------------------*
*& Report ZJFM_READ_ABAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zjfm_read_abap.

data: lt_source type table of string.

start-of-selection.

* Read source code of include program "LMEDRUCKF1E" of function group "MEDRUCK"

read report 'LMEDRUCKF1E' into lt_source.

get time.
