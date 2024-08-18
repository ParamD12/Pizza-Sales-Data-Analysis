use pizza_sales;

-- Retrieve the total number of orders placed

select count(order_id) as total_orders from orders;

-- Calculate total revenue generated from pizza sales

select round(sum(order_details.quantity * pizzas.price), 2) as Total_Revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza

select pizza_types.name, pizzas.size, pizzas.price as Highest_Priced_Pizza
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the lowest-priced pizza

select pizza_types.name, pizzas.size, pizzas.price as Lowest_Priced_Pizza
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price limit 1;

-- Identify the most common pizza size ordered

select pizzas.size, sum(order_details.quantity) 
from pizzas
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by pizzas.size limit 1;

-- List the top 5 most ordered pizza types along with their quantities

select pizza_types.name, sum(order_details.quantity) as order_quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by order_quantity desc limit 5;

-- List the 5 least ordered pizza types along with their quantities

select pizza_types.name, sum(order_details.quantity) as order_quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by order_quantity limit 5;

-- Intermediate Analysis

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity;

-- Determine the distribution of orders by hour of the day.

select 
	EXTRACT(HOUR FROM order_time) AS order_hour, 
    COUNT(order_id) AS order_count
from orders
group by order_hour 
order by order_hour;

-- Determine the Hour where peak orders are made

select 
	EXTRACT(HOUR FROM order_time) AS order_hour, 
    COUNT(order_id) AS order_count
from orders
group by order_hour 
order by order_count desc limit 1;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category as Category, count(pizza_type_id) as Distribution
from pizza_types
group by category
order by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity), 0) as Avg_Quantity_Per_Day from
( 
select orders.order_date, sum(order_details.quantity) as quantity
from orders
join order_details
on orders.order_id = order_details.order_id
group by orders.order_date 
) as Avg_Quantity;

-- Determine the average revenue per order

select round(avg(Total_Revenue), 2) as Avg_Revenue from 
(
select orders.order_id, sum(order_details.quantity * pizzas.price) as Total_Revenue
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id 
group by orders.order_id) as Revenue;

-- Determine the top 5 most ordered pizza types based on revenue.

select pizza_types.name as Pizza, sum(order_details.quantity * pizzas.price) as Revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by Pizza 
order by Revenue desc Limit 5;

-- Determine the 5 least ordered pizza types based on revenue.

select pizza_types.name as Pizza, round(sum(order_details.quantity * pizzas.price), 3) as Revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by Pizza 
order by Revenue Limit 5;

-- Determine the number of Pizzas sold for each category

Select pizza_types.category as Category, sum(order_details.quantity) as Quantity
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by Category
order by Quantity desc;

-- Advanced Analysis

-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category as Category, 
(round(round(sum(order_details.quantity * pizzas.price),2)/
(select round(sum(order_details.quantity * pizzas.price), 2) as Total_Revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id) * 100, 2)) as Revenue_Contribution
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by Category 
order by Revenue_Contribution desc;

-- Calculate the percentage contribution of each pizza size to total revenue.

select pizzas.size as Size, 
(round(round(sum(order_details.quantity * pizzas.price),2)/
(select round(sum(order_details.quantity * pizzas.price), 2) as Total_Revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id) * 100, 2)) as Revenue_Contribution
from pizzas 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by Size 
order by Revenue_Contribution desc;

-- Analyze the cumulative revenue generated over time.

select Date, Revenue, 
round(Sum(Revenue) OVER ( order by Date), 2) as Cumulative_Revenue
from 
(select orders.order_date as Date, round(sum(order_details.quantity*pizzas.price), 3) as Revenue
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select Category, Name, Revenue
from
(
select Category, Name, Revenue,
Rank() Over (Partition by Category Order By Revenue desc) as Ra_nk
from 
(
select pizza_types.category as Category, pizza_types.name as Name, 
round(sum(order_details.quantity*pizzas.price), 3) as Revenue
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name
order by pizza_types.category, Revenue desc)
as Top_Three) as Top_3
where ra_nk<=3;