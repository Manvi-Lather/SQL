

--2- WRITE A query TO find TOP 3 AND bottom 3 products BY sales IN each region.


--step 1
 
SELECT region,product_id,SUM(sales) AS sales
FROM Superstore_orders
GROUP BY region,product_id

--step 2

--top 3 and bottom 3 products 




WITH region_sales 
AS ( --cte 1
SELECT region,product_id,SUM(sales) AS sales
FROM Superstore_orders
GROUP BY region,product_id
)

,rnk 
AS ( --cte 2 

SELECT *, RANK() OVER(PARTITION BY region ORDER BY sales DESC) AS drn
,RANK() OVER(PARTITION BY region ORDER BY sales ASC) AS arn
FROM region_sales

)

select region,product_id,sales,

CASE when drn <=3 
	THEN 'Top 3' 
	ELSE 'Bottom 3' 
	END as top_bottom

from rnk
where drn <=3 or arn<=3


