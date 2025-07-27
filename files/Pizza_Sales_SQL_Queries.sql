Create database Pizza ;
use pizza ; 
select * from pizza_sales ;  

# KPI Requirements : 
# 1. Total Revenue : the sume of all total price 
select sum(total_price) As Total_Revenue from pizza_sales ; 

# 2. Average Order value : Dividing the total revenue by the total numbers of orders 
# We need to count total number of distinct orders 
select count(order_id) from pizza_sales ; 
select count(distinct order_id ) from pizza_sales ; 
# Average order value  
select sum(total_price) / count(distinct order_id) As Avg_order_value from pizza_sales ; 

# 3. Total Pizzas Sold : The sum of the quantities of all pizza sold 
select sum(quantity) As Total_Pizza_Sold from pizza_sales ;

# 4. Total Orders : The total number of order placed. 
select count(distinct order_id) As Total_orders from pizza_sales ;

# to check if the total_price column calculate correctly 
select quantity, count(*) As Count_of_orders 
FROM pizza_sales group by quantity order by quantity ; 
SELECT *
FROM pizza_sales
WHERE quantity > 1
  AND unit_price = total_price; # empty so its right calculated 
  
# 5. Average Pizza Per Order : how many pizza sold per order , dividing total number of pizza sold bt the total number of orders 
SELECT ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id), 2) AS Avg_pizza_per_order
FROM pizza_sales;
# ROUND(value, 2) → Rounds the value to 2 decimal places.
# * 1.0 ensures decimal division, not integer division. 


# Chart Requirements : -  
# 1. Daily trend for total orders : -  
# STR_TO_DATE(order_date, '%d-%m-%Y') converts your string date to proper DATE type.
# Now DAYNAME() can work correctly.
# This is DD-MM-YYYY format, but MySQL expects YYYY-MM-DD for date functions like DAYNAME().
# Data type issue:
# order_date is probably stored as VARCHAR (text), not DATE.
# MySQL cannot extract day names from a string directly.
SELECT DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day, 
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) ; 
# STR_TO_DATE(order_date, '%d-%m-%Y') converts your string date to proper DATE type. Now DAYNAME() can work correctly.

# 2. Monthly Trend for total orders :
 select MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) As Month_Nasme , Count(distinct order_id) As Total_orders
 From Pizza_sales 
 Group by MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y'))
 Order by Total_orders desc ; 
 
 # 3. Percentage of sales by Pizza category :
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

# 4. Percentage of Sales by Pizza Size  
SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) / SUM(SUM(total_price)) OVER () * 100, 2) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC;

# 5. Total Pizza Sold by Pizza Category : 
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_category;

# 6. Top 5 Best Sellers  by Total revenue, Total quantity and Total Orders  : 
# By Total Revenue
select pizza_name,
       sum(total_price) AS Total_revenue from pizza_sales
       group by pizza_name 
       Order by Total_revenue desc limit 5 ; 
 # By Total Quantity 
 select pizza_name,
       sum(quantity) As Total_quantity from pizza_sales
       group by pizza_name 
       Order by Total_quantity desc limit 5 ; 
# By Total Orders  
select pizza_name,
       count(distinct order_id) AS Total_Orders from pizza_sales
       group by pizza_name 
       Order by Total_Orders desc limit 5 ; 
       
# 7 Bottom 5 worst Sellers by Total_revenue, Total quantity and Total Orders  : 
# By Total revenue 
select pizza_name,
       sum(total_price) AS Total_revenue from pizza_sales
       group by pizza_name
       order by Total_revenue asc limit 5 ; 
 # By Total Quantity 
 select pizza_name,
       sum(quantity) AS Total_quantity from pizza_sales
       group by pizza_name 
       Order by Total_quantity asc limit 5 ; 
# By Total Orders : 
select pizza_name,
       count(distinct order_id) AS Total_Orders from pizza_sales
       group by pizza_name 
       Order by Total_Orders asc limit 5 ;  
 

 
 
