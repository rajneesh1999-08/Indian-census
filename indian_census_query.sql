-- creating a database
create database india_census;
-- using india_cenus database
use  india_census;

-- looking at table1
select * from data1;
-- looking at table2
select * from data2
;

-- how many rows in data1 and data2

select count(*) from data1; -- 640 rows in data1

select count(*) from data1; -- 640 rows in data2 as well

-- dataset for jharkhand and bihar

select * from data1 where state in ('jharkhand',"bihar");

-- TOTal population of india

select sum(population) as total_population
from data2; -- 121 cr according to data


-- average growth 

select avg(growth)*100 as Average_growth  from data1;

-- average growth by state and orderding them from highest to lowest


select state,avg(growth)*100 as Average_growth
from data1
group by state
order by average_growth desc;

-- average sex_ratio in india

select avg(sex_ratio) from data1;

-- average sex_ratio by state and arranging them from highest to lowest
select state,round(avg(sex_ratio)) as ratio from data1 group by state
order by ratio desc; -- goa has highest sex_ratio

-- avg literacy rate

select avg(Literacy) from data1;

-- avg literacy rate by state and arranging them from highest to lowest

select state,round(avg(literacy)) lt_ratio
from data1
group by state
order by lt_ratio desc; -- kerala has highest literacy rate
 
 -- selecting state whose literacy rate higher than 80
 
 select state,round(avg(literacy)) lt_ratio
from data1
group by state
having lt_ratio>80
order by lt_ratio desc
;

-- Top 3 state showing highest growth ratio
select state,round(avg(growth)*100) as Average_growth
from data1
group by state
order by average_growth desc
limit 3;


-- Top 3 state showing lowest growth ratio
select state,round(avg(growth)*100) as Average_growth
from data1
group by state
order by average_growth asc
limit 3;

-- top and bottom 3 states in literacy rate

create table top_state (select state,round(avg(literacy)) lt_ratio
from data1
group by state
order by lt_ratio desc
);

select* from (select * from top_state limit 3) a
union
select * from (
select * from top_state order by lt_ratio asc limit 3) b;

-- ALL state starts with A

select * from data1
where state like "a%";

-- joining both table

-- total  males and females 


select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from data1 a inner join data2 b on a.district=b.district ) c) d
group by d.state;


-- total literacy and illiterate people

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from data1 a 
inner join data2 b on a.district=b.district) d) c
group by c.state;

-- population in previous census by state

with population as (

select d.district,d.state,round(d.population/(1+growth)) previous_census_population,d.population current_census_population from ( 
select a.district,a.state,a.growth,b.population from data1 a 
inner join data2 b on a.district=b.district) d)


select state ,sum(previous_census_population),sum(current_census_population) from population group by state;


-- population in previous census 

with population as (

select d.district,d.state,round(d.population/(1+growth)) previous_census_population,d.population current_census_population from ( 
select a.district,a.state,a.growth,b.population from data1 a 
inner join data2 b on a.district=b.district) d)


select state ,sum(previous_census_population),sum(current_census_population) from population ;

-- window

-- top 3 district from each state with highest literacy rate
select a.* from(
select district,state,literacy,rank() over(partition by state order by literacy  desc) rnk
from data1) a where a.rnk in (1,2,3)
order by state;



























