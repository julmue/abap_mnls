report zjfm_factory.

* factory pattern
* https://en.wikipedia.org/wiki/Factory_method_pattern
* creational pattern - method to return one of several possible classes that share a common superclass
*
* interfaces
* 1. factory
*    - createX
*
* classes

* factory for algorithms

interface lif_algorithm.
  class-methods:
    compute importing iv_i1       type i
                      iv_i2       type i
            returning value(ev_i) type i.
endinterface.

define lcl_algorithm_meta.
  class lcl_algorithm_&1 definition.
    public section.
    interfaces:
    lif_algorithm.
    endclass.

    class lcl_algorithm_&1 IMPLEMENTATION.
      method lif_algorithm~compute.
        ev_i = iv_i1 &2 iv_i2.
        endmethod.
     endclass.
end-of-definition.

lcl_algorithm_meta sum +.
lcl_algorithm_meta prd *.

class lcl_algorithm_factory definition.
  public section.
    types: ty_token type c length 3.

    class-methods:
      create_algorithm importing iv_token            type ty_token
                       returning value(er_algorithm) type ref to lif_algorithm.

endclass.

class lcl_algorithm_factory implementation.
  method create_algorithm.
    case iv_token.
      when 'sum'.
        er_algorithm = new lcl_algorithm_sum( ).
      when 'prd'.
        er_algorithm = new lcl_algorithm_prd( ).
    endcase.
  endmethod.
endclass.

class demo definition.
  public section.
    class-methods:
      main.
endclass.

class demo implementation.
  method main.
    break-point.

    data(ic_alg) = lcl_algorithm_factory=>create_algorithm( 'sum' ).

    data(res) = ic_alg->compute( iv_i1 = 1 iv_i2 = 2 ).

    get time.
  endmethod.
endclass.

START-OF-SELECTION.

demo=>main( ).
