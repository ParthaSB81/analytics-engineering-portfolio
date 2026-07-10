select * from analytics.fact_orders
select * from analytics.fact_order_items

-- ## Total revenue.
select
	sum(price) as Total_Revenue
from analytics.fact_order_items;

-- ## Total orders.
select
	count(distinct order_id) as Total_Orders
from analytics.fact_orders;

-- ## Average order value.
select
	sum(foi.price) as Total_Revenue,
	count(distinct fo.order_id) as Total_Orders,
	cast(sum(foi.price)/count(distinct fo.order_id) as decimal(10,2)) as Avg_order_value
from analytics.fact_order_items foi
join analytics.fact_orders fo
on foi.customer_key = fo.customer_key;

-- ## Total customers.
select
	count(distinct(customer_unique_id)) as Total_Customers
from analytics.dim_customer;


-- ## Repeat customer rate.
WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        COUNT(DISTINCT fo.order_id) AS order_count
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    GROUP BY dc.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS repeat_customer_rate
FROM customer_orders;