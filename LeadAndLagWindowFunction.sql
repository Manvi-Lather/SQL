--Lead and Lag window function 


SELECT * FROM Superstore_orders


WITH year_sales AS 
(
SELECT DATEPART(YEAR,order_date) AS order_year, SUM(Sales) AS sales
FROM Superstore_orders GROUP BY DATEPART(YEAR,order_date)
)

SELECT * FROM year_sales
ORDER BY order_year


--lead and lag are used when you want to see the data of the current row w.r.t to next row or previous row 


--I want to compare 2019 sales with year 2018 and 2020 sales 



WITH year_sales AS 
(
SELECT DATEPART(YEAR,order_date) AS order_year, SUM(Sales) AS total_sales
FROM Superstore_orders GROUP BY DATEPART(YEAR,order_date)
)


SELECT *,

LAG(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year) AS prev_year_sales,

LEAD(year_sales.total_sales,1,0) OVER( ORDER BY year_sales.order_year) AS next_year_sales,  

(total_sales - LAG(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year)) AS CurrMinuPre,

(year_sales.total_sales -LEAD(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year)) AS currMinuNext

FROM year_sales

ORDER BY order_year


--We can use lag to attain the result of lead function by using order by desc in LAG function 


--testing 


WITH year_sales AS 
(
SELECT DATEPART(YEAR,order_date) AS order_year, SUM(Sales) AS total_sales
FROM Superstore_orders GROUP BY DATEPART(YEAR,order_date)
)


SELECT *,

LAG(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year DESC) AS next_year_sales,  --using order by desc with lag function 

LEAD(year_sales.total_sales,1,0) OVER( ORDER BY year_sales.order_year) AS next_year_sales 

FROM year_sales

ORDER BY order_year DESC


--final test

SELECT *,

LAG(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year DESC) AS next_year_sales,

LEAD(year_sales.total_sales,1,0) OVER( ORDER BY year_sales.order_year) AS next_year_sales,  

(total_sales - LAG(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year desc)) AS CurrMinuPre,

(year_sales.total_sales -LEAD(year_sales.total_sales,1,0) OVER(ORDER BY year_sales.order_year)) AS currMinuNext

FROM year_sales

ORDER BY order_year desc