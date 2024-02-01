
create table emp
( 
EMPID int, 
NAME varchar(50),
JOB varchar(30), 
SALARY DECIMAL(10, 2)

); 

insert into emp (EMPID, NAME, JOB, SALARY)
values
(201, 'ANIRUDDHA', 'ANALYST', 2100),
(212, 'LAKSHAY', 'DATA ENGINEER', 2700),
(209, 'SIDDHARTH', 'DATA ENGINEER', 3000),
(232, 'ABHIRAJ', 'DATA SCIENTIST', 2500),
(205, 'RAM', 'ANALYST', 2500),
(222, 'PRANAV', 'MANAGER', 4500),
(202, 'SUNIL', 'MANAGER', 4800),
(233, 'ABHISHEK', 'DATA SCIENTIST', 2800),
(244, 'PURVA', 'ANALYST', 2500),
(217, 'SHAROON', 'DATA SCIENTIST', 3000),
(216, 'PULKIT', 'DATA SCIENTIST', 3500),
(200, 'KUNAL', 'MANAGER', 5000);

select * from emp; 

select sum(salary) from emp; 

select job,sum(salary) as ttl_sal
from emp
group by job; 

--Display the total salary and the total salary per job category along with every row value.


select *,
sum(salary) over(order by salary rows between unbounded preceding and unbounded following) as total_sal,
sum(salary) over(partition by job order by job desc) as sal_job_cat
from emp;


--Arrange the salary in a decreasing order within each job category.



select *,
row_number() over(partition by job order by salary desc) as sal_job_cat
from emp;


--row_number() 

select *, row_number () over(order by salary) as 'row_number' 
from emp; 



select *, row_number () over(partition by job order by salary) as 'row_number' 
from emp; 


--Highest salary in front of all the rows 


select *, max(salary) over(order by empid) as 'max_salary' 
from emp; 

--Rank vs Dense_Rank



insert into emp (EMPID, NAME, JOB, SALARY)
values
(209, 'Manvi', 'ANALYST', 5100);

select *, 
row_number() over(partition by job order by salary) as "row_number", 
rank() over(partition by job order by salary) as "rank_row", 
dense_rank() over(partition by job order by salary) as "dense_rank_row"
from emp; 


--rank skip one rank after duplicate rank. 
--dense rank --> all the ranks are distinct and sequentially increasing within each partition. 
--As compared to the RANK() function, it has not skipped any rank within a partition.


--First_value

select * , 
FIRST_VALUE (salary) over(partition by job order by salary range between unbounded preceding and unbounded following) as first_value
from emp; 


select * , 
LAST_VALUE (salary) over(partition by job order by salary range between unbounded preceding and unbounded following) as last_value
from emp; 



--lead and lag 

select *, 
lead(salary,1) over(partition by job order by salary) as sal_next
from emp; 


select *, 
lag(salary,1) over(partition by job order by salary) as sal_previous, 
salary - lag(salary,1) over(partition by job order by salary) as sal_diff

from emp; 



