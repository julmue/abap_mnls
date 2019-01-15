report zjfm_strategy.

* strategy pattern
* behavioural pattern that enables selection an algorithm at runtime
*
* classes:
* 1. cl_context:
* - consumer of algorithm
* - algorithm signature provided by interface strategy
* 2. cl_strategy:
* - concrete instantiations of if_strategy
* interfaces:
* 1. strategy
* - algorithm signature

types: begin of ty_container,
         payload type i,
       end of ty_container.
types: container type standard table of ty_container.

class lcx_empty_table definition
  inheriting from cx_static_check.
endclass.

interface lif_strategy.

  methods:
    algorithm importing it_container type container
              returning value(ev_i)  type i
              raising   lcx_empty_table.
endinterface.

class lcl_context definition.
  public section.
    methods:
      add_element importing iv_int type i,
      app_strategy returning value(ev_i) type i
                   raising   lcx_empty_table,
      set_strategy importing ir_strategy type ref to lif_strategy.

  private section.
    data: it_container type container,
          ir_strategy  type ref to lif_strategy.
endclass.

class lcl_context implementation.
  method add_element.

    data: ls_container like line of me->it_container.

    ls_container-payload = iv_int.

    append ls_container to me->it_container.

  endmethod.

  method app_strategy.
    data: l_cx type ref to lcx_empty_table.

    if not me->ir_strategy is bound.
      raise exception type lcx_empty_table.
    endif.

    ev_i = me->ir_strategy->algorithm( me->it_container ).

  endmethod.

  method set_strategy.
    me->ir_strategy = ir_strategy.
  endmethod.

endclass.

* evil macro
* &1: monoid carrier set
* &2: monoid operation
* &3: neutral element of monoid
define strategy.
  class strategy_&1 definition.
    public section.
      interfaces: lif_strategy.
  endclass.

  class strategy_&1 implementation.
    method lif_strategy~algorithm.
      if lines( it_container ) = 0.
        raise exception type lcx_empty_table.
      endif.

      ev_i = reduce #(
        init acc = &3
        for ls_container in it_container
        next acc = acc &2 ls_container-payload ).
    endmethod.
  endclass.
end-of-definition.

strategy sum + 0.
strategy prod * 1.

class demo definition.
  public section.
    class-methods:
      main.
endclass.

class demo implementation.
  method main.
    data(io_context) = new lcl_context( ).
    data(lr_strategy_sum) = new strategy_sum( ).
    data(lr_strategy_prod) = new strategy_prod( ).

    break-point.

    data(i) = 1.
    while i < 10.
      io_context->add_element( i ).
      i = i + 1.
    endwhile.

    io_context->set_strategy( lr_strategy_sum ).

    data(sum) = io_context->app_strategy( ).

    io_context->set_strategy( lr_strategy_prod ).

    data(prod) = io_context->app_strategy( ).

  endmethod.

endclass.

start-of-selection.
  demo=>main( ).
