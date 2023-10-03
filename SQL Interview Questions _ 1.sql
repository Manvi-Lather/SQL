--SQL Interview Questions  


--Question 1 : 

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

--1- write a query to produce below output from icc_world_cup table.

--team_name, no_of_matches_played , no_of_wins , no_of_losses


--Step 1: 



select Team_1, Team_2, Winner from icc_world_cup
union all 
select Team_2, Team_1, Winner from icc_world_cup


--step 2 

WITH icc_word_cup(team_name, win_flag, loss_flag)
as
(
SELECT Team_1 as team_name,
case
when Team_1 = Winner
then 1
else 0 
end as win_flag, 
case
when Team_1 <> Winner
then 1
else 0 
end as loss_flag
from icc_world_cup
union all 
select Team_2 as team_name,
case
when Team_2 = Winner
then 1
else 0 
end as win_flag, 
case
when Team_2 <> Winner
then 1
else 0 
end as loss_flag
from icc_world_cup
)


SELECT team_name,COUNT(*) AS no_of_matches_played, SUM(win_flag) AS no_of_wins ,SUM(loss_flag) AS no_of_losses
FROM icc_word_cup
GROUP BY team_name

--Question 2 

--2- write a query to print first name and last name of a customer using 
--orders table(everything after first space can be considered as last name)

--customer_name, first_name,last_name

--Function I am using 

--SUBSTRING(string, start, length)
--CHARINDEX(substring, string, start) --> gives position 

SELECT TOP 2 *  from orders; 



select customer_name
,LOWER(SUBSTRING(customer_name, 1,charindex(' ',customer_name))) as first_name
,LOWER((SUBSTRING(customer_name, charindex(' ',customer_name),len(customer_name)))) AS LAST_name
FROM orders; 

--another way -- just experimenting -- First one straight forward 
select customer_name , trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)-CHARINDEX(' ',customer_name)+1) as second_name
from orders



--Question 3 : 

--Run below script to create drivers table:

--create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
--insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
--insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
--insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

--3- write a query to print below output using drivers table. 
--Profit rides are the no of rides where end location of a ride is same as start location 
--of immediate next ride for a driver
--id, total_rides , profit_rides
--dri_1,5,1
--dri_2,2,0


--using self left join 



select d1.id as driver_id,count(1) as total_rides
--d1.start_time,d1.start_loc, d2.start_loc, d1.end_loc,d2.end_loc
,count(d2.id) as profit_rides
from drivers d1
left join drivers d2
on d1.id = d2.id 
and d1.start_time = d2.end_time 
group by d1.id


--using lead function window and sub query 

SELECT * FROM drivers


--step 1
select *
, lead(start_loc,1) over(partition by id order by start_time asc) as next_start_location
from drivers


--step 2
select id, count(1) as total_rides
,sum(case when end_loc=next_start_location then 1 else 0 end ) as profit_rides
from (
select *
, lead(start_loc,1) over(partition by id order by start_time asc) as next_start_location
from drivers) A
group by id;



--Question 4: 


--4- write a query to print customer name and no of occurence of character 'n' in the customer name.

--customer_name , count_of_occurence_of_n

select * from orders;

--creating some data 

UPDATE dbo.orders
SET customer_name = 'nannette nnc'
WHERE customer_name = 'nannette'


UPDATE dbo.orders
SET customer_name = 'nancy'
WHERE customer_name = 'Rohit'



SELECT *, 
 LEN(customer_name) AS  total_len
,(REPLACE(customer_name, 'n', '')) AS Cust_name_WO_n
,len(REPLACE(customer_name, 'n', '')) AS len_WO_n
 ,LEN(customer_name) - LEN(REPLACE(customer_name, 'n', '')) AS n_count
FROM 
    dbo.orders

--Final



SELECT *
 ,LEN(customer_name) - LEN(REPLACE(customer_name, 'n', '')) AS n_count
	FROM 
    dbo.orders


--Question 5:
 
--5-write a query to print below output from orders data. example output

--hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region

--category , Technology, total_sales_in_west_region,total_sales_in_east_region
--category, Furniture, ,
--category, Office Supplies, ,
--sub_category, Art , ,
--sub_category, Furnishings, ,
----and so on all the category ,subcategory and ship_mode hierarchies 


SELECT * FROM Superstore_orders


SELECT  'category' AS hierarchy_type,
		category AS hierarchy_name,
		SUM(CASE WHEN region ='West'
		THEN sales
		END) AS total_sales_west_region, 
		SUM(CASE WHEN region = 'East'
		THEN sales
		END) AS total_sales_east_region

FROM Superstore_orders
GROUP BY category

UNION ALL 

SELECT  'sub-category' AS hierarchy_type,
		sub_category AS hierarchy_name,
		SUM(CASE WHEN region ='West'
		THEN sales
		END) AS total_sales_west_region, 
		SUM(CASE WHEN region = 'East'
		THEN sales
		END) AS total_sales_east_region

FROM Superstore_orders
GROUP BY sub_category

UNION ALL 

SELECT  'ship-mode' AS hierarchy_type,
		ship_mode AS hierarchy_name,
		SUM(CASE WHEN region ='West'
		THEN sales
		END) AS total_sales_west_region, 
		SUM(CASE WHEN region = 'East'
		THEN sales
		END) AS total_sales_east_region

FROM Superstore_orders
GROUP BY ship_mode


--6- the first 2 characters of order_id represents the country of order placed . 
--write a query to print total no of orders placed in each country
--(an order can have 2 rows in the data when more than 1 item was purchased 
--in the order but it should be considered as 1 order)


SELECT * FROM Superstore_orders

WITH cte AS
(
SELECT left(Order_ID, 2) AS country_name, Order_ID
 FROM Superstore_orders
 GROUP BY Order_ID
 )

 SELECT COUNT(country_name) , country_name
 FROM cte
 GROUP BY country_name


 --another solution 

select left(order_id,2) as country, count(distinct order_id) as total_orders
from Superstore_orders
group by left(order_id,2)