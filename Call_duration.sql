--write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.
--Please do take into account that
--there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.



create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;




select * from call_start_logs
select * from call_end_logs



select sl.*, el.*
from call_start_logs sl
join call_end_logs el
on sl.phone_number = el.phone_number
where sl.start_time < el.end_time -- this will not work 


-- we need one more key to create the join 


select st.phone_number, st.rn , et.rn, st.start_time, et.end_time, datediff(minute, start_time,end_time) as call_duration 
from 
(

(select *, row_number() over(partition by phone_number order by start_time) as rn from call_start_logs) st 

inner join  (select *, row_number() over(partition by phone_number order by end_time) as rn from call_end_logs) et 

on st.phone_number = et.phone_number

and st.rn = et.rn

);