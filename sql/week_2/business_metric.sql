-- ## Total revenue.
SELECT
    SUM(total_order_value) AS total_revenue
FROM analytics.fact_orders
WHERE order_status = 'delivered';

-- ## Total orders.
select
	count(distinct order_id) as Total_Orders
from analytics.fact_orders
WHERE order_status = 'delivered';

-- ## Average order value.
SELECT
    SUM(total_order_value) AS Total_revenue,
    count(distinct order_id) as Total_Orders,
    cast(SUM(total_order_value)/count(distinct order_id) as decimal(10,2)) as Avg_order_value
from analytics.fact_orders
where order_status = 'delivered';

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
    where fo.order_status = 'delivered'
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

-- ## Payment method contribution.
with total_payment_by_type as (
    select
        payment_type,
        sum(payment_value) as payment_by_type
    from 
    analytics.fact_payments
    where payment_type != 'not_defined'
    group by payment_type
)
select
    payment_type as Payment_Method,
    payment_by_type,
    cast(payment_by_type * 100.0 /NULLIF(sum(payment_by_type) over(),0) as decimal(10,2)) as 'Contribution%'
from total_payment_by_type
order by payment_by_type desc;


-- ## Cancellation rate
SELECT
    CAST(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS cancellation_rate
FROM analytics.fact_orders;
