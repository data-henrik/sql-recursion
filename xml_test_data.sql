with mytable(mydoc,depth,fanout,level) as
 (select xmlelement(name "first",'Hello recursive world'),
  5,10, 1 as level
  from sysibm.sysdummy1
union all
  select xmlelement(name "in-between",
     xmlquery('<a>{for $i in (1 to $FANOUT)
      return <b>{$MYDOC}</b>}</a>')), 
     depth,fanout, level+1 as level
  from mytable where level<depth)
select xmlelement(name "root",mydoc) as doc
from mytable
where level=depth