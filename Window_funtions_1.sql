-- windows functions 

-- IN SELECT STATEMENT GIVE FUNCTION NAME THEN INSIDE THE THE OVER CLASUE GIVE PARTITION BY AND ORDER BY 

--FUNCTION_NAME OVER (PARTITION BY ------ ORDER BY -----) 


-- write a query to print emp name, salary and dep id of highest salaried employee in each department 

USE ZZTest

--- solution 1 using join 
SELECT * FROM dbo.employee

--step1 
SELECT dept_id, max(salary) AS max_sal
FROM dbo.employee
GROUP BY dept_id 

--step 2 : final query 

SELECT e.*
FROM dbo.employee e
JOIN  (SELECT dept_id, max(salary) AS max_sal
FROM dbo.employee
GROUP BY dept_id ) AS max_sal
ON e.dept_id = max_sal.dept_id
WHERE e.salary = max_sal.max_sal


--using windows functions 

--write a query to print emp name, salary and dep id of top 2  salaried employee in each department 


---------------------------------------------------------------ROW_NUMBER()----------------------------------------------------------------
SELECT * FROM  dbo.employee
ORDER BY salary desc

SELECT *, 
ROW_NUMBER() OVER(ORDER BY salary desc) AS rn  -- order the data on the basis of salary and give row number
FROM dbo.employee

-- highest salary emp got rn = 1


--generate rn for each dept separately 

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) AS rn  --defining window using partition by for each dept 
FROM dbo.employee


--I have to fetch top 2 emp with highest salary


-- using CTE with window function 
WITH CTE
AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) AS rn  
FROM dbo.employee
)

SELECT * FROM CTE
WHERE rn IN (1, 2) 

--using Subquery with window function 
SELECT * FROM 
(SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rn 
FROM dbo.employee) rn
WHERE rn <=2


---------------------------------------------------------------------------RANK----------------------------------------------------

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) AS rn , --rn is running number. 
RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rnk ---  ppl in a dept, with same salary will get same rank but it will skip one number while assigning number to next 
FROM dbo.employee

--lets define one more column in window(partition by clause)

-- now a window is created by the combination to two columns
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id,salary ORDER BY salary desc) AS rn , --all the unique combination will have 1 number
RANK() OVER(PARTITION BY dept_id,salary ORDER BY salary DESC) AS rnk 
FROM dbo.employee



---------------------------------------------------------------------------DENSE RANK----------------------------------------------------

INSERT INTO employee VALUES( 11,'jay', 100, 500, 2, 30, '2010-09-04', 'M')


SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id,salary ORDER BY salary desc) AS rn , --all the unique combination will have 1 number
RANK() OVER(PARTITION BY dept_id,salary ORDER BY salary DESC) AS rnk , --it skip the rank number after finding a duplicate combination.
DENSE_RANK() OVER(PARTITION BY dept_id,salary ORDER BY salary DESC) AS Dns_rnk -- If two rows in a window have same salary they will have same dns_rnk and next salary with dns_rnk in continuation. 
FROM dbo.employee




SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id,salary ORDER BY salary desc) AS rn , --all the unique combination will have 1 number
RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rnk , --it skip the rank number after finding a duplicate.
DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS Dns_rnk -- If two rows in a window have same salary they will have same dns_rnk and next salary with dns_rnk in continuation. 
FROM dbo.employee


--use case for rank 

--you want to top 2 emp in each dept 




--you want to top 2 emp in each dept  but if salary is same for two emp, pick the one with less age 
--we can achieve this by using rank. 

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dept_id,salary ORDER BY salary desc) AS rn , --all the unique combination will have 1 number
RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC,emp_age asc) AS rnk 
FROM dbo.employee





--top 5 selling products in each category 

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

--adding one more CTE 

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


--second way 


 WITH rnk_sales AS  --second cte 
(
SELECT cte1.Category, cte1.Product_ID
, rank () OVER (PARTITION BY cte1.Category ORDER BY SUM(cte1.Sales) DESC) AS rn 
FROM Superstore_orders cte1
GROUP BY cte1.Category, cte1.Product_ID   -- first grp will take place 
)
SELECT * FROM 
rnk_sales
WHERE rn <=5