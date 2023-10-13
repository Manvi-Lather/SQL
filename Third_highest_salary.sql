--This question was asked to me in my first interview so it's very close to my heart ;)


--1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
--In case a department has less than 3 employees then print the details of highest salaried employee in that department.


SELECT TOP 2 *  FROM dbo.employee


WITH sal_rnk
AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY dept_id ORDER by salary,emp_age) AS dns
FROM dbo.employee
)
SELECT * FROM sal_rnk
WHERE dns =3


--the above solution is not considering the dept where number of emp are less than 3 so we need to modify it 



with rnk 
AS ( --cte 1
select *, dense_rank() over(partition by dept_id order by salary,emp_age ) as rn
from employee
)
,cnt 
AS ( --cte 2
SELECT dept_id,count(1) as no_of_emp from employee group by dept_id
)

select
rnk.*
from 
rnk 
inner join cnt on rnk.dept_id=cnt.dept_id
where rn=3 or  (no_of_emp<3 and rn=1) 


--second method to solve this : 

with rnk AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rn
,COUNT(1) OVER(PARTITION BY dept_id ) AS no_of_emp
FROM employee)
SELECT
*
FROM 
rnk 
where rn=3 or  (no_of_emp<3 and rn=1) 