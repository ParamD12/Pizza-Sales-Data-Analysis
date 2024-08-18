# Pizza-Sales-Data-Analysis

## Project Overview

This SQL project conducts a thorough analysis of pizza sales data, aiming to uncover key insights related to order quantities, pizza types, sizes, and revenue. The goal is to generate actionable insights and key performance indicators (KPIs) that will inform strategic decisions for the pizza business. The analysis includes a range of queries from basic to advanced levels, covering peak sales periods, top-selling pizzas, and average order values. The findings provide a comprehensive understanding of sales patterns, customer behavior, and overall operational performance.

## Tables Involved

- `orders`: Contains order information including order_id, order_date, order_time.
- `order_details`: Contains details of each order, including order_detail_id, order_id, pizza_id, quantity.
- `pizza_types`: Contains information about different pizza types, including pizza_type_id, name, category, ingredients.
- `pizzas`: Contains details about pizzas, including pizza_type_id, pizza_id, size, and price.

## Questions
<b>Basic:</b>
Retrieve the total number of orders placed. 
Calculate the total revenue generated from pizza sales.
Identify the highest-priced pizza. 
Identify the most common pizza size ordered. 
List the top 5 most ordered pizza types along with their quantities.
List the least 5 most ordered pizza types along with their quantities. 
Intermediate:
Join the necessary tables to find the total quantity of each pizza category ordered.
Determine the distribution of orders by hour of the day.
Determine the peak hour of orders
Join relevant tables to find the category-wise distribution of pizzas.
Group the orders by date and calculate the average number of pizzas ordered per day.
Determine the average revenue per order
Determine the top 5 most ordered pizza types based on revenue.
Determine the 5 least ordered pizza types based on revenue.
Find the number of pizzas sold for each category
Advanced:
Calculate the percentage contribution of each pizza type to total revenue.
Calculate the percentage contribution of each pizza size to total revenue.
Analyze the cumulative revenue generated over time.
Determine the top 3 most ordered pizza types based on revenue for each pizza category.
