drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);
 select count(*) from zepto;
--sample data
 select * from zepto limit 10;
 --null values
 select * from zepto where name is null
 or category is null
 or mrp is null 
 or discountpercent is null
 or availablequantity is null
 or discountedsellingprice is null 
 or weightingms is null
 or outofstock is null
 or quantity is null;

 --differnt product category
 select distinct category from zepto order by category;

-- how many products in stock and out of stock
select outofstock, count(sku_id) from zepto
 group by outofstock;

--product name present_multiple times
select name, count(sku_id) as noofterms from zepto
group by name having count(sku_id)>1
order by count(sku_id) desc;

--Data Cleaning
--product with price =0
select * from zepto where 
mrp=0 or discountedsellingprice=0;

delete from zepto where mrp=0;
--convert price to ruppes
update zepto set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

select mrp,discountedsellingprice from zepto;

--bussiness questions
--1.top 10 best value products based on percentage
select distinct name,mrp,discountpercent
from zepto order by discountpercent desc
limit 10;
--2.what are the products with high mrp but out of stock
select distinct name,mrp from zepto where 
outofstock =TRUE and mrp>300
order by mrp desc;
--3.calculated the estimated revenue os ecah catrgory
SELECT
    category,
    SUM(discountedSellingPrice * quantity) AS total_revenue
FROM
    zepto
GROUP BY
    category
ORDER BY
    total_revenue DESC; -- Sorting by total_revenue is often done descending
	--4.find all products where mrp is grater than 500 and discount is less than 10%
	select distinct name, mrp,discountpercent from zepto 
	where mrp>500 and 
	discountpercent <10
	order by mrp  desc,discountpercent desc;
--5.identify the top 5 categroies offering the highest average discount percent
select category,avg(discountpercent) as
avg_discount from zepto group by category 
order by avg_discount desc limit 5;
--6.find the price per gram for products above 100gs and sort by best value
select distinct name ,weightingms,discountedSellingPrice,
discountedSellingPrice/weightingms as price_per_gms
from zepto where weightingms >=100
order by price_per_gms;
--7.goup the products into categroy like lo,mideum,high
SELECT DISTINCT
    name,
    weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'low'
        WHEN C < 5000 THEN 'medium'
        ELSE 'bulk' -- Corrected 'bluk' to 'bulk'
    END AS weight_category -- Corrected 'categroy' to 'category'
FROM
    zepto;

--8.what is the total inventroy weight per catrgroy
select category,
sum(weightInGms * availableQuantity ) as
total_weight from
zepto group by category
order by total_weight;