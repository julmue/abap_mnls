*---------------------------------------------------------------------*
report zjfm_select_intro.

data: lt_sflight type hashed table of sflight
      with unique key primary_key components carrid connid fldate.
data: ls_sflight like line of lt_sflight.

select * from sflight into table lt_sflight.

get time.

clear lt_sflight.

get time.

select * from
  sflight
  into table lt_sflight
  where
  carrid = 'AA' or
  carrid = 'AC'
  order by carrid.

get time.

*---------------------------------------------------------------------*

select
    scarr~carrid,
    scarr~carrname,
    sbook~connid,
    count(*) as num_bookings
  into table @data(lt_proj)
from
    sbook
    inner join
    scarr
    on scarr~carrid = sbook~carrid
group by scarr~carrid, scarr~carrname, sbook~connid
order by num_bookings.

get time.
