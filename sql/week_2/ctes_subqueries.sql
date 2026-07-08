-- ## Find repeat customers.
with repeat_customers as (
	select
		dc.customer_unique_id as customer_id
	from analytics.fact_orders fo
	join analytics.dim_customer dc
	on fo.customer_key = dc.customer_key
	group by dc.customer_unique_id
	having count(distinct fo.order_id) >1
)
select
	count(customer_id) as Total_Repeat_Customers
from repeat_customers;


-- ## Calculate repeat purchase rate.
WITH customer_orders AS
(
    SELECT
        dc.customer_unique_id,
        COUNT(DISTINCT fo.order_id) AS order_count
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    WHERE fo.order_status = 'delivered'
    GROUP BY
        dc.customer_unique_id
        --having COUNT(DISTINCT fo.order_id) > 1
)

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS repeat_customer_purchase_rate_pct
FROM customer_orders;

-- ## Find customers whose second order value is higher than first order value.
WITH ranked_orders AS
(
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        fo.date_key,
        fo.total_order_value,
        ROW_NUMBER() OVER
        (
            PARTITION BY dc.customer_unique_id
            ORDER BY fo.date_key, fo.order_id
        ) AS purchase_rank
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    WHERE fo.order_status = 'delivered'
)

SELECT
    first_order.customer_unique_id,
    first_order.order_id AS first_order_id,
    first_order.total_order_value AS first_order_value,
    second_order.order_id AS second_order_id,
    second_order.total_order_value AS second_order_value
FROM ranked_orders first_order
JOIN ranked_orders second_order
    ON first_order.customer_unique_id = second_order.customer_unique_id
WHERE first_order.purchase_rank = 1
  AND second_order.purchase_rank = 2
  AND second_order.total_order_value > first_order.total_order_value
ORDER BY first_order.customer_unique_id;


-- ## Find sellers contributing to 80% of revenue.
with seller_rev as (
    select
        seller_key,
        sum(price) as seller_revenue
    from analytics.fact_order_items
    group by seller_key
),
seller_rev_perc as (
    select    
        seller_key,
        seller_revenue,
        cast(seller_revenue * 100.0 / sum(seller_revenue) over() as decimal(10,2)) as seller_rev_perc
    from seller_rev
),
seller_cum_perc as (
    select
        *,
        sum(seller_rev_perc) over(order by seller_revenue desc) as cummu_perc
    from seller_rev_perc
)
select
*
from seller_cum_perc
where cummu_perc <=80
    order by seller_revenue desc

