Create database MetMuseum;
use MetMuseum;
create table met(
ID INT PRIMARY KEY,
Department varchar(100),
Category varchar(100),
Title varchar(100),
Artist varchar(100),
Date varchar(100),
Medium varchar(100),
Country varchar(100));

-- Select the top 10 rows in the met table.
select * from met
limit 10;

-- How many pieces are in the American Metropolitan Art collection, where each record in the table represents the unique piece in the museum?
 select  count(*) as uniquePices
 from met;

-- Count the number of pieces where the category includes ‘celery’
select * from met
where Category Like '%celery%' ;

-- Find the title and medium of the oldest piece(s) in the collection
select title, medium, date
from met
where date = (
    select min(date)
  from met);
  
  -- Find the top 10 countries with the most pieces in the collection
select Country, count( *) as pieces
 from met
group by Country
order by pieces desc
limit 10;

-- Find the categories which have more than 100 pieces.
select Category, count(Category) as pieces
 from met
group by Category
order by pieces desc;

-- Count the number of pieces where the medium contains ‘gold’ or ‘silver’ and sort in descending order.
select medium , count(*) as pieces 
from met 
where Medium like '%Gold%' or Medium like '%Silver%'
group by Medium
order by pieces desc;