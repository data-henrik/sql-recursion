WITH temp1 (tabname,reftable) AS
       (
         SELECT … some properties … FROM syscat.tables AS t
              LEFT OUTER JOIN syscat.references AS r ON t.tabschema = r.tabschema AND t.tabname = r.tabname
         WHERE t.tabschema NOT LIKE  'SYS%' AND type = 'T'),
     temp2 (table, reftable,lvl) AS
       (
         SELECT tabname,reftable,1 FROM temp1
         WHERE reftable IS null AND tabname NOT IN (select tabname from temp1 where reftable is not null)
         UNION ALL
         SELECT t.tabname,t.reftable,z.lvl+1 FROM temp1 AS t, temp2 AS z
         WHERE t.reftable = z.table)
SELECT table,MAX(lvl) AS mlevel
FROM temp2
GROUP BY table
ORDER BY mlevel,table