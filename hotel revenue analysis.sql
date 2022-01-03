create database hotel_revenue_db;

use hotel_revenue_db;

SELECT * from hotel_revenue2018;

SELECT * from hotel_revenue2019;

SELECT * from hotel_revenue2020; 

-- Ran the above 3 codes individually and then together, 40k rows. Going to see how union affects the output

SELECT * from hotel_revenue2018
union
SELECT * from hotel_revenue2019
union
SELECT * from hotel_revenue2020; 
 -- this brough 100k rows.. 
-- the difference is simply. the first combined code didnt really combine them, it was bringing the out as different table (like Excel worksheets). the latter joined them as one table.

## Now, unto the proper business. How is the Hotel Business revenue growing?

## firstly, name the combined tables.

with hotels as (
SELECT * from hotel_revenue2018
union
SELECT * from hotel_revenue2019
union
SELECT * from hotel_revenue2020)
select * from hotels; 
-- the above gives same data.. 
## to create a stored procedure though


SELECT * from hotel_revenue2018 as source
union
SELECT * from hotel_revenue2019 as source
union
SELECT * from hotel_revenue2020 as source;

-- attempts to store it have not worked but it seems it shouldn't. I want it as a table actually, not a function, not necessarily a procedure. Let's goooo
create table Full_revenue
as
SELECT * from hotel_revenue2018 as source
union
SELECT * from hotel_revenue2019 as source
union
SELECT * from hotel_revenue2020 as source;

select * from full_revenue;

-- yes, it worked!


-- no revenue column but ADR and total stays in weekend nights and week nights. create another column where you add this info

select (stays_in_week_nights + stays_in_weekend_nights)*adr as revenue
from full_revenue;

-- does it increase by year?
select	arrival_date_year, (stays_in_week_nights + stays_in_weekend_nights)*adr as revenue
from full_revenue; 

select	arrival_date_year, sum(stays_in_week_nights + stays_in_weekend_nights)*adr as revenue
from full_revenue
group by arrival_date_year; 


-- also view by hotel type
select	hotel, arrival_date_year, sum(stays_in_week_nights + stays_in_weekend_nights)*adr as revenue
from full_revenue
group by arrival_date_year, hotel; 

-- resort hotel 2020 had too many zeroes after the decimal point. Gotta clip those wings
select	 arrival_date_year, hotel, round(sum(stays_in_week_nights + stays_in_weekend_nights)*adr,2) as revenue
from full_revenue
group by  hotel, arrival_date_year;
-- looks well groomed now.

select * from mkt_segment;
select * from meal_cost;


select * from full_revenue;

-- jon full_revenue and market segment tables..


select * from full_revenue
join
mkt_segment
on full_revenue.market_segment = mkt_segment.market_segment
left join
meal_cost
on meal_cost.meal = full_revenue.meal;

-- erm, let's move to Power BI and see how it looks. Especially this last query. it's not saved.. 

use hotel_revenue_db;
select * from full_revenue;