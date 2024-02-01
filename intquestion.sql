--how to find duplicate in a given table 

SELECT emp_id FROM emp 
GROUP BY emp_id 
HAVING COUNT(*)>1; 

--how to delete duplicates

WITH cte AS(
SELECT *, 
ROW_NUMBER () OVER(PARTITION BY emp_id ORDER BY emp_id) AS rn FROM emp1)

DELETE FROM cte WHERE rn>1; 

--difference between union and union all 

SELECT manager_id FROM emp
UNION 
SELECT manager_id FROM emp1;  --will return only unique values


SELECT emp_id FROM emp
UNION ALL
SELECT emp_id FROM emp1; -- will return all values 


--emp noot present in department table 

SELECT * FROM emp 
WHERE department_id NOT IN (SELECT dep_id FROM dept);

--second highest salary in each dept 

WITH cte AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rk IN emp)
SELECT * FROM cte WHERE rk  = 2; 


--find all transaction by shilpa 

SELECT * FROM orders WHERE UPPER(customer_name) = 'Shilpa'; 

--find emp salary > manager salary
SELECT e.emp_id, e.emp_name, 
m.emp_name AS man_name, 
e.sal, m.sal AS man_sal
FROM emp e
JOIN emp m
ON e.manager_id = m.emp_id 
WHERE m.salary < e.salary 


--update query to swap gender

UPDATE orders
SET customer_gender = 
CASE WHEN customer_gender = 'Male' THEN 'female'
WHEN customer_gender = 'female' THEN 'male'
END; 




