create database crowdfunding_project;

use crowdfunding_project;

create table creator(
id int,
name text);

set GLOBAL local_infile = 1;
load data local infile '/Users/sharikagunalan/Documents/SQL_CSV_File/creator crowdfunding - Cleaned.csv'
into table creator
character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from creator;
select * from creator;

create table category(
id int,
name text,
parent_id int,
position int);

load data local infile '/Users/sharikagunalan/Documents/SQL_CSV_File/category crowdfunding Cleaned.csv'
into table category
character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from category;
select * from category;

create table location(
id              INT PRIMARY KEY,
  displayable_name VARCHAR(100),
  type            VARCHAR(50),
  name            VARCHAR(100),
  state           VARCHAR(10),
  short_name      VARCHAR(100),
  is_root         BOOLEAN,
  country         VARCHAR(10));

load data local infile '/Users/sharikagunalan/Documents/SQL_CSV_File/location_Crowdfunding.csv'
into table location
character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from location;
select * from location;



create table project(
id int,
name text,
country varchar(50),
state varchar(50),
goal double,
pledged double,
backers int,
created_date varchar(50),
launched_date varchar(50),
deadline_date varchar(50),
Project_duration_days int,
updated_date varchar(50),
state_changed_date varchar(50),
category_id int,
creator_id bigint,
location_id bigint,
currency varchar(10),
usd_amount double,
static_usd_rate int,
spotlight boolean,
staff_pick boolean,
blurb varchar(100));


load data local infile '/Users/sharikagunalan/Documents/SQL_CSV_File/Crowdfunding_projects_cleaned.csv'
into table project
character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from project;
select * from project;


set SQL_SAFE_UPDATES =0;
set SQL_SAFE_UPDATES =1;

create table calendar (

created_date varchar(50),
year int,
month int,
month_name varchar(20),
week_of_year int,
day_of_week int,
day int,
day_name varchar(20),
quarter varchar(20),
year_monthh varchar(50),
financial_month varchar(10),
financial_quarter varchar(10));

load data local infile '/Users/sharikagunalan/Documents/SQL_CSV_File/CALENDER TABLE.csv'
into table calendar
character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from calendar;
select * from calendar;

-- total number of projects based on outcome

select state, count(*) as total_projects
from project
group by state 
order by total_projects desc;

-- total number of projects based on location

select country, count(*) as total_projects 
from project
group by country
order by total_projects desc;

-- percentage of successful projects overall

select(count( case when state='successful' then 1 end)*100/count(*))
as success_percentage from project;

-- total number of projects by amount raised

select 
name as project_name, state,
(goal*static_usd_rate) as amount_raised
from project
where state= "successful"
order by amount_raised desc;

-- total number of successful projects by backers
select name as project_name,
state, backers
from project
where state="successful"
order by backers desc;

-- Average Number of Days for Successful Projects 
  
SELECT 
    state as project,
    avg(datediff(deadline_date,created_date)) AS avg_project_duration_days
FROM 
     project
WHERE 
    state = 'successful'
ORDER BY 
    avg_project_duration_days DESC;
   
   
   show tables in crowdfunding_project;
-- Total Number of Projects Based on Category 
    
 SELECT c.name, COUNT(p.ID) AS total_projects
FROM crowdfunding_project.project p
JOIN crowdfunding_project.category c ON p.category_id = c.id
GROUP BY c.name
ORDER BY total_projects DESC;   

-- Total Number of Projects By Year, Quarter & Month

SELECT 
    YEAR(created_date) AS year,
    QUARTER(created_date) AS quarter,
    MONTHNAME(created_date) AS month,
    COUNT(*) AS total_projects
FROM 
    crowdfunding_project.project
GROUP BY 
    YEAR(created_date), 
    QUARTER(created_date), 
    MONTHNAME(created_date)
ORDER BY 
    YEAR(created_date) DESC, 
    QUARTER(created_date), 
    MONTHNAME(created_date);
    
    
-- Percentage of successful projects by category
SELECT 
    c.name AS category_name,
    COUNT(p.ID) AS total_projects,
    COUNT(CASE WHEN p.state = 'successful' THEN 1 END) AS successful_projects,
    (COUNT(CASE WHEN p.state = 'successful' THEN 1 END) * 100.0 / COUNT(p.ID)) AS success_percentage
FROM 
    crowdfunding_project.project p
JOIN 
    crowdfunding_project.category c 
    ON p.category_id = c.id
GROUP BY 
    c.name
ORDER BY 
    success_percentage desc;
    
    
    
-- Percentage of Successful Projects by Goal Range --
SELECT 
    CASE 
        WHEN (goal * static_usd_rate) < 5000 THEN 'less than 5000'
        WHEN (goal * static_usd_rate) BETWEEN 5000 AND 20000 THEN '5000 to 20000'
        WHEN (goal * static_usd_rate) BETWEEN 20000 AND 50000 THEN '20000 to 50000'
        WHEN (goal * static_usd_rate) BETWEEN 50000 AND 100000 THEN '50000 to 100000'
        ELSE 'greater than 100000'
    END AS goal_range,
    COUNT(ID) AS total_projects,
    COUNT(CASE WHEN state = 'successful' THEN 1 END) AS successful_projects,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(ID)) AS success_percentage
FROM 
    crowdfunding_project.project
GROUP BY 
    goal_range
ORDER BY 
    success_percentage DESC;
    



