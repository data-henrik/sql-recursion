with temp (source_airport, destination_airport, airline_id, hops, route) as (
SELECT source_airport, destination_airport, airline_id, 0 as hops, cast(source_airport || '->' || destination_airport as varchar(500)) as route
  FROM airline_routes ar
 WHERE source_airport = 'FRA'
   AND exists (SELECT 1 FROM airline_routes WHERE destination_airport = 'PHL'  
                                              AND airline_id = ar.airline_id)
 UNION ALL
SELECT ar.source_airport, ar.destination_airport, ar.airline_id, t.hops + 1 as hops
     , cast(route || '->' || ar.destination_airport as varchar(500)) as route
  FROM temp t, airline_routes ar
 WHERE ar.source_airport = t.destination_airport
   AND ar.airline_id = t.airline_id
   AND LOCATE_IN_STRING(t.route, ar.destination_airport) = 0
   AND ar.source_airport <> 'PHL'
   AND t.hops < 3        )
SELECT * FROM temp WHERE destination_airport = 'PHL'