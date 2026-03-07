-- sql Retail Sales 1
Create database project_1
Drop table if exists reatil_sales;
Create table Reatil_Sales
(
				transactions_id	int primary key ,
				sale_date	Date,
                -- Date should be in YYYY-MM-DD
				sale_time time,
				customer_id	int,
				gender	varchar(20),
				age	int,
				category varchar(20),	
				quantiy	int,
				price_per_unit float,	
				cogs float,
				total_sale float

);
select * from reatil_sales;

delete from reatil_sales
where transactions_id is null or
				sale_date is null or
              
				sale_time is null or
				customer_id	is null or
				gender is null or
				age	is null or
				category is null or	
				quantiy	is null or
				price_per_unit is null or	
				cogs is null or
				total_sale is null ;


-- SET SQL_SAFE_UPDATES = 0;
-- Data exploartion 
select count(*) as total_sale
from reatil_sales;
-- How Many customer we have.
select count(distinct customer_id) from reatil_sales;
-- where transactions_id is not null;
select distinct Category from reatil_sales;
-- Data analyst/bussine key problems
-- retrivee all colums made on 2022-11-05
select * from reatil_sales
where sale_date= '2022-11-05';
-- Query for retreivng all transaction id where category is clothing , sold more than 10 and in nov 2022
select Category,sum(quantiy) from reatil_sales
where category ='clothing' and quantiy >= 4
and year(sale_Date) = 2022
and month(sale_date)=11;
-- getting total sales for each category
Select sum(total_Sale) as net_Sale,category,count(*)as total_order from reatil_sales
group by category;
-- customeravg age who purchased item from beauty category
select round(avg(age),2)from reatil_sales
where category='Beauty';
-- find all transaction where total_sale is greater than 1000
select * from reatil_sales
where total_sale >1000;
-- total no. of transation made by each gender in each category
select count(*)as total_Sale,category,gender from reatil_sales
group by gender,category
order by 1 ;
-- avg sale for each month,find out best selling month in each year;
select * from 
(Select avg(total_Sale) as avg_sale ,
extract(year from sale_date)as year,
extract(month from sale_date)as month ,
Rank()over(partition by extract(year from sale_date)order by avg(total_sale)desc) as rank1
 from reatil_sales
group by 2,3) as t1
where rank1 = 1;
-- write sql to find the top 5 customer based on the highest total sale
select customer_id,SUM(total_sale)AS SALE from reatil_sales
GROUP BY customer_id
order by SALE DESC
LIMIT 5;
-- WRITE SQL QUERY TO FIND UNIQUE CUSTOMER WHO PURCHASEED ITEMS FROM EACH CATEGORY
select count(distinct (customer_id) )as customer, category from reatil_sales
group by category;
-- sql to create each shift and number of orders ecxamoke morining<=12, afternoonbetween 12 adn 17 , evening >17  
with hourly_Sale as 
(select * ,
case
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from reatil_sales)
select shift,Count(*) as total_Order from hourly_Sale
group by shift
