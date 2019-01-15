*&---------------------------------------------------------------------*
report zjfm_observer_1.

* ovserver pattern
* behavioural pattern that allows dipatch state changes of a central object
* ( https://en.wikipedia.org/wiki/Observer_pattern)
*
* classes

* avoid memory leak (lapsed listener problem) use weak references
* CL_ABAP_WEAK_REFERENCE

* global logging
types: ty_state type c length 1.
types: ty_object_id type c length 4.

types: begin of ty_log,
         object_id type ty_object_id,
         time      type timestampl,
         state     type ty_state,
       end of ty_log.

data: gt_log type table of ty_log.

interface lif_observer.
  methods:
    update.
endinterface.

interface lif_subject.
  methods:
    attach importing ir_observer type ref to lif_observer,
    detach importing ir_observer type ref to lif_observer,
    notify.
endinterface.


class lcl_subject definition.
  public section.

    interfaces: lif_subject.

    methods:
      constructor importing iv_id type ty_object_id,
      set_state importing iv_state type ty_state,
      get_state returning value(ev_state) type ty_state.

  private section.
    types: begin of ty_observers,
             oref type ref to lif_observer,
           end of ty_observers.

    data: it_observers type sorted table of ty_observers
          with unique key oref.
    data: iv_state type ty_state,
          iv_id    type ty_object_id.

    methods:
      log_state.
endclass.

class lcl_subject implementation.
  method constructor.
    me->iv_id = iv_id.
  endmethod.

  method lif_subject~attach.
    insert value #( oref = ir_observer ) into table me->it_observers.
  endmethod.

  method lif_subject~detach.
    delete me->it_observers from ir_observer.
  endmethod.

  method lif_subject~notify.

    loop at me->it_observers into data(observer).
      observer-oref->update( ).
    endloop.

  endmethod.

  method set_state.
    me->iv_state = iv_state.
    me->log_state( ).
    me->lif_subject~notify( ).
  endmethod.

  method get_state.
    ev_state = me->iv_state.
  endmethod.

  method log_state.
    get time stamp field data(ts).

    append value #( object_id = me->iv_id
                    time = ts
                    state = me->get_state( ) ) to gt_log.
  endmethod.

endclass.

class lcl_observer definition.
  public section.
    interfaces: lif_observer.

    methods:
      constructor importing iv_id type ty_object_id,
      set_subject importing ir_subject type ref to lcl_subject, "could/should be in interface?
      get_state returning value(ev_state) type ty_state.
  private section.

    data: ir_subject   type ref to lcl_subject,
          iv_state     type ty_state,
          iv_id        type ty_object_id.

    methods:
      log_state.
endclass.

class lcl_observer implementation.
  method constructor.
    me->iv_id = iv_id.
  endmethod.

  method lif_observer~update.
    " todo check if me->ir_subject is bound.
    me->iv_state = me->ir_subject->get_state( ).
    me->log_state( ).
  endmethod.

  method get_state.
    ev_state = me->iv_state.
  endmethod.

  method set_subject.
    me->ir_subject = ir_subject.
  endmethod.

  method log_state.
    get time stamp field data(ts).

    append value #( object_id = me->iv_id
                    time = ts
                    state = me->get_state( ) ) to gt_log.
  endmethod.

endclass.

class demo definition.
  public section.
    class-methods:
      main.
endclass.

class demo implementation.
  method main.
    clear gt_log.

    data(sub1) = new lcl_subject( iv_id = 'sub1' ).

    data(obs1) = new lcl_observer( iv_id = 'obs1' ).
    data(obs2) = new lcl_observer( iv_id = 'obs2' ).

    obs1->set_subject( ir_subject = sub1 ).
    obs2->set_subject( ir_subject = sub1 ).

    sub1->lif_subject~attach( obs1 ).
    sub1->lif_subject~attach( obs2 ).

    break-point.

    sub1->set_state( 'X' ).
    sub1->set_state( 'Y' ).

    get time.
  endmethod.

endclass.

start-of-selection.

  data(demo) = new demo( ).

  demo=>main( ).
