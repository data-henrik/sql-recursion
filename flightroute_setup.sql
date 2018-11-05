-- Airline 	2-letter (IATA) or 3-letter (ICAO) code of the airline.
-- Airline ID 	Unique OpenFlights identifier for airline (see Airline).
-- Source airport 	3-letter (IATA) or 4-letter (ICAO) code of the source airport.
-- Source airport ID 	Unique OpenFlights identifier for source airport (see Airport)
-- Destination airport 	3-letter (IATA) or 4-letter (ICAO) code of the destination airport.
-- Destination airport ID 	Unique OpenFlights identifier for destination airport (see Airport)
-- Codeshare 	"Y" if this flight is a codeshare (that is, not operated by Airline, but another carrier), empty otherwise.
-- Stops 	Number of stops on this flight ("0" for direct)
-- Equipment 	3-letter codes for plane type(s) generally used on this flight, separated by spaces

connect to sample
create table AIRLINE_ROUTES  (Airline varchar(3),
              Airline_ID int,
              Source_airport varchar(4),
              Source_airport_ID int,
              Destination_airport varchar(4),
              Destination_airport_ID int,
              Codeshare char(1),
              Stops int,
              Equipment varchar(50)
  )
  
import from routes.dat of del insert into c_AIRLINE_ROUTES

select * from c_airline_routes 

drop  table AIRPORTS 
create table AIRPORTS  (Airport_ID int,
              NAME varchar(100),
              CITY varchar(100),
              COUNTRY varchar(50),
              IATA char(3),
              ICAO char(4),
              Latitude decimal(31,15), 
              Longitude decimal(31,15), 
              Altitude int,
              Timezone decimal(4,2),
              DST char(1), 
              Tz_database_timezone varchar(50),
              TYPE varchar(20),
              SOURCE varchar(20)
  )
  commit
import from airports.dat of del messages import_airport_msg.txt insert into AIRPORTS

drop  table airlines
create table airlines (
Airline_ID int,
NAME varchar(100),
ALIAS varchar(100), 
              IATA varchar(20),
              ICAO varchar(20),
              Callsign varchar(100),
              Country varchar(100),
              Active char(1)
)
commit

import from airlines.txt of del messages import_airport_msg2.txt insert into AIRLINES


SELECT count(*) FROM Airlines;
SELECT count(*) FROM Airports;
SELECT count(*) FROM Airline_Routes;

SELECT * from airports where name like '%Mushaf Air Base%'

UPDATE airports set IATA=NULL where IATA = 'NUL'
UPDATE airports set DST=NULL where DST = 'N'
UPDATE airports set TZ_DATABASE_TIMEZONE=NULL where TZ_DATABASE_TIMEZONE='NULL'

SELECT count(*) FROM c_Airlines;
SELECT count(*) FROM c_Airports;
SELECT count(*) FROM c_Airline_Routes;


select *
from airline_routes ar
inner join airlines al
   on ar.airline_id = al.airline_id
inner join airports aps
   on ar.source_airport_id = aps.airport_id
inner join airports apd
   on ar.destination_airport_id = apd.airport_id
   

select ar.source_airport, aps.city
     , ar.destination_airport, apd.city
     , al.name as airline
  from airline_routes ar
 inner join airlines al
    on ar.airline_id = al.airline_id
 inner join airports aps
    on ar.source_airport_id = aps.airport_id
 inner join airports apd
    on ar.destination_airport_id = apd.airport_id
 where source_airport = 'FRA'
   and destination_airport = 'PHL'
   

select source_airport
     , destination_airport
     , airline_id
  from airline_routes
 where source_airport = 'FRA'
   and destination_airport = 'PHL'


