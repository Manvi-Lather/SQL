--write a query to print emp name, salary and dep id of highest salaried employee in each department ;

select * from employee
order by dept_id, salary desc;

--ROW_NUMBER ( )   
--    OVER ( [ PARTITION BY value_expression , ... [ n ] ] order_by_clause )



select * from(
select  row_number() over ( PARTITION BY dept_id order by salary desc) as rn , e.*
from employee e )  sub
where sub.rn = 1; 


-- Write the query to find the top 2 highest salaried employees: 


select * from(
select  row_number() over ( PARTITION BY dept_id order by salary desc) as rn , e.*
from employee e )  sub
where sub.rn <=2; 

-- we have people with same salary in a dept . let use age to sort the data 

select * from(
select  row_number() over ( PARTITION BY dept_id order by salary desc, emp_age asc) as rn , e.*
from employee e )  sub
where sub.rn <=2; 


--> row_number is a running number 
-- rank --> two person with same salary will have  same rank but it will skip one rank 
select * from(
select  row_number() over ( PARTITION BY dept_id order by salary desc) as rn ,
rank() over ( PARTITION BY dept_id order by salary desc) as rank , e.dept_id, e.salary
from employee e )sub;




--Lets add dense rank : Same like rank but it does not skip any number 

select * from(
select  row_number() over ( PARTITION BY dept_id order by salary desc) as rn ,
rank() over ( PARTITION BY dept_id order by salary desc) as rank ,
dense_rank() over ( PARTITION BY dept_id order by salary desc) as den_rank ,e.dept_id, e.salary
from employee e )sub;


