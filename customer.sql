create database customer
use customer
show tables
select * from customer

# Total revenue by male vs female customers
select gender ,sum(purchase_amount) as revenue
from customer group by gender

# Customers who used discount but spent more than average purchase amount
select customer_id,purchase_amount from customer
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount)from customer)

# Top 5 products with highest average review rating
SELECT Item_Purchased,
       round(AVG(Review_Rating),2) AS Avg_Rating
FROM customer
GROUP BY Item_Purchased
ORDER BY Avg_Rating DESC
LIMIT 5;

# Compare average purchase between Standard and Express shipping
select shipping_type,round(avg(purchase_amount),2) from customer
where shipping_type in ('Standard','Express') group by shipping_type

# Compare subscribers vs non-subscribers
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer group by subscription_status
order by total_revenue, avg_spend desc

# Top 5 products with highest discount usage
select item_purchased,
round(sum(case when discount_applied = 'yes' then 1 else 0 end)/count(*) * 100,2) as discount_rate
from customer group by item_purchased 
order by discount_rate desc limit 5

# Customer segmentation new,returning,loyal
with customer_type as (
select customer_id,previous_purchases,
case when previous_purchases = 1 then 'New'
	 when previous_purchases between 2 and 10 then 'Returning'
     else 'Loyal'
     end as customer_segment from customer)
select customer_segment,count(*) as "Number of customers"
from customer_type
group by customer_segment

