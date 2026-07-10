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


-- ## Late delivery percentage.
with delivery_counts as (
    select 
        count(*) as Total_delivery,
        count (case 
                when delay_days > 0 then 1
               end
               ) as Delay_delivery_count
    from analytics.fact_orders
    where order_status = 'delivered'
)
select
    Total_delivery,
    Delay_delivery_count,
    cast(Delay_delivery_count * 100.0 / Total_delivery as decimal(10,2)) as Late_delivery_percentage
from delivery_counts;


-- ## Average delivery days.
select 
    avg(delivery_days) as avg_delivery_days
from analytics.fact_orders
where order_status = 'delivered';


-- ## Revenue by state.
select
    dc.customer_state,
    sum(foi.price) as Revenue
from analytics.fact_order_items foi
join analytics.dim_customer dc
on foi.customer_key = dc.customer_key
group by dc.customer_state
order by sum(foi.price) desc;

-- ## Seller contribution percentage.
with seller_rev as (
    select
        seller_key,
        sum(price) as seller_Revenue
    from analytics.fact_order_items foi
    group by seller_key
)
select 
    seller_key,
    seller_Revenue,
    cast(seller_Revenue * 100.0 / sum(seller_Revenue) over() as decimal(10,2)) as seller_rev_perc
from seller_rev
order by seller_Revenue desc


-- ## Monthly active customers.

select * from analytics.fact_order_items
select * from analytics.fact_payments
select * from analytics.dim_date

select DAY(date_key) from analytics.fact_order_items
