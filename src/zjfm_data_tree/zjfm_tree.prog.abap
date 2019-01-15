*&---------------------------------------------------------------------*
REPORT ZJFM_TREE.

CLASS tree DEFINITION ABSTRACT.
ENDCLASS.

CLASS node DEFINITION FINAL INHERITING FROM tree.

  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_payload TYPE REF TO object
                            i_left    TYPE REF TO tree
                            i_right   TYPE REF TO tree.
    DATA: payload TYPE REF TO object,
          left    TYPE REF TO tree,
          right   TYPE REF TO tree.
ENDCLASS.

CLASS node IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->payload = i_payload.
    me->left = i_left.
    me->right = i_right.
  ENDMETHOD.
ENDCLASS.

CLASS leaf DEFINITION FINAL INHERITING FROM tree.
ENDCLASS.


* ---------------------
* little testclass wrapper
CLASS wrapper DEFINITION.
  PUBLIC SECTION.
    DATA: payload TYPE i.
ENDCLASS.

* -----------------------

START-OF-SELECTION.

  DATA(tree) = NEW node(
      i_left = NEW leaf( )
      i_payload = NEW wrapper( )
      i_right = NEW leaf( )
    ).

  BREAK-POINT.
