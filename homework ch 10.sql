-- Find Top 10 
-- #1:  Busiest City in US  
-- a) Most Arrivals + Departures.    Hint: City, State: Count of Arrivals and Departures
USE dbda3;
SELECT 
row_number() over (order by COUNT(ARR_TIME) + COUNT(DEP_TIME) desc) as Sno,
rank () over (order by COUNT(ARR_TIME) + COUNT(DEP_TIME) desc) as Rno,
dense_rank () over (order by COUNT(ARR_TIME) + COUNT(DEP_TIME) desc) as Dno,
    ORIGIN_CITY_NAME, DEST_CITY_NAME,
    COUNT(ARR_TIME) + COUNT(DEP_TIME) AS 'Most Arrivals + Departures'
FROM
    dbda3.ontime_reporting
GROUP BY ORIGIN_CITY_NAME
LIMIT 10;
-- b) Most Delayed + Cancelled + Diverted    Hint: Carrier, Count of flights,  CANCELLED,  CANCELLATION_CODE, Diverted, Reasons ??
SELECT 
row_number() over (order by count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) desc) as Sno,
rank () over (order by count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) desc) as Rno,
dense_rank () over (order by count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) desc) as Dno,
ORIGIN_CITY_NAME, DEST_CITY_NAME, OP_UNIQUE_CARRIER Carrier,
count(if(arr_delay>=1,1,NULL)) countdelay, sum(cancelled) cancelled, sum(diverted),
count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) as "Most Delay_Cancel_Diverted",
count(*) count_flights
from dbda3.ontime_reporting
group by ORIGIN_CITY_NAME, DEST_CITY_NAME, OP_UNIQUE_CARRIER
LIMIT 25; 

-- #2:   Carriers       
-- a) Most Operated Flight for Carrier      Hint: Carrier, Count of flights.
select row_number() over (order by count(FLIGHTS) desc) as sno,
rank() over (order by count(FLIGHTS) desc) as rno,
dense_rank() over (order by count(FLIGHTS) desc) as dno,
OP_UNIQUE_CARRIER Carrier, count(FLIGHTS) Count_flight
FROM dbda3.ontime_reporting
group by op_unique_carrier
limit 10;

-- b) Most Delayed + Cancelled + Diverted    Hint: As Above.
select 
row_number() over (order by sum(DIVERTED) + sum(CANCELLED) + sum(CARRIER_DELAY) desc) as rno,
rank() over (order by sum(DIVERTED) + sum(CANCELLED) + sum(CARRIER_DELAY) desc) as rno,
dense_rank() over (order by sum(DIVERTED) + sum(CANCELLED) + sum(CARRIER_DELAY) desc) as dno,
OP_UNIQUE_CARRIER Carrier, sum(DIVERTED), sum(CANCELLED), sum(CARRIER_DELAY), 
sum(DIVERTED) + sum(CANCELLED) + sum(CARRIER_DELAY) as TOTAL_DELAYS
from dbda3.ontime_reporting
group by OP_UNIQUE_CARRIER
limit 10;

#3:   Flights      
-- a) Most Between Cities      Hint: City Pair, Count of flights.
use dbda3;
select row_number() over (order by count(*) desc) as sno,
ORIGIN_CITY_NAME, DEST_CITY_NAME, count(*) countofflights 
FROM dbda3.ontime_reporting
group by origin, dest
limit 10;

-- b) 
-- Longest      Hint: Flight#, Sum of Distance.
select row_number() over (order by round(avg(distance),2) desc) as sno,
ORIGIN_CITY_NAME, dest_CITY_NAME, round(avg(distance),2) , count(*),round(avg(CRS_ELAPSED_TIME),2), round(avg(ACTUAL_ELAPSED_TIME),2)
from dbda3.ontime_reporting
group by ORIGIN_CITY_NAME, dest_CITY_NAME
limit 10;
-- Shortest
select row_number() over (order by round(avg(distance),2)) as sno,
 ORIGIN_CITY_NAME, dest_CITY_NAME,  round(avg(distance),2), count(*),round(avg(CRS_ELAPSED_TIME),2), round(avg(ACTUAL_ELAPSED_TIME),2)
from dbda3.ontime_reporting
group by ORIGIN_CITY_NAME, dest_CITY_NAME
limit 10;

-- #4:   Day of Week      
-- a) Most Operated      Hint: Day#, Count of flights
select 
  row_number() over (order by count(*) desc) as Sno,
  case day_of_week
     when 1 then "Monday" when 2 then "Tuesday" when 3 then "Wednesday" when 4 then "Thursday"
     when 5 then "Friday" when 6 then "Saturday" when 7 then "Sunday" when 9 then "Unknown"
   END as DayOfWeek,
     count(*) numflights, min(arr_delay) minarrdelay,
     max(arr_delay) maxarrdelay, sum(arr_delay) sumarrdelay, 
     round(avg(arr_delay),2) avgarrdelay, min(dep_delay) mindepdelay,
     max(dep_delay) maxdepdelay, sum(dep_delay) sumdepdelay, 
     round(avg(dep_delay),2) avgdepdelay 
from dbda3.ontime_reporting
group by DAY_OF_WEEK;

-- b) Most Delayed + Cancelled + Diverted    Hint: As Above.
SELECT   row_number() over (order by count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) desc) as Sno,
case day_of_week
     when 1 then "Monday" when 2 then "Tuesday" when 3 then "Wednesday" when 4 then "Thursday"
     when 5 then "Friday" when 6 then "Saturday" when 7 then "Sunday" when 9 then "Unknown"
   END as DayOfWeek,
count(if(arr_delay>=1,1,NULL)) countdelay, sum(cancelled) cancelled, sum(diverted),
count(if(arr_delay>=1,1,NULL)) + sum(cancelled) + sum(diverted) as "Most Delayed + Cancelled + Diverted",
count(*) count_flights
from dbda3.ontime_reporting
group by DAY_OF_WEEK;
