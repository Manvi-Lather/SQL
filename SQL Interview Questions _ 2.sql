
--1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.

--Step 1 : find avg no num of order per customer 
--AVG = total number OF orders/total number OF customers 



SELECT  (COUNT(Order_ID)/COUNT(DISTINCT(Customer_ID))) AS avg_order
FROM Superstore_orders



--step 2 : 

--Find the customers 

SELECT Customer_ID, COUNT(Order_ID) AS no_orders FROM Superstore_orders 
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > (SELECT  (COUNT(Order_ID)/COUNT(DISTINCT(Customer_ID))) AS avg_order
FROM Superstore_orders) ORDER BY no_orders DESC , Customer_ID asc


--testing 
SELECT *  FROM Superstore_orders WHERE Customer_ID = 'WB-21850'




--2- write a query to find employees whose salary is more than average salary of employees in their department


SELECT * FROM employee

--step 1 
--avg salary per department 

SELECT dept_id, AVG(salary) AS avg_sal FROM employee
GROUP BY dept_id


--step 2



select e.*,avg_tab.* from employee e
inner join (select dept_id,avg(salary) as avg_sal from employee group by dept_id)  avg_tab
on e.dept_id=avg_tab.dept_id




--emp_id	emp_name	dept_id	salary	manager_id	emp_age	dob		 Gender	dept_id	avg_sal
--1		Ankit		100		1000		4		39		2/7/1984	G	100		1750
--2		Mohit		100		2000		5		48		2/7/1975	G	100		1750
--3		Vikas		100		3000		4		37		2/7/1986	G	100		1750
--4		Rohit		100		1000		2		16		2/7/2007	M	100		1750
--5		Mudit		200		5000		6		55		2/7/1968	G	200		5250
--6		Agam		200		6000		2		14		2/7/2009	M	200		5250
--7		Sanjay		200		5000		2		13		2/7/2010	M	200		5250
--8		Ashish		200		5000		2		12		2/7/2011	G	200		5250
--9		Mukesh		300		6000		6		51		2/7/1972	M	300		6000
--10		Rakesh		500		7000		6		50		2/7/1973	M	500		7000


--Final 
select e.*,avg_tab.* from employee e
inner join (select dept_id,avg(salary) as avg_sal from employee group by dept_id)  avg_tab
on e.dept_id=avg_tab.dept_id
where salary>avg_sal


--3- write a query to find employees whose age is more than average age of all the employees.



--step 1: find avg age 

SELECT AVG(emp_age) AS avg_sal FROM employee

SELECT * FROM employee 
WHERE emp_age >  (
SELECT AVG(emp_age) AS avg_sal FROM employee)


--4- write a query to print emp name, salary and dep id of highest salaried employee in each department 


--step 1 : max salary in each dept 



SELECT dept_id,MAX(salary) AS max_salary FROM employee
GROUP BY dept_id


SELECT * FROM employee

--step 2 : 

SELECT e.emp_name, e.salary , e.dept_id
FROM employee e 
INNER JOIN (
SELECT dept_id,MAX(salary) AS max_salary FROM employee
GROUP BY dept_id) AS max_sal
ON e.dept_id = max_sal.dept_id
WHERE e.salary = max_sal.max_salary


--emp_id	emp_name	dept_id	salary	manager_id	emp_age		dob		Gender		dept_id	max_salary
--1		Ankit		100		1000	4			39			2/7/1984	G		100		3000
--2		Mohit		100		2000	5			48			2/7/1975	G		100		3000
--3		Vikas		100		3000	4			37			2/7/1986	G		100		3000
--4		Rohit		100		1000	2			16			2/7/2007	M		100		3000
--5		Mudit		200		5000	6			55			2/7/1968	G		200		6000
--6		Agam		200		6000	2			14			2/7/2009	M		200		6000
--7		Sanjay		200		5000	2			13			2/7/2010	M		200		6000
--8		Ashish		200		5000	2			12			2/7/2011	G		200		6000
--9		Mukesh		300		6000	6			51			2/7/1972	M		300		6000
--10		Rakesh		500		7000	6			50			2/7/1973	M		500		7000




--5- write a query to print emp name, salary and dep id of highest salaried overall


--step 1 : max salary 
SELECT MAX(salary) 
FROM dbo.employee

--step2 : 

select emp_name, salary,dept_id from employee 
where salary = (select max(salary) from employee)


--6- write a query to print product id and total quantity sales of highest selling products (by no of units sold) in each category

SELECT * FROM Superstore_orders


-- product sale in each category 

select Category,product_id,sum(quantity) as total_quantity
from Superstore_orders 
group by Category,product_id


--total sales of highest selling products


-- creating  2 CTE 

with product_quantity as (
select Category,product_id,sum(quantity) as total_quantity
from Superstore_orders 
group by Category,product_id)
,cat_max_quantity as (
select Category,max(total_quantity) as max_quantity from product_quantity 
group by Category
)



select *
from product_quantity pq
inner join cat_max_quantity cmq on pq.category=cmq.category
where pq.total_quantity  = cmq.max_quantity
