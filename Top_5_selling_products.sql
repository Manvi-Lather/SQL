


--Find top 5 selling products in each category 

--this is ranking question 


--first we have to sum sales of each product in a category 
--here we need to do the aggregation first as product_id is not unique 
--then we will aplly ranking 

SELECT TOP 2 * FROM Superstore_orders

--step 1 

SELECT category , product_id , SUM(Sales) AS category_sales
FROM Superstore_orders
GROUP BY category , product_id 

--step 2: 
--using CTE 

WITH cte AS 
(
SELECT category , product_id , SUM(Sales) AS category_sales
FROM Superstore_orders
GROUP BY category , product_id 
) 

SELECT * 
, rank () OVER (PARTITION BY cte.Category ORDER BY cte.category_sales DESC) AS rn
FROM cte 


--Step 3

--adding one more CTE as we have to apply filter 

WITH cat_product_sales AS  --first cre 
(
SELECT category , product_id , SUM(Sales) AS category_sales
FROM Superstore_orders
GROUP BY category , product_id 
) 

, rnk_sales AS  --second cte 
(
SELECT * 
, rank () OVER (PARTITION BY cte1.Category ORDER BY cte1.category_sales DESC) AS rn
FROM cat_product_sales cte1
)

SELECT * FROM 
rnk_sales
WHERE rn <=5



--------------------------------------------------------------------------------------------

--understanding row number, rank, dense rank window function					
						
order ID 	Product ID 	Cat		Sales 	rn	rnk dn_rnk 
1			100			cat1	400		1	1	1
2			100			cat1	200		2	1	1
3			200			cat1	150		3	3	2
4			300			cat1	100		4	4	3
5			400			cat1	100		5	4	3
6			600			cat2	250		1	1	1
7			600			cat2	250		2	1	1
8			700			cat2	200		3	3	2
9			700			cat2	200		4	3	2
10			800			cat2	100		5	5	3


--expected output 					
					
cat 	Product ID 	sum(sales)	rn	rnk	dn_rnk 
cat1	100			600			1	1	1
cat1	200			150			2	2	2
cat1	300			100			3	3	3
cat1	400			100			4	3	3
cat2	600			500			1	1	1
cat2	700			400			2	2	2
cat2	800			100			3	3	3



SELECT Category,Product_ID,Sales, 
DENSE_RANK() OVER(PARTITION BY Category ORDER BY sales DESC) AS rnk
FROM dbo.Superstore_orders
where rn < =2



SELECT Category,Product_ID,Sales, 
DENSE_RANK() OVER(PARTITION BY Category ORDER BY sales DESC) AS rnk
FROM dbo.Superstore_orders
where rnk <= 2



SELECT Category,Product_ID,Sales, 
DENSE_RANK() OVER(PARTITION BY Category ORDER BY sales DESC) AS rnk
FROM dbo.Superstore_orders
where dn_rnk < =2
