create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

1- write a query to produce below output from icc_world_cup table.
team_name, no_of_matches_played , no_of_wins , no_of_losses

use
ZZTest;

--Step 1: 



select Team_1, Team_2, Winner from icc_world_cup
union all 
select Team_2, Team_1, Winner from icc_world_cup


--Step 2: 
--building final query
WITH icc_word_cup(team_name, win_flag, loss_flag)
as
(
SELECT Team_1 as team_name,
case
when Team_1 = Winner
then 1
else 0 
end as win_flag, 
case
when Team_1 <> Winner
then 1
else 0 
end as loss_flag
from icc_world_cup
union all 
select Team_2 as team_name,
case
when Team_2 = Winner
then 1
else 0 
end as win_flag, 
case
when Team_2 <> Winner
then 1
else 0 
end as loss_flag
from icc_world_cup
)


SELECT team_name,COUNT(*) AS no_of_matches_played, SUM(win_flag) AS no_of_wins ,SUM(loss_flag) AS no_of_losses
FROM icc_word_cup
GROUP BY team_name