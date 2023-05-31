CREATE TABLE IF NOT EXISTS store (
Row_ID SERIAL,
Order_ID CHAR(25),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID CHAR(25),
Customer_Name VARCHAR(75),
Segment VARCHAR(25),
Country VARCHAR(50),
City VARCHAR(50),
States VARCHAR(50),
Postal_Code INT,
Region VARCHAR(12),
Product_ID VARCHAR(75),
Category VARCHAR(25),
Sub_Category VARCHAR(25),
Product_Name VARCHAR(255),
Sales FLOAT,
Quantity INT,
Discount FLOAT,
Profit FLOAT,
Discount_amount FLOAT,
Years INT,
Customer_Duration VARCHAR(50),
Returned_Items VARCHAR(50),
Return_Reason VARCHAR(255)
) ;

SET datestyle to german;
show datestyle;
SET client_encoding = 'ISO_8859_5';
COPY store(Row_ID,Order_ID,Order_Date,Ship_Date,Ship_Mode,Customer_ID,Customer_Name,Segment,Country,City,States,Postal_Code,Region,Product_ID,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit,Discount_Amount,Years,Customer_Duration,Returned_Items,Return_Reason)
FROM 'C:\Files\Store.csv'
DELIMITER ','
CSV HEADER;
--1)first view
SELECT * FROM public.store;

--2) Database Size
SELECT pg_size_pretty(pg_database_size('store_analysis'));

--3) Table Size
SELECT pg_size_pretty(pg_relation_size('store'));

--4) DATASET  INFORMATION
SELECT column_name,data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'store';

-- Customer_Name   : Customer's Name
-- Customer_Id  : Unique Id of Customers
-- Segment : Product Segment
-- Country : United States
-- City : City of the product ordered
-- State : State of product ordered
-- Product_Id : Unique Product ID
-- Category : Product category
-- Sub_Category : Product sub category
-- Product_Name : Name of the product
-- Sales : Sales contribution of the order
-- Quantity : Quantity Ordered
-- Discount : % discount given
-- Profit : Profit for the order
-- Discount_Amount : discount  amount of the product 
-- Customer Duration : New or Old Customer
-- Returned_Item :  whether item returned or not
-- Returned_Reason : Reason for returning the item

--5) row count of data 
select count(*) from store;

--6)column count of data 
SELECT COUNT(*) AS column_Count
FROM information_schema.columns
WHERE table_name = 'store';

/* checking null values of store data */
/* Using Nested Query */
SELECT * FROM store
where(select column_name
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='store') IS NULL;
/* No Missing Values Found */

/* Dropping Unnecessary column like Row_ID */
ALTER TABLE "store" DROP COLUMN "row_id";
select * from store limit 10;

/* Check the count of United States */
select count(*) from store
where country='United States';

/* PRODUCT LEVEL ANALYSIS*/
--1) What are the unique product categories? 
select count(distinct(category)) from store ;

--2) What is the number of products in each category? 
select * from store;

select category,count(product_name) as number_product
from store
group by category
order by number_product desc;

--3)Find the number of Subcategories products that are divided.
select count(distinct(sub_category)) as no_of_sub_category 
from store;

--4)Find the number of products in each sub-category.
select sub_category,count(product_name) as no_of_product 
from store
group by sub_category
order by no_of_product desc;

--5)Find the number of unique product names.
select count(distinct(Product_Name)) as unique_product
from store;

--6)Which are the Top 10 Products that are ordered frequently? 

select product_name,count(product_name) as frequency 
from store
group by product_name
order by frequency desc 
limit 10;

--7) Calculate the cost for each Order_ID with respective Product Name. 
select order_id,product_name,round(cast((sales-profit) as numeric),2) as cost
from store
order by cost desc;

--8)Calculate % profit for each Order_ID with respective Product Name.
select order_id,product_name,round(cast((profit/(sales-profit)) as numeric),2)*100 as profit_percent
from store
order by profit_percent desc;

--Calculate the overall profit of the store.
select ROUND(CAST(((SUM(profit)/((sum(sales)-sum(profit))))*100)AS NUMERIC),2) as overall_profit 
from store;

/* Calculate percentage profit and group by them with Product Name and Order_Id. */
select order_id,product_name,round(sum(round(cast((profit/(sales-profit)) as numeric),2)*100)/count(*),2) as profit_percent
from store
group by order_id,product_name
order by profit_percent desc;

--or

select  order_id,Product_Name,((profit/((sales-profit))*100)) as percentage_profit
from store
group by order_id,Product_Name,percentage_profit
order by percentage_profit desc;

/* Where can we trim some loses? 
   In Which products?
   We can do this by calculating the average sales and profits, and comparing the values to that average.
   If the sales or profits are below average, then they are not best sellers and 
   can be analyzed deeper to see if its worth selling thema anymore. */

select round(cast(avg(sales) as numeric),2) as avg_sales
from store;

-- the average sales on any given product is 229.8, so approx. 230.

SELECT round(cast(AVG(Profit)as numeric),2) AS avg_profit
FROM store;
-- the average profit on any given product is 28.6, or approx 29.


-- Average sales per sub-cat below total avg
select Sub_Category,round(cast(avg(Sales) as numeric),2)
from store
group by Sub_Category
order by avg(Sales) limit 9;
--The sales of these Sub_category products are below the average sales.



-- Average profit per sub-cat below total avg profit

select Sub_Category,round(cast(avg(Profit) as numeric),2)
from store
group by Sub_Category
order by avg(Profit) limit 11;

--The profit of these Sub_category products are below the average profit.
-- "Minus sign" Respresnts that those products are in losses.

/* CUSTOMER LEVEL ANALYSIS*/
/* What is the number of unique customer IDs? */
select count(distinct(Customer_Name)) as no_of_unique_customer
from store;

/* Find those customers who registered during 2014-2016. */
select distinct(Customer_Name), Years from store
where Years BETWEEN 2014 AND 2016
order by Years;

/* Calculate Total Frequency of each order id by each customer Name in descending order. */

select customer_name, count(order_id) as order_frequency
from store
group by customer_name
order by order_frequency desc

/* Calculate  cost of each customer name. */

select customer_name,round(cast(sum((Sales-Profit)) as numeric),2) as total_cost
from store
group by customer_name
order by total_cost desc;

/* Display No of Customers in each region in descending order. */
select region,count(customer_name) as no_of_customer
from store
group by region
order by no_of_customer desc;

/* Find Top 10 customers who order frequently. */
select customer_name, count(order_id) as order_frequency
from store
group by customer_name
order by order_frequency desc 
limit 10;

/* Display the records for customers who live in state California and Have postal code 90032. */
select distinct(customer_name),states,postal_code 
from store
where states='California' and postal_code=90032;


/* Find Top 20 Customers who benefitted the store.*/
select customer_name,round(cast(sum(Profit) as numeric),2) as profit from store
group by customer_name
order by profit desc 
limit 20;

--Which state(s) is the superstore most succesful in? Least?
--Top 10 results:
select states,round(cast((sum(profit)/(sum(sales)-sum(profit)))*100 as numeric),2) as profit_percentage from store
group by states
order by profit_percentage desc
limit 10;

--worst 10
select states,round(cast((sum(profit)/(sum(sales)-sum(profit)))*100 as numeric),2) as profit_percentage from store
group by states
order by profit_percentage 
limit 10;

/* ORDER LEVEL ANALYSIS */
/* number of unique orders */
select count(distinct (Order_ID)) as no_of_unique_orders
from store;

/* Find Sum Total Sales of Superstore. */
select round(cast(SUM(sales) as numeric),2) as Total_Sales
from store;

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */

select * from store
select order_id,order_date,ship_date,(ship_date-order_date) as duration_for_shipping
from store;
/* Extract the year  for respective order ID and Customer ID with quantity. */

select customer_id,order_id,Years, quantity 
from store
group by customer_id,order_id,Years,quantity
order by Years ;
/* What is yearwise Sales impact ? */
SELECT EXTRACT(YEAR from Order_Date), Sales, round(cast(((profit/((sales-profit))*100))as numeric),2) as profit_percentage
FROM store
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20;

--Breakdown by Top vs Worst Sellers:

select city,round(cast(sum(sales) as numeric),2) as total_sales
from store
group by city
order by total_sales desc
limit 10 -- top sellers;

select city,round(cast(sum(sales) as numeric),2) as total_sales
from store
group by city
order by total_sales 
limit 10 --worst sellers;

-- Find Top 10 Categories (with the addition of best sub-category within the category).
--Find Top 10 Sub-Categories. :
SELECT round(cast(SUM(sales) as numeric),2) AS prod_sales,Sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales DESC
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

--Find Worst 10 Categories.:
SELECT round(cast(SUM(sales) as numeric),2) AS prod_sales, Category, Sub_Category
FROM store
GROUP BY Category, Sub_Category
ORDER BY prod_sales;

-- Find Worst 10 Sub-Categories. :
SELECT sub_Category,round(cast(SUM(sales) as numeric),2) AS prod_sales 
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;


/* RETURN LEVEL ANALYSIS */
/* Find the number of returned orders. */

select Returned_items, count(Returned_items)as Returned_Items_Count
from store
group by Returned_items
Having Returned_items='Returned';

--Find Top 10 Returned Categories.:
select * from store;

select category,sub_category,count(returned_items) as returned_count
from store
group by category,sub_category,returned_items
having returned_items='Returned'
order by returned_count desc
limit 10;



-- Find Top 10  Returned Sub-Categories.:
SELECT Sub_Category,Count(returned_items) as returned_items 
FROM store
GROUP BY Sub_Category,returned_items
Having returned_items='Returned'
ORDER BY Count(Returned_items) DESC
--OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

--Find Top 10 Customers Returned Frequently.:
select customer_name,count(returned_items) as no_product_returned
from store
group by customer_name,returned_items
having returned_items='Returned'
order by no_product_returned desc 
limit 10;


-- Find Top 20 cities and states having higher return.
select states,count(returned_items) as no_product_returned
from store
group by states,returned_items
having returned_items='Returned'
order by no_product_returned desc 
limit 20--top states with higher return ;

select city,states,count(returned_items) as no_product_returned
from store
group by city,states,returned_items
having returned_items='Returned'
order by no_product_returned desc 
limit 20; --top cities with higher return



--Check whether new customers are returning higher or not.

SELECT customer_name,Customer_duration,Count(Returned_items)as Returned_Items_Count
FROM store
GROUP BY customer_name,Customer_duration,Returned_items
Having Returned_items='Not Returned' and customer_duration='new customer'
ORDER BY Count(Returned_items) desc
limit 20;--Cutomers who did not return

SELECT customer_name,Customer_duration,Count(Returned_items)as Returned_Items_Count
FROM store
GROUP BY customer_name,Customer_duration,Returned_items
Having Returned_items='Returned' and customer_duration='new customer'
ORDER BY Count(Returned_items)
limit 20;--Cutomers who return

--Find Top  Reasons for returning.
SELECT return_reason,Count(Returned_items)as Returned_Items_Count
FROM store
GROUP BY return_reason,Returned_items
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC;



