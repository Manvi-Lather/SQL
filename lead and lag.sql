--lead and lag 


select * from employee; 


--https://learn.microsoft.com/en-us/sql/t-sql/functions/lead-transact-sql?view=sql-server-ver16

--LEAD ( scalar_expression [ , offset ] , [ default ] ) [ IGNORE NULLS | RESPECT NULLS ]
--    OVER ( [ partition_by_clause ] order_by_clause )



-- look for next row as per order by 


select salary ,dept_id, 
lead(salary,1) over(order by salary desc) as lead_sal
from employee;


select salary ,dept_id, 
lead(salary,1) over(partition by dept_id order by salary desc) as lead_sal
from employee;


--look for previous row as per order by 

select salary ,dept_id, 
lag(salary,1) over(partition by dept_id order by salary desc) as lead_sal
from employee;



--






